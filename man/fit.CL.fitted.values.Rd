\name{fit.CL.fitted.values}
\alias{fit.CL.fitted.values}
\title{Fitted values for CL model}
\description{Return response function for given model parameters.}
\usage{
fit.CL.fitted.values(est, parms)
}

\arguments{
  \item{est}{Vector of model parameters.}
  \item{parms}{List containing model data required to calculate fitted values, in addition to the model parameters given in \code{est}. The list should take the following form: \code{list(x.cop=x.cop, x.covariates=x.covariates, h.func = h.func, h.prime.func = h.prime.func, cop.flag=cop.flag)}. All elements should be included, except that \code{x.cop} only has to be given when \code{cop.flag = TRUE}. The elements in \code{parms} are the same as for function \code{\link{fit.COP}}}. 
}
\details{
Vectors \code{y} and \code{x.cop} (when used) must be the same length \code{n}.  The covariate matrices are stored in a list \code{x.covariates} of three elements. 
}

\value{A list of the form \code{list(mu, pi.matrix, dmu)}. The fitted values are given in vector \code{mu}. The response functions for each component are given in the matrix \code{pi.matrix}. The partial derivatives of the response function are given in the matrix \code{dmu} (the \eqn{\Gamma} matrix). See documentation.}

\references{
Almudevar A. and Almudevar J. (2026). A Compound Logistic Regression Model for Binary Responses (preprint).

Nelder, J. A. and Mead, R. (1965) A simplex algorithm for function minimization. Computer Journal 7, 308–313.

Soetaert K. (2009) rootSolve: Nonlinear root finding, equilibrium and steady-state analysis of ordinary differential equations.  R-package version 1.6
}
\author{
\packageAuthor{CLmodel}

Maintainer: \packageMaintainer{CLmodel}
}
\seealso{\code{\link{fit.CL}}}
\examples{

### Define two-component model

h.func = function(p) {p[1]*p[2]}
hdev1 = function(p) {p[2]}
hdev2 = function(p) {p[1]}
h.prime.func = list(hdev1=hdev1, hdev2=hdev2)

### Generate predictor variables

n.sample = 100
x.cop = 2*runif(n.sample)-1
x1 = rep(1,n.sample)
x.obj = fit.CL.make.xmatrices(list(cbind(x1,x.cop),x1))

### Create parms object 

parms = list(x.cop=x.cop, x.covariates=x.obj,h.func = h.func, h.prime.func = h.prime.func, cop.flag=FALSE)

### Specify model parameters

true.par = c(0.75,3,log(0.75/0.25))

### Get fitted values, then plot

mu = fit.CL.fitted.values(true.par,parms)$mu

plot(x.cop,mu,ylim=c(0,1))

}

