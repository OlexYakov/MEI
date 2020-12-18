#!/usr/bin/env Rscript
#some statistical tests
source("utils.R")
source("graphs.R")
require(e1071)
require(ggformula)
require(cowplot)

#wk = load_workload("default")
# 
# aggregate(wk[6:8],list(wk$scheduler),mean)
# # similar for mean etc..
# 
# #kurtosis -> measure of heavy/light tail. higher -> more outliers
# aggregate(wk[6:8],list(wk$scheduler),mean)
# #skewness -> measure of symmetry
# aggregate(wk[6:8],list(wk$scheduler),skewness)
# 
# #split by column value
# split(wk,wk$scheduler)
# # filter by column
# wk[wk$scheduler == "FCFS",]

#interesting plots
# boxplot(wk$tat ~ wk$scheduler)
# boxplot(wk$tat ~ wk$workload) #load multiple workloads
# boxplot(wk$tat ~ wk$scheduler+wk$workload)

# # Interesting CPU bound experiment
# p <- gen_compare_seeds_by_scheduler("cpu_bound_1000","tat")
# print(p)
# p <- p + labs(title="tat densities for diffrent seeds")
# save_plot("graphs/cpu_bound_1000_tat_seed_compare.png",p,ncol=2)

#generate all tat density plots for the cpu_tests

# path="./graphs/cpu_tests/"
# gen_density_from_wk_list(cpu_tests,"tat",path=path,save=FALSE)
# gen_density_from_wk_list(cpu_tests,"ready_wait_time",path=path)
# 
# gen_qq_from_wk(load_workload("cpu_tests_b2"),"tat")


# compare workloads
# prs = load_procs(cpu_tests)
# gen_proc_hbinmap(prs)
# 
# wks = load_workloads(c("cpu_tests_b1","cpu_tests_c"))
# compare_workload("cpu_tests_b2","tat",mean)
# 
# wk_b1 = wks[wks$workload=="cpu_tests_b1"]
# gen_density_by_scheduler(wk_b1,"ready_wait_time")

total_time <- function (wk){
  return(max(wk$arrival_time+wk$tat))
}

calc_usage <- function (wks){
  for (wk in split(wks,wk$scheduler)) {
    total_t <- total_time(wk)
    print(paste(wk$scheduler[1]," ",total_t))
    print(sum(wk$cpu_bursts_time)/total_t)
    }
}