#include "cks_cutgenerator.h"

/// algorithm setup switches

bool SEPARATE_MSI = true;               // MSI = minimal separator inequalities
bool SEPARATE_INDEGREE = false;
bool SEPARATE_GSCI = true;              // GSCI = generalized single-class ineq. NB! CURRENTLY SKIPPING INDEGREE CUTS IF AN GSCI WAS FOUND!

bool MSI_ONLY_IF_NO_INDEGREE = false;   // only used with SEPARATE_MSI == true
bool INDEGREE_AT_ROOT_ONLY = true;

// strategy for running separation algorithms for colour-specific inequalities
bool SEARCH_ALL_COLOURS_FOR_INDEGREE = true;
bool MSI_STRATEGY_FIRST_CUT_BELOW_ROOT = true;

// clean any bits beyond the corresponding precision to avoid numerical errors?
// (at most 14, since gurobi does not support long double yet...)
// NB! THIS OPTION MIGHT RISK MISSING A VIOLATED INEQUALITY
bool CLEAN_VARS_BEYOND_PRECISION = false;
int  SEPARATION_PRECISION = 14;

// use a tolerance in dealing with relaxation values?
// e.g. y_u < epsilon instead of y_u == 0
// set to 0 to stick to exact values and operators
const double MSI_EPSILON = 1e-5;
const double MSI_ZERO = MSI_EPSILON;
const double MSI_ONE = 1.0 - MSI_EPSILON;
const double INDEGREE_EPSILON = 1e-5;

///////////////////////////////////////////////////////////////////////////////

/// specialized depth-first search to identify/count connected components

void inline dfs_to_tag_components(long u,
                                  long count, 
                                  vector<long> &components, 
                                  vector< vector<long> > &adj_list)
{
    // auxiliary dfs to check connected components in adj_list

    components[u] = count;

    const long degree = adj_list[u].size();

    for (long i = 0; i < degree; ++i)
    {
        long v = adj_list[u].at(i);
        if (components[v] < 0)
            dfs_to_tag_components(v, count, components, adj_list);
    }
}

long inline check_components(vector< vector<long> > &adj_list,
                             vector<long> &components)
{
    /// NB! Expect components initialized as vector<long>(adj_list.size(), -1)

    long count = 0;
    const long n = adj_list.size();

    for (long u = 0; u < n; ++u)
    {
        if (components[u] < 0)
        {
            dfs_to_tag_components(u, count, components, adj_list);
            ++count;
        }
    }

    return count;
}

double inline get_common_out_neighbours(long v1,
                                        long v2, 
                                        const vector< list<long> > &adj_list,
                                        double **x_val,
                                        long colour,
                                        set<long> &common_out_neighbours) 
{
    /***
     * Fills 'common_out_neighbours' with indices of vertices u adjacent to both
     * v1 and v2, and such that x_val[u][colour] is smaller than both
     * x_val[v1][colour] and x_val[v2][colour].
     * Returns the sum of such x_val[u][colour].
     */

    double total = 0.;

    for (list<long>::const_iterator it_v1 = adj_list.at(v1).begin();
        it_v1 != adj_list.at(v1).end(); ++it_v1)
    {
        long u = *it_v1;

        // cheaper to test first if the possible arcs would be oriented into u
        bool x_v1_above = ( x_val[v1][colour]  > x_val[u][colour] ||
                           (x_val[v1][colour] == x_val[u][colour] && v1<u) );
        bool x_v2_above = ( x_val[v2][colour]  > x_val[u][colour] ||
                           (x_val[v2][colour] == x_val[u][colour] && v2<u) );

        if (x_v1_above && x_v2_above)
        {
            bool found = false;
            list<long>::const_iterator it_v2 = adj_list.at(v2).begin();
            while (it_v2 != adj_list.at(v2).end() && !found)
            {
                // is this neighbour of v2 exactly u?
                if (u == *it_v2)
                {
                    found = true;
                    common_out_neighbours.insert(u);
                    total += x_val[u][colour];
                }

                ++it_v2;
            }
        }
    }

    return total;
}

///////////////////////////////////////////////////////////////////////////////

void CKSCutGenerator::check_integrality()
{
    /***
     * Fills attribute x_integral_wrt_colour indicating if all vars
     * corresponding to each colour are zero/one-valued
     */

    x_integral_wrt_colour = vector<bool>(num_subgraphs, false);
    
    for (long colour = 0; colour < num_subgraphs; ++colour)
    {
        bool current_is_integral = true;
        long u = 0;
        while (u < num_vertices && current_is_integral)
        {
            if (x_val[u][colour] > MSI_ZERO && x_val[u][colour] < MSI_ONE)
                current_is_integral = false;

            ++u;
        }

        if (current_is_integral)
            x_integral_wrt_colour.at(colour) = true;
    }
}

///////////////////////////////////////////////////////////////////////////////


CKSCutGenerator::CKSCutGenerator(GRBModel *model, GRBVar **x_vars, IO *instance)
{
    this->model = model;
    this->x_vars = x_vars;
    this->instance = instance;

    this->num_vertices = instance->graph->num_vertices;
    this->num_edges = instance->graph->num_edges;
    this->num_subgraphs = instance->num_subgraphs;
    this->at_root_relaxation = true;

    this->indegree_counter = 0;
    this->minimal_separators_counter = 0;

    this->x_integral_wrt_colour = vector<bool>(num_subgraphs, false);

    this->msi_next_source = 0;
    this->msi_current_colour = 0;
    this->gsci_counter = 0;
    this->gsci_current_colour = 0;
    this->gsci_current_starting_v1 = 0;
}

