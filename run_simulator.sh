#!/bin/bash
simulator="python3 ./simulator.py"
input_file="./outputs_gen/inverse/1.csv"
out_file="./outputs_sim/inverse"
mkdir -p $out_file
echo "Running only simulation for $input_file"

$simulator --cpu-scheduler fcfs < $input_file > "${out_file}/FCFS_1.txt"
echo -en "\rSimulating workloads seed $i RR  "
$simulator --cpu-scheduler rr --quantum 0.1  < $input_file > "${out_file}/RR_1.txt"
echo -en "\rSimulating workloads seed $i SJF"
$simulator --cpu-scheduler sjf < $input_file > "${out_file}/SJF_1.txt"
echo -en "\rSimulating workloads seed $i SRTF"
$simulator --cpu-scheduler srtf < $input_file > "${out_file}/SRTF_1.txt"
echo -e "\rSimulations for seed $i done.     "