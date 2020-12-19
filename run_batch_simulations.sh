#!/bin/bash
out_dir_generator="outputs_gen"
out_dir_simulator="outputs_sim"

generator="python3 gen_workload.py"
simulator="python3 simulator.py"
#Round Robin Quantum Defautlt
quantum=10
seeds=1
if [[ $1 == "-h" ]];
then
    echo "./run_batch_simulations.sh [name] [nprocs] [mean_io_bursts] [mean_iat] [min_cpu] [max_cpu] [min_io] [max_io] [nseeds] [quant]"
    exit
fi

if [ $# -lt 8 ]
then
    echo "Wrong amount of parameter passed"
else
    if [[ $# -ge 9 ]]; then seeds=$9; fi
    if [[ $# -ge 10 ]]; then quantum=${10}; fi

    start=`date +%s`
    # workload="Procs$1IOBurst$2IAT$3MinCPU$4MaxCPU$5MinIO$6MaxIO$7"
    workload="$1"
    workload_dir="$out_dir_generator/$workload"
    mkdir -p $workload_dir
    simulation_dir="$out_dir_simulator/$workload"
    mkdir -p $simulation_dir

    for ((i=1;i<=$seeds;i++)); do
        input_file="$workload_dir/$i.csv"

        echo -en "\rGenerating workloads seed $i"
        $generator $2 $3 $4 $5 $6 $7 $8 $i > $input_file 

        echo -en "\rSimulating workloads seed $i FCFS"
        $simulator --cpu-scheduler fcfs < $input_file > "${simulation_dir}/FCFS_$i.txt"
        echo -en "\rSimulating workloads seed $i RR  "
        $simulator --cpu-scheduler rr --quantum $quantum  < $input_file > "${simulation_dir}/RR_$i.txt"
        echo -en "\rSimulating workloads seed $i SJF"
        $simulator --cpu-scheduler sjf < $input_file > "${simulation_dir}/SJF_$i.txt"
        echo -en "\rSimulating workloads seed $i SRTF"
        $simulator --cpu-scheduler srtf < $input_file > "${simulation_dir}/SRTF_$i.txt"
        echo -e "\rSimulations for seed $i done.     "
    done

    end=`date +%s`
    runtime=$((end-start))
    echo "Generating $1 took $runtime seconds"
fi
