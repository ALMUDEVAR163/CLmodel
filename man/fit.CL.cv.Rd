\name{fit.CL.cv}
\alias{fit.CL.cv}
\title{Cross-validation for  CL model}
\description{Cross-validation algorithm for the selection of the egularization parameter \code{lambda} for ridge regression model.}
\usage{
fit.CL.cv(y, x.cop = NULL, x.covariates = NULL, h.func = NULL, h.prime.func = NULL, 
          initial.estimate = NULL, group = NULL, exchangeable = FALSE, 
          quasi.lik = FALSE, cop.flag = FALSE, lambda = 0,
          k.cv = NULL, gof.score.type = NULL, linear.comb = NULL, est.labs = NULL, control=NULL)
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
  \item{lambda}{Regularization parameter for ridge regression model. This may be a vector of values (all assumed to be nonnegative). If multiple values are given, all will be scored using cross-validation.}
  \item{k.cv}{\code{K}-fold cross-validation is used, where \code{K = k.cv}. For leave-one-out cross-validation (LOOCV), set \code{k.cv} to be the length of response vector \code{y}. LOOCV is used if \code{k.cv = NULL}. Matrix defining linear combination of parameters to be including in any estimation. Each row represents the linear combination coefficients. Any number of rows may be used. The number of columns must equal the number of model parameters.}
  \item{gof.score.type}{This option determines the type of GOF score used by the cross-validation algorithm. Three scores are currently implemented, \code{dev}, \code{auc} and \code{sse}. The option \code{gof.score.type} is a vector of character strings containing at least one of these labels. A separate cross-validation will be done for each score included. If \code{gof.score.type = NULL}, \code{dev} is selected.} 
   \item{linear.comb}{This argument is used in function \code{\link{fit.CL}} but not \code{fit.CL.simple}. It is included  here so that the two functon can be used interchangeably.}
  \item{est.labs}{Vector of character strings used as parameter labels. Must be equal in length to the number of model parameters. The function  \code{\link{fit.CL.covariate.labels}} may be used to create suitable parameter labels which identify the associated component (however, these labels may not be appropriate when a single paremeter appears in multiple components). If \code{est.labs = NULL} then numbered labels will be created. See documentation.}
  \item{control}{List of additional control parameters for \code{optim} function.}
}

\details{The \code{fit.CL.cv} function provides a cross-validation method for selecting the shrinkage parameter \eqn{lambda}.} 

\value{A list. For each score given in option \code{gof.score.type}, the list includes an element summarizing the best value of lambda and its associated score. In addition, the list contains a table summarizing the scores for each value of \code{lambda} included in the options.}

\references{
Almudevar A. and Almudevar J. (2026). A Compound Logistic Regression Model for Binary Responses (preprint).

Nelder, J. A. and Mead, R. (1965) A simplex algorithm for function minimization. Computer Journal 7, 308–313.

Soetaert K. (2009) rootSolve: Nonlinear root finding, equilibrium and steady-state analysis of ordinary differential equations.  R-package version 1.6
}
\author{
\packageAuthor{CLmodel}

Maintainer: \packageMaintainer{CLmodel}
}
\seealso{\code{\link{fit.CL.init}}}
\examples{
# Sample data may be used to demonstrate cross-validation algorithm

data(sampleDataCLmodel)

### Get initial estimate

init.obj = fit.CL.init(sampleDataCLmodel$y,sampleDataCLmodel$x.cop)
init.est = c(-init.obj[4]*init.obj[1],init.obj[1],log(init.obj[3]/(1-init.obj[3])))

### Regularization parameter will vary over the following values

lambda.list = seq(0,0.5,0.05)

### This example will use the dev score, with 10-fold cross-validation.

fit.CL.cv.obj <- fit.CL.cv(y=sampleDataCLmodel$y,x.cop=NULL,x.covariates=sampleDataCLmodel$x.covariates,group=NULL,
                     initial.estimate=init.est, h.func = sampleDataCLmodel$h.func, h.prime.func = sampleDataCLmodel$h.prime.func, 
                     cop.flag=FALSE, exchangeable=FALSE, quasi.lik = FALSE, lambda=lambda.list, 
                     k.cv = 10, gof.score.type = 'dev', linear.comb = NULL, est.labs = NULL, 
                     control=list(reltol=1e-14))

### display table, and plot dev against lambda

fit.CL.cv.obj
plot(fit.CL.cv.obj$cv.table,type='b')

}

