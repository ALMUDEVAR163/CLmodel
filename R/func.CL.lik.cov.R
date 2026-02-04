func.CL.lik.cov <-
function(est,parms) {
  
  
  fitted.values.obj = fit.CL.fitted.values(est,parms)
 
  cov.matrix0 = matrix(NA,length(est),length(est))
  
  mu = fitted.values.obj$mu
  dmuv = fitted.values.obj$dmu/sqrt(mu*(1-mu))
  
  a1 = t(dmuv)%*%dmuv 
  a2 = a1 + parms$lambda*diag(length(est))
  cov.matrix = solve(a2,a1)
  cov.matrix = solve(a2,cov.matrix)
  
  return(cov.matrix)
}
