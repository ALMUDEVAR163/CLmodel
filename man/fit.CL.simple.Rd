\name{fit.CL.simple}
\alias{fit.CL.simple}
\title{Fit CL model (simple version)}
\description{Simple version of \code{fit.CL}.}
\usage{
fit.CL.simple(y, x.cop = NULL, x.covariates = NULL, h.func = NULL, h.prime.func = NULL, 
                  initial.estimate = NULL, group = NULL, exchangeable = FALSE, 
                   quasi.lik = FALSE, cop.flag = FALSE, lambda = 0,
                   linear.comb=NULL, est.labs = NULL, control=NULL) 
}

\arguments{
  \item{y}{Vector of binary responses.}
  \item{x.cop}{Vector containing COP variable. Only needed if cop.flag=TRUE. See documentation.}
  \item{x.covariates}{List of \code{K}  \code{N*D} matrices, where \code{K} is the number of logistic function components, \code{N} is the length of the binary response vector, \code{D} is the total number of model parameters (this does not include \code{alpha} when \code{cop.flag = T}). The function  \code{\link{fit.CL.make.xmatrices}} can be used to convert design matrices for the separate logistic functions into a single object  of the correct format.}
  \item{h.func}{Function defining the compound logistic response function. This should be a function type which inputs a numeric vector of length \code{K}, where \code{K} is the number of logistic function components. The \emph{k}th element of the input vector represents the \emph{k}th logistic function component. The function should output the compound response value. See documentation.}
  \item{h.prime.func}{List of \code{K} function, where \code{K} is the number of logistic function components. Each function should input a numeric vector of length \code{K}, where \code{K} is the number of logistic function components. The \emph{k}th element of the list evaluates the partial derivative of the function represetned by \code{f.func} with respect to the \emph{k}th parameter (equivalently, with respect to the \emph{k}th element of the input vector). See documentation.}
  \item{initial.estimate}{An initial estimate must be provided. This parameter can be one of several types: (1) Vector containing initial estimate; (2) List of initial estimates (each will be used, and the optimal solution adopted); (3) A function which converts the default output of \code{\link{fit.CL.init}} to the required format.} 
  \item{group}{Vector of groups for exchangeable correlation model. If \code{group = NULL} responses are assumed to be independent.}
  \item{exchangeable}{Set option to \code{TRUE} to fit exchangeable correlation model. Otherwise, responses are assumed to be independent.}
  \item{quasi.lik}{Set option to \code{TRUE} to use quasi-likleihood estimator.} 
  \item{cop.flag}{Set option to \code{TRUE} to use the COP variable model. See documentation.} 
  \item{lambda}{Regularization parameter for ridge regression model. The default \code{lambda = 0} gives an unpenalized quasilikelihood fit.}
  \item{linear.comb}{This argument is used in function \code{\link{fit.CL}} but not \code{fit.CL.simple}. It is included  here so that the two functon can be used interchangeably.}
  \item{est.labs}{Vector of character strings used as parameter labels. Must be equal in length to the number of model parameters. The function  \code{\link{fit.CL.covariate.labels}} may be used to create suitable parameter labels which identify the associated component (however, these labels may not be appropriate when a single paremeter appears in multiple components). If \code{est.labs = NULL} then numbered labels will be created. See documentation.}
  \item{control}{List of additional control parameters for \code{optim} function.}
}
\details{
Vectors \code{y} and \code{x.cop} (when used) must be the same length \code{n}.  The covariate matrices are stored in a list \code{x.covariates} of three elements. 

Likelihood optimization is performed using the \code{optim} package. The default method of Nelder and Mead (1965) is used, which does not require gradients. Users may include additional control parameters in the list \code{control}. See documentation for \code{optim}. The quasi-likleihood estimate is calculated using the \code{multiroot} function of the \code{rootSolve} package (Soetaert, 2009). An initial estimate (a vector equal in length to the number of model parameters) is required. If multiple initial estimates are provided, each is used, and the single best resulting fit is retained. The manner in which initial estimates are generated is specified by objects \code{initial.estimate} and/or \code{initial.alpha}. A list of initial estimates, or a single initial estimate  may be included in option \code{initial.estimate}. A vector of initial scale parameter "alpha" values used to generate initial estimates may be included in option \code{initial.alpha}.}

\value{A list of the form \code{list(est=est, cor.est=cor.exch)}, where \code{est} are the model parameter estimates, and \code{cor.est} is the estimate of the exchangeable correlation parameter, when included in the model.}

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

est.labs = fit.CL.covariate.labels(c(2,1))
init.obj = fit.CL.init(sampleDataCLmodel$y,sampleDataCLmodel$x.cop)
init.est = c(-init.obj[4]*init.obj[1],init.obj[1],log(init.obj[3]/(1-init.obj[3])))
fit.CL.simple(y=sampleDataCLmodel$y,x.cop=NULL,x.covariates=sampleDataCLmodel$x.covariates,group=NULL,
  initial.estimate=init.est, h.func = sampleDataCLmodel$h.func, h.prime.func = sampleDataCLmodel$h.prime.func,
  cop.flag = FALSE, exchangeable = FALSE, quasi.lik = FALSE, lambda=0.0,  est.labs = est.labs, 
  control=list(reltol=1e-14))

}

