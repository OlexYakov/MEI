#!/bin/bash
out_dir_generator="outputs_gen"
out_dir_simulator="outputs_sim"

generator="python3 gen_workload.py"
simulator="python3 simulator.py"

#defaults
num_procs=20
mean_io_bursts=10
mean_iat=10
min_CPU=1
max_CPU=2
min_IO=1
max_IO=2
quantum=10
seeds=1


usage() { 
    echo "Usage: [name] [nproc] [io_bursts] [iat] [min_cpu] [max_cpu] [min_io] [max_io] [nseeds] [quant]" 1>&2; 
    echo "Usage: -g ^" 1>&2; 
    echo "Usage: -s NAME [SEEDS] [QUANT]" 1>&2; 
    
    exit 1;
    }

while getopts "hg:s:n:q:" o; do
    case "${o}" in
        g)
            g=1
            workload=${OPTARG}
            ;;
        s)
            s=1
            workload=${OPTARG}
            ;;
        n)
            seeds=${OPTARG}
            ;;
        q)
            quantum=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-2))
echo "num " $#
start=`date +%s`
if [[ $g ]]; then 
    # so gerar
    if [[ $# -lt 8 ]]; then usage; fi
    workload="$1"
    workload_dir="$out_dir_generator/$workload"
    mkdir -p $workload_dir
    # Check optional arguments
    if [[ $# -ge 9 ]]; then seeds=$9; fi
    if [[ $# -ge 10 ]]; then quantum=${10}; fi

    for ((i=1;i<=$seeds;i++)); do
        input_file="$workload_dir/$i.csv"
        echo "Generating workloads seed $i"
        $generator $2 $3 $4 $5 $6 $7 $8 $i > $input_file 
    done
elif [[ $s ]]; then
    # so simular
    workload="$1"
    workload_dir="$out_dir_generator/$workload"
    mkdir -p $workload_dir
    simulation_dir="$out_dir_simulator/$workload"
    mkdir -p $simulation_dir
    rm $simulation_dir/*
    
    if [[ $# -ge 2 ]]; then seeds=$2; fi
    if [[ $# -ge 3 ]]; then quantum=$3; fi

    for ((i=1;i<=$seeds;i++)); do
        input_file="$workload_dir/$i.csv"
        ./run_simulator.sh $input_file $simulation_dir $quantum $i
    done
else
    # Get arguments
    if [[ $# -lt 8 ]]; then usage; fi
    workload="$1"
    workload_dir="$out_dir_generator/$workload"
    mkdir -p $workload_dir
    simulation_dir="$out_dir_simulator/$workload"
    mkdir -p $simulation_dir
    rm $simulation_dir/*

    # Check optional arguments
    if [[ $# -ge 9 ]]; then seeds=$9; fi
    if [[ $# -ge 10 ]]; then quantum=${10}; fi
    # gerar e simular
    for ((i=1;i<=$seeds;i++)); do
        input_file="$workload_dir/$i.csv"

        echo -en "\rGenerating workloads seed $i"
        $generator $2 $3 $4 $5 $6 $7 $8 $i > $input_file 

        ./run_simulator.sh $input_file $simulation_dir $quantum $i
    done
fi
end=`date +%s`
runtime=$((end-start))
echo "Took $runtime seconds"





