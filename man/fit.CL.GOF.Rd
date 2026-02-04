\name{fit.CL.GOF}
\alias{fit.CL.GOF}
\title{GOF test for standard logistic regression model}
\description{GOF test with standard logistic regression model as null hypothesis. A \eqn{\chi^2}-statistic is used, with significance level estimated using a bootstrap procedure.}
\usage{
fit.CL.GOF(y, x.data, group=NULL, nboot=1000) 
}

\arguments{
  \item{y}{Vector of binary responses.}
  \item{x.data}{Vector containing single predictor variable suitable for a simple logistic regression model.}
  \item{group}{Vector of groups for exchangeable correlation model. If \code{group = NULL} responses are assumed to be independent.}
  \item{nboot}{Number of replications to be used for bootstrap procedure.}
}

\details{
Vectors \code{y} and \code{x.cop} (when used) must be the same length \code{n}.  The covariate matrices are stored in a list \code{x.covariates} of three elements.}

\value{A list of the form \code{list(chi.stat.obs, chisq.df, p.value, rho.est)}, where \code{chi.stat.obs} is the observed \eqn{\chi^2}-statistic, \code{chisq.df} is the degrees of freedom and \code{p.value} is the level of significance estimated by the bootstrap procedure, where the standard logistic regression model defines the null hypothesis. If \code{group} is provided, the bootstrap samples are simulated using an appropriate exchangeble correlation model, and fit using GEEs. Then \code{rho.est = list(est,se)} contains the estimate and standard error of the correlation parameter.}

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

fit.CL.GOF.obj = fit.CL.GOF(y,x.cop,group=NULL,nboot=1000) 

plot(x.cop,mu,ylim=c(0,1))

fit.CL.GOF.obj

}

