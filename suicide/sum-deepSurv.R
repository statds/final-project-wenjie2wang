#!/usr/bin/Rscript --vanilla


################################################################################
### summarize c-index from random splits for deepSurv model
### version controled by git
################################################################################


inDir <- "randomSplit-deepSurv"
csv_files <- list.files(inDir, "\\.csv$")

sum_deepSurv <- sapply(seq_along(csv_files), function(i) {
    unlist(read.csv(file.path(inDir, csv_files[i])))
})

## outputs
outDir <- "sum_rdata"
if (! dir.exists(outDir)) dir.create(outDir)
save(sum_deepSurv, file = file.path(outDir, "sum_deepSurv.RData"))
