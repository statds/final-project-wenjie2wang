################################################################################
### generates simulated data
### version controlled by git
################################################################################


source("simu-fun.R")

## output directory
outDir <- "simu-data"
if (! dir.exists(outDir)) dir.create(outDir)

## generate 1,000 simulated survival datasets with a cure fraction
set.seed(613)
for (i in seq_len(1e3)) {
    ## Consider 10 covariates for Cox model, only the first two of which have
    ## non-zero coefficients, one and two.  The cure layer follows logistics
    ## model and the average cure rate is 80%.
    coxMat <- matrix(runif(1e4, min = - 1), nrow = 1e3)
    coxCoef <- c(1, 2, rep(0, ncol(coxMat) - 2))
    cureMat <- cbind(runif(1e3), 1)
    cureCoef <- c(1, 1)
    ## using the function `simuData`
    simDat <- simuCureData(nSubject = 1e3, coxCoef = coxCoef, coxMat = coxMat,
                           cureMat = cureMat, cureCoef = cureCoef,
                           shape = 1.5, scale = 0.01)
    ## remove intercept term
    simDat$z2 <- NULL
    ## save simulated data as csv files
    write.table(simDat, file = file.path(outDir, paste0(i, ".csv")),
                sep = ",", row.names = FALSE)
}


## some quick tests
## library(survival)
## plot(survfit(Surv(obsTime, status) ~ 1, simDat))
