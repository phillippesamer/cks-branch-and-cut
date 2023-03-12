#!/bin/bash

instances_gnp_50=( 
"./input/new_g_np/50-1-0.gcc"  
"./input/new_g_np/50-1-1.gcc"  
"./input/new_g_np/50-1-2.gcc"  
"./input/new_g_np/50-1-3.gcc"  
"./input/new_g_np/50-1-4.gcc"  
"./input/new_g_np/50-2-0.gcc"  
"./input/new_g_np/50-2-1.gcc"  
"./input/new_g_np/50-2-2.gcc"  
"./input/new_g_np/50-2-3.gcc"  
"./input/new_g_np/50-2-4.gcc"  
"./input/new_g_np/50-3-0.gcc"  
"./input/new_g_np/50-3-1.gcc"  
"./input/new_g_np/50-3-2.gcc"  
"./input/new_g_np/50-3-3.gcc"  
"./input/new_g_np/50-3-4.gcc"  
"./input/new_g_np/50-4-0.gcc"  
"./input/new_g_np/50-4-1.gcc"  
"./input/new_g_np/50-4-2.gcc"  
"./input/new_g_np/50-4-3.gcc"  
"./input/new_g_np/50-4-4.gcc"  
"./input/new_g_np/50-5-0.gcc"  
"./input/new_g_np/50-5-1.gcc"  
"./input/new_g_np/50-5-2.gcc"  
"./input/new_g_np/50-5-3.gcc"  
"./input/new_g_np/50-5-4.gcc"  
"./input/new_g_np/50-6-0.gcc"  
"./input/new_g_np/50-6-1.gcc"  
"./input/new_g_np/50-6-2.gcc"  
"./input/new_g_np/50-6-3.gcc"  
"./input/new_g_np/50-6-4.gcc"  
"./input/new_g_np/50-7-0.gcc"  
"./input/new_g_np/50-7-1.gcc"  
"./input/new_g_np/50-7-2.gcc"  
"./input/new_g_np/50-7-3.gcc"  
"./input/new_g_np/50-7-4.gcc"  
"./input/new_g_np/50-8-0.gcc"  
"./input/new_g_np/50-8-1.gcc"  
"./input/new_g_np/50-8-2.gcc"  
"./input/new_g_np/50-8-3.gcc"  
"./input/new_g_np/50-8-4.gcc"  
"./input/new_g_np/50-9-0.gcc"  
"./input/new_g_np/50-9-1.gcc"  
"./input/new_g_np/50-9-2.gcc"  
"./input/new_g_np/50-9-3.gcc"  
"./input/new_g_np/50-9-4.gcc"  
"./input/new_g_np/50-10-0.gcc"  
"./input/new_g_np/50-10-1.gcc"  
"./input/new_g_np/50-10-2.gcc"  
"./input/new_g_np/50-10-3.gcc"  
"./input/new_g_np/50-10-4.gcc"  
"./input/new_g_np/50-11-0.gcc"  
"./input/new_g_np/50-11-1.gcc"  
"./input/new_g_np/50-11-2.gcc"  
"./input/new_g_np/50-11-3.gcc"  
"./input/new_g_np/50-11-4.gcc"  
"./input/new_g_np/50-12-0.gcc"  
"./input/new_g_np/50-12-1.gcc"  
"./input/new_g_np/50-12-2.gcc"  
"./input/new_g_np/50-12-3.gcc"  
"./input/new_g_np/50-12-4.gcc"  
"./input/new_g_np/50-13-0.gcc"  
"./input/new_g_np/50-13-1.gcc"  
"./input/new_g_np/50-13-2.gcc"  
"./input/new_g_np/50-13-3.gcc"  
"./input/new_g_np/50-13-4.gcc"  
"./input/new_g_np/50-14-0.gcc"  
"./input/new_g_np/50-14-1.gcc"  
"./input/new_g_np/50-14-2.gcc"  
"./input/new_g_np/50-14-3.gcc"  
"./input/new_g_np/50-14-4.gcc"  
"./input/new_g_np/50-15-0.gcc"  
"./input/new_g_np/50-15-1.gcc"  
"./input/new_g_np/50-15-2.gcc"  
"./input/new_g_np/50-15-3.gcc"  
"./input/new_g_np/50-15-4.gcc"  
"./input/new_g_np/50-16-0.gcc"  
"./input/new_g_np/50-16-1.gcc"  
"./input/new_g_np/50-16-2.gcc"  
"./input/new_g_np/50-16-3.gcc"  
"./input/new_g_np/50-16-4.gcc"  
"./input/new_g_np/50-17-0.gcc"  
"./input/new_g_np/50-17-1.gcc"  
"./input/new_g_np/50-17-2.gcc"  
"./input/new_g_np/50-17-3.gcc"  
"./input/new_g_np/50-17-4.gcc"  
"./input/new_g_np/50-18-0.gcc"  
"./input/new_g_np/50-18-1.gcc"  
"./input/new_g_np/50-18-2.gcc"  
"./input/new_g_np/50-18-3.gcc"  
"./input/new_g_np/50-18-4.gcc"  
"./input/new_g_np/50-19-0.gcc"  
"./input/new_g_np/50-19-1.gcc"  
"./input/new_g_np/50-19-2.gcc"  
"./input/new_g_np/50-19-3.gcc"  
"./input/new_g_np/50-19-4.gcc"  
"./input/new_g_np/50-20-0.gcc"  
"./input/new_g_np/50-20-1.gcc"  
"./input/new_g_np/50-20-2.gcc"  
"./input/new_g_np/50-20-3.gcc"  
"./input/new_g_np/50-20-4.gcc"  
"./input/new_g_np/50-21-0.gcc"  
"./input/new_g_np/50-21-1.gcc"  
"./input/new_g_np/50-21-2.gcc"  
"./input/new_g_np/50-21-3.gcc"  
"./input/new_g_np/50-21-4.gcc"  
"./input/new_g_np/50-22-0.gcc"  
"./input/new_g_np/50-22-1.gcc"  
"./input/new_g_np/50-22-2.gcc"  
"./input/new_g_np/50-22-3.gcc"  
"./input/new_g_np/50-22-4.gcc"  
"./input/new_g_np/50-23-0.gcc"  
"./input/new_g_np/50-23-1.gcc"  
"./input/new_g_np/50-23-2.gcc"  
"./input/new_g_np/50-23-3.gcc"  
"./input/new_g_np/50-23-4.gcc"  
"./input/new_g_np/50-24-0.gcc"  
"./input/new_g_np/50-24-1.gcc"  
"./input/new_g_np/50-24-2.gcc"  
"./input/new_g_np/50-24-3.gcc"  
"./input/new_g_np/50-24-4.gcc"  
"./input/new_g_np/50-25-0.gcc"  
"./input/new_g_np/50-25-1.gcc"  
"./input/new_g_np/50-25-2.gcc"  
"./input/new_g_np/50-25-3.gcc"  
"./input/new_g_np/50-25-4.gcc"  
)

