################################################################################
### fitting Cox cure model as oracle procedure for reference
### version controlled by git
################################################################################


## read in arguments
inArgs <- commandArgs(trailingOnly = TRUE)
trainID <- as.integer(inArgs[1L])

## source functions and packages
library(methods)
source("simu-fun.R")
library("smcure")

## read in simulated datasets as the train data and the test data
## testID <- ifelse(trainID == 1L, 1000L, trainID - 1L)

inDir <- "simu-data"
trainDat <- read.csv(file.path(inDir, paste0(trainID, ".csv")))
## testDat <- read.csv(file.path(inDir, paste0(testID, ".csv")))
oneFit <- smcure(Surv(Time, Event) ~ x1 + x2, cureform = ~ z2,
                 data = trainDat, model = "ph", Var = FALSE)

## define output names
outObjName <- paste0("fit", trainID)
assign(outObjName, oneFit)

## save as RData files
outDir <- "fit-coxCure"
if (! dir.exists(outDir)) dir.create(outDir)
save(list = outObjName,
     file = file.path(outDir, paste0(trainID, ".RData")))
