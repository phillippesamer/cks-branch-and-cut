#!/bin/bash

instances=(
"./input/dimacs-MWCS-GAM/3a0d4427fe32.stp"
"./input/dimacs-MWCS-GAM/3a0dff0eb70.stp"
"./input/dimacs-MWCS-GAM/48e76a6886bc.stp"
"./input/dimacs-MWCS-GAM/3a0d2255a681.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-ACTMOD/drosophila001.stp"
"./input/dimacs-MWCS-ACTMOD/HCMV.stp"
"./input/dimacs-MWCS-ACTMOD/metabol_expr_mice_1.stp"
"./input/dimacs-MWCS-ACTMOD/metabol_expr_mice_3.stp"
)

all_instances=(
"./input/dimacs-MWCS-ACTMOD/drosophila001.stp"
"./input/dimacs-MWCS-ACTMOD/drosophila005.stp"
"./input/dimacs-MWCS-ACTMOD/drosophila0075.stp"
"./input/dimacs-MWCS-ACTMOD/HCMV.stp"
"./input/dimacs-MWCS-ACTMOD/lymphoma.stp"
"./input/dimacs-MWCS-ACTMOD/metabol_expr_mice_1.stp"
"./input/dimacs-MWCS-ACTMOD/metabol_expr_mice_2.stp"
"./input/dimacs-MWCS-ACTMOD/metabol_expr_mice_3.stp"
"./input/dimacs-MWCS-GAM/25e814a792c4.stp"
"./input/dimacs-MWCS-GAM/25e81700dead.stp"
"./input/dimacs-MWCS-GAM/25e83661bc4.stp"
"./input/dimacs-MWCS-GAM/25e83d7dbeea.stp"
"./input/dimacs-MWCS-GAM/25e857e14393.stp"
"./input/dimacs-MWCS-GAM/3a0d1335fe78.stp"
"./input/dimacs-MWCS-GAM/3a0d151a8ee0.stp"
"./input/dimacs-MWCS-GAM/3a0d17a83362.stp"
"./input/dimacs-MWCS-GAM/3a0d1a1e31cf.stp"
"./input/dimacs-MWCS-GAM/3a0d2255a681.stp"
"./input/dimacs-MWCS-GAM/3a0d226a0a5c.stp"
"./input/dimacs-MWCS-GAM/3a0d25c9a738.stp"
"./input/dimacs-MWCS-GAM/3a0d25f9bda3.stp"
"./input/dimacs-MWCS-GAM/3a0d2875c8cf.stp"
"./input/dimacs-MWCS-GAM/3a0d325af5cc.stp"
"./input/dimacs-MWCS-GAM/3a0d32b18854.stp"
"./input/dimacs-MWCS-GAM/3a0d33d2aa32.stp"
"./input/dimacs-MWCS-GAM/3a0d390c537e.stp"
"./input/dimacs-MWCS-GAM/3a0d435ee480.stp"
"./input/dimacs-MWCS-GAM/3a0d4427fe32.stp"
"./input/dimacs-MWCS-GAM/3a0d4ccc9b37.stp"
"./input/dimacs-MWCS-GAM/3a0d4dac5319.stp"
"./input/dimacs-MWCS-GAM/3a0d52ee8185.stp"
"./input/dimacs-MWCS-GAM/3a0d55ddd0a5.stp"
"./input/dimacs-MWCS-GAM/3a0d568fbd87.stp"
"./input/dimacs-MWCS-GAM/3a0d5dc4a759.stp"
"./input/dimacs-MWCS-GAM/3a0d5e4aac27.stp"
"./input/dimacs-MWCS-GAM/3a0d5e4aac27x.stp"
"./input/dimacs-MWCS-GAM/3a0d610beb4c.stp"
"./input/dimacs-MWCS-GAM/3a0d6505353b.stp"
"./input/dimacs-MWCS-GAM/3a0d6a21bbd5.stp"
"./input/dimacs-MWCS-GAM/3a0d6e97602a.stp"
"./input/dimacs-MWCS-GAM/3a0d724ffec9.stp"
"./input/dimacs-MWCS-GAM/3a0d73143aeb.stp"
"./input/dimacs-MWCS-GAM/3a0dff0eb70.stp"
"./input/dimacs-MWCS-GAM/48e7452da6ba.stp"
"./input/dimacs-MWCS-GAM/48e7526364af.stp"
"./input/dimacs-MWCS-GAM/48e76a6886bc.stp"
"./input/dimacs-MWCS-GAM/795313fd138b.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.25-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.25-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.25-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.5-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.5-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.75-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.75-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-0.6-d-0.75-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.25-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.25-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.25-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.5-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.5-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.75-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.75-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1000-a-1-d-0.75-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.25-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.25-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.25-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.5-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.5-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.75-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.75-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-0.6-d-0.75-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.25-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.25-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.25-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.5-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.5-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.75-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.75-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-1500-a-1-d-0.75-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-0.62-d-0.25-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-0.62-d-0.25-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-0.62-d-0.25-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-0.62-d-0.5-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-0.62-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-0.62-d-0.5-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-0.62-d-0.75-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-0.62-d-0.75-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-0.62-d-0.75-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-1-d-0.25-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-1-d-0.25-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-1-d-0.25-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-1-d-0.5-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-1-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-1-d-0.5-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-1-d-0.75-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-1-d-0.75-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-500-a-1-d-0.75-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-0.647-d-0.25-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-0.647-d-0.25-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-0.647-d-0.25-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-0.647-d-0.5-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-0.647-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-0.647-d-0.5-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-0.647-d-0.75-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-0.647-d-0.75-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-0.647-d-0.75-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-1-d-0.25-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-1-d-0.25-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-1-d-0.25-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-1-d-0.5-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-1-d-0.5-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-1-d-0.5-e-0.75.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-1-d-0.75-e-0.25.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-1-d-0.75-e-0.5.stp"
"./input/dimacs-MWCS-JMPALMK/MWCS-I-D-n-750-a-1-d-0.75-e-0.75.stp"
)


