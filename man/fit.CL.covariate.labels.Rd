\name{fit.CL.covariate.labels}
\alias{fit.CL.covariate.labels}
\title{Create covariate label for CL model}
\description{Input vector listing number of parameters associated with each CL component.}
\usage{
fit.CL.covariate.labels(pattern, cop.flag=FALSE) 
}

\arguments{
  \item{pattern}{Vector of length \code{K}, where \code{K} is the number of logistic function components. The \emph{k}th element  gives the number of parameters associated with the \emph{k}th component of the CL model.}
  \item{cop.flag}{Set option to \code{TRUE} to use the COP variable model. See documentation.} 
}
\details{The function \code{fit.CL.covariate.labels} is a simple utility for the creation of parameter labels. These may be used as the option \code{est.labs} in the function \code{\link{fit.CL}} or \code{\link{fit.CL.simple}}. The format is \code{b[k,j]}, which labels the \emph{j}th parameter of the \emph{k}th model component. However, it is important to note that the same parameter vector is used for each model component, so this labelling system is suitable only when no parameter is used by more than one model component. If \code{cop.flag = TRUE} the first label will reference the scale parameter \code{alpha}. The remaining labels will otherwise be the same. See documentation.
.}

\value{Character vector of parameter labels. The vector is of length \code{D} (\code{cop.flag = FALSE}) or \code{D+1} (\code{cop.flag = TRUE}), where \code{D} is the total number of model parameters not including the scale parameter \code{alpha} (used when \code{cop.flag = TRUE}).}

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

### covariate labels can be created for regular and COP models

fit.CL.covariate.labels(c(2,2,1), cop.flag=FALSE)

fit.CL.covariate.labels(c(2,2,1), cop.flag=TRUE)

}

