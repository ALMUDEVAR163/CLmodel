func.CL.quasi.lik.gradient <-
function(est,y,parms,group,cor.exch) {
  
  
  fitted.values.obj = fit.CL.fitted.values(est,parms)
  mu = fitted.values.obj$mu
  taum.sqrt = sqrt(mu*(1-mu))
  
  dmuv = fitted.values.obj$dmu/taum.sqrt
 
  yc = (y - mu)
  r.inv = func.give.cor.inv(group,cor.exch)
  gradient = (t(dmuv)%*%r.inv)%*%matrix(yc/sqrt(taum.sqrt),ncol=1) - 2*parms$lambda*est
  
  return(as.matrix(gradient))
  
}
