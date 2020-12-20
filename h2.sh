#!/bin/bash

echo "Generating second hypotesis"

seeds=120

./run_batch_simulations.sh -g long_solo 5 5 10 10 20 10 20 $seeds
./run_batch_simulations.sh -g short_bursts 100 100 10 0.1 1 1 2 $seeds 
./workload_merge.py short_bursts long_solo mixed_h2 
./run_batch_simulations.sh -s mixed_h2 $seeds 0.1   
./gen_workload_info.py -full  
echo "Done"
