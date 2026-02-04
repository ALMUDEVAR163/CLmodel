func.CL.lik <-
function(est,y,parms) {
  
  mu = fit.CL.fitted.values(est,parms)$mu
  ans = sum(y*log(mu))+sum((1-y)*log(1-mu)) - parms$lambda*sum(est^2) 

  return(ans)
}
