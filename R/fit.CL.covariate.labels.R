fit.CL.covariate.labels <-
function(pattern, cop.flag=FALSE) {
  
  n.comp = length(pattern) 
  
  if (cop.flag) {
  
    est.labs = c('alpha')
    est.labs = c(est.labs, paste('b[1,',1:(pattern[1]),']',sep=''))
    if (n.comp > 1) {
      for (i in 2:n.comp) {
        for (j in 1:(pattern[i])) {
          est.labs = c(est.labs, paste('b[',i,',',j,']',sep=''))  
        }
      }
    }
  } else {
    
    est.labs = paste('b[1,',1:pattern[1],']',sep='')
    if (n.comp > 1) {
      for (i in 2:n.comp) {
        for (j in 1:(pattern[i])) {
          est.labs = c(est.labs, paste('b[',i,',',j,']',sep=''))  
        }
      }
    }
  }
  return(est.labs)
}
