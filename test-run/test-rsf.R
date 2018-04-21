################################################################################
### testing model fitting with random survival forest
### version controlled by git
################################################################################


## read in arguments
inArgs <- commandArgs(trailingOnly = TRUE)
trainID <- as.integer(inArgs[1L])

## source functions and packages
source("../docker/enable_checkpoint.R")
library(methods)
source("../simulation/simu-fun.R")
suppressMessages(library("randomForestSRC"))

## read in simulated datasets as the train data and the test data
testID <- ifelse(trainID == 1L, 2L, trainID - 1L)

inDir <- "test-data"
trainDat <- read.csv(file.path(inDir, paste0(trainID, ".csv")))
testDat <- read.csv(file.path(inDir, paste0(testID, ".csv")))
oneFit <- rfsrc(Surv(Time, Event) ~ ., data = trainDat, importance = TRUE)
pred <- predict.rfsrc(oneFit, newdata = testDat, outcome = "test")

## define output names
outObjName <- paste0("fit", trainID)
predObjName <- paste0("pred", trainID)
assign(outObjName, oneFit)
assign(predObjName, pred)

## save as RData files
outDir <- "test-rsf"
if (! dir.exists(outDir)) dir.create(outDir)
save(list = c(outObjName, predObjName),
     file = file.path(outDir, paste0(trainID, ".RData")))