instances_gnp_50_num_colours=( 
"7"
"7"
"7"
"7"
"7"
"6"
"6"
"6"
"6"
"6"
"8"
"8"
"8"
"8"
"8"
"7"
"7"
"7"
"7"
"7"
"11"
"11"
"11"
"11"
"11"
"13"
"13"
"13"
"13"
"13"
"6"
"6"
"6"
"6"
"6"
"11"
"11"
"11"
"11"
"11"
"14"
"14"
"14"
"14"
"14"
"11"
"11"
"11"
"11"
"11"
"10"
"10"
"10"
"10"
"10"
"10"
"10"
"10"
"10"
"10"
"4"
"4"
"4"
"4"
"4"
"14"
"14"
"14"
"14"
"14"
"8"
"8"
"8"
"8"
"8"
"7"
"7"
"7"
"7"
"7"
"12"
"12"
"12"
"12"
"12"
"5"
"5"
"5"
"5"
"5"
"4"
"4"
"4"
"4"
"4"
"13"
"13"
"13"
"13"
"13"
"3"
"3"
"3"
"3"
"3"
"14"
"14"
"14"
"14"
"14"
"13"
"13"
"13"
"13"
"13"
"4"
"4"
"4"
"4"
"4"
"6"
"6"
"6"
"6"
"6"
)

