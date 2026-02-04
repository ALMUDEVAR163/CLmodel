func.give.cor.inv <-
function(gr,rho) { 
  
  ny = length(gr)
  mm = matrix(0,ny,ny)
  diag(mm)=1
  usub.list = split(1:ny,gr)
  nsub = length(usub.list)
  for (i in 1:nsub) {
    ind = usub.list[[i]]
    n = length(ind)
    if (n>1) {
      dd = (1+(n-1)*rho)*(1-rho)
      ap = (1 + rho*(n-2))/dd
      bp = -rho/dd
      mm[ind,ind]=bp
      diag(mm[ind,ind])=ap
    }
  } 
  mm <- Matrix::Matrix(mm,sparse=T)
  return(mm) 
}
