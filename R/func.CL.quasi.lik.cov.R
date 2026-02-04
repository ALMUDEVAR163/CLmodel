func.CL.quasi.lik.cov <-
function(est, parms, group, cor.exch) {
 
  fitted.values.obj = fit.CL.fitted.values(est,parms)
  mu = fitted.values.obj$mu
  dmuv = fitted.values.obj$dmu/sqrt(mu*(1-mu))
 
  r.inv.sqrt = func.give.cor.inv.sqrt(group,cor.exch)
  cov.matrix = matrix(NA,length(est),length(est))
  
  dmuv = r.inv.sqrt%*%dmuv
  dmuv = as.matrix(dmuv)
  omega = t(dmuv)%*%dmuv
  if (parms$lambda > 0) {
    omega.lambda = omega + parms$lambda*diag(length(est))
    mtemp = solve(omega.lambda,omega)
    cov.matrix = solve(omega.lambda,t(mtemp))
  } else {
    cov.matrix = solve(omega,diag(length(est)))
  }
    
  return(as.matrix(cov.matrix))
  
}