instances_025=( 
"./input/itor2020-instances/10/010_010_025.gcc"   
"./input/itor2020-instances/10/010_020_025.gcc"   
"./input/itor2020-instances/10/010_030_025.gcc"   
"./input/itor2020-instances/10/010_040_025.gcc"   
"./input/itor2020-instances/10/010_050_025.gcc"   
"./input/itor2020-instances/20/020_010_025.gcc"   
"./input/itor2020-instances/20/020_020_025.gcc"   
"./input/itor2020-instances/20/020_030_025.gcc"   
"./input/itor2020-instances/20/020_040_025.gcc"   
"./input/itor2020-instances/20/020_050_025.gcc"   
"./input/itor2020-instances/30/030_010_025.gcc"   
"./input/itor2020-instances/30/030_020_025.gcc"   
"./input/itor2020-instances/30/030_030_025.gcc"   
"./input/itor2020-instances/30/030_040_025.gcc"   
"./input/itor2020-instances/30/030_050_025.gcc"   
"./input/itor2020-instances/40/040_010_025.gcc"   
"./input/itor2020-instances/40/040_020_025.gcc"   
"./input/itor2020-instances/40/040_030_025.gcc"   
"./input/itor2020-instances/40/040_040_025.gcc"   
"./input/itor2020-instances/40/040_050_025.gcc"   
"./input/itor2020-instances/50/050_010_025.gcc"   
"./input/itor2020-instances/50/050_020_025.gcc"   
"./input/itor2020-instances/50/050_030_025.gcc"   
"./input/itor2020-instances/50/050_040_025.gcc"   
"./input/itor2020-instances/50/050_050_025.gcc"   
"./input/itor2020-instances/60/060_010_025.gcc"   
"./input/itor2020-instances/60/060_020_025.gcc"   
"./input/itor2020-instances/60/060_030_025.gcc"   
"./input/itor2020-instances/60/060_040_025.gcc"   
"./input/itor2020-instances/60/060_050_025.gcc"   
"./input/itor2020-instances/70/070_010_025.gcc"   
"./input/itor2020-instances/70/070_020_025.gcc"   
"./input/itor2020-instances/70/070_030_025.gcc"   
"./input/itor2020-instances/70/070_040_025.gcc"   
"./input/itor2020-instances/70/070_050_025.gcc"   
"./input/itor2020-instances/80/080_010_025.gcc"   
"./input/itor2020-instances/80/080_020_025.gcc"   
"./input/itor2020-instances/80/080_030_025.gcc"   
"./input/itor2020-instances/80/080_040_025.gcc"   
"./input/itor2020-instances/80/080_050_025.gcc"   
"./input/itor2020-instances/90/090_010_025.gcc"   
"./input/itor2020-instances/90/090_020_025.gcc"   
"./input/itor2020-instances/90/090_030_025.gcc"   
"./input/itor2020-instances/90/090_040_025.gcc"   
"./input/itor2020-instances/90/090_050_025.gcc"   
"./input/itor2020-instances/100/100_010_025.gcc"   
"./input/itor2020-instances/100/100_020_025.gcc"   
"./input/itor2020-instances/100/100_030_025.gcc"   
"./input/itor2020-instances/100/100_040_025.gcc"   
"./input/itor2020-instances/100/100_050_025.gcc"   
)

bounds_025=( 
"./input/itor2020-bounds/10/010_010_025.gcc"   
"./input/itor2020-bounds/10/010_020_025.gcc"   
"./input/itor2020-bounds/10/010_030_025.gcc"   
"./input/itor2020-bounds/10/010_040_025.gcc"   
"./input/itor2020-bounds/10/010_050_025.gcc"   
"./input/itor2020-bounds/20/020_010_025.gcc"   
"./input/itor2020-bounds/20/020_020_025.gcc"   
"./input/itor2020-bounds/20/020_030_025.gcc"   
"./input/itor2020-bounds/20/020_040_025.gcc"   
"./input/itor2020-bounds/20/020_050_025.gcc"   
"./input/itor2020-bounds/30/030_010_025.gcc"   
"./input/itor2020-bounds/30/030_020_025.gcc"   
"./input/itor2020-bounds/30/030_030_025.gcc"   
"./input/itor2020-bounds/30/030_040_025.gcc"   
"./input/itor2020-bounds/30/030_050_025.gcc"   
"./input/itor2020-bounds/40/040_010_025.gcc"   
"./input/itor2020-bounds/40/040_020_025.gcc"   
"./input/itor2020-bounds/40/040_030_025.gcc"   
"./input/itor2020-bounds/40/040_040_025.gcc"   
"./input/itor2020-bounds/40/040_050_025.gcc"   
"./input/itor2020-bounds/50/050_010_025.gcc"   
"./input/itor2020-bounds/50/050_020_025.gcc"   
"./input/itor2020-bounds/50/050_030_025.gcc"   
"./input/itor2020-bounds/50/050_040_025.gcc"   
"./input/itor2020-bounds/50/050_050_025.gcc"   
"./input/itor2020-bounds/60/060_010_025.gcc"   
"./input/itor2020-bounds/60/060_020_025.gcc"   
"./input/itor2020-bounds/60/060_030_025.gcc"   
"./input/itor2020-bounds/60/060_040_025.gcc"   
"./input/itor2020-bounds/60/060_050_025.gcc"   
"./input/itor2020-bounds/70/070_010_025.gcc"   
"./input/itor2020-bounds/70/070_020_025.gcc"   
"./input/itor2020-bounds/70/070_030_025.gcc"   
"./input/itor2020-bounds/70/070_040_025.gcc"   
"./input/itor2020-bounds/70/070_050_025.gcc"   
"./input/itor2020-bounds/80/080_010_025.gcc"   
"./input/itor2020-bounds/80/080_020_025.gcc"   
"./input/itor2020-bounds/80/080_030_025.gcc"   
"./input/itor2020-bounds/80/080_040_025.gcc"   
"./input/itor2020-bounds/80/080_050_025.gcc"   
"./input/itor2020-bounds/90/090_010_025.gcc"   
"./input/itor2020-bounds/90/090_020_025.gcc"   
"./input/itor2020-bounds/90/090_030_025.gcc"   
"./input/itor2020-bounds/90/090_040_025.gcc"   
"./input/itor2020-bounds/90/090_050_025.gcc"   
"./input/itor2020-bounds/100/100_010_025.gcc"   
"./input/itor2020-bounds/100/100_020_025.gcc"   
"./input/itor2020-bounds/100/100_030_025.gcc"   
"./input/itor2020-bounds/100/100_040_025.gcc"   
"./input/itor2020-bounds/100/100_050_025.gcc"   
)

