#!/bin/bash

instances=(
"./input/HAND_SMALL/handsd01.stp"  
"./input/HAND_SMALL/handsd02.stp"  
"./input/HAND_SMALL/handsd03.stp"  
"./input/HAND_SMALL/handsd04.stp"  
"./input/HAND_SMALL/handsd05.stp"  
"./input/HAND_SMALL/handsd06.stp"  
"./input/HAND_SMALL/handsd07.stp"  
"./input/HAND_SMALL/handsd08.stp"  
"./input/HAND_SMALL/handsd09.stp"  
"./input/HAND_SMALL/handsd10.stp"  
"./input/HAND_SMALL/handsi01.stp"  
"./input/HAND_SMALL/handsi02.stp"  
"./input/HAND_SMALL/handsi03.stp"  
"./input/HAND_SMALL/handsi04.stp"  
"./input/HAND_SMALL/handsi05.stp"  
"./input/HAND_SMALL/handsi06.stp"  
"./input/HAND_SMALL/handsi07.stp"  
"./input/HAND_SMALL/handsi08.stp"  
"./input/HAND_SMALL/handsi09.stp"  
"./input/HAND_SMALL/handsi10.stp"  
)

GNP1000_25=(
"./input/g_np_1000/1000-1-0.gcc"
"./input/g_np_1000/1000-1-1.gcc"
"./input/g_np_1000/1000-1-2.gcc"
"./input/g_np_1000/1000-1-3.gcc"
"./input/g_np_1000/1000-1-4.gcc"
"./input/g_np_1000/1000-2-0.gcc"
"./input/g_np_1000/1000-2-1.gcc"
"./input/g_np_1000/1000-2-2.gcc"
"./input/g_np_1000/1000-2-3.gcc"
"./input/g_np_1000/1000-2-4.gcc"
"./input/g_np_1000/1000-3-0.gcc"
"./input/g_np_1000/1000-3-1.gcc"
"./input/g_np_1000/1000-3-2.gcc"
"./input/g_np_1000/1000-3-3.gcc"
"./input/g_np_1000/1000-3-4.gcc"
"./input/g_np_1000/1000-4-0.gcc"
"./input/g_np_1000/1000-4-1.gcc"
"./input/g_np_1000/1000-4-2.gcc"
"./input/g_np_1000/1000-4-3.gcc"
"./input/g_np_1000/1000-4-4.gcc"
"./input/g_np_1000/1000-5-0.gcc"
"./input/g_np_1000/1000-5-1.gcc"
"./input/g_np_1000/1000-5-2.gcc"
"./input/g_np_1000/1000-5-3.gcc"
"./input/g_np_1000/1000-5-4.gcc"
)

