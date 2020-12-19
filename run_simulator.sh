#!/bin/bash
simulator="python3 simulator.py"

if [[ $# -ne 4 ]] ; then
    echo 
    echo "Wrong number of arguments: [in] [out] [quant] [seed]";
    echo $@
    exit 1
fi

input_file=$1
simulation_dir=$2
quantum=$3
seed=$4

echo -en "\rSimulating workloads seed $seed FCFS"
$simulator --cpu-scheduler fcfs < $input_file > "${simulation_dir}/FCFS_$seed.txt"
echo -en "\rSimulating workloads seed $seed RR  "
$simulator --cpu-scheduler rr --quantum $quantum  < $input_file > "${simulation_dir}/RR_$seed.txt"
echo -en "\rSimulating workloads seed $seed SJF"
$simulator --cpu-scheduler sjf < $input_file > "${simulation_dir}/SJF_$seed.txt"
echo -en "\rSimulating workloads seed $seed SRTF"
$simulator --cpu-scheduler srtf < $input_file > "${simulation_dir}/SRTF_$seed.txt"
echo -e "\rSimulations for seed $seed done.     "