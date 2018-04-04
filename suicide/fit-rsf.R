#!/usr/bin/Rscript --vanilla


################################################################################
### fitting random survival forest for suicide data
### version controlled by git
################################################################################


## source functions and packages
library(methods)
source("../simulation/simu-fun.R")
need.packages("randomForestSRC")

## read in simulated datasets as the train data and the test data
inDir <- "../cleanData"
trainDat <- read.csv(file.path(inDir, "train_suicide.csv"))
testDat <- read.csv(file.path(inDir, "test_suicide.csv"))

## fitting random survival forest model
fit_rsf <- rfsrc(Surv(Time, Event) ~ ., data = trainDat, importance = TRUE)
pred_rsf <- predict.rfsrc(fit_rsf, newdata = testDat, outcome = "test")

## save as RData files
outDir <- "fits"
if (! dir.exists(outDir)) dir.create(outDir)
save(fit_rsf, pred_rsf, file = file.path(outDir, "fit-rsf.RData"))
