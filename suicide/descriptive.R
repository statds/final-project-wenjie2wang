## check the distribution of censoring time
inDir <- "../cleanData"
suicide <- read.csv(file.path(inDir, "suicide.csv"))

## descriptive analysis on survival time and censoring time
library(survival)
fm <- Surv(Time / 360, Event) ~ 1
kmList <- survfit(fm, suicide)
kmDat <- data.frame(unclass(kmList)[c("time", "surv", "upper", "lower")])

library(ggplot2)

outDir <- "../figs"
if (! dir.exists(outDir)) dir.create(outDir)

p <- ggplot(kmDat, aes(x = time, y = surv)) +
    geom_line() +
    geom_line(aes(y = upper), linetype = 2) +
    geom_line(aes(y = lower), linetype = 2) +
    xlab("Years") + ylab("Kaplan-Meier Estimates") +
    ylim(c(0.94, 1)) + theme_bw()

ggsave(file.path(outDir, "suicide-kmcurve.pdf"), p,
       width = 7, height = 5)
ggsave(file.path("../docs/www/imgs", "suicide-kmcurve.png"), p,
       width = 7, height = 5)
