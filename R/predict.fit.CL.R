predict.fit.CL <-
function(fit.CL.obj, newdata = NULL, level = 0.95) {
  
  if (is.null(newdata)) {
      ans =  cbind(fit.CL.obj$fitted.values,fit.CL.obj$fitted.values.se)
      n.sample = dim(ans)[1]
  } else {
    
    new.parms = fit.CL.obj$parms
    
    if (new.parms$cop.flag) {
      
      new.parms$x.cop = newdata$x.cop
      new.parms$x.covariates = newdata$x.covariates
      n.sample = length(new.parms$x.cop)  
    
    } else {
    
      new.parms$x.cop = NULL
      
      if (is.null(newdata$x.covariates)) {
        new.parms$x.covariates = newdata
      } else {
        new.parms$x.covariates = newdata$x.covariates
      }
      n.sample = dim(new.parms$x.covariates[[1]])[1]
    
    }  
  
    new.parms$n = n.sample
     
    fit.CL.fitted.values.obj = fit.CL.fitted.values(fit.CL.obj$est,new.parms)  
    dmu = fit.CL.fitted.values.obj$dmu  
    ans = cbind(fit.CL.fitted.values.obj$mu, func.sqrt0(diag(dmu%*%fit.CL.obj$sigma%*%t(dmu))))
  }
 
  crit.val = sqrt(qchisq(level,df=fit.CL.obj$model.df,lower.tail=TRUE))
  
  ans = cbind(ans, ans[,1]-crit.val*ans[,2],  ans[,1]+crit.val*ans[,2])
  colnames(ans) = c('fitted.values','S.E.','LB','UB')
    
  return(ans)
}
