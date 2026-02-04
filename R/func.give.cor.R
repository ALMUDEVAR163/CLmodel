func.give.cor <-
function(gr,rho) { 
  
  ny = length(gr)
  mm = matrix(0,ny,ny)
  diag(mm)=1
  usub.list = split(1:ny,gr)
  nsub = length(usub.list)
  for (i in 1:nsub) {
    ind = usub.list[[i]]
    if (length(ind)>1) {
      mm[ind,ind]=rho
      diag(mm[ind,ind])=1
    } 
  }  
  mm <- Matrix::Matrix(mm,sparse=T)
  return(mm) 
}
