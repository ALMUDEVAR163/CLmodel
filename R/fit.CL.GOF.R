fit.CL.GOF <-
function(y, x.data, group=NULL, nboot=1000) {
  
  nboot = max(2,nboot)
  
  x.data = data.frame(x.data,y)
  if (!is.null(group)) {
      group = as.numeric(as.factor(group))
      x.data = data.frame(x.data,group)
      ind = sort.list(group)
      x.data = x.data[ind,]
  }
  
  if (is.null(group)) {model.df = length(y) - dim(x.data)} else {model.df = length(y) - dim(x.data) - 1}
  
  if (is.null(group)) {
    rho = NULL
    rho.se = NULL
    
    mu.est = stats::glm(y~.,family='binomial', data=x.data)$fitted.values
    chi.stat.obs = sum( (y-mu.est)^2/(mu.est*(1-mu.est)))

    ny = length(mu.est)
    ym = bindata::rmvbin(nboot,margprob=mu.est)
 
    chi.stat.boot = numeric(nboot)
    for (iii in 1:nboot) {
        mus = stats::glm(ym[iii,]~.,family='binomial', data=x.data)$fitted.values
        chi.stat.boot[iii] = sum((ym[iii,]-mus)^2/(mus*(1-mus)))
    }     
     
    p.value = mean(c(chi.stat.boot, chi.stat.obs) >= chi.stat.obs)
  } else {
    
  
    fit0 = geepack::geeglm(y~.-group,id=group,family='binomial',corstr='exchangeable', data=x.data)
    mu.est = fit0$fitted.values 
    chi.stat.obs = sum( (y-mu.est)^2/(mu.est*(1-mu.est)))
    rho = summary(fit0)$corr$Estimate
    rho.se = summary(fit0)$corr$Std.err
    
    ny = length(mu.est)
    ym = fit.CL.sim.data(mu.est,nboot,group,rho)
 
    chi.stat.boot = numeric(nboot)
    for (iii in 1:(nboot-1)) {
       mus = geepack::geeglm(ym[iii,]~.-group,id=group,family='binomial',corstr='exchangeable', data=x.data)$fitted.values
       chi.stat.boot[iii] = sum((ym[iii,]-mus)^2/(mus*(1-mus)))
    }
  
    p.value = mean(c(chi.stat.boot, chi.stat.obs) >= chi.stat.obs)
  }
  
  return(list(chi.stat.obs=chi.stat.obs, chisq.df=model.df, p.value=p.value, rho.est=list(est=rho,se=rho.se)))  
  
}
