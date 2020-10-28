source("utils.R")
require(ggplot2)
require(cowplot)

# alpha = 0.1
# colors = c(
#   rgb(1,0,0,alpha = alpha),
#   rgb(0,1,0,alpha = alpha),
#   rgb(0,0,1,alpha = alpha),
#   rgb(1,1,0,alpha = alpha),
#   rgb(0,1,1,alpha = alpha))


gen_density_by_scheduler <- function(wk,var){
  p <- ggplot(wk, aes(.data[[var]],color=scheduler,fill=scheduler))
  return(p + geom_density(alpha=0.1))
}

gen_compare_seeds_by_scheduler <- function(wk_name,var){
  plots = list()
  seeds = seq(1,6)
  for (i in seeds){
    wk <- load_workload(wk_name,seed=i)
    p <- gen_density_by_scheduler(wk,var)
    p <- p + labs(tag = i)
    plots[[i]] <- p
  }
  args <- append(plots,list("ncol"=2))
  return(do.call(plot_grid,args))
}

gen_density_from_wk_list <- function(wk_list,var,save=TRUE,draw=TRUE,path="./graphs"){
   for (wk_name in wk_list){
     wk <- load_workload(wk_name)
     p <- gen_density_by_scheduler(wk,var)
     title <- paste("Density plot for",var,"in workload",wk_name,sep=" ")
     p <- p + labs(title=title)
     if (draw) print(p)
     if (save){
       filename <- paste(wk_name,"_",var,"_den_plt",".png",sep = "")
       ggsave(filename,p,path = path)
     }
   }
}

gen_qq_from_wk <- function(wk,var,draw=TRUE,save=FALSE){
  p <- ggplot(wk,aes(sample=.data[[var]],color=scheduler)) + stat_qq(alpha = 0.1) + stat_qq_line()
  if (draw) print(p)
}

gen_boxplot_from_wk <- function(wk,var,draw=TRUE,save=TRUE){
  p <- ggplot(wk,aes(.data[[var]],scheduler,color=workload))
  p <- p + geom_boxplot(notch=TRUE)
  if (draw) print(p)
}

gen_proc_hbinmap <- function(wk_name,draw=TRUE){
  pr = load_procs(wk_name)
  wk = load_workload(wk_name)
  p <- ggplot(pr,aes(cpu_time,io_time,)) + 
    geom_hex()
  if (draw) print(p)
  return(p)
}