void CKSCutGenerator::callback()
{
    /***
     * The actual callback method within the solver. Currently, only used for 
     * dynamically adding violated indegree inequalities (if any) and/or
     * violated minimal separator inequalities (MSI).
     */

    try
    {
        // callback from the search at a given MIP node - may include USER CUTS
        if (where == GRB_CB_MIPNODE)
        {
            // node relaxation solution must be available at the current node
            if (this->getIntInfo(GRB_CB_MIPNODE_STATUS) != GRB_OPTIMAL)
                return;

            // flag when done with the root node relaxation
            if (this->at_root_relaxation)   // initially true
                if (getDoubleInfo(GRB_CB_MIPNODE_NODCNT) > 0)
                    this->at_root_relaxation = false;

            // retrieve relaxation solution
            x_val = new double*[num_vertices];
            for (long u = 0; u < num_vertices; ++u)
                x_val[u] = this->getNodeRel(x_vars[u], num_subgraphs);

            this->check_integrality();

            bool separated = false;

            if (SEPARATE_GSCI)
                separated = run_gsci_separation(ADD_USER_CUTS);

            if (SEPARATE_INDEGREE && !separated)
            {
                if (at_root_relaxation || !INDEGREE_AT_ROOT_ONLY)
                    separated = run_indegree_separation(ADD_USER_CUTS);
            }

            if (SEPARATE_MSI)
            {
                if (!MSI_ONLY_IF_NO_INDEGREE || !separated)
                {
                    if (CLEAN_VARS_BEYOND_PRECISION)
                        clean_x_val_beyond_precision(SEPARATION_PRECISION);

                    run_minimal_separators_separation(ADD_LAZY_CNTRS);
                }
            }

            for (long u=0; u < num_vertices; u++)
                delete[] x_val[u];
            delete[] x_val;
        }

        // callback from a new MIP incumbent: only LAZY CONSTRAINTS
        else if (where == GRB_CB_MIPSOL)
        {
            // retrieve solution
            x_val = new double*[num_vertices];
            for (long u = 0; u < num_vertices; ++u)
                x_val[u] = this->getSolution(x_vars[u], num_subgraphs);

            this->check_integrality();

            if (SEPARATE_MSI)
            {
                if (CLEAN_VARS_BEYOND_PRECISION)
                    clean_x_val_beyond_precision(SEPARATION_PRECISION);

                run_minimal_separators_separation(ADD_LAZY_CNTRS);
            }

            for (long u=0; u < num_vertices; u++)
                delete[] x_val[u];
            delete[] x_val;
        }
    }
    catch (GRBException e)
    {
        cout << "Error " << e.getErrorCode()
             << " during CKSCutGenerator::callback(): ";
        cout << e.getMessage() << endl;
    }
    catch (...)
    {
        cout << "Unexpected error during CKSCutGenerator::callback()" << endl;
    }
}

bool CKSCutGenerator::separate_lpr()
{
    /// Interface to be used when solving the LP relaxation only.

    try
    {
        // retrieve relaxation solution
        x_val = new double*[num_vertices];
        for (long u = 0; u < num_vertices; ++u)
        {
            x_val[u] = new double[num_subgraphs];
            for (long c = 0; c < num_subgraphs; ++c)
                x_val[u][c] = x_vars[u][c].get(GRB_DoubleAttr_X);
        }

        this->check_integrality();

        bool gsci_cut = false;
        bool indegree_cut = false;
        bool msi_cut = false;

        if (SEPARATE_GSCI)
            gsci_cut = run_gsci_separation(ADD_STD_CNTRS);

        if (SEPARATE_INDEGREE && !gsci_cut)
            indegree_cut = run_indegree_separation(ADD_STD_CNTRS);

        if (SEPARATE_MSI)
        {
            if (!MSI_ONLY_IF_NO_INDEGREE || !indegree_cut)
            {
                if (CLEAN_VARS_BEYOND_PRECISION)
                    clean_x_val_beyond_precision(SEPARATION_PRECISION);

                msi_cut = run_minimal_separators_separation(ADD_STD_CNTRS);
            }
        }

        for (long u=0; u < num_vertices; u++)
            delete[] x_val[u];
        delete[] x_val;

        return (gsci_cut || indegree_cut || msi_cut);
    }
    catch (GRBException e)
    {
        cout << "Error " << e.getErrorCode() << " during separate_lpr(): ";
        cout << e.getMessage() << endl;
        return false;
    }
    catch (...)
    {
        cout << "Unexpected error during separate_lpr()" << endl;
        return false;
    }
}

void CKSCutGenerator::clean_x_val_beyond_precision(int precision)
{
    /// prevent floating point errors by ignoring digits beyond given precision
    for (long u = 0; u < num_vertices; ++u)
        for (long c = 0; c < num_subgraphs; ++c)
        {
            double tmp = x_val[u][c] * std::pow(10, precision);
            tmp = std::round(tmp);
            x_val[u][c] = tmp * std::pow(10, -precision);
        }
}

////////////////////////////////////////////////////////////////////////////////

bool CKSCutGenerator::run_indegree_separation(int kind_of_cut)
{
    /// wrapper for the separation procedure to suit different execution contexts

    bool model_updated = false;

    // eventual cuts are stored here
    vector<GRBLinExpr> cuts_lhs = vector<GRBLinExpr>();
    vector<long> cuts_rhs = vector<long>();

    /* run separation algorithm from "On imposing connectivity constraints in
     * integer programs", 2017, by [Wang, Buchanan, Butenko]
     */
    model_updated = separate_indegree(cuts_lhs,cuts_rhs);

    if (model_updated)
    {
        // add cuts
        for (unsigned long idx = 0; idx<cuts_lhs.size(); ++idx)
        {
            ++indegree_counter;

            if (kind_of_cut == ADD_USER_CUTS)
                addCut(cuts_lhs[idx] <= cuts_rhs[idx]);

            else if (kind_of_cut == ADD_LAZY_CNTRS)
                addLazy(cuts_lhs[idx] <= cuts_rhs[idx]);

            else // kind_of_cut == ADD_STD_CNTRS
                model->addConstr(cuts_lhs[idx] <= cuts_rhs[idx]);
        }
    }

    return model_updated;
}

