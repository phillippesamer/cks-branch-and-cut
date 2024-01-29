#ifndef _CKS_MODEL_H_
#define _CKS_MODEL_H_

#include <iostream>
#include <sstream>
#include <cmath>
#include <limits>
#include <sys/time.h>
#include <utility>

#include "gurobi_c++.h"

#include "io.h"
#include "cks_cutgenerator.h"

enum ModelStatus {AT_OPTIMUM, STATUS_UNKNOWN};

/***
 * \file cks_model.h
 * 
 * Module for the integer programming model to find connected k subpartitions
 * of minimum weight, using the Gurobi solver API.
 * 
 * \author Phillippe Samer <samer@uib.no>
 * \date 22.12.2022
 */

class CKSCutGenerator;

class CKSModel
{
public:
    CKSModel(IO*);
    virtual ~CKSModel();

    int solve(bool);
    double solution_weight;
    double solution_dualbound;
    vector<long> solution_vector;   // vertex -> subgraph (-1 if none)
    ModelStatus solution_status;
    double solution_runtime;

    bool solve_lp_relax(bool, double, bool);
    double lp_bound;
    double lp_runtime;
    long lp_passes;

    void set_time_limit(double);

    // further info methods
    double get_mip_runtime();
    double get_mip_gap();
    long get_mip_num_nodes();
    long get_mip_msi_counter();
    long get_mip_indegree_counter();
    long get_mip_gsci_counter();
    long get_mip_multiway_counter();

protected:
    IO *instance;

    GRBEnv *env;
    GRBModel *model;
    GRBVar **x;

    void create_variables();
    void create_constraints();
    void create_objective();

    CKSCutGenerator *cutgen;

    bool check_solution();
    void fill_solution_vectors();
    void dfs_to_tag_component(long, long, vector<bool>&);

    int save_optimization_status();
};

#endif
