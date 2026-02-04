summary.fit.CL <-
function(fit.CL.obj, silent = FALSE) {
  
  coef.table = fit.CL.obj$coef
  log.lik = fit.CL.obj$log.lik
  n = fit.CL.obj$n
  #rho = fit.CL.obj$cor.est
  cor.est = fit.CL.obj$cor.est
  model.df = fit.CL.obj$model.df
  aic = -2*log.lik + 2*model.df
  bic = -2*log.lik + log(n)*model.df
  qic = fit.CL.obj$qic.cl
  qicu = fit.CL.obj$qicu.cl
  n.groups=length(unique(fit.CL.obj$parms$group))
  
  if (!silent) {
    print(fit.CL.obj$coef,digits=5,quote=F)
    cat("\n")
    
    if (fit.CL.obj$quasi.lik) {
       cat('Quasi-likelihood estimate:', "\n")
    } else {
      cat('Maximum-likelihood estimate:', "\n")
    }

    if (fit.CL.obj$exchangeable) {
      cat('Exchangeable Correlation: ')
      cat(paste('rho = ',signif(fit.CL.obj$cor.est,digits=4)),"\n")
      cat('Number of groups = ',n.groups,"\n")
    } else {
      cat('Independence assumed',"\n")
    }
  
    cat('N = ',n,'; model DF = ',model.df,"\n")
    if (is.null(qic)) {
      cat('Log-lik = ',log.lik,'; AIC = ',aic,'; BIC = ',bic,"\n")
    } else {
      cat('Log-lik = ',log.lik,'; QIC = ',qic,'; QICu = ',qicu,"\n")
    }
  } ### if (!silent)
  
  summary.fit.CL.obj = list(
    coef.table = coef.table,
    log.lik = log.lik,
    n = n,
    #rho = rho,
    cor.est = cor.est,
    model.df = model.df,
    aic = aic,
    bic = bic,
    n.groups = n.groups)
  
   class(summary.fit.CL.obj) = "summary.fit.CL"
   invisible(summary.fit.CL.obj)

}