bool CKSCutGenerator::separate_indegree(vector<GRBLinExpr> &cuts_lhs,
                                        vector<long> &cuts_rhs)
{
    /// Solve the separation problem for indegree inequalities, for each colour

    long colour = 0;
    bool done = false;
    while (colour < num_subgraphs && !done)
    {
        vector<long> indegree = vector<long>(num_vertices, 0);

        // 1. COMPUTE INDEGREE ORIENTING EDGES ACCORDING TO RELAXATION SOLUTION
        for (long idx = 0; idx < num_edges; ++idx)
        {
            long u = instance->graph->s.at(idx);
            long v = instance->graph->t.at(idx);
            if (x_val[u][colour] >= x_val[v][colour])
                indegree.at(v) += 1;
            else
                indegree.at(u) += 1;
        }

        // 2. EVALUATE LHS (1-d[u])*x[u]
        double lhs_sum = 0.;
        for (long u = 0; u < num_vertices; ++u)
            lhs_sum += ( (1 - indegree.at(u)) * x_val[u][colour] );

        // 3. FOUND MOST VIOLATED INDEGREE INEQUALITY (IF ANY) IF LHS > 1
        if (lhs_sum > 1 + INDEGREE_EPSILON)
        {
            // store inequality (caller method adds it to the model)
            GRBLinExpr violated_constr = 0;

            for (long u = 0; u < num_vertices; ++u)
                violated_constr += ( (1 - indegree.at(u)) * x_vars[u][colour] );

            cuts_lhs.push_back(violated_constr);
            cuts_rhs.push_back(1);

            if (!SEARCH_ALL_COLOURS_FOR_INDEGREE)
                done = true;
        }

        ++colour;
    }

    return (cuts_lhs.size() > 0);
}

////////////////////////////////////////////////////////////////////////////////

bool CKSCutGenerator::run_minimal_separators_separation(int kind_of_cut)
{
    /// wrapper for the separation procedure to suit different execution contexts

    bool model_updated = false;

    // eventual cuts are stored here
    vector<GRBLinExpr> cuts_lhs = vector<GRBLinExpr>();
    vector<long> cuts_rhs = vector<long>();

    /* run separation algorithm from "Partitioning a graph into balanced
     * connected classes - Formulations, separation and experiments", 2021,
     * by [Miyazawa, Moura, Ota, Wakabayashi].
     * NB! If all vars for a given colour are integral, the method below
     * performs a more efficient separation algorithm based on depth-first
     * search in the support graph. See e.g. "Thinning out Steiner trees - 
     * a node-based model for uniform edge costs", 2016, by [Fischetti, Leitner,
     * Ljubic, Luipersbeck, Monaci, Resch, Salvagnin, Sinnl]
     */
    model_updated = separate_minimal_separators_std(cuts_lhs,cuts_rhs);

    if (model_updated)
    {
        // add cuts
        for (unsigned long idx = 0; idx<cuts_lhs.size(); ++idx)
        {
            ++minimal_separators_counter;

            if (kind_of_cut == ADD_USER_CUTS)
                addCut(cuts_lhs[idx] <= cuts_rhs[idx]);

            else if (kind_of_cut == ADD_LAZY_CNTRS)
                addLazy(cuts_lhs[idx] <= cuts_rhs[idx]);

            else // kind_of_cut == ADD_STD_CNTRS
                model->addConstr(cuts_lhs[idx] <= cuts_rhs[idx]);
        }
    }

    return model_updated;
}

