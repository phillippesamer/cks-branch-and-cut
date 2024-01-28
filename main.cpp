/***
 * \file main.cpp
 * 
 * Branch-and-cut algorithm to find a maximum weight connected k-subpartition
 * in a graph (disjoint vertex subsets inducing k connected subgraphs).
 * 
 * \author Phillippe Samer <samer@uib.no>
 * \date 22.12.2022
 */

#include "io.h"
#include "cks_model.h"

#include <cstdlib>
#include <fstream>

using namespace std;

// execution switches
bool CONVEX_RECOLORING_INSTANCE = false;   // e.g. as of ITOR'2022

double RUN_CKS_WITH_TIME_LIMIT = 600.0;

bool DEDICATED_LP_RELAXATION = false;
double DEDICATED_LPR_TIME_LIMIT = 300;
bool DEDICATED_LPR_GRB_CUTS_OFF = false;

bool WRITE_LATEX_TABLE_ROW = true;
string LATEX_TABLE_FILE_PATH = string("xp1dimacs.dat");

int main(int argc, char **argv)
{
    // 0. PARSE INPUT FILE

    IO* instance = new IO();

    if (argc < 3)
    {
        cout << endl << "usage: \t" << argv[0];
        if (CONVEX_RECOLORING_INSTANCE)
            cout << " [CR instance file] [CR solution file]" << endl << endl;
        else
        {
            cout << " [.stp or .gcc input file path] [number of subgraphs] [-e]"
                 << endl << endl;
            cout << " [-e]: flag indicating .stp format instance "
                 << "WITH edge weights (to be ignored)" << endl << endl;
        }

        delete instance;
        return 0;
    }
    else
    {
        if (CONVEX_RECOLORING_INSTANCE)
        {
            cout << "### CONVEX RECOLORING ###" << endl << endl;

            if (instance->parse_CR_input_file(string(argv[1])) == false)
            {
                cout << "unable to parse CR input file" << endl;
                delete instance;
                return 0;
            }
        }
        else
        {
            cout << "### CONNECTED K-SUBPARTITION ###" << endl << endl;

            instance->num_subgraphs = atol(argv[2]);
            bool stp_with_edge_weights = (argc > 3);

            string file_path = string(argv[1]);
            string file_extension = file_path.substr(file_path.find_last_of(".")+1);

            bool successful_parsing = (file_extension.compare("gcc") == 0) ?
                                      instance->parse_gcc_file(file_path) :
                                      instance->parse_stp_file(file_path, stp_with_edge_weights);
            if (!successful_parsing)
            {
                    cout << "unable to parse input file" << endl;
                    delete instance;
                    return 0;
            }
        }
    }

    /*
    if (instance->only_nonpositive_weights)
    {
        cout << endl << "*** All edges in instance " << instance->instance_id
             << " have non-positive weight." << endl;
        cout << endl << "*** Empty solution is optimal." << endl;

        return 0;
    }
    */

    if (WRITE_LATEX_TABLE_ROW)
    {
        instance->save_instance_info();
        if (CONVEX_RECOLORING_INSTANCE)
            instance->save_literature_info(string(argv[2]));
    }

    // 1. BUILD AND SOLVE THE INTEGER PROGRAM

    CKSModel *model = new CKSModel(instance);

    if (DEDICATED_LP_RELAXATION)
    {
        model->solve_lp_relax(false,
                              DEDICATED_LPR_TIME_LIMIT,
                              DEDICATED_LPR_GRB_CUTS_OFF);

        if (WRITE_LATEX_TABLE_ROW)
            instance->save_lpr_info(model->lp_bound, model->lp_runtime);
    }

    model->set_time_limit(RUN_CKS_WITH_TIME_LIMIT - model->lp_runtime);
    model->solve(true);

    if (WRITE_LATEX_TABLE_ROW)
    {
        instance->save_ip_info(model->solution_weight,
                               model->solution_dualbound,
                               model->get_mip_gap(),
                               model->get_mip_runtime(),
                               model->get_mip_num_nodes(),
                               model->get_mip_msi_counter(),
                               model->get_mip_indegree_counter());

        instance->write_summary_info(LATEX_TABLE_FILE_PATH);
    }

    delete model;
    delete instance;
    return 0;
}
