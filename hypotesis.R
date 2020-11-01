source("utils.R")
source("graphs.R")

# H1: under high CPU loads, the turnaround time of RR will be higher
#analise process workload 
pwk = load_procs(cpu_tests)
p <- gen_proc_hbinmap(pwk)
print(p)
aggregate(pwk$cpu_time,list(pwk$workload),summary)

#analise simulation
wks = load_workloads(cpu_tests)
gen_density_by_workload(wks,"tat")

wks_a = load_workloads(cpu_tests[1:2])
wks_a$type = 1
wks_b = load_workloads(cpu_tests[3:4])
wks_b$type = 2
wks_c = load_workloads(cpu_tests[5:6])
wks_c$type = 3
wks = rbind(wks_a,wks_b,wks_c)
p <- ggplot(wks,aes(ready_wait_time,scheduler,color=workload)) +
      geom_boxplot(notch=TRUE) +
      theme(legend.position = "top") +
      facet_wrap(vars(type),scales = "free")
print(p)

wk = wks[wks$workload=="cpu_tests_b3"]
aggregate(wk$tat,list(wk$scheduler),kurtosis)
aggregate(wk$tat,list(wk$scheduler),skewness)
# H2 : FCFS despachar os processos mais rápido do que o RR
wks = load_workload("big_and_fast")
prc = load_proc("big_and_fast")
p <- gen_proc_hbinmap(prc) + theme(legend.position="top")
print(p)
p1 <- gen_density_by_workload(wks,"ready_wait_time") + theme(legend.position="bottom")
print(p1)
p2 <- gen_boxplot_from_wk(wks,"ready_wait_time") + theme(legend.position = "none")
print(p2)
gen_compare_seeds_by_scheduler("big_and_fast","tat")

# H3 : ???
# wk = load_workload("sorted")
# gen_density_by_scheduler(wk,"tat")

# H3.1 SJF will have bigger tat that SRTF if the first processes are lengthy (SRTF will preempt)
prc = load_proc("inverse")
p <- ggplot(prc,aes(cpu_time)) + geom_histogram()
print(p)
wk1 = load_workload("inverse")
wk2 = load_workload("inverse2")


p <- gen_density_by_scheduler(wk1,"tat") + theme(legend.position = "bottom")
print(p)
gen_density_by_scheduler(wk2,"tat")
#wk2 is bugged -> tat is not counted from time of arrival

# H6
wk = load_workload("normal")

ggplot(wk,aes(cpu_bursts_time)) + geom_histogram(binwidth = 5)

p_tat <- gen_density_by_workload(wk,"tat") + theme(legend.position = "top")
print(p_tat)
p_rwt <- gen_density_by_workload(wk,"ready_wait_time") + theme(legend.position = "top")
print(p_rwt)
p_qq_tat <- gen_qq_from_wk(wk,"tat") 
p_qq_rwt <- gen_qq_from_wk(wk,"ready_wait_time") + theme(legend.position = "top")
print(p_qq_rwt)

#seed comparison
gen_compare_seeds_by_scheduler("cpu_tests_b1","tat")
