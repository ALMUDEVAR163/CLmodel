func.thresh.log.lik <-
function(thr,y,x) {
  
  na = sum(x <= thr)
  na1 = sum(y[x <= thr])
  nb = sum(x > thr)
  nb1 = sum(y[x > thr])
  ans = func.xlog(na1)+ func.xlog(na-na1) - func.xlog(na)
  ans = ans + func.xlog(nb1) + func.xlog(nb-nb1) - func.xlog(nb)
  estimates = c(na1/na,nb1/nb,thr)
  fitted.values = (na1/na)*(x <= thr) + (nb1/nb)*(x > thr)
  names(estimates) = c('p.lower','p.upper','threshold')
  return(list(estimates=estimates,log.lik=ans,fitted.values=fitted.values))
  
}
