fit.CL <-
function(y, x.cop = NULL, x.covariates = NULL, h.func = NULL, h.prime.func = NULL, 
                  initial.estimate = NULL, group = NULL, exchangeable = FALSE, 
                   quasi.lik = FALSE, cop.flag = FALSE, lambda = 0,
                   linear.comb=NULL, est.labs = NULL, control=NULL) {
  
  ny = length(y)
  memo = NULL
  cor.exch=NULL
  
  if (!is.null(x.covariates) & !is.list(x.covariates)) {x.covariates = list(x.covariates)}
  
  if (!exchangeable) {quasi.lik = F}
  
  if (exchangeable) {
      if (!is.vector(group)) {
          stop("Valid group vector required for exchangeable option.")
      } else {
          if (length(group)!=ny) { stop("Valid group vector required for exchangeable option.")}
      }
  }
  
  if (class(initial.estimate) ==  "function") {
    init.est = fit.CL.init(y,x.cop,initial.estimate)
  } else {
    init.est = initial.estimate
  }
  
  
  n.par = length(init.est)
  n.comp = length(x.covariates)
  
  #if (cop.flag) {n.par.CL = dim(x.cop.covariates)[2]}
  
  #n.par.components = NULL
  #if (length(x.covariates) > 0) {
  #  for (i in 1:length(x.covariates)) {n.par.components = c(n.par.components, dim(x.covariates[[i]])[2])}      
  #}
  
  if (is.null(est.labs)) {
      if (cop.flag) {
          est.labs = c('alpha')
          if (n.par > 1) {
              for (i in 1:(n.par-1)) {
                  est.labs = c(est.labs, paste('b[',i,']',sep=''))
              }
          }
      } else {
          est.labs=NULL
          for (i in 1:n.par) {
              est.labs = c(est.labs, paste('b[',i,']',sep=''))
          }
      }
  }    
  
  model.df = n.par
  
  ### setup linear.comb matrix
  
  coef.names = c(est.labs,rownames(linear.comb))
  linear.comb = rbind(diag(1,model.df),linear.comb)
  rownames(linear.comb) = coef.names
  
  ### initial fit
  
  parms = list(y=y,x.cop=x.cop,x.covariates=x.covariates,  group=group,
               initial.estimate=initial.estimate, 
               h.func = h.func, h.prime.func = h.prime.func, cop.flag=cop.flag, n = length(y), 
               n.comp=n.comp, model.df=model.df, lambda = lambda)
 
  ### obtain likelihood solution
  
  #optim.obj = func.CL.opt(initial.estimate.list, y=y, parms=parms, control = control)
  optim.obj = func.CL.opt(init.est, y=y, parms=parms, control = control)
   
  est = optim.obj$par
  esti = est
  log.lik = optim.obj$value
  names(est) = est.labs
  fitted.values.obj = fit.CL.fitted.values(est,parms)
  
  ### get correlation estimate if needed
  
  if (exchangeable) {cor.exch = func.cor.est(y, fitted.values.obj$mu,length(est), group)[2]}
      
  ### obtain quasi-likelihood solution if requested
  
  if (exchangeable && quasi.lik) {
    
      	quasi1 = rootSolve::multiroot(func.CL.quasi.lik.gradient,start=est,y=y,parms=parms,
      	                              group=group,cor.exch=cor.exch,jacfunc=func.CL.quasi.lik.jacobian)
          
      	### check for convergence 
        	
      	if (sum(is.na(quasi1$f.root))==0) {
      	    est = quasi1$root
      	} else {
      	    memo = c(memo, 'Quasi-likelihood estimate requested but not used')   
      	    quasi.lik = F
      	}
      	
      	fitted.values.obj = fit.CL.fitted.values(est,parms)
  }      	
  
  
  ### calculate covariance matrix
  
  if (exchangeable) {
      if (quasi.lik) {
         sigma = func.CL.quasi.lik.cov(est,parms,group,cor.exch)
         sigma = as.matrix(sigma)
      } else {
      		sigma = func.CL.lik.cov.r(est,parms,group,cor.exch)
  		    sigma = as.matrix(sigma)
      }
  } else {
      	sigma = func.CL.lik.cov(est, parms)  
  }
  
  ### calculate QIC
  
  qic.cl = NULL
  qicu.cl = NULL
  if (exchangeable) {
      if (quasi.lik) {
         sigmai = func.CL.lik.cov(esti, parms)
         sigmai = as.matrix(sigmai)
         qq = sum(y*log(fitted.values.obj$mu) + (1-y)*log(1-fitted.values.obj$mu))
         qic.cl = 2*(sum(diag(solve(sigmai,sigma))) - qq)
         qicu.cl = 2*(model.df - qq)
      }
  }
  
  #dimnames(sigma) = list(est.labs,est.labs)
  
  dmu =  fitted.values.obj$dmu  
  fitted.values.se = func.sqrt0(diag(dmu%*%sigma%*%t(dmu)))
  
  coef.est = linear.comb%*%est
  coef.se = func.sqrt0(diag(linear.comb%*%sigma%*%t(linear.comb)))
  coef = cbind(coef.est, coef.se, coef.est/coef.se, 2*pnorm(-abs(coef.est/coef.se)))
  colnames(coef) = c('Est','SE','Z','p-val (Z)')
  
  rownames(coef) = coef.names
  
  #n.groups=NA 
  #if (exchangeable) {n.groups=length(unique(group))}
  
  fit.CL.obj =  list(n = length(parms$y),
                      model.df = model.df,
                      est=est,
                      coef=coef,
                      sigma=sigma,
                      qic.cl = qic.cl,
                      qicu.cl = qicu.cl,
                      cor.est=cor.exch,
                      fitted.values=fitted.values.obj$mu,
                      fitted.values.se=fitted.values.se,
                      log.lik=log.lik,
                      memo=memo,
                      exchangeable = exchangeable,
                      quasi.lik = quasi.lik,
                      control=control,
                      init.est=init.est,
                      initial.estimate=initial.estimate,
                      parms=parms,
                      lambda = lambda
                      ) 
  class(fit.CL.obj) = 'fit.CL'
  
  
  return(fit.CL.obj)
  
}
