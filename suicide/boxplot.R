#!/usr/bin/Rscript --vanilla


################################################################################
### visualizing c-statistic with boxplots
### version controled by git
################################################################################


## enable checkpoing
source("../docker/enable_checkpoint.R")
library(ggplot2)

sum_rsf <- readRDS("sum_rdata/sum_rsf.rds")
load("sum_rdata/sum_deepSurv.RData")
sum_deepSurv <- t(sum_deepSurv)

ggDat <- rbind(data.frame(sum_rsf, model = "RSF"),
               data.frame(sum_deepSurv, model = "DeepSurv"))

library(gridExtra)
p1 <- ggplot(ggDat) +
    geom_boxplot(aes(y = train_cStat, x = model)) +
    ylab("Training C-index") + xlab("Model") + theme_bw()
p2 <- ggplot(ggDat) +
    geom_boxplot(aes(y = test_cStat, x = model)) +
    ylab("Testing C-index") + xlab("Model") + theme_bw()
p <- grid.arrange(p1, p2, ncol = 2)

## save as png for slides
ggsave("../docs/www/img/boxplot_c-index.png", p, width = 7, heigh = 4.5)

## save as pdf for report
ggsave("../figs/boxplot_c-index.pdf", p, width = 7, heigh = 4.5)
