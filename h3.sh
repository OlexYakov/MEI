#!/bin/bash

echo "Generating second hypotesis"

seeds=10
first="long_solo_$seeds"
second="short_bursts_$seeds"
merged="h3"

./run_batch_simulations.sh -g $first 5 5 10 10 20 10 20 $seeds
./run_batch_simulations.sh -g $second 100 100 10 0.1 1 10 20 $seeds 
./workload_merge.py $first $second $merged 
./run_batch_simulations.sh -s $merged $seeds 0.1   
./gen_workload_info.py -full  
echo "Done"
