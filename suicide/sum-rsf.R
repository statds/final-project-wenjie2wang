#!/usr/bin/Rscript --vanilla


################################################################################
### summarizing results from random forest with random splits
### version controled by git
################################################################################


## enable checkpoint and source some utility functions
source("../docker/enable_checkpoint.R")
source("../simulation/simu-fun.R")
suppressMessages(library(randomForestSRC))

## define input directory
inDir <- "randomSplit-rsf"
inFiles <- list.files(inDir, "\\.RData")
idx <- order(as.numeric(sub("\\.RData", "", inFiles)))
inFiles <- inFiles[idx]
sum_rsf <- lapply(seq_along(inFiles), function(a) {
    load(file.path(inDir, inFiles[a]))
    tmp_fit <- eval(parse(text = paste0("fit", a)))
    tmp_pred <- eval(parse(text = paste0("pred", a)))
    c_index <- summarize_rsf(tmp_fit, tmp_pred)
    ## first order depth
    var_md <- max.subtree(tmp_fit, max.order = 0)$count
    ## sort by names
    var_md <- var_md[sort(names(var_md))]
    rm(list = c(paste0("fit", a), paste0("pred", a))); gc()
    list(c_index = c_index, var_md = var_md)
})

## outputs
outDir <- "sum_rdata"
if (! dir.exists(outDir)) dir.create(outDir)
save(sum_rsf, file = file.path(outDir, "sum_rsf.RData"))

## variable importance
load(file.path(outDir, "sum_rsf.RData"))
vimp_mat <- sapply(sum_rsf, function(a) a[[2L]])

md_score_sum <- sort(rowSums(vimp_mat), decreasing = TRUE)
head(md_score_sum, 30)
##       los    dx_E84    dx_305    dx_296    dx_969    dx_965    dx_311    dx_780
## 12.165083 11.270683 10.434813  9.771029  9.607609  8.737330  8.626841  7.985877
##    dx_300       age    dx_304    dx_301    dx_E85    dx_276    dx_303    dx_401
##  7.761547  7.325321  6.799875  6.633165  6.153369  6.092919  6.044547  5.960787
##    dx_309    dx_881    dx_V62    dx_E98    dx_518    dx_493      male    dx_292
##  5.419838  5.359971  5.160597  5.051067  4.961104  4.784875  4.330595  4.070347
##    dx_967    dx_980     white    dx_295    dx_250    dx_530
##  4.016022  3.888091  3.786988  3.591911  3.586157  3.552533

md_score_order <- apply(vimp_mat, 2L, function(a) {
    order(a, decreasing = TRUE) / length(a)
})
row.names(md_score_order) <- row.names(vimp_mat)
md_score_order_sum <- sort(rowSums(md_score_order),
                           decreasing = TRUE)
head(md_score_order_sum, 30)
##      age   dx_041   dx_296   dx_300   dx_293   dx_482   dx_292   dx_428
## 196.7193 167.6316 158.5614 139.6257 136.5614 132.5906 132.5614 127.1696
##   dx_301   dx_507   dx_491   dx_722   dx_535   dx_728   dx_710   dx_458
## 124.9708 124.6023 124.4503 124.1930 123.4269 122.3918 121.8713 121.7895
##   dx_427   dx_486   dx_707   dx_573   dx_496   dx_715   dx_578   dx_584
## 121.7193 120.6667 120.5439 119.8596 119.3918 118.7836 118.6550 118.0819
##   dx_599   dx_682   dx_719   dx_600   dx_714   dx_780
## 118.0468 117.9649 117.8889 117.4386 117.3333 116.4737
