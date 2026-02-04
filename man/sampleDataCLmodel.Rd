\name{sampleDataCLmodel}
\alias{sampleDataCLmodel}
\title{Sample data set for package \code{CLmodel}}
\description{Sample data set for demonstration of functions from package \code{CLmodel}.}


\usage{
data(sampleDataCLmodel)
}

\details{List contain an example of a CL model, with simulated data.} 

\value{A list with the following elements:
\item{y}{Response vector.}
\item{x.cop}{COP variable. This is included for convenience, and is not required for this example (it is already included in the required format in the \code{x.covariates} object.}     
 \item{x.covariates}{List of \code{K}  \code{N*D} matrices, where \code{K} is the number of logistic function components, \code{N} is the length of the binary response vector, \code{D} is the total number of model parameters (this does not include \code{alpha} when \code{cop.flag = T}). The function  \code{\link{fit.CL.make.xmatrices}} can be used to convert design matrices for the separate logistic functions into a single object  of the correct format.}
  \item{h.func}{Function defining the compound logistic response function. This should be a function type which inputs a numeric vector of length \code{K}, where \code{K} is the number of logistic function components. The \emph{k}th element of the input vector represents the \emph{k}th logistic function component. The function should output the compound response value. See documentation.}
  \item{h.prime.func}{List of \code{K} function, where \code{K} is the number of logistic function components. Each function should input a numeric vector of length \code{K}, where \code{K} is the number of logistic function components. The \emph{k}th element of the list evaluates the partial derivative of the function represetned by \code{f.func} with respect to the \emph{k}th parameter (equivalently, with respect to the \emph{k}th element of the input vector). See documentation.}
\item{cop.flag}{Set option to \code{TRUE} to use the COP variable model. See documentation.} 
}

\references{
Almudevar A. and Almudevar J. (2026). A Compound Logistic Regression Model for Binary Responses (preprint).
}
\author{
\packageAuthor{CLmodel}

Maintainer: \packageMaintainer{CLmodel}
}
\seealso{\code{\link{fit.CL}}}
\examples{

### The following code was used to generate sampleDataCLmodel

library(CLmodel)
set.seed(321987)

h.func = function(p) {p[1]*p[2]}
hdev1 = function(p) {p[2]}
hdev2 = function(p) {p[1]}
h.prime.func = list(hdev1=hdev1, hdev2=hdev2)
h.two.component = list(h.func=h.func, h.prime.func=h.prime.func)

n.sample = 1000
x.cop = 2*runif(n.sample)-1
x1 = rep(1,n.sample)
x.obj = fit.CL.make.xmatrices(list(cbind(x1,x.cop),x1))
est.labs = fit.CL.covariate.labels(c(2,1))

true.par = c(0.75,3,log(0.75/0.25))

### simulate data 

parms = list(y=NULL, x.cop=x.cop, x.covariates=x.obj,
             h.func = h.two.component$h.func, h.prime.func = h.two.component$h.prime.func, cop.flag=FALSE)

mu = fit.CL.fitted.values(true.par,parms)$mu
ymat = fit.CL.sim.data(mu,1)
y = ymat[1,]

parms$y = y 

sampleDataCLmodel = parms
save(sampleDataCLmodel,file='sampleDataCLmodel.RData')


}



