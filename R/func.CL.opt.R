func.CL.opt <-
function(initial.estimate.list, y=y, parms=parms, control = control) {
  
  if (!is.list(initial.estimate.list)) { initial.estimate.list = list(initial.estimate.list) }
  nlist = length(initial.estimate.list)
  optim.obj.list = vector("list",nlist)
  ll.vec = rep(NA,nlist)
  for (i in 1:nlist) {
      optim.obj = stats::optim(initial.estimate.list[[i]], func.CL.lik, y=y, parms=parms, control = append(control, list(fnscale=-1)))
      ll.vec[i] = optim.obj$value
      optim.obj.list[[i]] = optim.obj
  }
  return(optim.obj.list[[which.max(ll.vec)]])
  
}
