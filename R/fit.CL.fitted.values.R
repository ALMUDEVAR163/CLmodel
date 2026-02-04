fit.CL.fitted.values <-
function(est,parms) {
  
  if (parms$cop.flag) {
  
      x.cop=parms$x.cop
      x.covariates = parms$x.covariates
     
      n.comp = length(x.covariates)
      n = length(x.cop)
      
      alpha = est[1]
      beta = est[-1]
      
      pi.matrix = matrix(NA,n,n.comp)
      
      eta0 = (x.cop - x.covariates[[1]]%*%matrix(beta,ncol=1))
      pi.matrix[,1] = func.logit(exp(alpha)*eta0)
      
      if (n.comp > 1) {
        for (i in 2:n.comp) {
          eta = x.covariates[[i]]%*%beta
          pi.matrix[,i] = func.logit(eta)
        }
      }
    
      mu = apply(pi.matrix,1,parms$h.func)
    
      hprime = matrix(NA, n, n.comp)
      for (i in 1:n.comp) {
        hprime[,i] =  apply(pi.matrix,1,parms$h.prime.func[[i]])
      }
      
      dmu = matrix(0, n, length(est))
      
      tau0 = pi.matrix[,1]*(1-pi.matrix[,1])
      dmu[,1] = exp(alpha)*eta0*hprime[,1]*tau0
      dmu[,2:length(est)] = -exp(alpha)*x.covariates[[1]]*hprime[,1]*tau0
      
      if (n.comp > 1) {
        for (i in 2:n.comp) {
          tau0 = pi.matrix[,i]*(1-pi.matrix[,i])
          dmu[,2:length(est)] = dmu[,2:length(est)] + x.covariates[[i]]*hprime[,i]*tau0
        }
      }
      
      
  } else {
    
      x.covariates=parms$x.covariates
     
      n = dim(x.covariates[[1]])[1]
      n.comp = length(x.covariates)
      
      beta = est
      
      pi.matrix = matrix(NA,n,n.comp)
      
      for (i in 1:n.comp) {
        eta = x.covariates[[i]]%*%beta
        pi.matrix[,i] = func.logit(eta)
      }
      
      mu = apply(pi.matrix,1,parms$h.func)
      
      hprime = matrix(NA, n, n.comp)
      for (i in 1:n.comp) {
        hprime[,i] =  apply(pi.matrix,1,parms$h.prime.func[[i]])
      }
      
      dmu = matrix(0, n, length(est))
      
      for (i in 1:n.comp) {
        tau0 = pi.matrix[,i]*(1-pi.matrix[,i])
        dmu = dmu + x.covariates[[i]]*hprime[,i]*tau0
      }
      
  }
  
  obj = list(mu=mu, pi.matrix=pi.matrix, dmu=dmu)
  return(obj)
}
