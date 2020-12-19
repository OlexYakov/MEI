#!/usr/bin/env Rscript

source("utils.R")
source("graphs.R")
 
# for (test in cpu_tests){
#   wk = load_workload(test)
#   print(test)
#   print(calc_usage(wk))
# }

wk = load_workload("test")
print(aggregate(wk[5:8],list(wk$scheduler),mean))
print(calc_usage(wk))