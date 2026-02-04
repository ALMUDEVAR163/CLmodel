fit.CL.make.xmatrices <-
function(x.list) {
  
  ### number of components
  
  ncomp = length(x.list)
  
  ### get number of observations
  
  npv = rep(NA, ncomp)
  if (!is.matrix(x.list[[1]])) {ny = length(x.list[[1]])} else {ny = dim(x.list[[1]])[1]} 
  
  for (iii in 1:ncomp) {
    if (!is.matrix(x.list[[iii]])) {npv[iii] = 1} else {npv[iii] = dim(x.list[[iii]])[2]}
  }
  nbeta = sum(npv)
  
  ### create list of covariate matrices in correct format
  
  x.covariates = list()
  for (iii in 1:ncomp) {  
      x.covariates[[iii]] = matrix(0,ny,nbeta)
      colind = (sum(c(0,npv)[1:iii])+1):sum(c(0,npv)[1:(iii+1)])
      x.covariates[[iii]][,colind] = x.list[[iii]]
  }
  
  return(x.covariates)
}