# xp1: plain = msi+indegree, k=5
num_subgraphs=5
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    #if [ $idx -eq 1 ]
    #then
    #    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs  [xp1]"
    #    ((++idx))
    #    continue
    #fi
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp1.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs  [xp1]"

    output=$(./cks_plain  $entry  $num_subgraphs "xp1.dat" >> "$entry""_xp1.out" 2>&1)
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

# xp2: full = msi+gsci+multiway, k=5
num_subgraphs=5
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp2.out")
    echo "[$timestamp] $idx/${#instances[@]}$entry  $num_subgraphs  [xp2]"

    output=$(./cks_full  $entry  $num_subgraphs "xp2.dat" >> "$entry""_xp2.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp2.out")

    # adding number of cuts from the strengthened LP relaxation to those reported by gurobi
    grep '\[LPR\] Minimal separator inequalities added: '          "$entry""_xp2.out"  >>tmp_log_lpr_m.txt
    grep '\[LPR\] Indegree inequalities added: '                   "$entry""_xp2.out"  >>tmp_log_lpr_i.txt
    grep '\[LPR\] Generalized single-colour inequalities added: '  "$entry""_xp2.out"  >>tmp_log_lpr_g.txt
    grep '\[LPR\] Multiway inequalities added: '                   "$entry""_xp2.out"  >>tmp_log_lpr_w.txt
    sed -i 's/\[LPR\] Minimal separator inequalities added: //g' tmp_log_lpr_m.txt
    sed -i 's/\[LPR\] Indegree inequalities added: //g' tmp_log_lpr_i.txt
    sed -i 's/\[LPR\] Generalized single-colour inequalities added: //g' tmp_log_lpr_g.txt
    sed -i 's/\[LPR\] Multiway inequalities added: //g' tmp_log_lpr_w.txt
    paste tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt | awk '{print $1 + $2 + $3 + $4}' >>tmp_log_lpr.txt
    rm tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt

    # get the number of cuts shown in the final statistics (cuts actually applied to improve the dual bound)
    grep 'User: ' "$entry""_xp2.out" >>tmp_log_user.txt || echo "  User: 0" >>tmp_log_user.txt
    grep 'Lazy ' "$entry""_xp2.out" >>tmp_log_lazy.txt || echo "  Lazy constraints: 0" >>tmp_log_lazy.txt
    sed -i 's/  User: //g' tmp_log_user.txt
    sed -i 's/  Lazy constraints: //g' tmp_log_lazy.txt

    # if not running/adding cuts from strengthened LPR above, just count user cuts + lazy constraints
    #paste tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % "$1 + $2}' >>xp2.dat
    #rm tmp_log_user.txt tmp_log_lazy.txt

    # otherwise, saving cut count during LPR and user+lazy
    paste tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % " $1 " + " $2 + $3}' >>xp2.dat
    rm tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt

    ((++idx))
done


