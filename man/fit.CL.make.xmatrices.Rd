\name{fit.CL.make.xmatrices}
\alias{fit.CL.make.xmatrices}
\title{Format predictor variables for CL model.}
\description{Convert predictor variables for CL model into the correct format.}
\usage{
fit.CL.make.xmatrices(x.list) 
}

\arguments{
  \item{x.list}{List of length \code{K}, where \code{K} is the number of logistic function components. The \emph{k}th element of \code{x.list} is an \code{N*D[k]} design matrix of predictor variables, where \code{N} is the length of the binary response vector, and \code{D[k]} is the number of predictor variables associated with the \emph{k}th component of the CL model.}
}
\details{
Vectors \code{y} and \code{x.cop} (when used) must be the same length \code{n}.  The covariate matrices are stored in a list \code{x.covariates} of three elements. 

Likelihood optimization is performed using the \code{optim} package. The default method of Nelder and Mead (1965) is used, which does not require gradients. Users may include additional control parameters in the list \code{control}. See documentation for \code{optim}. The quasi-likleihood estimate is calculated using the \code{multiroot} function of the \code{rootSolve} package (Soetaert, 2009). An initial estimate (a vector equal in length to the number of model parameters) is required. If multiple initial estimates are provided, each is used, and the single best resulting fit is retained. The manner in which initial estimates are generated is specified by objects \code{initial.estimate} and/or \code{initial.alpha}. A list of initial estimates, or a single initial estimate  may be included in option \code{initial.estimate}. A vector of initial scale parameter "alpha" values used to generate initial estimates may be included in option \code{initial.alpha}.}

\value{A list of numerical matrices conforming to the format of the \code{x.covariates} object of function \code{\link{fit.CL}}.}

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

set.seed(76543)
n.sample = 1000
x.cop = 2*runif(n.sample)-1
x1 = rep(1,n.sample)
x.obj = fit.CL.make.xmatrices(list(cbind(x1,x.cop),x1))
est.labs = fit.CL.covariate.labels(c(2,1))
}

