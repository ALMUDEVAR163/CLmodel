fit.CL.sim.data <-
function(mu,nsim,group=NULL,rho=NULL) {
  
  ny = length(mu)
  if (!is.null(rho)) {if (rho <= 0) {rho=NULL}}
  
  if (is.null(group) | is.null(rho)) {
    ym = bindata::rmvbin(nsim,margprob=mu)
  } else {
    usub.list = split(1:ny,group)
    nsub = length(usub.list)
    cor.list = list()
    p.list = list()
    for (i in 1:nsub) {
      ind = usub.list[[i]]
      ng = length(ind)
      p.list[[i]] = mu[ind]
      cor.list[[i]] = matrix(rho,ng,ng)
      diag(cor.list[[i]]) = 1 
    }

    ym = matrix(NA,nsim,ny)
    for (i in 1:nsub) {
      if (length(p.list[[i]]) == 1 ) {
        ym[,usub.list[[i]]] = stats::rbinom(nsim,prob=p.list[[i]][1],size=1)
      } else
      {
        if (bindata::check.commonprob(bindata::bincorr2commonprob(p.list[[i]],cor.list[[i]]))) {
          ym[,usub.list[[i]]] =  bindata::rmvbin(nsim,margprob=p.list[[i]],bincorr=cor.list[[i]])
        } else {
          ym[,usub.list[[i]]] =  bindata::rmvbin(nsim,margprob=p.list[[i]])
        }
      }  
    }
  }
  return(ym)
}
