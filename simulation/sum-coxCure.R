################################################################################
### summarizes the simulation results from random survival forest model
### version controlled by git
################################################################################


## source
source("simu-fun.R")

## inputs
inDir <- "fit-coxCure"
inFiles <- list.files(inDir, "\\.RData$")
idx <- order(as.numeric(sub("\\.RData", "", inFiles)))
inFiles <- inFiles[idx]

sum_coxCure <- lapply(seq_along(inFiles), function(a) {
    load(file.path(inDir, inFiles[a]))
    beta <- eval(parse(text = paste0("fit", a)))[["beta"]]
    ## c-statistic from the training set
    dat <- read.csv(paste0("simu-data/", a, ".csv"))
    riskVec <- as.matrix(dat[, paste0("x", seq_len(2))]) %*% beta
    train_res <- with(dat, harrel_cure(Time, Event, riskVec))
    ## c-statistic from the testing set
    b <- ifelse(a == 1, 1000, a - 1)
    dat <- read.csv(paste0("simu-data/", b, ".csv"))
    riskVec <- as.matrix(dat[, paste0("x", seq_len(2))]) %*% beta
    test_res <- with(dat, harrel_cure(Time, Event, riskVec))
    rm(list = c(paste0("fit", a), "dat")); gc()
    list(train_res = train_res, test_res = test_res)
})

## outputs
outDir <- "sum_rdata"
if (! dir.exists(outDir)) dir.create(outDir)
save(sum_coxCure, file = file.path(outDir, "sum_coxCure.RData"))
