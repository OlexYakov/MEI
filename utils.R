load_simulation_data_frames <- function(workload,scheduler) 
{
  workload_path = paste("outputs_sim/",workload,"/",sep = "")
  pattern = paste(scheduler,"*",sep="")
  files = list.files(path=workload_path,pattern = pattern,full.names = TRUE)
  fcfs_vec = lapply(files, read.table, header=TRUE, quote="\"");
  return(fcfs_vec)
}
