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