func.CL.auc <-
function(group,y) {

	y0<-y[group==0]
	y1<-y[group==1]
	
	count<-0
	for (i in 1:length(y0)) {count<-count+sum(y1 > y0[i]) + 0.5*sum(y1 == y0[i])}
	ans<-count/(length(y0)*length(y1))
	return(ans) 
}
