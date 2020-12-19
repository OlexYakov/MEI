#!/usr/bin/env Rscript

source("utils.R")
source("graphs.R")

for (test in cpu_tests){
  wk = load_workload(test)
  print(test)
  print(calc_usage(wk))
}