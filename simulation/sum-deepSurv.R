################################################################################
### summarizes the simulation results from DeepSurv model
### version controlled by git
################################################################################


inDir <- "fit-deepSurv"
csv_files <- list.files(inDir, "\\.csv$")

sum_deepSurv <- sapply(seq_along(csv_files), function(i) {
    unlist(read.csv(file.path(inDir, csv_files[i])))
})

## outputs
outDir <- "sum_rdata"
if (! dir.exists(outDir)) dir.create(outDir)
save(sum_deepSurv, file = file.path(outDir, "sum_deepSurv.RData"))
