require("data.table")

schedulers = c("FCFS","RR","SJF","SRTF")

load_simulation_data_frames <- function(workload,scheduler) 
{
  workload_path = paste("outputs_sim/",workload,"/",sep = "")
  pattern = paste(scheduler,"*",sep="")
  files = list.files(path=workload_path,pattern = pattern,full.names = TRUE)
  fcfs_vec = lapply(files, read.table, header=TRUE, quote="\"");
  return(fcfs_vec)
}


load_one <- function(workload_name,scheduler,seed=1){
  file_name = paste("outputs_sim/",workload_name,"/",scheduler,"_",seed,".txt",sep = "")
  df = read.table(file = file_name,header=TRUE,quote="\"")
  df$scheduler = scheduler
  df$workload = workload_name
  df$seed=seed
  return(df);
}

load_workload <- function(workload_name,seed=1){
    dfull = data.frame()
    for (sc in schedulers){
      df = load_one(workload_name,sc,seed)
      dfull = rbind(dfull,df)
    }
    return(dfull)
}

load_workloads <- function(names,seed=1){
  return(rbindlist(lapply(names,load_workload,seed=seed)))
}

load_proc<-function(wk_name){
  proc_name = paste("./outputs_gen_info/",wk_name,"/1.cvs",sep="")
  df = read.table(proc_name,header=TRUE, sep="")
  df$workload=wk_name
  return(df)
}

load_procs <- function(wk_names){
  return(rbindlist(lapply(wk_names,load_proc)))
}


# workload = "default_1000"
# 
# data = list(NA)
# length(data) = length(schedulers)
# 
# for (i in 1:length(data)){
#   data[[i]] = load_first(workload,schedulers[i])
# }
# 
# lapply(data,summary)
# 

# hists = list(NA)
# length(hists) = length(data)
# 
# for (i in 1:length(data)){
#   hists[[i]] = hist(data[[i]]$tat,plot=FALSE)
#   new = i != 1
#   plot(hists[[i]],col=colors[i],add = new)
# }

