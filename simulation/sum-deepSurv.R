################################################################################
### summarizes the simulation results from DeepSurv model
### version controlled by git
################################################################################


inDir <- "fit-deepSurv"
csv_files <- list.files(inDir, "\\.csv$")

res <- sapply(seq_along(csv_files), function(i) {
    tmpDat <- read.csv(file.path(inDir, csv_files[i]))
    unlist(tmpDat)
})
rowMeans(res)