instances_075=( 
"./input/itor2020-instances/10/010_010_075.gcc"   
"./input/itor2020-instances/10/010_020_075.gcc"   
"./input/itor2020-instances/10/010_030_075.gcc"   
"./input/itor2020-instances/10/010_040_075.gcc"   
"./input/itor2020-instances/10/010_050_075.gcc"   
"./input/itor2020-instances/20/020_010_075.gcc"   
"./input/itor2020-instances/20/020_020_075.gcc"   
"./input/itor2020-instances/20/020_030_075.gcc"   
"./input/itor2020-instances/20/020_040_075.gcc"   
"./input/itor2020-instances/20/020_050_075.gcc"   
"./input/itor2020-instances/30/030_010_075.gcc"   
"./input/itor2020-instances/30/030_020_075.gcc"   
"./input/itor2020-instances/30/030_030_075.gcc"   
"./input/itor2020-instances/30/030_040_075.gcc"   
"./input/itor2020-instances/30/030_050_075.gcc"   
"./input/itor2020-instances/40/040_010_075.gcc"   
"./input/itor2020-instances/40/040_020_075.gcc"   
"./input/itor2020-instances/40/040_030_075.gcc"   
"./input/itor2020-instances/40/040_040_075.gcc"   
"./input/itor2020-instances/40/040_050_075.gcc"   
"./input/itor2020-instances/50/050_010_075.gcc"   
"./input/itor2020-instances/50/050_020_075.gcc"   
"./input/itor2020-instances/50/050_030_075.gcc"   
"./input/itor2020-instances/50/050_040_075.gcc"   
"./input/itor2020-instances/50/050_050_075.gcc"   
"./input/itor2020-instances/60/060_010_075.gcc"   
"./input/itor2020-instances/60/060_020_075.gcc"   
"./input/itor2020-instances/60/060_030_075.gcc"   
"./input/itor2020-instances/60/060_040_075.gcc"   
"./input/itor2020-instances/60/060_050_075.gcc"   
"./input/itor2020-instances/70/070_010_075.gcc"   
"./input/itor2020-instances/70/070_020_075.gcc"   
"./input/itor2020-instances/70/070_030_075.gcc"   
"./input/itor2020-instances/70/070_040_075.gcc"   
"./input/itor2020-instances/70/070_050_075.gcc"   
"./input/itor2020-instances/80/080_010_075.gcc"   
"./input/itor2020-instances/80/080_020_075.gcc"   
"./input/itor2020-instances/80/080_030_075.gcc"   
"./input/itor2020-instances/80/080_040_075.gcc"   
"./input/itor2020-instances/80/080_050_075.gcc"   
"./input/itor2020-instances/90/090_010_075.gcc"   
"./input/itor2020-instances/90/090_020_075.gcc"   
"./input/itor2020-instances/90/090_030_075.gcc"   
"./input/itor2020-instances/90/090_040_075.gcc"   
"./input/itor2020-instances/90/090_050_075.gcc"   
"./input/itor2020-instances/100/100_010_075.gcc"   
"./input/itor2020-instances/100/100_020_075.gcc"   
"./input/itor2020-instances/100/100_030_075.gcc"   
"./input/itor2020-instances/100/100_040_075.gcc"   
"./input/itor2020-instances/100/100_050_075.gcc"   
)

