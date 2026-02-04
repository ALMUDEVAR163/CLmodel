func.CL.lik.cov.r <-
function(est,parms,group,cor.exch) {
  
  fitted.values.obj = fit.CL.fitted.values(est,parms)
  
  rmat = func.give.cor(group,cor.exch)
  
  cov.matrix0 = matrix(NA,length(est),length(est))
  
  mu = fitted.values.obj$mu
  
  dmuv = fitted.values.obj$dmu/sqrt(mu*(1-mu))
  
  qr.obj = qr(dmuv)
  qrank = qr.obj$rank
  
  rr = qr.R(qr(dmuv))[1:qrank,1:qrank]
  if (qrank==1) rr = as.matrix(rr)
  rri = backsolve(rr,diag(rep(1,dim(rr)[1])))
  cov.matrix0[qr.obj$pivot[1:qrank],qr.obj$pivot[1:qrank]] = rri%*%t(rri)
  
  cov.matrix0 = as.matrix(cov.matrix0)
  cov.matrix1 = (t(dmuv)%*%rmat)%*%dmuv
  
  cov.matrix = (cov.matrix0%*%cov.matrix1)%*%cov.matrix0
  
  
  return(cov.matrix)
}
