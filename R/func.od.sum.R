func.od.sum <-
function(x) {
  n=length(x)
  mm = matrix(x,n,1)%*%matrix(x,1,n)
  diag(mm)=0
  ans = sum(mm)/2
  return(ans)
}
