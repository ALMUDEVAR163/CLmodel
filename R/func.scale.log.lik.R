func.scale.log.lik <-
function(alpha,pa,pb,thr,y,x) {
  
  phiv = func.logit(alpha*(x-thr))
  mu = pa*(1-phiv) + pb*phiv
  norm.const = mean(y)/mean(mu)
  pa = norm.const*pa
  pb = norm.const*pb
  mu = pa*(1-phiv) + pb*phiv
  ans = sum(y*log(mu)) + sum((1-y)*log(1-mu))
  
  estimates = c(alpha,pa,pb,thr)
  names(estimates) = c('alpha','a1','a2','x.thr')
  return(list(estimates=estimates, log.lik=ans, fitted.values=mu))
}
