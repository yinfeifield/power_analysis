
####anova test method all criteria


for (i in 1:nrow(td_va0))
{
  p2<- mean(x=apply(X=cbind(matrix(data=runif(n=(td_va0$no_trt[i]), min=td_va0$mean[i]*(1-0.01), max=td_va0$mean[i]*(1+0.01)), ncol=td_va0$no_trt[i]), td_va0$mean[i]*(1-0.01),td_va0$mean[i]*(1+0.01)), MARGIN=1, FUN=var))
  p5<- mean(x=apply(X=cbind(matrix(data=runif(n=(td_va0$no_trt[i]), min=td_va0$mean[i]*(1-0.025), max=td_va0$mean[i]*(1+0.025)), ncol=td_va0$no_trt[i]), td_va0$mean[i]*(1-0.025), td_va0$mean[i]*(1+0.025)), MARGIN=1, FUN=var))
  p10<- mean(x=apply(X=cbind(matrix(data=runif(n=(td_va0$no_trt[i]), min=td_va0$mean[i]*(1-0.05), max=td_va0$mean[i]*(1+0.05)), ncol=td_va0$no_trt[i]), td_va0$mean[i]*(1-0.05), td_va0$mean[i]*(1+0.05)), MARGIN=1, FUN=var))
  
  td_va0$n_p2[i] <- power.anova.test(groups=td_va0$no_trt[i], between.var=p2, within.var=(td_va0$sd[i])^2,
                                       power=0.8, sig.level=0.05)$n
  td_va0$n_p5[i] <- power.anova.test(groups=td_va0$no_trt[i], between.var=p5, within.var=(td_va0$sd[i])^2,
                                       power=0.8, sig.level=0.05)$n
  td_va0$n_p10[i] <- power.anova.test(groups=td_va0$no_trt[i], between.var=p10, within.var=(td_va0$sd[i])^2,
                                      power=0.8, sig.level=0.05)$n
}

td_va<-td_va0



