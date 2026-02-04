func.cor.est <-
function(y,mu,np,gr=NULL) {

  rho = 0
  ny = length(y)
  res = (y - mu)/(sqrt(mu*(1-mu)))
  phi = sum(res^2)/ny

  if (!is.null(gr)) {
    v1 = tapply(res,as.factor(gr),func.od.sum)
    v2 = tapply(res,as.factor(gr),func.od.num)
    rho = sum(v1,na.rm=T)/(sum(v2,na.rm=T)-np)
  }
  ans = c(phi,rho)
  names(ans) = c('phi','rho')
  return(ans)
  
}