bounds_075=( 
"./input/itor2020-bounds/10/010_010_075.gcc"   
"./input/itor2020-bounds/10/010_020_075.gcc"   
"./input/itor2020-bounds/10/010_030_075.gcc"   
"./input/itor2020-bounds/10/010_040_075.gcc"   
"./input/itor2020-bounds/10/010_050_075.gcc"   
"./input/itor2020-bounds/20/020_010_075.gcc"   
"./input/itor2020-bounds/20/020_020_075.gcc"   
"./input/itor2020-bounds/20/020_030_075.gcc"   
"./input/itor2020-bounds/20/020_040_075.gcc"   
"./input/itor2020-bounds/20/020_050_075.gcc"   
"./input/itor2020-bounds/30/030_010_075.gcc"   
"./input/itor2020-bounds/30/030_020_075.gcc"   
"./input/itor2020-bounds/30/030_030_075.gcc"   
"./input/itor2020-bounds/30/030_040_075.gcc"   
"./input/itor2020-bounds/30/030_050_075.gcc"   
"./input/itor2020-bounds/40/040_010_075.gcc"   
"./input/itor2020-bounds/40/040_020_075.gcc"   
"./input/itor2020-bounds/40/040_030_075.gcc"   
"./input/itor2020-bounds/40/040_040_075.gcc"   
"./input/itor2020-bounds/40/040_050_075.gcc"   
"./input/itor2020-bounds/50/050_010_075.gcc"   
"./input/itor2020-bounds/50/050_020_075.gcc"   
"./input/itor2020-bounds/50/050_030_075.gcc"   
"./input/itor2020-bounds/50/050_040_075.gcc"   
"./input/itor2020-bounds/50/050_050_075.gcc"   
"./input/itor2020-bounds/60/060_010_075.gcc"   
"./input/itor2020-bounds/60/060_020_075.gcc"   
"./input/itor2020-bounds/60/060_030_075.gcc"   
"./input/itor2020-bounds/60/060_040_075.gcc"   
"./input/itor2020-bounds/60/060_050_075.gcc"   
"./input/itor2020-bounds/70/070_010_075.gcc"   
"./input/itor2020-bounds/70/070_020_075.gcc"   
"./input/itor2020-bounds/70/070_030_075.gcc"   
"./input/itor2020-bounds/70/070_040_075.gcc"   
"./input/itor2020-bounds/70/070_050_075.gcc"   
"./input/itor2020-bounds/80/080_010_075.gcc"   
"./input/itor2020-bounds/80/080_020_075.gcc"   
"./input/itor2020-bounds/80/080_030_075.gcc"   
"./input/itor2020-bounds/80/080_040_075.gcc"   
"./input/itor2020-bounds/80/080_050_075.gcc"   
"./input/itor2020-bounds/90/090_010_075.gcc"   
"./input/itor2020-bounds/90/090_020_075.gcc"   
"./input/itor2020-bounds/90/090_030_075.gcc"   
"./input/itor2020-bounds/90/090_040_075.gcc"   
"./input/itor2020-bounds/90/090_050_075.gcc"   
"./input/itor2020-bounds/100/100_010_075.gcc"   
"./input/itor2020-bounds/100/100_020_075.gcc"   
"./input/itor2020-bounds/100/100_030_075.gcc"   
"./input/itor2020-bounds/100/100_040_075.gcc"   
"./input/itor2020-bounds/100/100_050_075.gcc"   
)

# convex recolouring instances (with a solution file)
#
# idx=0
# for entry in "${instances_025[@]}";
# do
#     timestamp=$(date)
#     $(echo "[$timestamp]  $entry" >> "$entry""_xp4.out")
#     echo "[$timestamp]  $entry"
#
#     output=$(./cks  $entry  ${bounds_025[$idx]} >> "$entry""_xp4.out" 2>&1)
#     echo "$output"
#
#     timestamp=$(date)
#     $(echo -e "[$timestamp]  done\n" >> "$entry""_xp4.out")
#
#     ((++idx))
# done


# new instances

idx=0
for entry in "${instances_gnp_50[@]}";
do
    timestamp=$(date)
    $(echo "[$timestamp]  $entry" >> "$entry""_xp4.out")
    echo "[$timestamp]  $entry"

    output=$(./cks  $entry  ${instances_gnp_50_num_colours[$idx]} >> "$entry""_xp4.out" 2>&1)
    echo "$output"

    timestamp=$(date)
    $(echo -e "[$timestamp]  done\n" >> "$entry""_xp4.out")

    ((++idx))
done
