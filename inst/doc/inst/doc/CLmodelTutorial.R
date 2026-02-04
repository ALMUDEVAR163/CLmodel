### R code from vignette source 'CLmodelTutorial.Rnw'

###################################################
### code chunk number 1: CLmodelTutorial.Rnw:64-65
###################################################
library(CLmodel)


###################################################
### code chunk number 2: CLmodelTutorial.Rnw:232-251
###################################################

###
### Predictor variable
###

x = c(1.2, 3.4, 7.6, 8.2)

###
### Intercept 
###

x0 = rep(1,4)

###
### Create design matrices in format required by CLmodel functions
###

x.list = list(cbind(x0,x),x0)
fit.CL.make.xmatrices(x.list)


###################################################
### code chunk number 3: CLmodelTutorial.Rnw:256-261
###################################################

### There are 2 parameters for component 1, and 1 parameter for component 2.  

pattern = c(2,1)
fit.CL.covariate.labels(pattern, cop.flag = FALSE) 


###################################################
### code chunk number 4: CLmodelTutorial.Rnw:269-273
###################################################

data(sampleDataCLmodel)
names(sampleDataCLmodel)
length(sampleDataCLmodel$y)


###################################################
### code chunk number 5: CLmodelTutorial.Rnw:278-281
###################################################

head(sampleDataCLmodel$x.covariates[[1]])
head(sampleDataCLmodel$x.covariates[[2]])


###################################################
### code chunk number 6: CLmodelTutorial.Rnw:286-289
###################################################

est.labs = fit.CL.covariate.labels(c(2,1))
est.labs


###################################################
### code chunk number 7: CLmodelTutorial.Rnw:294-297
###################################################

sampleDataCLmodel$h.func
sampleDataCLmodel$h.prime.func


###################################################
### code chunk number 8: CLmodelTutorial.Rnw:328-335
###################################################

init.obj = fit.CL.init(sampleDataCLmodel$y,sampleDataCLmodel$x.cop)
init.obj
init.est = c(-init.obj[4]*init.obj[1],
             init.obj[1],
             log(init.obj[3]/(1-init.obj[3])))
init.est


###################################################
### code chunk number 9: CLmodelTutorial.Rnw:343-383
###################################################

fit.CL.obj <- fit.CL(y = sampleDataCLmodel$y,
                     x.cop = NULL,
                     x.covariates = sampleDataCLmodel$x.covariates,
                     group = NULL,
                     initial.estimate = init.est, 
                     h.func = sampleDataCLmodel$h.func, 
                     h.prime.func = sampleDataCLmodel$h.prime.func,
                     cop.flag = FALSE, 
                     exchangeable = FALSE, 
                     quasi.lik = FALSE, 
                     lambda = 0.0, 
                     linear.comb = NULL, 
                     est.labs = est.labs, 
                     control = list(reltol = 1e-14))

###
### Generic summary function for S3 class = fit.CL 
###

summary(fit.CL.obj)

###
### Simple fit function
###

fit.CL.simple(y = sampleDataCLmodel$y,
              x.cop = NULL,
              x.covariates = sampleDataCLmodel$x.covariates,
              group = NULL,
              initial.estimate = init.est, 
              h.func = sampleDataCLmodel$h.func, 
              h.prime.func = sampleDataCLmodel$h.prime.func,
              cop.flag = FALSE, 
              exchangeable = FALSE, 
              quasi.lik = FALSE, 
              lambda = 0.0, 
              est.labs = est.labs, 
              control = list(reltol = 1e-14))



###################################################
### code chunk number 10: CLmodelTutorial.Rnw:420-423
###################################################

est.labs = fit.CL.covariate.labels(c(1,1), cop.flag = TRUE)
est.labs


###################################################
### code chunk number 11: CLmodelTutorial.Rnw:428-435
###################################################

init.obj = fit.CL.init(sampleDataCLmodel$y,sampleDataCLmodel$x.cop)
init.obj
init.est = c(log(init.obj[1]), 
             init.obj[4], 
             log(init.obj[3]/(1-init.obj[3])))
init.est


###################################################
### code chunk number 12: CLmodelTutorial.Rnw:440-462
###################################################

###
### Sample size
###

