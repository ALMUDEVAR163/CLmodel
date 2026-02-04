func.scale.log.lik.value <-
function(alpha,pa,pb,thr,y,x) {
  
  phiv = func.logit(alpha*(x-thr))
  mu = pa*(1-phiv) + pb*phiv
  norm.const = mean(y)/mean(mu)
  pa = norm.const*pa
  pb = norm.const*pb
  mu = pa*(1-phiv) + pb*phiv
  ans = sum(y*log(mu)) + sum((1-y)*log(1-mu))
  return(ans)
}