bool CKSCutGenerator::separate_minimal_separators_std(vector<GRBLinExpr> &cuts_lhs,
                                                      vector<long> &cuts_rhs)
{
    /// Solve the separation problem for minimal (a,b)-separator inequalities

    long colours_tried = 0;
    bool done = false;
    while (colours_tried < num_subgraphs && !done)
    {
        long colour = this->msi_current_colour;

        // 0. WHENEVER POSSIBLE, WE RUN AN INTEGRAL SEPARATION ALGORITHM INSTEAD
        if (this->x_integral_wrt_colour.at(colour))
        {
            bool separated = separate_minimal_separators_integral_colour(cuts_lhs,
                                                                         cuts_rhs,
                                                                         colour);

            if (separated && MSI_STRATEGY_FIRST_CUT_BELOW_ROOT && !at_root_relaxation)
                done = true;
        }
        else
        {
            // 1. CONSTRUCT AUXILIARY NETWORK D, WITH REDUCTIONS FROM INTEGRAL VARS

            // LEMON digraph representing the current solution
            SmartDigraph D;
            vector<SmartDigraph::Node> D_vertices;
            map<pair<long,long>, SmartDigraph::Arc> D_arcs;
            SmartDigraph::ArcMap<double> D_capacity(D);
            long D_size = 0;

            vector<long> vars_at_one = vector<long>();
            vector<long> fractional_vars_D_idx = vector<long>();
            vector<double> fractional_vars_val = vector<double>();

            // maps u->u_1 ; u_2 = D_idx_of_vertex[u]+1 for fractional x_val[u]
            vector<long> D_idx_of_vertex = vector<long>(num_vertices, -1);

            // 1.1 ADD VERTICES CORRESPONDING TO VARS IN [0,1) IN THIS RELAXATION
            for (long u = 0; u < num_vertices; ++u)
            {
                const double value = x_val[u][colour];
                if (value <= MSI_ZERO)  // == 0
                {
                    // add only one vertex u_1 = u_2 in D
                    D_vertices.push_back(D.addNode());
                    D_idx_of_vertex[u] = D_size;
                    ++D_size;
                }
                else if(value > MSI_ZERO && value < MSI_ONE)   // > 0 && < 1
                {
                    // add two vertices u_1, u_2 in D
                    D_vertices.push_back(D.addNode());
                    D_vertices.push_back(D.addNode());
                    D_idx_of_vertex[u] = D_size;

                    // redundant, but helps adding arcs more efficiently below
                    fractional_vars_D_idx.push_back(D_size);
                    fractional_vars_val.push_back(value);

                    D_size += 2;
                }
                else // value == 1
                    vars_at_one.push_back(u);
            }

            // 1.2 ADD VERTICES CORRESPONDING TO VARS AT 1

            // inspect subgraph induced by vertices at one (contracted if adjacent)
            long num_vars_at_one = vars_at_one.size();

            vector< vector<long> > aux_adj_list;

            for (long i = 0; i < num_vars_at_one; ++i)
                aux_adj_list.push_back(vector<long>());

            for (long i = 0; i < num_vars_at_one; ++i)
                for (long j = i+1; j < num_vars_at_one; ++j)
                {
                    long u = vars_at_one.at(i);
                    long v = vars_at_one.at(j);
                    if (instance->graph->index_matrix[u][v] >= 0)
                    {
                        // i-th vertex at one (u) adjacent to j-th one (v)
                        aux_adj_list[i].push_back(j);
                        aux_adj_list[j].push_back(i);
                    }
                }

            // dfs in this auxiliary graph tagging connected components
            vector<long> components = vector<long>(num_vars_at_one, -1);
            long num_components = check_components(aux_adj_list, components);

            // add one vertex in D for each component in the auxiliary graph
            for (long i = 0; i < num_components; ++i)
                D_vertices.push_back(D.addNode());

            for (long i = 0; i < num_vars_at_one; ++i)
            {
                long u = vars_at_one.at(i);
                long cluster = D_size + components.at(i); // D_size not updated yet
                D_idx_of_vertex[u] = cluster;
            }

            D_size += num_components;

            // 1.3 FIRST SET OF ARCS: (U1,U2) FOR U IN V(G) S.T. x_val[u] \in (0,1)

            const unsigned num_frac_vars = fractional_vars_D_idx.size();

            for (unsigned idx = 0; idx < num_frac_vars; ++idx)
            {
                long v1 = fractional_vars_D_idx.at(idx);
                long v2 = v1 + 1;
                pair<long,long> v1v2 = make_pair(v1,v2);

                D_arcs[v1v2] = D.addArc(D_vertices[v1], D_vertices[v2]);

                D_capacity[ D_arcs[v1v2] ] = fractional_vars_val.at(idx);
            }

            // 1.4 REMAINING ARCS, WITH UNLIMITED CAPACITY (|V|+1 SUFFICES HERE!)

            const long UNLIMITED_CAPACITY = num_vertices + 1;

            for (long idx = 0; idx < num_edges; ++idx)
            {
                long u = instance->graph->s.at(idx);
                long v = instance->graph->t.at(idx);

                // the actual arcs (one or two, for each original edge) depend on
                // the reductions due to integral valued vars (7 cases... boring!)
                // NB!
                // "... >= MSI_ONE" means ... == 1; "... <= MSI_ZERO" means == 0

                if (x_val[u][colour] >= MSI_ONE && x_val[v][colour] <= MSI_ZERO)
                {
                    // CASE 1
                    long uu = D_idx_of_vertex[u];
                    long vv = D_idx_of_vertex[v];
                    pair<long,long> uuvv = make_pair(uu,vv);

                    D_arcs[uuvv] = D.addArc(D_vertices[uu], D_vertices[vv]);

                    D_capacity[ D_arcs[uuvv] ] = UNLIMITED_CAPACITY;
                }
                else if (x_val[u][colour] <= MSI_ZERO && x_val[v][colour] >= MSI_ONE)
                {
                    // CASE 2
                    long uu = D_idx_of_vertex[u];
                    long vv = D_idx_of_vertex[v];
                    pair<long,long> vvuu = make_pair(vv,uu);

                    D_arcs[vvuu] = D.addArc(D_vertices[vv], D_vertices[uu]);

                    D_capacity[ D_arcs[vvuu] ] = UNLIMITED_CAPACITY;
                }
                else if (x_val[u][colour] <= MSI_ZERO && x_val[v][colour] > MSI_ZERO
                                                      && x_val[v][colour] < MSI_ONE)
                {
                    // CASE 3
                    long uu = D_idx_of_vertex[u];
                    long v2 = D_idx_of_vertex[v] + 1;
                    pair<long,long> v2uu = make_pair(v2,uu);

                    D_arcs[v2uu] = D.addArc(D_vertices[v2], D_vertices[uu]);

                    D_capacity[ D_arcs[v2uu] ] = UNLIMITED_CAPACITY;
                }
                else if (x_val[u][colour] > MSI_ZERO && x_val[v][colour] <= MSI_ZERO &&
                         x_val[u][colour] < MSI_ONE)
                {
                    // CASE 4
                    long u2 = D_idx_of_vertex[u] + 1;
                    long vv = D_idx_of_vertex[v];
                    pair<long,long> u2vv = make_pair(u2,vv);

                    D_arcs[u2vv] = D.addArc(D_vertices[u2], D_vertices[vv]);

                    D_capacity[ D_arcs[u2vv] ] = UNLIMITED_CAPACITY;
                }
                else if (x_val[u][colour] > MSI_ZERO && x_val[v][colour] >= MSI_ONE &&
                         x_val[u][colour] < MSI_ONE)
                {
                    // CASE 5
                    long u1 = D_idx_of_vertex[u];
                    long u2 = D_idx_of_vertex[u] + 1;
                    long vv = D_idx_of_vertex[v];
                    pair<long,long> u2vv = make_pair(u2,vv);
                    pair<long,long> vvu1 = make_pair(vv,u1);

                    D_arcs[u2vv] = D.addArc(D_vertices[u2], D_vertices[vv]);
                    D_arcs[vvu1] = D.addArc(D_vertices[vv], D_vertices[u1]);

                    D_capacity[ D_arcs[u2vv] ] = UNLIMITED_CAPACITY;
                    D_capacity[ D_arcs[vvu1] ] = UNLIMITED_CAPACITY;
                }
                else if (x_val[u][colour] >= MSI_ONE && x_val[v][colour] > MSI_ZERO
                                                     && x_val[v][colour] < MSI_ONE)
                {
                    // CASE 6
                    long uu = D_idx_of_vertex[u];
                    long v1 = D_idx_of_vertex[v];
                    long v2 = D_idx_of_vertex[v] + 1;
                    pair<long,long> v2uu = make_pair(v2,uu);
                    pair<long,long> uuv1 = make_pair(uu,v1);

                    D_arcs[v2uu] = D.addArc(D_vertices[v2], D_vertices[uu]);
                    D_arcs[uuv1] = D.addArc(D_vertices[uu], D_vertices[v1]);

                    D_capacity[ D_arcs[v2uu] ] = UNLIMITED_CAPACITY;
                    D_capacity[ D_arcs[uuv1] ] = UNLIMITED_CAPACITY;
                }
                else if (x_val[u][colour] > MSI_ZERO && x_val[v][colour] > MSI_ZERO &&
                         x_val[u][colour] < MSI_ONE  && x_val[v][colour] < MSI_ONE  )
                {
                    // CASE 7
                    long u1 = D_idx_of_vertex[u];
                    long u2 = D_idx_of_vertex[u] + 1;
                    long v1 = D_idx_of_vertex[v];
                    long v2 = D_idx_of_vertex[v] + 1;
                    pair<long,long> u2v1 = make_pair(u2,v1);
                    pair<long,long> v2u1 = make_pair(v2,u1);

                    D_arcs[u2v1] = D.addArc(D_vertices[u2], D_vertices[v1]);
                    D_arcs[v2u1] = D.addArc(D_vertices[v2], D_vertices[u1]);

                    D_capacity[ D_arcs[u2v1] ] = UNLIMITED_CAPACITY;
                    D_capacity[ D_arcs[v2u1] ] = UNLIMITED_CAPACITY;
                }
            }

            /* 2. TRY EACH PAIR OF NON-ADJACENT VERTICES (IN THE ORIGINAL GRAPH)
             * WHOSE COMBINED VALUES IN THIS RELAXATION SOLUTION EXCEED 1
             * (OTHERWISE THE CORRESPONDNG MSI CANNOT BE VIOLATED)
             */

            // NOTE: not looking for more than 1 violated MSI for a given color
            bool done_with_this_colour = false;
            long num_trials = 0;
            while (num_trials < num_vertices && !done_with_this_colour)
            {
                // "cycling" through the initial source vertex tried (only relevant with MSI_STRATEGY_FIRST_CUT_BELOW_ROOT)
                long s = this->msi_next_source;
                long t = s+1;
                while (t < num_vertices && !done_with_this_colour)
                {
                    // wanted: a (s_2, t_1) separating cut
                    long s_in_D = (x_val[s][colour] > MSI_ZERO && x_val[s][colour] < MSI_ONE) ?
                        D_idx_of_vertex[s]+1 : D_idx_of_vertex[s];

                    long t_in_D = D_idx_of_vertex[t];

                    if ( instance->graph->index_matrix[s][t] < 0 &&              // non-adjacent
                         x_val[s][colour] + x_val[t][colour] > 1+MSI_EPSILON &&  // might cut x*
                         s_in_D != t_in_D )                                      // not contracted
                    {
                        // 3. MAX FLOW COMPUTATION

                        /***
                         * Using the first phase of Goldberg & Tarjan preflow
                         * push-relabel algorithm (with "highest label" and "bound
                         * decrease" heuristics). The worst case time complexity of
                         * the algorithm is in O(n^2 * m^0.5), n and m wrt D
                         */

                        Preflow<SmartDigraph, SmartDigraph::ArcMap<double> >
                            s_t_preflow(D, D_capacity, D_vertices[s_in_D],
                                                       D_vertices[t_in_D]);

                        s_t_preflow.runMinCut();
                        
                        double mincut = s_t_preflow.flowValue();

                        // 4. IF THE MIN CUT IS LESS THAN WHAT THE MSI PRESCRIBES
                        // (UP TO A VIOLATION TOLERANCE), WE FOUND A CUT

                        if (mincut < x_val[s][colour] + x_val[t][colour] - 1 - MSI_EPSILON)
                        {
                            // 5. DETERMINE VERTICES IN ORIGINAL GRAPH CORRESPONDING
                            // TO ARCS IN THE MIN CUT

                            vector<long> S = vector<long>();
                            vector<bool> S_mask = vector<bool>(num_vertices, false);

                            for (long u = 0; u < num_vertices; ++u)
                            {
                                if (u != s && u != t)
                                {
                                    long u_in_D = D_idx_of_vertex[u];

                                    // query if u1 is on the source side of the min cut
                                    if ( s_t_preflow.minCut(D_vertices[u_in_D]) )
                                    {
                                        bool u_at_zero = x_val[u][colour] <= MSI_ZERO;

                                        bool u_frac = x_val[u][colour] > MSI_ZERO &&
                                                      x_val[u][colour] < MSI_ONE ;

                                        long u2_in_D = u_frac ? D_idx_of_vertex[u]+1
                                                              : D_idx_of_vertex[u];

                                        bool u2_separated =
                                           !s_t_preflow.minCut(D_vertices[u2_in_D]);

                                        if (u_at_zero || (u_frac && u2_separated) )
                                        {
                                            S.push_back(u);
                                            S_mask.at(u) = true;
                                        }
                                    }
                                }
                            }

                            // 6. LIFT CUT BY REDUCING S TO A MINIMAL SEPARATOR
                            #ifdef DEBUG_MSI
                                cout << "### (" << s << "," << t << ")- separator"
                                     << endl;
                                cout << "### before lifting: { ";

                            for (vector<long>::iterator it = S.begin();
                                                        it != S.end(); ++it)
                                cout << *it << " ";

                            cout << "}" << endl;
                            #endif

                            lift_to_minimal_separator(S, S_mask, s, t);

                            #ifdef DEBUG_MSI
                                cout << "### after lifting: { ";

                            for (vector<long>::iterator it = S.begin();
                                                        it != S.end(); ++it)
                                cout << *it << " ";

                            cout << "}" << endl;
                            #endif

                            // 7. DETERMINE INEQUALITY

                            GRBLinExpr violated_constr = 0;

                            violated_constr += x_vars[s][colour];
                            violated_constr += x_vars[t][colour];

                            for (vector<long>::iterator it = S.begin();
                                                        it != S.end(); ++it)
                            {
                                violated_constr += ( (-1) * x_vars[*it][colour] );
                            }

                            cuts_lhs.push_back(violated_constr);
                            cuts_rhs.push_back(1);

                            #ifdef DEBUG_MSI
                                double violating_lhs = 0;

                                cout << "### ADDED MSI: ";

                                cout << "x_" << s << " + x_" << t;
                                violating_lhs += x_val[s][colour];
                                violating_lhs += x_val[t][colour];

                                for (vector<long>::iterator it = S.begin();
                                                            it != S.end(); ++it)
                                {
                                    cout << " - x_" << *it << "";
                                    violating_lhs -= x_val[*it][colour];
                                }

                                cout << " <= 1 " << endl;
                                cout << right;
                                cout << setw(80) << "(lhs at current point "
                                     << violating_lhs << ")" << endl;
                                cout << left;
                            #endif

                            done_with_this_colour = true;

                            if (MSI_STRATEGY_FIRST_CUT_BELOW_ROOT && !at_root_relaxation)
                                done = true;
                        }
                    }

                    ++t;
                }

                this->msi_next_source = (this->msi_next_source+1) % num_vertices;
                ++num_trials;
            }
        }

        // move to the next colour (unless done)
        this->msi_current_colour = (this->msi_current_colour+1) % num_subgraphs;
        ++colours_tried;
    }

    return (cuts_lhs.size() > 0);
}

