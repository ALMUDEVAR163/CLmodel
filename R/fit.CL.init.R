fit.CL.init <-
function(y,x.cop,init.function = NULL) {
  
  fit.scale = func.CL.scale(y,x.cop)
  alpha = fit.scale$estimates[1]
  pa = fit.scale$estimates[2]
  pb = fit.scale$estimates[3]
  thr = fit.scale$estimates[4]
  
  if (is.null(init.function)) {
    init.estimate = fit.scale$estimates
    names(init.estimate) = c('alpha','a1','a2','x.thr')
  } else {
    init.estimate = init.function(alpha,pa,pb,thr)
  }
  
  return(init.estimate)
  
}