data(sampleData)
n = length(sampleDataCLmodel$y)

###
### Intercept term
###

x0 = rep(1,n)

###
### Create design matrices in format required by CLmodel functions
###

x.list = list(x0, x0)
x.covariates = fit.CL.make.xmatrices(x.list)
head(x.covariates[[1]])
head(x.covariates[[2]])


###################################################
### code chunk number 13: CLmodelTutorial.Rnw:466-493
###################################################

fit.CL.obj.COP <- fit.CL(y = sampleDataCLmodel$y, 
                         x.cop = sampleDataCLmodel$x.cop, 
                         x.covariates = x.covariates, 
                         group = NULL,
                         initial.estimate = init.est, 
                         h.func = sampleDataCLmodel$h.func, 
                         h.prime.func = sampleDataCLmodel$h.prime.func,
                         cop.flag = TRUE, 
                         exchangeable = FALSE, 
                         quasi.lik = FALSE, 
                         lambda = 0.0, 
                         linear.comb = NULL, 
                         est.labs = est.labs, 
                         control = list(reltol = 1e-14))

###
### Fit summary
###

summary(fit.CL.obj.COP)

###
### summary for non-COP model
###

summary(fit.CL.obj)


###################################################
### code chunk number 14: CLmodelTutorial.Rnw:505-567
###################################################

library(CLmodel)
data(sampleDataCLmodel)

###
### fit using regular model
###

est.labs = fit.CL.covariate.labels(c(2,1))
init.obj = fit.CL.init(sampleDataCLmodel$y,sampleDataCLmodel$x.cop)
init.est = c(-init.obj[4]*init.obj[1],
             init.obj[1],
             log(init.obj[3]/(1-init.obj[3])))
fit.CL.obj <- fit.CL(y = sampleDataCLmodel$y,
                     x.cop = NULL,
                     x.covariates = sampleDataCLmodel$x.covariates,
                     group = NULL,
                     initial.estimate = init.est, 
                     h.func = sampleDataCLmodel$h.func, 
                     h.prime.func = sampleDataCLmodel$h.prime.func,
                     cop.flag = FALSE, 
                     exchangeable = FALSE, 
                     quasi.lik = FALSE, 
                     lambda = 0.0, 
                     linear.comb = NULL, 
                     est.labs = est.labs, 
                     control = list(reltol = 1e-14))

###
### Fit summary
###

summary(fit.CL.obj)

###
### Construct grid on which to plot fitted curve
###

xgrid = seq(-2, 2, 0.1)

###
### Intercept 
###

x0 = rep(1,length(xgrid))

###
### Create design matrices 
###

x.list = list(cbind(x0,xgrid),x0)
x.covariates = fit.CL.make.xmatrices(x.list)

###
### calculate then plot fitted curve on grid
###

mu.est = predict(fit.CL.obj, newdata = x.covariates)
matplot(xgrid, mu.est[,c(1,3,4)], ylim = c(0,1), lty = c(1,2,2),
        col = 'black',type = 'l', xlab = 'x',ylab = 'Predicted Curve')
legend('topleft',legend=c('Predicted Curve','95% Confidence Bounds'),
       lty=1:2,col='black')


###################################################
### code chunk number 15: CLmodelTutorial.Rnw:606-612
###################################################

h.func = function(p) {p[2]*(1-p[1]) + p[3]*p[1]}
hdev1 = function(p) {-p[2]+p[3]}
hdev2 = function(p) {1-p[1]}
hdev3 = function(p) {p[1]} 
h.prime.func = list(hdev1 = hdev1, hdev2 = hdev2, hdev3 = hdev3)


###################################################
### code chunk number 16: CLmodelTutorial.Rnw:617-621
###################################################

set.seed(543876)
n.sample = 1000
x.cop = runif(n.sample,-3,3)


###################################################
### code chunk number 17: CLmodelTutorial.Rnw:626-629
###################################################

x1 = rep(1,n.sample)
x.covariates = fit.CL.make.xmatrices(list(x1,x1,x1))


###################################################
### code chunk number 18: CLmodelTutorial.Rnw:639-648
###################################################

true.par = c(3,1,log(0.75/0.25),log(0.1/0.9))
parms = list(x.cop = x.cop, 
             x.covariates = x.covariates, 
             h.func = h.func, 
             h.prime.func = h.prime.func, 
             cop.flag = TRUE)
