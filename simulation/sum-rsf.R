################################################################################
### summarizes the simulation results from random survival forest model
### version controlled by git
################################################################################


## source
source("simu-fun.R")

## inputs
inDir <- "fit-rsf"
inFiles <- list.files(inDir, "\\.RData$")
idx <- order(as.numeric(sub("\\.RData", "", inFiles)))
inFiles <- inFiles[idx]
sum_rsf <- sapply(seq_along(inFiles), function(a) {
    load(file.path(inDir, inFiles[a]))
    out <- summarize_rsf(eval(parse(text = paste0("fit", a))),
                         eval(parse(text = paste0("pred", a))))
    rm(list = c(paste0("fit", a), paste0("pred", a))); gc()
    out
})

## outputs
outDir <- "sum_rdata"
if (! dir.exists(outDir)) dir.create(outDir)
save(sum_rsf, file = file.path(outDir, "sum_rsf.RData"))
