source("utils.R")
source("graphs.R")

# H1: under high CPU loads, the turnaround time of RR will be higher
#analise process workload 
pwk = load_procs(cpu_tests)
gen_proc_hbinmap(pwk)
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
