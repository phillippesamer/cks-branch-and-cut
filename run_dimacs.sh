#!/bin/bash

instances_selection_of_15=(
"./input/dimacs-MWCS-GAM/3a0d4427fe32.stp"
"./input/dimacs-MWCS-GAM/3a0dff0eb70.stp"
"./input/dimacs-MWCS-GAM/3a0d724ffec9.stp"
"./input/dimacs-MWCS-GAM/48e76a6886bc.stp"
"./input/dimacs-MWCS-GAM/3a0d2255a681.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.25-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.75-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.25-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.75-e-0.25.stp"
"./input/dimacs-MWCS-ACTMOD/drosophila001.stp"
"./input/dimacs-MWCS-ACTMOD/HCMV.stp"
"./input/dimacs-MWCS-ACTMOD/metabol_expr_mice_1.stp"
"./input/dimacs-MWCS-ACTMOD/metabol_expr_mice_3.stp"
)

# xp1: msi+indegree, k=2
num_subgraphs=2

idx=1
for entry in "${instances_selection_of_15[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp1.out")
    echo "[$timestamp] $idx/${#instances_selection_of_15[@]}:  $entry  $num_subgraphs"

    output=$(./cks  $entry  $num_subgraphs  >> "$entry""_xp1.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp1.out")

    # adding number of cuts from the strengthened LP relaxation to those reported by gurobi
    grep '\[LPR\] Minimal separator inequalities added: '          "$entry""_xp1.out"  >>tmp_log_lpr_m.txt
    grep '\[LPR\] Indegree inequalities added: '                   "$entry""_xp1.out"  >>tmp_log_lpr_i.txt
    grep '\[LPR\] Generalized single-colour inequalities added: '  "$entry""_xp1.out"  >>tmp_log_lpr_g.txt
    grep '\[LPR\] Multiway inequalities added: '                   "$entry""_xp1.out"  >>tmp_log_lpr_w.txt
    sed -i 's/\[LPR\] Minimal separator inequalities added: //g' tmp_log_lpr_m.txt
    sed -i 's/\[LPR\] Indegree inequalities added: //g' tmp_log_lpr_i.txt
    sed -i 's/\[LPR\] Generalized single-colour inequalities added: //g' tmp_log_lpr_g.txt
    sed -i 's/\[LPR\] Multiway inequalities added: //g' tmp_log_lpr_w.txt
    paste tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt | awk '{print $1 + $2 + $3 + $4}' >>tmp_log_lpr.txt
    rm tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt

    # get the number of cuts shown in the final statistics (cuts actually applied to improve the dual bound)
    grep 'User: ' "$entry""_xp1.out" >>tmp_log_user.txt || echo "  User: 0" >>tmp_log_user.txt
    grep 'Lazy ' "$entry""_xp1.out" >>tmp_log_lazy.txt || echo "  Lazy constraints: 0" >>tmp_log_lazy.txt
    sed -i 's/  User: //g' tmp_log_user.txt
    sed -i 's/  Lazy constraints: //g' tmp_log_lazy.txt

    # if not running/adding cuts from strengthened LPR above, just count user cuts + lazy constraints
    #paste tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % "$1 + $2}' >>xp1.dat
    #rm tmp_log_user.txt tmp_log_lazy.txt

    # otherwise, saving cut count during LPR and user+lazy
    paste tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % " $1 " + " $2 + $3}' >>xp1.dat
    rm tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt

    ((++idx))
done