void inline CKSCutGenerator::lift_to_minimal_separator(vector<long> &S,
                                                       vector<bool> &S_mask,
                                                       long s,
                                                       long t)
{
    /// Remove vertices from S until it is a minimal (s,t)-separator

    bool updated = true;
    while (updated)
    {
        updated = false;

        const long len = S.size();

        long count = 0;
        vector<bool> seen = vector<bool>(num_vertices, false);

        // only try dfs from t if dfs from s found all vertices of S 
        dfs_avoiding_set(S, S_mask, s, seen, count);
        if (count == len)
        {
            count = 0;
            seen.assign(num_vertices, false);
            dfs_avoiding_set(S, S_mask, t, seen, count);
        }

        /***
         * S is a minimal (s,t)-separator if and only if every element in S has
         * a neighbour both in the connected component of G-S containing s, and  
         * in the one containing t. So we may remove from S a vertex not found
         * in either dfs' above.
         */
        if (count < len)
        {
            long i = 0;
            while (i < len && !updated)
            {
                long vertex_at_i = S.at(i);

                if ( !seen.at(vertex_at_i) )
                {
                    updated = true;
                    S.erase(S.begin() + i);
                    S_mask.at(vertex_at_i) = false;
                }

                ++i;
            }
        }

    }  // repeat search if S was updated 
}

