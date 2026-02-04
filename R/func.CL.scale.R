func.CL.scale <-
function(y,x) {
  
  fit.thr = func.CL.threshold(y,x) 
  pa = fit.thr$estimates[1]
  pb = fit.thr$estimates[2]
  thr = fit.thr$estimates[3]
  opt.scale = stats::optimize(func.scale.log.lik.value, pa=pa, pb=pb, thr=thr, y=y, x=x, interval=c(0,5), maximum=T)
  return(func.scale.log.lik(opt.scale$maximum,pa,pb,thr,y,x))
}
