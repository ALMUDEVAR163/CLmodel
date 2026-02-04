func.CL.sse.quad <-
function(est, parms, group=NULL, cor.exch=NULL, y.cv, yhat.cv) {
 
  if (is.null(group) | is.null(cor.exch)) {
    mu = fit.CL.fitted.values(est,parms)$mu
    ybar = (y.cv - yhat.cv)
    sse.quad = sum(ybar^2/(mu*(1-mu)))
  } else {
    mu = fit.CL.fitted.values(est,parms)$mu
    r.inv.sqrt = func.give.cor.inv.sqrt(group,cor.exch)
    ybar = (y.cv - yhat.cv)/sqrt(mu*(1-mu))
    sse.sqrt = r.inv.sqrt%*%ybar
    sse.quad = sum(sse.sqrt^2)
  }
  
  return(sse.quad)
  
}
