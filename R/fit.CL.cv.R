fit.CL.cv <-
function(y, x.cop = NULL, x.covariates = NULL, h.func = NULL, h.prime.func = NULL, 
                  initial.estimate = NULL, group = NULL, exchangeable = FALSE, 
                   quasi.lik = FALSE, cop.flag = FALSE, lambda = 0,
                   k.cv = NULL, gof.score.type = NULL,  linear.comb=NULL, est.labs = NULL, control=NULL) {
  ny = length(y)
  memo = NULL
  #cor.exch=NULL
  
  if (is.null(gof.score.type)) {gof.score.type = 'dev'}
  
  f.dev = function(y,pr) {-2*sum(y*log(pr)+(1-y)*log(1-pr))}
  
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
  
  #coef.names = c(est.labs,rownames(linear.comb))
  #linear.comb = rbind(diag(1,model.df),linear.comb)
  #rownames(linear.comb) = coef.names
  
  ### initial fit
  
  lambda.max = max(lambda)
  lambda = sort(lambda)
  
  parms = list(y=y,x.cop=x.cop,x.covariates=x.covariates, group=group,
               initial.estimate=initial.estimate, 
               h.func = h.func, h.prime.func = h.prime.func, cop.flag=cop.flag, n = length(y), 
               n.comp=n.comp, model.df=model.df, lambda = lambda.max)
 
  fit.init = fit.CL(y=y, x.cop=x.cop, x.covariates=x.covariates, 
                    h.func=h.func, h.prime.func=h.prime.func, 
                    initial.estimate=initial.estimate, group=group, exchangeable=exchangeable, 
                    quasi.lik=quasi.lik, cop.flag=cop.flag, lambda=lambda.max,
                    linear.comb=NULL, est.labs=est.labs, control=control) 
  est.init = fit.init$est
  
  ### obtain likelihood solution
  
  give.cv.list = function(n,k) {
   ns = floor(n/k)
   ind = sample(n)
   test.list = list()
   for (iii in 1:k) {
     test.list[[iii]] = ind[(1:ns)+ns*(iii-1)]
   }
   if (n > (ns*k)) {
     test.list[[k]] = c(test.list[[k]],ind[((ns*k)+1):n])
   }
   return(list(test.list=test.list,cv.sort=ind))
  }  
 
  if (is.null(k.cv)) {k.cv = ny}
  
  test.obj = give.cv.list(ny,k.cv) 
  test.list = test.obj$test.list 
  y.cv = y[test.obj$cv.sort]
  n.lambda = length(lambda)
  
  parms.cv = parms
  
  pr.cv.list = vector('list',n.lambda)
  x.cop.train = NULL
  #x.cop.covariates.train = NULL
  x.covariates.train = NULL
  group.train = NULL
  
  for (iii in 1:k.cv) {
 
     y.train = y[-test.list[[iii]]]
     if (cop.flag) {
        x.cop.train = x.cop[-test.list[[iii]]]
        #x.cop.covariates.train = x.cop.covariates[-test.list[[iii]],]
     }  
  
     x.covariates.train = x.covariates
     for (kkk in 1:length(x.covariates.train)) {x.covariates.train[[kkk]] = x.covariates.train[[kkk]][-test.list[[iii]],]}
     
     if (!is.null(group)) {group.train = group[-test.list[[iii]]]}
  
     parms.cv$y = y[test.list[[iii]]]
     if (cop.flag) {
        parms.cv$x.cop = x.cop[test.list[[iii]]]
        #parms.cv$x.cop.covariates = x.cop.covariates[test.list[[iii]],]
     }
     #if ( (cop.flag & (n.comp > 1)) | !cop.flag ) {
     
     parms.cv$x.covariates = x.covariates
     for (kkk in 1:length(parms.cv$x.covariates)) {parms.cv$x.covariates[[kkk]] = parms.cv$x.covariates[[kkk]][test.list[[iii]],]}
     
     #}
     if (!is.null(group)) {parms.cv$group = group[test.list[[iii]]]}
     parms.cv$n = length(parms.cv$y)
     
     for (jjj in 1:n.lambda) {
      
        lambda0 = lambda[n.lambda+1-jjj]
        
        if (jjj == 1) {est.old=est.init}

        cv.temp = rep(NA, length(y.train))  
        try({ 
            est.old <- fit.CL.simple(y=y.train, x.cop=x.cop.train,
            x.covariates=x.covariates.train, h.func=h.func, h.prime.func=h.prime.func, 
            initial.estimate=est.old, group=group.train, 
            exchangeable=exchangeable, quasi.lik=quasi.lik, cop.flag=cop.flag, lambda=lambda0, 
            est.labs = est.labs, control=control)$est
            cv.temp <- fit.CL.fitted.values(est.old,parms.cv)$mu
        }, silent = TRUE)    
        
        pr.cv.list[[jjj]] = c(pr.cv.list[[jjj]], cv.temp)
     }
  }  
     
  cv.table = data.frame(lambda)
  
  cv.obj = NULL
  
  
  if ('dev' %in% gof.score.type) {
    
    gof.score = rep(NA,n.lambda)
    for (jjj in 1:n.lambda) {gof.score[n.lambda+1-jjj] = f.dev(y.cv,pr.cv.list[[jjj]])}
    cv.table = data.frame(cv.table,dev=gof.score)
    
    besti = min(which.min(gof.score))
    cv.best.dev = c(lambda[besti],gof.score[besti])
    names(cv.best.dev) = c('lambda','dev')
    cv.obj = append(cv.obj, list(cv.best.dev = cv.best.dev))
  }
    
  
  if ('auc' %in% gof.score.type) {
    
    gof.score = rep(NA,n.lambda)
    for (jjj in 1:n.lambda) {gof.score[n.lambda+1-jjj] = func.CL.auc(y.cv,pr.cv.list[[jjj]])}
    cv.table = data.frame(cv.table,auc=gof.score)
    
    besti = min(which.max(gof.score))
    cv.best.auc = c(lambda[besti],gof.score[besti])
    names(cv.best.auc) = c('lambda','auc')
    cv.obj = append(cv.obj, list(cv.best.auc = cv.best.auc))
    
  }
  
  if ('sse' %in% gof.score.type) {
    
    gof.score = rep(NA,n.lambda)
    
    for (jjj in 1:n.lambda) {
      pr.cv.sorted = pr.cv.list[[jjj]]
      pr.cv.sorted[test.obj$cv.sort] = pr.cv.list[[jjj]]
      
      lambda0 = lambda[n.lambda+1-jjj]
      
      if (jjj == 1) {est.old=est.init}
      
      fit.all = fit.CL.simple(y=y, x.cop=x.cop, x.covariates=x.covariates, 
          h.func=h.func, h.prime.func=h.prime.func, initial.estimate=est.init, group=group, 
          exchangeable=exchangeable, quasi.lik=quasi.lik, cop.flag=cop.flag, lambda=lambda0, 
          est.labs = est.labs, control=control)
      est.old = fit.all$est
      gof.score[n.lambda+1-jjj] = func.CL.sse.quad(fit.all$est, parms, group, fit.all$cor.est, y, pr.cv.sorted) 
    }
    cv.table = data.frame(cv.table,sse=gof.score)
    
    besti = min(which.min(gof.score))
    cv.best.sse = c(lambda[besti],gof.score[besti])
    names(cv.best.sse) = c('lambda','sse')
    cv.obj = append(cv.obj, list(cv.best.sse = cv.best.sse))
    
  }

  cv.obj = append(cv.obj, list(cv.table = cv.table))
  
  return(cv.obj)
  
}
