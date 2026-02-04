func.sqrt0 <-
function(x) {
  x[x<0] = NA
  return(sqrt(x))
}
