source("utils.R")
require(ggplot2)
require(cowplot)

compare_var <- function(datalist,name_vec,var,fun){
  values = c()
  for (i in 1:length(datalist)){
    data = datalist[[i]]
    values[i] = fun(data[[var]])
  } 
  barplot(values,names.arg = name_vec,xlab = "Schedulers",ylab = var)
}

compare_workload <- function(workload,var,fun){
  data = list()
  for (scheduler in schedulers){
    data[[scheduler]] = load_one(workload,scheduler)
  }
  compare_var(data,schedulers,var,fun)
}

gen_density_by_scheduler <- function(wk,var){
  p <- ggplot(wk, aes(.data[[var]],color=scheduler,fill=scheduler)) +
      geom_density(alpha=0.1)
  return(p)
}

gen_compare_seeds_by_scheduler <- function(wk_name,var,draw=TRUE){
  wks = list()
  seeds = seq(1,6)
  for (i in seeds){
    wks[[i]] <- load_workload(wk_name,seed=i)
  }
  wk = rbindlist(wks)
  
  p <- ggplot(wk,aes(.data[[var]],color=scheduler,fill=scheduler)) +
    geom_density(alpha=0.1) +
    facet_grid(vars(seed), scales = "free",labeller = label_both) +
    theme(legend.position = "top")
  
  if (draw) print(p)
  return(p)
}


gen_density_by_workload <- function(wks,var,group=TRUE,draw=TRUE,save=FALSE,path="./graphs"){
  if (group){
    p <- ggplot(wks,aes(.data[[var]],color=scheduler,fill=scheduler)) + 
      geom_density(alpha=0.1) +
      facet_wrap(vars(workload),scales = "free")
    filename <- paste("group_",var,"_den_plt.png",sep="")
    
    if (draw) print(p)
    if (save){
      ggsave(filename,p,path=path)
    }
  } else {
    wk_list <- split(wk_list,wk_list$workload)
    for (i in 1:length(wk_list)){
      wk = wk_list[[i]]
      wk_name <- wk$workload[[1]]
      
      p <- gen_density_by_scheduler(wk,var) +
        labs(title=wk_name)
      
      if (draw) print(p)
      if (save){
        filename <- paste(wk_name,"_",var,"_den_plt.png",sep = "")
        ggsave(filename,p,path = path)
      }
    }
  }
  return(p)
}

gen_qq_from_wk <- function(wk,var,draw=TRUE,save=FALSE){
  p <- ggplot(wk,aes(sample=.data[[var]],color=scheduler)) + stat_qq(alpha = 0.1) + stat_qq_line()
  if (draw) print(p)
  return(p)
}

gen_boxplot_from_wk <- function(wk,var,draw=TRUE,save=TRUE){
  p <- ggplot(wk,aes(.data[[var]],scheduler,color=workload))
  p <- p + geom_boxplot(notch=TRUE)
  if (draw) print(p)
  return(p)
}

gen_proc_hbinmap <- function(pr,draw=TRUE){
  p <- ggplot(pr,aes(cpu_time,io_time,color=workload)) + 
    geom_hex()
  
  # p2 <- ggplot(pr,aes(nbursts,color=workload)) +
  #   geom_histogram(binwidth = 0.5)
  # 
  # p3 <- ggplot(pr,aes(nbursts,after_stat(count),color=workload)) +
  #   geom_density()
  # 
  # p <- plot_grid(p,p2,p3)
  
  if (draw) print(p)
  return(p)
}
