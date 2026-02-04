\name{fit.CL.sim.data}
\alias{fit.CL.sim.data}
\title{Simulate data for CL models}
\description{Simulates data suitable for fitting CL models.}
\usage{
fit.CL.sim.data(mu,nsim,group=NULL,rho=NULL)
}

\arguments{
  \item{mu}{Vector of length \code{N}, interpreted as expected responses for a CL model.}
  \item{nsim}{Number replications. Each replication consists of a vector of binary responses corresponding to the vector \code{mu}.}  
  \item{group}{Group variable used for simulating binary responses with exchangeable correlation. If 
  \code{group = NULL} then respoinses will be independent.}
  \item{rho}{Correlation parameter for exchangeble correlation model. If  \code{rho = NULL} then respoinses will be independent.}
}
\details{
Vectors \code{y} and \code{x.cop} (when used) must be the same length \code{n}.  The covariate matrices are stored in a list \code{x.covariates} of three elements. 

Likelihood optimization is performed using the \code{optim} package. The default method of Nelder and Mead (1965) is used, which does not require gradients. Users may include additional control parameters in the list \code{control}. See documentation for \code{optim}. The quasi-likleihood estimate is calculated using the \code{multiroot} function of the \code{rootSolve} package (Soetaert, 2009). An initial estimate (a vector equal in length to the number of model parameters) is required. If multiple initial estimates are provided, each is used, and the single best resulting fit is retained. The manner in which initial estimates are generated is specified by objects \code{initial.estimate} and/or \code{initial.alpha}. A list of initial estimates, or a single initial estimate  may be included in option \code{initial.estimate}. A vector of initial scale parameter "alpha" values used to generate initial estimates may be included in option \code{initial.alpha}.}

\value{A matrix of dimension \code{nsim * N}. Each row is a single replication.}

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


library(CLmodel)
set.seed(543876)
n.sample = 1000
x.cop = 2*runif(n.sample)-1
true.par = c(3,0,log(0.75/0.25),log(0.75/0.25))

h.func = function(p) {p[2]*(1-p[3]*p[1])}
hdev1 = function(p) {-p[2]*p[3]}
hdev2 = function(p) {1-p[3]*p[1]}
hdev3 = function(p) {-p[1]*p[2]} 
h.prime.func = list(hdev1=hdev1, hdev2=hdev2, hdev3=hdev3)

x1 = rep(1,n.sample)
x2 = cbind(x1,x.cop)

x.obj = fit.CL.make.xmatrices(list(x1,x1,x1))

parms = list(x.cop=x.cop, x.covariates=x.obj,h.func=h.func, h.prime.func=h.prime.func, cop.flag=TRUE)

mu = fit.CL.fitted.values(true.par,parms)$mu
ymat = fit.CL.sim.data(mu,1)
y = ymat[1,]


}

