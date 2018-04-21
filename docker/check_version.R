#!/usr/bin/Rscript --vanilla

### check the version of R packages
source("enable_checkpoint.R")

version_dat <- as.data.frame(installed.packages(lib.loc = .libPaths()[1]))
res_dat <- base::subset(version_dat, select = c("Package", "Version"))
row.names(res_dat) <- NULL
res_dat