mu = fit.CL.fitted.values(true.par,parms)$mu
plot(x.cop, mu, ylim = c(0,1), xlab = 'x', ylab = 'Fitted Values')


###################################################
### code chunk number 19: CLmodelTutorial.Rnw:653-655
###################################################
ymat = fit.CL.sim.data(mu,1)
y = ymat[1,]


###################################################
### code chunk number 20: CLmodelTutorial.Rnw:664-666
###################################################
fit.CL.GOF.obj = fit.CL.GOF(y,x.cop)
fit.CL.GOF.obj


###################################################
### code chunk number 21: CLmodelTutorial.Rnw:679-729
###################################################

###
### Creat labels
###

est.labs = fit.CL.covariate.labels(c(1,1,1),cop.flag = TRUE)
est.labs

###
### Create matrix of linear combinations (labels can be introduced as row labels for this matrix)
###

linear.comb = matrix(c(0,0,-1,1),nrow = 1)
rownames(linear.comb) = c('b[3,1] - b[2,1]')

###
### Get initial estmate
###

init.obj = fit.CL.init(y,x.cop)
lodds = function(x) {log(x/(1-x))}
init.est = c(log(init.obj[1]), 
             init.obj[4], 
             lodds(init.obj[2]), 
             lodds(init.obj[3]))

###
### create \ttt{fit.CL} class object containing fit 
###

fit.CL.obj <- fit.CL(y = y,
                     x.cop = x.cop,
                     x.covariates = x.covariates,
                     group = NULL,
                     initial.estimate = init.est, 
                     h.func = h.func, 
                     h.prime.func  = h.prime.func,
                     cop.flag = TRUE, 
                     exchangeable = FALSE, 
                     quasi.lik = FALSE, 
                     lambda = 0.0, 
                     linear.comb = linear.comb, 
                     est.labs = est.labs, 
                     control = list(reltol = 1e-14))

###
### Fit summary
###

summary(fit.CL.obj)


###################################################
### code chunk number 22: CLmodelTutorial.Rnw:740-751
###################################################

library(CLmodel)
set.seed(543876)
n.sample = 1000
x.cop = runif(n.sample, -3, 3)

agei = runif(200, 20, 75)
agea = rep(agei,each = 5)
agec = agea - mean(agea)
sub.id = rep(1:200, each = 5)



###################################################
### code chunk number 23: CLmodelTutorial.Rnw:774-799
###################################################

###
### Model function
###

h.func = function(p) {p[2]*(1-p[1]) + p[3]*p[1]}
hdev1 = function(p) {-p[2]+p[3]}
hdev2 = function(p) {1-p[1]}
hdev3 = function(p) {p[1]} 
h.prime.func = list(hdev1 = hdev1, hdev2 = hdev2, hdev3 = hdev3)

###
### Format predictor variables
###

x1 = rep(1,n.sample)
x2 = agec
x.obj = fit.CL.make.xmatrices(list(cbind(x1,x2),cbind(x1,x2),cbind(x1,x2)))
est.labs = fit.CL.covariate.labels(c(2,2,2), cop.flag = TRUE)
parms = list(x.cop = x.cop, 
             x.covariates = x.obj, 
             h.func = h.func, 
             h.prime.func = h.prime.func, 
             group = sub.id, 
             cop.flag = TRUE)


###################################################
### code chunk number 24: CLmodelTutorial.Rnw:804-810
###################################################

true.par = c(1,0,1/25,log(0.75/0.25),0,log(0.25/0.75),-1/25)
rho = 0.1
mu = fit.CL.fitted.values(true.par,parms)$mu
ymat = fit.CL.sim.data(mu,1,sub.id,rho)
y = ymat[1,]


###################################################
### code chunk number 25: CLmodelTutorial.Rnw:815-817
###################################################

fit.CL.GOF(y, cbind(x.cop, agec), group = sub.id, nboot = 50)


###################################################
### code chunk number 26: CLmodelTutorial.Rnw:822-894
###################################################

init.obj = fit.CL.init(y,x.cop) 
init.est = c(log(init.obj[1]), 
             init.obj[4], 
             0, 
             lodds(init.obj[2]), 
             lodds(init.obj[3]), 0)

