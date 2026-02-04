func.CL.quasi.lik.jacobian <-
function(est,parms,group,cor.exch) {
  
  
  fitted.values.obj = fit.CL.fitted.values(est,parms)
  mu = fitted.values.obj$mu
  dmuv = fitted.values.obj$dmu/sqrt(mu*(1-mu))
 
  r.inv = func.give.cor.inv(group,cor.exch)
  jacobian = as.matrix(-t(dmuv%*%r.inv)%*%dmuv) - 2*parms$lambda*diag(length(est))
  
  return(jacobian)
  
}
