\name{summary.fit.CL}
\alias{summary.fit.CL}
\title{Summary method for class \code{fit.CL}}
\description{Summary method for class \code{fit.CL}.}

\usage{
summary(fit.CL.obj) 
}

\arguments{
  \item{fit.CL.obj}{A fitted object of class \code{fit.CL}.}
  \item{silent = FALSE}{Print is suppressed if set to \code{TRUE}}
}

\details{This method prints to console a coefficient table, including columns for the estimated coefficient, the standard error, t-statistic and two-sided p-value. In addition to all coefficients, linear combinations requested using the \code{linear.comb} option in the  \code{\link{fit.CL}} are included.} 

\value{An object of class \code{fit.CL}. List with the following elements:
\item{coef.table}{Coefficient table. Includes rows for linear combinations defined by \code{linear.comb}. Columns include the estimate, the standard error, the Z-score, and the p-value against the null hypothesis of 0 (using the asymptotic distribution for the estimates). Use generic function \code{\link{summary.fit.CL}} for a more convenient method of displaying this table.}
\item{log.lik}{The maximum log-likelihood. If the quasi-likelihood option is selected (\code{quasi.lik=TRUE}), this value corresponds to the initial fit (no "quasi-likelihood function" is reported). Therefore, the log-likleihood is only formally interpretable if the responses are independent.}     
\item{n}{Sample size (length of response vector).}
\item{rho}{The estimated correlation parameter. Its interpretation depends on the correlation model. (Used  if \code{exchangeable=TRUE}).}
\item{cor.est}{The estimated correlation parameter. Its interpretation depends on the correlation model. (Used  if \code{exchangeable=TRUE}).}
\item{model.df}{Model degrees of freedom.}
\item{aic}{AIC model criterion.}
\item{bic}{BIC model criterion.}
\item{n.groups}{Number of groups within which exchangeable correlation is modelled.}
}

\references{
Almudevar A. and Almudevar J. (2026). A Compound Logistic Regression Model for Binary Responses (preprint).
}
\author{
\packageAuthor{CLmodel}

Maintainer: \packageMaintainer{CLmodel}
}
\seealso{\code{\link{predict.fit.CL}}, \code{\link{fit.CL}}}
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

summary(fit.CL.obj)

}



