require("data.table")
require(dplyr)
require(ggpubr)

schedulers = c("FCFS","RR","SJF","SRTF")
cpu_tests=c(
  "cpu_tests_a1","cpu_tests_a2","cpu_tests_b1","cpu_tests_b2","cpu_tests_b3","cpu_tests_c"
)

load_simulation_data_frames <- function(workload,scheduler) 
{
  workload_path = paste("outputs_sim/",workload,"/",sep = "")
  pattern = paste(scheduler,"*",sep="")
  files = list.files(path=workload_path,pattern = pattern,full.names = TRUE)
  fcfs_vec = lapply(files, read.table, header=TRUE, quote="\"");
  return(fcfs_vec)
}


load_one <- function(path, scheduler, seed = 1) {
  file_name = paste(path, "/", scheduler, "_", seed, ".txt", sep = "")
  df = read.table(file = file_name,header = TRUE,quote = "\"")
  df$scheduler = scheduler
  df$seed = seed
  return(df)
  
}

load_workload <- function(workload_name, all_seeds = FALSE, seed=1) {
  path = paste("outputs_sim/", workload_name, sep = "")
  dfull = data.frame()
  nseeds = 1
  if (all_seeds) {
    nseeds = length(list.files(path)) / 4
    for (seed in 1:nseeds) {
      for (sc in schedulers) {
        df = load_one(path, sc, seed)
        df$workload = workload_name
        dfull = rbind(dfull, df)
      }
    }
  } else {
    for (sc in schedulers) {
      df = load_one(path, sc, seed)
      df$workload = workload_name
      dfull = rbind(dfull, df)
    }
  }
  dfull["tat_per_cpu_burst_time"] = dfull$tat / dfull$cpu_bursts_time
  dfull["rw_per_nbursts"] = dfull$ready_wait_time / dfull$nbursts
  return(dfull)
}

load_workloads <- function(names,seed=1){
  return(rbindlist(lapply(names,load_workload,seed=seed)))
}

load_proc<-function(wk_name,seed=1){
  proc_name = paste("./outputs_gen_info/",wk_name,"/",seed,".csv",sep="")
  df = read.table(proc_name,header=TRUE, sep="")
  df$workload=wk_name
  df$cpu_per_burst = df$cpu_time / df$nbursts
  return(df)
}

load_procs <- function(wk_names){
  return(rbindlist(lapply(wk_names,load_proc)))
}

total_time <- function (wk){
  return(max(wk$arrival_time+wk$tat))
}

calc_usage <- function (wks){
  df <- data.frame(
    "scheduler"=character(0),
    "total"=double(0),
    "usage"=double(0),
    stringsAsFactors = FALSE);

#   for (wk in split(wks,wk$scheduler)) {
#     total_t <- total_time(wk)
#     usage <- sum(wk$cpu_bursts_time)/total_t
#     df[nrow(df)+1,] <- list(wk$scheduler[1],total_t,usage)
#   }
#   return(df)
  
  wk = wks %>%
    group_by(seed,scheduler) %>%
    summarise(total=max(arrival_time+tat),usage= sum(cpu_bursts_time/max(arrival_time+tat)))
  return(wk)
}

per_scheduller <- function(wk,fun){
  return(aggregate(wk,list(wk$scheduler),fun));
}

