################################################################################
### Testing model fitting with Cox cure model
### version controlled by git
################################################################################


## read in arguments
inArgs <- commandArgs(trailingOnly = TRUE)
trainID <- as.integer(inArgs[1L])

## source functions and packages
source("../docker/enable_checkpoint.R")
library(methods)
source("../simulation/simu-fun.R")
library("smcure")
## packageVersion("smcure")

## read in simulated datasets as the train data and the test data
testID <- ifelse(trainID == 1L, 2L, trainID - 1L)

inDir <- "test-data"
trainDat <- read.csv(file.path(inDir, paste0(trainID, ".csv")))
## testDat <- read.csv(file.path(inDir, paste0(testID, ".csv")))
oneFit <- smcure(Surv(Time, Event) ~ x1 + x2, cureform = ~ z1,
                 data = trainDat, model = "ph", Var = FALSE)

## define output names
outObjName <- paste0("test", trainID)
assign(outObjName, oneFit)

## save as RData files
outDir <- "test-coxCure"
if (! dir.exists(outDir)) dir.create(outDir)
save(list = outObjName,
     file = file.path(outDir, paste0(trainID, ".RData")))
