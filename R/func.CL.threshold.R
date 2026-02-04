func.CL.threshold <-
function(y,x) {
  opt.thresh = stats::optimize(func.thresh.log.lik.value, y=y, x=x,interval=range(x,na.rm=T), maximum=T)
  return(func.thresh.log.lik(opt.thresh$maximum,y,x))
}
