#!/usr/bin/env Rscript
#some statistical tests
source("utils.R")
source("graphs.R")
require(e1071)
require(ggformula)
require(cowplot)

wk = load_workload("default")

aggregate(wk[6:8],list(wk$scheduler),mean)
# similar for mean etc..

#kurtosis -> measure of heavy/light tail. higher -> more outliers
aggregate(wk[6:8],list(wk$scheduler),mean)
#skewness -> measure of symmetry
aggregate(wk[6:8],list(wk$scheduler),skewness)

#split by column value
split(wk,wk$scheduler)
# filter by column
wk[wk$scheduler == "FCFS",]

#interesting plots
boxplot(wk$tat ~ wk$scheduler)
boxplot(wk$tat ~ wk$workload) #load multiple workloads
boxplot(wk$tat ~ wk$scheduler+wk$workload)

# # Interesting CPU bound experiment
# p <- gen_compare_seeds_by_scheduler("cpu_bound_1000","tat")
# print(p)
# p <- p + labs(title="tat densities for diffrent seeds")
# save_plot("graphs/cpu_bound_1000_tat_seed_compare.png",p,ncol=2)

#generate all tat density plots for the cpu_tests
cpu_tests=c(
  "cpu_tests_a1","cpu_tests_a2","cpu_tests_b1","cpu_tests_b2","cpu_tests_b3","cpu_tests_c"
)
path="./graphs/cpu_tests/"
gen_density_from_wk_list(cpu_tests,"tat",path=path,save=FALSE)
gen_density_from_wk_list(cpu_tests,"ready_wait_time",path=path)

gen_qq_from_wk(load_workload("cpu_tests_b2"),"tat")