# xp3: plain = msi+indegree, k=10
num_subgraphs=10
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp3.out")
    echo "[$timestamp] $idx/${#instances[@]}$entry  $num_subgraphs  [xp3]"

    output=$(./cks_plain  $entry  $num_subgraphs "xp3.dat" >> "$entry""_xp3.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp3.out")

    # adding number of cuts from the strengthened LP relaxation to those reported by gurobi
    grep '\[LPR\] Minimal separator inequalities added: '          "$entry""_xp3.out"  >>tmp_log_lpr_m.txt
    grep '\[LPR\] Indegree inequalities added: '                   "$entry""_xp3.out"  >>tmp_log_lpr_i.txt
    grep '\[LPR\] Generalized single-colour inequalities added: '  "$entry""_xp3.out"  >>tmp_log_lpr_g.txt
    grep '\[LPR\] Multiway inequalities added: '                   "$entry""_xp3.out"  >>tmp_log_lpr_w.txt
    sed -i 's/\[LPR\] Minimal separator inequalities added: //g' tmp_log_lpr_m.txt
    sed -i 's/\[LPR\] Indegree inequalities added: //g' tmp_log_lpr_i.txt
    sed -i 's/\[LPR\] Generalized single-colour inequalities added: //g' tmp_log_lpr_g.txt
    sed -i 's/\[LPR\] Multiway inequalities added: //g' tmp_log_lpr_w.txt
    paste tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt | awk '{print $1 + $2 + $3 + $4}' >>tmp_log_lpr.txt
    rm tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt

    # get the number of cuts shown in the final statistics (cuts actually applied to improve the dual bound)
    grep 'User: ' "$entry""_xp3.out" >>tmp_log_user.txt || echo "  User: 0" >>tmp_log_user.txt
    grep 'Lazy ' "$entry""_xp3.out" >>tmp_log_lazy.txt || echo "  Lazy constraints: 0" >>tmp_log_lazy.txt
    sed -i 's/  User: //g' tmp_log_user.txt
    sed -i 's/  Lazy constraints: //g' tmp_log_lazy.txt

    # if not running/adding cuts from strengthened LPR above, just count user cuts + lazy constraints
    #paste tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % "$1 + $2}' >>xp3.dat
    #rm tmp_log_user.txt tmp_log_lazy.txt

    # otherwise, saving cut count during LPR and user+lazy
    paste tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % " $1 " + " $2 + $3}' >>xp3.dat
    rm tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt

    ((++idx))
done

# xp4: full = msi+gsci+multiway, k=10
num_subgraphs=10
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp4.out")
    echo "[$timestamp] $idx/${#instances[@]}$entry  $num_subgraphs  [xp4]"

    output=$(./cks_full  $entry  $num_subgraphs "xp4.dat" >> "$entry""_xp4.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp4.out")

    # adding number of cuts from the strengthened LP relaxation to those reported by gurobi
    grep '\[LPR\] Minimal separator inequalities added: '          "$entry""_xp4.out"  >>tmp_log_lpr_m.txt
    grep '\[LPR\] Indegree inequalities added: '                   "$entry""_xp4.out"  >>tmp_log_lpr_i.txt
    grep '\[LPR\] Generalized single-colour inequalities added: '  "$entry""_xp4.out"  >>tmp_log_lpr_g.txt
    grep '\[LPR\] Multiway inequalities added: '                   "$entry""_xp4.out"  >>tmp_log_lpr_w.txt
    sed -i 's/\[LPR\] Minimal separator inequalities added: //g' tmp_log_lpr_m.txt
    sed -i 's/\[LPR\] Indegree inequalities added: //g' tmp_log_lpr_i.txt
    sed -i 's/\[LPR\] Generalized single-colour inequalities added: //g' tmp_log_lpr_g.txt
    sed -i 's/\[LPR\] Multiway inequalities added: //g' tmp_log_lpr_w.txt
    paste tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt | awk '{print $1 + $2 + $3 + $4}' >>tmp_log_lpr.txt
    rm tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt

    # get the number of cuts shown in the final statistics (cuts actually applied to improve the dual bound)
    grep 'User: ' "$entry""_xp4.out" >>tmp_log_user.txt || echo "  User: 0" >>tmp_log_user.txt
    grep 'Lazy ' "$entry""_xp4.out" >>tmp_log_lazy.txt || echo "  Lazy constraints: 0" >>tmp_log_lazy.txt
    sed -i 's/  User: //g' tmp_log_user.txt
    sed -i 's/  Lazy constraints: //g' tmp_log_lazy.txt

    # if not running/adding cuts from strengthened LPR above, just count user cuts + lazy constraints
    #paste tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % "$1 + $2}' >>xp4.dat
    #rm tmp_log_user.txt tmp_log_lazy.txt

    # otherwise, saving cut count during LPR and user+lazy
    paste tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % " $1 " + " $2 + $3}' >>xp4.dat
    rm tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt

    ((++idx))
done