void inline CKSCutGenerator::dfs_avoiding_set(vector<long> &S,
                                              vector<bool> &S_mask,
                                              long source,
                                              vector<bool> &seen,
                                              long &count)
{
    // auxiliary dfs tagging seen vertices, but not exploring vertices in S

    // NB! Expecting 'seen' with num_vertices 'false' entries (not S.size()!)

    seen.at(source) = true;

    for (list<long>::iterator it = instance->graph->adj_list.at(source).begin();
        it != instance->graph->adj_list.at(source).end(); ++it)
    {
        long v = *it;

        if ( !seen.at(v) )
        {
            if ( S_mask.at(v) )
            {
                // v in S
                seen.at(v) = true;
                ++count;
            }
            else
                dfs_avoiding_set(S, S_mask, v, seen, count);
        }
    }
}


bool CKSCutGenerator::separate_minimal_separators_integral_colour(vector<GRBLinExpr> &cuts_lhs,
                                                                  vector<long> &cuts_rhs,
                                                                  long colour)
{
    /***
     * Solve the separation problem for minimal (a,b)-separator inequalities,
     * assuming the current point has integer coordinates for the given colour
     */

    vector<long> vars_at_one = vector<long>();
    for (long u=0; u < num_vertices; ++u)
        if (x_val[u][colour] >= MSI_ONE)
            vars_at_one.push_back(u);

    long num_vars_at_one = vars_at_one.size();
    if (num_vars_at_one < 2)
        return false;

    // 1. SUBGRAPH CONTAINING ONLY EDGES BETWEEN VERTICES AT ONE
    vector< vector<long> > aux_adj_list;

    // all vertices
    for (long i = 0; i < num_vertices; ++i)
        aux_adj_list.push_back(vector<long>());

    // only edges between vertices at one
    for (long i = 0; i < num_vars_at_one; ++i)
        for (long j = i+1; j < num_vars_at_one; ++j)
        {
            long u = vars_at_one.at(i);
            long v = vars_at_one.at(j);
            if (instance->graph->index_matrix[u][v] >= 0)
            {
                // i-th vertex at one (u) adjacent to j-th one (v)
                aux_adj_list[u].push_back(v);
                aux_adj_list[v].push_back(u);
            }
        }

    // 2. DFS IN THIS AUXILIARY GRAPH TAGGING CONNECTED COMPONENTS
    vector<long> components = vector<long>(num_vertices, -1);
    check_components(aux_adj_list, components);

    // 3. GET TWO VARS X_{s,c} = X_{t,c} = 1, WITH s AND t IN DIFFERENT COMPONENTS
    // NB! Trying to stick to the "rotating source" strategy to avoid favouring
    // separators between vertices of smaller index
    long s = -1;
    vector<long>::iterator it = vars_at_one.begin();
    while ( it != vars_at_one.end() && s < 0)
    {
        long v = *it;
        if(v >= this->msi_next_source)
            s = v;

        ++it;
    }

    // msi_next_source not at 1, nor any vertex with larger index?
    if (s < 0)
        s = vars_at_one.front();

    long t = -1;
    it = vars_at_one.begin();
    while ( it != vars_at_one.end() && t < 0)
    {
        long v = *it;
        if(components.at(v) != components.at(s))
            t = v;

        ++it;
    }

    if (t < 0)
    {
        // no two vertices at 1 in two different components... NO VIOLATED MSI FOR THIS COLOUR!
        return false;
    }

    // 4. DETERMINE VERTICES IN V\COMPONENT[s] THAT ARE ADJACENT TO SOME VERTEX IN COMPONENT[s]
    vector<long> separator_vertices = vector<long>();
    vector<bool> separator_mask = vector<bool>(num_vertices, false);
    vector<bool> s_component_mask = vector<bool>(num_vertices, false);
    for (long u=0; u < num_vertices; ++u)
    {
        if(components.at(u) == components.at(s))
            s_component_mask.at(u) = true;
        else
        {
            bool u_is_a_neighbour = false;
            list<long>::iterator it = instance->graph->adj_list.at(u).begin();
            while (it != instance->graph->adj_list.at(u).end() && !u_is_a_neighbour)
            {
                long v = *it;
                if (components.at(v) == components.at(s))
                    u_is_a_neighbour = true;

                ++it;
            }

            if (u_is_a_neighbour)
            {
                separator_vertices.push_back(u);
                separator_mask.at(u) = true;
            }
        }
    }

    // 5. FOUND A SEPARATOR, BUT NOW LIFT IT TO A MINIMAL ONE
    #ifdef DEBUG_MSI_INTEGRAL
        cout << "### (" << s << "," << t << ")- separator"
             << endl;
        cout << "### before lifting: { ";

        for (vector<long>::iterator it = separator_vertices.begin();
                                    it != separator_vertices.end(); ++it)
            cout << *it << " ";

        cout << "}" << endl;
    #endif

    lift_to_minimal_separator(separator_vertices, separator_mask, s, t);

    #ifdef DEBUG_MSI_INTEGRAL
        cout << "### after lifting: { ";

        for (vector<long>::iterator it = separator_vertices.begin();
                                    it != separator_vertices.end(); ++it)
            cout << *it << " ";

        cout << "}" << endl;
    #endif

    // 6. DETERMINE INEQUALITY

    GRBLinExpr violated_constr = 0;

    violated_constr += x_vars[s][colour];
    violated_constr += x_vars[t][colour];

    vector<long>::iterator it_S = separator_vertices.begin();
    while (it_S != separator_vertices.end())
    {
        violated_constr += ( (-1) * x_vars[*it_S][colour] );
        ++it_S;
    }

    cuts_lhs.push_back(violated_constr);
    cuts_rhs.push_back(1);

    #ifdef DEBUG_MSI_INTEGRAL
        double violating_lhs = 0;

        cout << "### INTEGRAL VARS FOR COLOUR " << colour << " GAVE MSI: ";
        cout << "x_" << s << " + x_" << t;

        violating_lhs += x_val[s][colour];
        violating_lhs += x_val[t][colour];

        it_S = separator_vertices.begin();
        while (it_S != separator_vertices.end())
        {
            cout << " - x_" << *it_S << "";
            violating_lhs -= x_val[*it_S][colour];
            ++it_S;
        }

        cout << " <= 1 " << endl;
        cout << right;
        cout << setw(80) << "(lhs at current point "
             << violating_lhs << ")" << endl;
        cout << left;
    #endif

    this->msi_next_source++;
    return true;
}