DIMACS_15=(
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

# xp1: plain = msi+indegree, k=2
num_subgraphs=2
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp1.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs"

    output=$(./cks_plain  $entry  $num_subgraphs "-e" >> "$entry""_xp1.out" 2>&1)
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

### # xp2: msi+gsci, k=2
### num_subgraphs=2
### idx=1
### for entry in "${instances[@]}";
### do
###     timestamp=$(date)
###     $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp2.out")
###     echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs"
### 
###     output=$(./cks_gsci  $entry  $num_subgraphs  >> "$entry""_xp2.out" 2>&1)
###     echo "$output"
### 
###     timestamp=$(date)
###     $(echo -e "[$timestamp]  done\n" >> "$entry""_xp2.out")
### 
###     # adding number of cuts from the strengthened LP relaxation to those reported by gurobi
###     grep '\[LPR\] Minimal separator inequalities added: '          "$entry""_xp2.out"  >>tmp_log_lpr_m.txt
###     grep '\[LPR\] Indegree inequalities added: '                   "$entry""_xp2.out"  >>tmp_log_lpr_i.txt
###     grep '\[LPR\] Generalized single-colour inequalities added: '  "$entry""_xp2.out"  >>tmp_log_lpr_g.txt
###     grep '\[LPR\] Multiway inequalities added: '                   "$entry""_xp2.out"  >>tmp_log_lpr_w.txt
###     sed -i 's/\[LPR\] Minimal separator inequalities added: //g' tmp_log_lpr_m.txt
###     sed -i 's/\[LPR\] Indegree inequalities added: //g' tmp_log_lpr_i.txt
###     sed -i 's/\[LPR\] Generalized single-colour inequalities added: //g' tmp_log_lpr_g.txt
###     sed -i 's/\[LPR\] Multiway inequalities added: //g' tmp_log_lpr_w.txt
###     paste tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt | awk '{print $1 + $2 + $3 + $4}' >>tmp_log_lpr.txt
###     rm tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt
### 
###     # get the number of cuts shown in the final statistics (cuts actually applied to improve the dual bound)
###     grep 'User: ' "$entry""_xp2.out" >>tmp_log_user.txt || echo "  User: 0" >>tmp_log_user.txt
###     grep 'Lazy ' "$entry""_xp2.out" >>tmp_log_lazy.txt || echo "  Lazy constraints: 0" >>tmp_log_lazy.txt
###     sed -i 's/  User: //g' tmp_log_user.txt
###     sed -i 's/  Lazy constraints: //g' tmp_log_lazy.txt
### 
###     # if not running/adding cuts from strengthened LPR above, just count user cuts + lazy constraints
###     #paste tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % "$1 + $2}' >>xp2.dat
###     #rm tmp_log_user.txt tmp_log_lazy.txt
### 
###     # otherwise, saving cut count during LPR and user+lazy
###     paste tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % " $1 " + " $2 + $3}' >>xp2.dat
###     rm tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt
### 
###     ((++idx))
### done
### 
### # xp3: msi+indegree+multiway, k=2
### num_subgraphs=2
### idx=1
### for entry in "${instances[@]}";
### do
###     timestamp=$(date)
###     $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp3.out")
###     echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs"
### 
###     output=$(./cks_multiway  $entry  $num_subgraphs  >> "$entry""_xp3.out" 2>&1)
###     echo "$output"
### 
###     timestamp=$(date)
###     $(echo -e "[$timestamp]  done\n" >> "$entry""_xp3.out")
### 
###     # adding number of cuts from the strengthened LP relaxation to those reported by gurobi
###     grep '\[LPR\] Minimal separator inequalities added: '          "$entry""_xp3.out"  >>tmp_log_lpr_m.txt
###     grep '\[LPR\] Indegree inequalities added: '                   "$entry""_xp3.out"  >>tmp_log_lpr_i.txt
###     grep '\[LPR\] Generalized single-colour inequalities added: '  "$entry""_xp3.out"  >>tmp_log_lpr_g.txt
###     grep '\[LPR\] Multiway inequalities added: '                   "$entry""_xp3.out"  >>tmp_log_lpr_w.txt
###     sed -i 's/\[LPR\] Minimal separator inequalities added: //g' tmp_log_lpr_m.txt
###     sed -i 's/\[LPR\] Indegree inequalities added: //g' tmp_log_lpr_i.txt
###     sed -i 's/\[LPR\] Generalized single-colour inequalities added: //g' tmp_log_lpr_g.txt
###     sed -i 's/\[LPR\] Multiway inequalities added: //g' tmp_log_lpr_w.txt
###     paste tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt | awk '{print $1 + $2 + $3 + $4}' >>tmp_log_lpr.txt
###     rm tmp_log_lpr_m.txt tmp_log_lpr_i.txt tmp_log_lpr_g.txt tmp_log_lpr_w.txt
### 
###     # get the number of cuts shown in the final statistics (cuts actually applied to improve the dual bound)
###     grep 'User: ' "$entry""_xp3.out" >>tmp_log_user.txt || echo "  User: 0" >>tmp_log_user.txt
###     grep 'Lazy ' "$entry""_xp3.out" >>tmp_log_lazy.txt || echo "  Lazy constraints: 0" >>tmp_log_lazy.txt
###     sed -i 's/  User: //g' tmp_log_user.txt
###     sed -i 's/  Lazy constraints: //g' tmp_log_lazy.txt
### 
###     # if not running/adding cuts from strengthened LPR above, just count user cuts + lazy constraints
###     #paste tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % "$1 + $2}' >>xp3.dat
###     #rm tmp_log_user.txt tmp_log_lazy.txt
### 
###     # otherwise, saving cut count during LPR and user+lazy
###     paste tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt | awk '{print " % " $1 " + " $2 + $3}' >>xp3.dat
###     rm tmp_log_lpr.txt tmp_log_user.txt tmp_log_lazy.txt
### 
###     ((++idx))
### done

# xp4: full = msi+gsci+multiway, k=2
num_subgraphs=2
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp4.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs"

    output=$(./cks_full  $entry  $num_subgraphs "-e" >> "$entry""_xp4.out" 2>&1)
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


# xp1: plain = msi+indegree, k=3
num_subgraphs=3
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp1.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs"

    output=$(./cks_plain  $entry  $num_subgraphs "-e" >> "$entry""_xp1.out" 2>&1)
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

# xp4: full = msi+gsci+multiway, k=3
num_subgraphs=3
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp4.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs"

    output=$(./cks_full  $entry  $num_subgraphs "-e" >> "$entry""_xp4.out" 2>&1)
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

