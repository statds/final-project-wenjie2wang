################################################################################
### pre-process the clean data for model fitting
################################################################################


## input directory
inDir <- "../cleanData"
load(file.path(inDir, "dis.RData"))

## data from fiscal year 2005 to 2012
## from 2004/10/01 to 2012/09/30
summary(dis$dod)
summary(as.numeric(dis$dod - dis$adat))
cutoff_date <- as.Date("2012-09-30", format = "%F")

## create observed event or censoring times
dis$Time <- with(dis, ifelse(is.na(dod),
                             as.numeric(cutoff_date - adat),
                             as.numeric(dod - adat)))
dis$Event <- ifelse(is.na(dis$dod), 0, 1)

## propare for the covariates
## create dummy variables for categorical covariates
dis$male <- ifelse(dis$sex == "M", 1, 0)

## create white variable for the Whites
xtabs(~ race + race6, data = dis)
xtabs(~ race6 + Event, data = dis)
levels(dis$race6)
dis$white <- ifelse(dis$race6 %in% "white", 1, 0)

## covariates' pool
dx3_vec <- colnames(dis)[grepl("dx_[0-9EV]*[0-9]$", colnames(dis))]
cov_vec <- c("Time", "Event", "age", "male", "white", "los", dx3_vec)
dat <- dis[, cov_vec]

## output csv file for fitting
write.table(dat, file = file.path(inDir, "suicide.csv"),
            sep = ",", row.names = FALSE)

## one training dataset and one testing dataset
set.seed(123)
test_ratio <- 0.3
nSample <- nrow(dat)
nTest <- floor(nSample * test_ratio)
idx <- sample(nSample, nTest)
test_dat <- dat[idx, ]
train_dat <- dat[- idx, ]
stopifnot(sum(train_dat$Event) > 0 && sum(test_dat$Event) > 0)
write.table(train_dat, sep = ",", row.names = FALSE,
            file = file.path(inDir, "train_suicide.csv"))
write.table(test_dat, sep = ",", row.names = FALSE,
            file = file.path(inDir, "test_suicide.csv"))


## random splitting and output csv files
outDir <- "../randomSplit"
if (! dir.exists(outDir)) dir.create(outDir)

set.seed(1216)
test_ratio <- 0.3
nSample <- nrow(dat)
nTest <- floor(nSample * test_ratio)
i <- 1

while (i <= 200) {
    idx <- sample(nSample, nTest)
    test_dat <- dat[idx, ]
    train_dat <- dat[- idx, ]
    if (sum(train_dat$Event) > 0 && sum(test_dat$Event) > 0) {
        write.table(train_dat, sep = ",", row.names = FALSE,
                    file = file.path(outDir, paste0("train_", i, ".csv")))
        write.table(test_dat, sep = ",", row.names = FALSE,
                    file = file.path(outDir, paste0("test_", i, ".csv")))
        i <- i + 1
    }
}


## try finer dx codes later

## dx_all <- unique(c(trimws(
##     as.character(as.matrix(dis[, paste0("dx", seq_len(10))]))
## )))

## gen_dx <- function()
