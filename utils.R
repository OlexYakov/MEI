load_simulation_data_frames <- function(workload,scheduler) 
{
  workload_path = paste("outputs_sim/",workload,"/",sep = "")
  pattern = paste(scheduler,"*",sep="")
  files = list.files(path=workload_path,pattern = pattern,full.names = TRUE)
  fcfs_vec = lapply(files, read.table, header=TRUE, quote="\"");
  return(fcfs_vec)
}

load_first <- function(workload,scheduler){
  file_name = paste("outputs_sim/",workload,"/",scheduler,"_1.txt",sep = "")
  return(read.table(file = file_name,header=TRUE,quote="\""));
}



workload = "default_1000"
schedulers = c("FCFS","RR","SJF","SRTF")

data = list(NA)
length(data) = length(schedulers)

for (i in 1:length(data)){
  data[[i]] = load_first(workload,schedulers[i])
}

lapply(data,summary)

alpha = 0.1
colors = c(
  rgb(1,0,0,alpha = alpha),
  rgb(0,1,0,alpha = alpha),
  rgb(0,0,1,alpha = alpha),
  rgb(1,1,0,alpha = alpha),
  rgb(0,1,1,alpha = alpha))

hists = list(NA)
length(hists) = length(data)

for (i in 1:length(data)){
  hists[[i]] = hist(data[[i]]$tat,plot=FALSE)
  new = i != 1
  plot(hists[[i]],col=colors[i],add = new)
}