###
### Model assuming independent responses 
###

fit.CL.obj.u = fit.CL(y = y,
                      x.cop = x.cop,
                      x.covariates = x.obj,
                      group = sub.id,
                      initial.estimate = true.par, 
                      h.func = h.func, 
                      h.prime.func = h.prime.func, 
                      cop.flag = T, 
                      exchangeable = F, 
                      quasi.lik = F, 
                      lambda = 0.0, 
                      linear.comb = NULL, 
                      est.labs = est.labs, 
                      control = list(reltol = 1e-14))

summary(fit.CL.obj.u)

###
### Ordinary least squares fit. Estimates are constructed assuming 
### independence with standard errors incorporating the
### correlation model. 
###

fit.CL.obj.ex = fit.CL(y = y,
                       x.cop = x.cop,
                       x.covariates = x.obj,
                       group = sub.id,
                       initial.estimate = true.par, 
                       h.func = h.func, 
                       h.prime.func = h.prime.func, 
                       cop.flag = T, 
                       exchangeable = T, 
                       quasi.lik = F, 
                       lambda = 0.0, 
                       linear.comb = NULL, 
                       est.labs = est.labs, 
                       control = list(reltol = 1e-14))

summary(fit.CL.obj.ex)

###
### Quasilikelihood method. 
###

fit.CL.obj.ql = fit.CL(y = y,
                       x.cop = x.cop,
                       x.covariates = x.obj,
                       group = sub.id,
                       initial.estimate = true.par, 
                       h.func = h.func, 
                       h.prime.func = h.prime.func, 
                       cop.flag = T, 
                       exchangeable = T, 
                       quasi.lik = T, 
                       lambda = 0.0, 
                       linear.comb = NULL, 
                       est.labs = est.labs, 
                       control = list(reltol = 1e-14))

summary(fit.CL.obj.ql)


###################################################
### code chunk number 27: CLmodelTutorial.Rnw:907-946
###################################################

###
### Include only intercept terms in x.covariates object
###

x.obj = fit.CL.make.xmatrices(list(x1,x1,x1))
est.labs = fit.CL.covariate.labels(c(1,1,1), cop.flag = TRUE)

###
### reformat initial solution
###

lodds = function(x) {log(x/(1-x))}
true.par.000 = c(log(init.obj[1]), 
                 init.obj[4], 
                 lodds(init.obj[2]), 
                 lodds(init.obj[3]))

###
### Fit model without age covariate
###

fit.CL.obj.ql.000 = fit.CL(y = y,
                           x.cop = x.cop,
                           x.covariates = x.obj,
                           group = sub.id,
                           initial.estimate = true.par.000, 
                           h.func = h.func, 
                           h.prime.func = h.prime.func, 
                           cop.flag = T,
                           exchangeable = T, 
                           quasi.lik = T, 
                           lambda = 0.00, 
                           linear.comb = NULL,
                           est.labs = est.labs, 
                           control = list(reltol = 1e-14))


summary(fit.CL.obj.ql.000)


###################################################
### code chunk number 28: CLmodelTutorial.Rnw:959-986
###################################################

x.obj = fit.CL.make.xmatrices(list(cbind(x1,x2),cbind(x1,x2),cbind(x1,x2)))
est.labs = fit.CL.covariate.labels(c(2,2,2), cop.flag = TRUE)

lambda.list = seq(0,1,0.1)
fit.CL.cv.obj = fit.CL.cv(y = y,
                          x.cop = x.cop,
                          x.covariates = x.obj,
                          group = sub.id,
                          initial.estimate = true.par, 
                          h.func = h.func, 
                          h.prime.func = h.prime.func, 
                          cop.flag = T, 
                          exchangeable = T, 
                          quasi.lik = T,  
                          lambda = lambda.list, 
                          k.cv = 2, 
                          gof.score.type = 'dev',  
                          est.labs = est.labs, 
                          control = list(reltol = 1e-14))

###
### display table, and plot dev against lambda
###

fit.CL.cv.obj
plot(fit.CL.cv.obj$cv.table,type = 'b',xlab = 'lambda',ylab = 'dev')


