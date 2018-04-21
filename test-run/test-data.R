#!/usr/bin/Rscript --vanilla


################################################################################
### generates simulated data for testing
### version controlled by git
################################################################################


source("../simulation/simu-fun.R")

## output directory
outDir <- "test-data"
if (! dir.exists(outDir)) dir.create(outDir)

## generate two simulated survival datasets with a cure fraction
nSub <- 100
set.seed(1216)
for (i in seq_len(3)) {
    ## Consider 10 covariates for Cox model, only the first two of which have
    ## non-zero coefficients, one and two.  The cure layer follows logistics
    ## model and the average cure rate is 80%.
    coxMat <- matrix(runif(5 * nSub, min = - 1), nrow = nSub)
    coxCoef <- c(1, 2, rep(0, ncol(coxMat) - 2))
    cureMat <- cbind(runif(nSub), 1)
    cureCoef <- c(1, 1)
    ## using the function `simuData`
    simDat <- simuCureData(nSubject = nSub, coxCoef = coxCoef, coxMat = coxMat,
                           cureMat = cureMat, cureCoef = cureCoef,
                           shape = 1.5, scale = 0.01)
    ## remove intercept term
    simDat$z2 <- NULL
    ## save simulated data as csv files
    write.table(simDat, file = file.path(outDir, paste0(i, ".csv")),
                sep = ",", row.names = FALSE)
}
