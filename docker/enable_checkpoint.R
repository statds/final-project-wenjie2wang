#!/usr/bin/Rscript --vanilla


## define snapshot date
snapshot_date = "2018-04-13"

## install checkpoint v0.4.3 if not installed
if (! suppressWarnings(require(checkpoint, quietly = TRUE)) ||
    packageVersion("checkpoint") != "0.4.3") {
    ## specify the checkpoint package version
    checkpoint_version <- "checkpoint_0.4.3.tar.gz"

    ## two possible urls of the source package of the specified version
    mirror_url <- "https://cloud.r-project.org"
    url1 <- file.path(mirror_url, "src/contrib", checkpoint_version)
    url2 <- file.path(mirror_url, "src/contrib/Archive/checkpoint",
                      checkpoint_version)

    ## try to install from the first url
    try1 <- tryCatch({
        install.packages(url1, repos = NULL, type = "source")
    }, warning = function(w) w, error = function(e) e)

    ## if any error or warning, then try the second url
    if (any(c("warning", "error") %in% class(try1))) {
        try2 <- tryCatch({
            install.packages(url2, repos = NULL, type = "source")
        }, warning = function(w) w, error = function(e) e)
        ## if the second url also fails, install the lastest version
        if (any(c("warning", "error") %in% class(try2))) {
            install.packages("checkpoint", repos = mirro_url)
        }
    }
    message(sprintf("\nInstalled checkpoint version %s\n",
                    packageVersion("checkpoint")))

    ## enable checkpoint the first time
    checkpoint::checkpoint(snapshotDate = snapshot_date, R.version = "3.4.4",
                           use.knitr = TRUE, scan.rnw.with.knitr = TRUE)

} else {
    ## for later usage
    checkpoint::checkpoint(snapshotDate = snapshot_date, R.version = "3.4.4",
                           scanForPackages = FALSE, auto.install.knitr = FALSE)
}