////////////////////////////////////////////////////////////////////////////////

bool CKSCutGenerator::run_gsci_separation(int kind_of_cut)
{
    /// wrapper for the separation procedure to suit different execution contexts

    bool model_updated = false;

    // eventual cuts are stored here
    vector<GRBLinExpr> cuts_lhs = vector<GRBLinExpr>();
    vector<long> cuts_rhs = vector<long>();

    // run separation heuristic for generalized single-class inequalities (GSCI)
    model_updated = separate_gsci(cuts_lhs, cuts_rhs);

    if (model_updated)
    {
        // add cuts
        for (unsigned long idx = 0; idx<cuts_lhs.size(); ++idx)
        {
            ++gsci_counter;

            if (kind_of_cut == ADD_USER_CUTS)
                addCut(cuts_lhs[idx] <= cuts_rhs[idx]);

            else if (kind_of_cut == ADD_LAZY_CNTRS)
                addLazy(cuts_lhs[idx] <= cuts_rhs[idx]);

            else // kind_of_cut == ADD_STD_CNTRS
                model->addConstr(cuts_lhs[idx] <= cuts_rhs[idx]);
        }
    }

    return model_updated;
}

bool CKSCutGenerator::separate_gsci(vector<GRBLinExpr> &cuts_lhs,
                                    vector<long> &cuts_rhs)
{
    /// Solve the separation problem for generalized single-class inequalities

    // 1. ITERATE OVER EACH COLOUR CLASS THAT INCLUDES FRACTIONAL VARS

    long colours_tried = 0;
    bool done = false;
    while (colours_tried < num_subgraphs && !done)
    {
        long colour = this->gsci_current_colour;

        if (this->x_integral_wrt_colour.at(colour) == false)
        {
            // the first index corresponds to the representative in each pair
            vector<pair<long,long> > pairs = vector<pair<long,long> >();
            vector<bool> paired = vector<bool>(num_vertices, false);
            vector<bool> representative = vector<bool>(num_vertices, false);
            vector<long> class_of_vertex = vector<long>(num_vertices, -1);

            // 2. STARTING WITH THE ARC ORIENTATION IN STANDARD INDEGREE INEQUALITIES

            /* NB! Even though the reference/starting partitioning changes with
             * each pair made below, the actual evaluation (3.1 below) on each
             * iteration does not depend on the partitioning (it is based on
             * x_val only, no coefficients involved); we may recompute indegrees
             * only when adding an inequality.
             */

            double lhs_of_std_indegree = 0.;
            vector<long> indegree = vector<long>(num_vertices, 0);

            for (long idx = 0; idx < num_edges; ++idx)
            {
                long u = instance->graph->s.at(idx);
                long v = instance->graph->t.at(idx);
                if ( x_val[u][colour]  > x_val[v][colour] ||
                    (x_val[u][colour] == x_val[v][colour] && u<v) )
                    indegree.at(v) += 1;
                else
                    indegree.at(u) += 1;
            }

            for (long u = 0; u < num_vertices; ++u)
                lhs_of_std_indegree += ( (1 - indegree.at(u)) * x_val[u][colour] );

            // 3. TRY TO PAIR UP VERTICES (AT NONZERO VALUE IN THE CURRENT RELAXATION)

            long num_trials = 0;
            long v1 = this->gsci_current_starting_v1;
 
            while (num_trials < num_vertices)
            {
                // no cut possible if v1 is null
                if (x_val[v1][colour] > MSI_ZERO && !paired[v1])
                {
                    long v2 = v1+1;
                    while (v2 < num_vertices && !paired[v1])
                    {
                        // no cut possible if v2 is null
                        if (x_val[v2][colour] > MSI_ZERO && !paired[v2])
                        {
                            // 3.1. EVALUATE LHS BENEFIT OF HAVING A SET {V_1, V_2} IN THE PARTITION

                            // TO DO: if not needed in each iteration, remove the list and just get the number
                            // sum of x_val of common out-neighbours
                            set<long> common_neighbours = set<long>();
                            double possible_gain = get_common_out_neighbours(v1,
                                                                             v2,
                                                                             instance->graph->adj_list,
                                                                             x_val,
                                                                             colour,
                                                                             common_neighbours);
                            bool lhs_improves = false;
                            bool x_v1_above = ( x_val[v1][colour]  > x_val[v2][colour] ||
                                               (x_val[v1][colour] == x_val[v2][colour] && v1<v2) );

                            // first case: v1 and v2 are adjacent
                            if (instance->graph->index_matrix[v1][v2] >= 0)
                                lhs_improves = (possible_gain > MSI_ZERO);

                            // second case: v1 and v2 are not neighbours
                            else
                            {
                                if (x_v1_above)
                                    lhs_improves = (possible_gain - x_val[v2][colour] > MSI_ZERO);
                                else
                                    lhs_improves = (possible_gain - x_val[v1][colour] > MSI_ZERO);
                            }

                            // 3.2. PAIR V_1 AND V_2 IF MERGING THEM GIVES A STRONGER LHS
                            if (lhs_improves)
                            {
                                if (x_v1_above)
                                {
                                    pairs.push_back(make_pair(v1,v2));
                                    representative[v1] = true;
                                }
                                else
                                {
                                    pairs.push_back(make_pair(v2,v1));
                                    representative[v2] = true;
                                }

                                paired[v1] = true;
                                paired[v2] = true;
                                class_of_vertex[v1] = pairs.size()-1;
                                class_of_vertex[v2] = pairs.size()-1;
                            }
                        }

                        ++v2;
                    }
                }

                v1 = (v1 + 1) % num_vertices;
                ++num_trials;
            }

            // 4. FOUND A VIOLATED GSCI BASED ON THIS COLOUR?
            if(pairs.size() > 0)
            {
                // fill up information for vertices that will remain in singletons
                long num_of_classes = pairs.size();
                vector<set<long> > incoming_classes = vector<set<long> >();

                for (long u=0; u < num_vertices; ++u)
                {
                    incoming_classes.push_back(set<long>());

                    if (!paired[u])
                    {
                        class_of_vertex[u] = num_of_classes++;
                        representative[u] = true;
                    }
                }

                // calculate updated indegree vector
                for (long idx = 0; idx < num_edges; ++idx)
                {
                    long u = instance->graph->s.at(idx);
                    long v = instance->graph->t.at(idx);

                    if (class_of_vertex[u] != class_of_vertex[v])
                    {
                        // indegree orientation
                        if ( x_val[u][colour]  > x_val[v][colour] ||
                            (x_val[u][colour] == x_val[v][colour] && u<v) )
                            incoming_classes[v].insert(class_of_vertex[u]);
                        else
                            incoming_classes[u].insert(class_of_vertex[v]);
                    }
                }

                // store inequality (caller method adds it to the model)
                GRBLinExpr violated_constr = 0;

                for (long u = 0; u < num_vertices; ++u)
                {
                    long d_hat = incoming_classes[u].size();

                    if (representative[u])
                        violated_constr += ( (1 - d_hat) * x_vars[u][colour] );
                    else
                        violated_constr += ( (0 - d_hat) * x_vars[u][colour] );
                }

                cuts_lhs.push_back(violated_constr);
                cuts_rhs.push_back(1);

                #ifdef DEBUG_GSCI
                    double violating_lhs = 0;

                    cout << "### ADDED GSCI ON COLOUR #" << colour << ": ";

                    for (long u = 0; u < num_vertices; ++u)
                    {
                        long d_hat = incoming_classes[u].size();
                        if (representative[u])
                        {
                            cout << "(1-" << d_hat << ")x_" << u << " + ";
                            violating_lhs += ( (1 - d_hat) * x_val[u][colour] );
                        }
                    }
                    for (long u = 0; u < num_vertices; ++u)
                    {
                        long d_hat = incoming_classes[u].size();
                        if (!representative[u])
                        {
                            cout << "-" << d_hat << "x_" << u << " ";
                            violating_lhs += ( (0 - d_hat) * x_val[u][colour] );
                        }
                    }

                    cout << " <= 1 " << endl;
                    cout << right;
                    cout << setw(80) << "(lhs at current point "
                         << violating_lhs << ")" << endl;
                    cout << left;
                #endif
            }
        }

        // move to the next colour (unless done)
        this->gsci_current_colour = (this->gsci_current_colour+1) % num_subgraphs;
        ++colours_tried;
    }

    // cycling v1 along different relaxations
    this->gsci_current_starting_v1 = (this->gsci_current_starting_v1+1) % num_vertices;

    return (cuts_lhs.size() > 0);
}

