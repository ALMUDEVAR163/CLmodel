\name{fit.CL.init}
\alias{fit.CL.init}
\title{Initial Fit for CL model}
\description{Provides an initial solution for the calculation of CL model fits.}
\usage{
fit.CL.init(y,x.cop,init.function = NULL)
}

\arguments{
  \item{y}{Vector of binary responses.}
  \item{x.cop}{Vector containing COP variable. This must be provided.}
  \item{init.function}{This function transforms the parameters of the initial fit to the form used by a particula CL model. If \code{init.function = NULL}, then the parametrization used will be in the form \code{c('alpha','a1','a2','x.thr')}. See documentation.}
}

\details{
Vectors \code{y} and \code{x.cop} (when used) must be the same length \code{n}.  The covariate matrices are stored in a list \code{x.covariates} of three elements. 

Likelihood optimization is performed using the \code{optim} package. The default method of Nelder and Mead (1965) is used, which does not require gradients. Users may include additional control parameters in the list \code{control}. See documentation for \code{optim}. The quasi-likleihood estimate is calculated using the \code{multiroot} function of the \code{rootSolve} package (Soetaert, 2009). An initial estimate (a vector equal in length to the number of model parameters) is required. If multiple initial estimates are provided, each is used, and the single best resulting fit is retained. The manner in which initial estimates are generated is specified by objects \code{initial.estimate} and/or \code{initial.alpha}. A list of initial estimates, or a single initial estimate  may be included in option \code{initial.estimate}. A vector of initial scale parameter "alpha" values used to generate initial estimates may be included in option \code{initial.alpha}.}

\value{A vector of initial parameter estimates.}

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
# Sample data may be used to demonstrate main fitting function

data(sampleDataCLmodel)

### fit using regular model

init.fun  = function(x) {c(-x[4]*x[1],x[1],log(x[3]/(1-x[3])),0)}
est.labs = fit.CL.covariate.labels(c(2,2))
init.obj = fit.CL.init(sampleDataCLmodel$y,sampleDataCLmodel$x.cop)
init.obj

}

