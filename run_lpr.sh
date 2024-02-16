#!/bin/bash

instances=(
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
)

# xp1: plain = msi+indegree, k=2
num_subgraphs=2
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp1.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs  [xp1]"

    output=$(./cks_plain  $entry  $num_subgraphs "xp1.dat" >> "$entry""_xp1.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp1.out")

    ((++idx))
done

# xp2: full = msi+gsci+multiway, k=2
num_subgraphs=2
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp2.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs  [xp2]"

    output=$(./cks_full  $entry  $num_subgraphs "xp2.dat" >> "$entry""_xp2.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp2.out")

    ((++idx))
done


# xp3: plain = msi+indegree, k=3
num_subgraphs=3
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp3.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs  [xp3]"

    output=$(./cks_plain  $entry  $num_subgraphs "xp3.dat" >> "$entry""_xp3.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp3.out")

    ((++idx))
done

# xp4: full = msi+gsci+multiway, k=3
num_subgraphs=3
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp4.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs  [xp4]"

    output=$(./cks_full  $entry  $num_subgraphs "xp4.dat" >> "$entry""_xp4.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp4.out")

    ((++idx))
done

# xp5: plain = msi+indegree, k=4
num_subgraphs=4
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp5.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs  [xp5]"

    output=$(./cks_plain  $entry  $num_subgraphs "xp5.dat" >> "$entry""_xp5.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp5.out")

    ((++idx))
done

# xp6: full = msi+gsci+multiway, k=4
num_subgraphs=4
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp6.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs  [xp6]"

    output=$(./cks_full  $entry  $num_subgraphs "xp6.dat" >> "$entry""_xp6.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp6.out")

    ((++idx))
done

# xp7: plain = msi+indegree, k=5
num_subgraphs=5
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp7.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs  [xp7]"

    output=$(./cks_plain  $entry  $num_subgraphs "xp7.dat" >> "$entry""_xp7.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp7.out")

    ((++idx))
done

# xp8: full = msi+gsci+multiway, k=5
num_subgraphs=5
idx=1
for entry in "${instances[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry  $num_subgraphs" >> "$entry""_xp8.out")
    echo "[$timestamp] $idx/${#instances[@]}:  $entry  $num_subgraphs  [xp8]"

    output=$(./cks_full  $entry  $num_subgraphs "xp8.dat" >> "$entry""_xp8.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp8.out")

    ((++idx))
done

