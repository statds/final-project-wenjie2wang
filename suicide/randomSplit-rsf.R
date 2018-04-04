################################################################################
### fitting random survival forest for suicide data
### version controlled by git
################################################################################


## read in arguments
inArgs <- commandArgs(trailingOnly = TRUE)
id <- as.integer(inArgs[1L])

## source functions and packages
library(methods)
source("../simulation/simu-fun.R")
need.packages("randomForestSRC")

## read in simulated datasets as the train data and the test data
inDir <- "../randomSplit"
trainDat <- read.csv(file.path(inDir, paste0("train_", id, ".csv")))
testDat <- read.csv(file.path(inDir, paste0("test_", id, ".csv")))
oneFit <- rfsrc(Surv(Time, Event) ~ ., data = trainDat, importance = FALSE)
pred <- predict.rfsrc(oneFit, newdata = testDat, outcome = "test")

## Define output names
outObjName <- paste0("fit", id)
predObjName <- paste0("pred", id)
assign(outObjName, oneFit)
assign(predObjName, pred)

## save as RData files
outDir <- "randomSplit-rsf"
if (! dir.exists(outDir)) dir.create(outDir)
save(list = c(outObjName, predObjName),
     file = file.path(outDir, paste0(id, ".RData")))
