#!/bin/bash

echo "Generating third hypotesis"

seeds=35
first="h3_long_solo_$seeds"
second="h3_short_bursts_$seeds"
merged="h3"

./run_batch_simulations.sh -g $first 10 5 10 30 30 0.1 0.1 $seeds
./run_batch_simulations.sh -g $second 100 50 10 0.1 1 1 1 $seeds 
./workload_merge.py $first $second $merged 
./run_batch_simulations.sh -s $merged $seeds 0.1   
#./gen_workload_info.py -full  
echo "Done"
