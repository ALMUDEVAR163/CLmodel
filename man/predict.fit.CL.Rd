\name{predict.fit.CL}
\alias{predict.fit.CL}
\alias{predict}
\title{Predict  method for class \code{fit.CL}}
\description{Predict method for class \code{fit.CL}.}

\usage{
predict(fit.CL.obj, newdata = NULL, level = 0.95) 
}

\arguments{
  \item{fit.CL.obj}{A fitted object of class \code{fit.CL}.}
  \item{newdata}{Optional data frame containing covariate values to be used for prediction. If omitted, the original data is used.}
  \item{level}{Confidence level for confidence bands.}
}
\details{This method calculates fitted values for the fitted model summarized in a \code{fit.CL} class object. If argument \code{newdata = NULL}, the fitted values will be those corresponding to the original predictor variables. Alternatively, fitted values for new predictor variables can be calculated by including them in the argument \code{newdata}. If the \code{cop.flag = TRUE} option was used to produce the \code{fit.CL} class object then \code{newdata} must be a list of the form \code{list(x.cop, x.covariates)}. Otherwise, \code{new.data} can be either a list with an element labelled \code{x.covariates}, or a \code{covariates} type object itself. 

In either case, the \code{predict} method outputs an \code{N*4} matrix, where \code{N} is the number of design points. The first two columns contain the fitted values and their standard errors, while the last two columns contain lower and upper  confidence bounds for the fit (the confidence level is specified in the \code{level} argument, with defalut 0.95).  The critical value used to construct the confidence bounds is \emph{chi-squared_{p,alpha}^{1/2}}, where \code{p} is the model degrees of freedom (Cox 1995).} 

\value{An \code{N*4} matrix, where \code{N*4} is the number of design points. The column names are: 
\item{fitted.values}{Predicted (fitted).}
\item{S.E.}{Standard error of fitted value.}
\item{LB}{Lower bound of confidence band.}
\item{UB}{Upper bound of confidence band.}
}

\references{
Almudevar A. and Almudevar J. (2026). A Compound Logistic Regression Model for Binary Responses (preprint).

Cox C, Ma G (1995). Asymptotic confdence bands for generalized nonlinear regression models. Biometrics, 51, 142-150.

Nelder, J. A. and Mead, R. (1965) A simplex algorithm for function minimization. Computer Journal 7, 308–313.

Soetaert K. (2009) rootSolve: Nonlinear root finding, equilibrium and steady-state analysis of ordinary differential equations.  R-package version 1.6
}
\author{
\packageAuthor{CLmodel}

Maintainer: \packageMaintainer{CLmodel}
}
\seealso{\code{\link{summary.fit.CL}}, \code{\link{fit.CL}}}
\examples{

data(sampleDataCLmodel)

### fit using regular model

est.labs = fit.CL.covariate.labels(c(2,1))
init.obj = fit.CL.init(sampleDataCLmodel$y,sampleDataCLmodel$x.cop)
init.est = c(-init.obj[4]*init.obj[1],init.obj[1],log(init.obj[3]/(1-init.obj[3])))
fit.CL.obj <- fit.CL(y=sampleDataCLmodel$y,x.cop=NULL,x.covariates=sampleDataCLmodel$x.covariates,group=NULL,
                     initial.estimate=init.est, h.func = sampleDataCLmodel$h.func, h.prime.func = sampleDataCLmodel$h.prime.func, 
                     cop.flag=FALSE, exchangeable=FALSE, quasi.lik = FALSE, lambda=0.0, linear.comb=NULL, est.labs = est.labs, 
                     control=list(reltol=1e-14))

### plot fitted curve on an evenly spaced grid 

xgrid = seq(-1,1,.01)
ngrid = length(xgrid)

### create CL model covariate object with cop.flag = F option 

x1 = rep(1,ngrid)
x.obj = fit.CL.make.xmatrices(list(cbind(x1,xgrid),x1))
newdata = list(x.covariates=x.obj)

### create and plot fitted curce with 95\% confidence bands

predict.matrix = predict(fit.CL.obj, newdata)
matplot(xgrid, predict.matrix[,c(1,3,4)],lty=c(1,2,2),type='l',col=1,ylim=c(0,1),xlab='x',ylab='Fitted Values')
title('Fitted Curve with 95\% Confidence Band')

}

