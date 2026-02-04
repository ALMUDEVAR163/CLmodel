func.thresh.log.lik.value <-
function(thr,y,x) {
  
  na = sum(x <= thr)
  na1 = sum(y[x <= thr])
  nb = sum(x > thr)
  nb1 = sum(y[x > thr])
  ans = func.xlog(na1)+ func.xlog(na-na1) - func.xlog(na)
  ans = ans + func.xlog(nb1) + func.xlog(nb-nb1) - func.xlog(nb)
  return(ans)
}
