################################################################################
### a collection of functions that help simulation studies
### version controlled by git
################################################################################


##' Generate Simulated Survival Data
##'
##' The function generates survival data with exact event times and
##' right-censoring time.  The event times can be simulated from Gompertz
##' distribution, Weibull distribution, and exponential distribution as a
##' special case of Weibull distribution (\code{shape = 1}).  Censoring times
##' are generated from uniform distribution.
##'
##' @param nSubject Number of subjects.
##' @param coxCoef Time-invariant covariate coefficients for Cox model.
##' @param coxMat Design matrix for Cox model.
##' @param cureCoef Time-invariant covariate coefficients for cure fraction.
##' @param cureMat Design matrix for cure fraction.
##' @param censorMin A non-negative number, lower bound of uniform
##'     distribution for censoring times.
##' @param censorMax A positive number, upper bound of uniform distribution
##'     for censoring times.
##' @param shape A positive number, shape parameter in baseline hazard
##'     function for event times.
##' @param scale A positive number, scale parameter in baseline hazard
##'     function for event times.
##' @param type Distribution name of event times. Partial matching is allowed.
##' @return A data frame.
##' @author Wenjie Wang
##' @references
##' Bender, R., Augustin, T., & Blettner, M. (2005).
##' Generating survival times to simulate Cox proportional hazards models.
##' \emph{Statistics in Medicine}, 24(11), 1713--1723.
##' @examples
##' coxMat <- matrix(runif(1e3), nrow = 100)
##' simDat <- simuCureData(100, coxCoef = c(1, 1, rep(0, 8)), coxMat = coxMat,
##'                        cureCoef = c(0, 0, 1, 1, rep(0, 6)))
##' str(simDat)
simuCureData <- function(nSubject = 1e3,
                         coxCoef, coxMat,
                         cureCoef, cureMat = coxMat,
                         censorMin = 0, censorMax = 10,
                         shape = 1, scale = 0.01,
                         type = c("weibull", "gompertz"), ...)
{
    ## internal functions
    ## similar function with eha::rgompertz, where param == "canonical"
    rGompertz <- function(n, shape = 1, scale = 1, ...) {
        u <- runif(n)
        1 / shape * log1p(- shape * log1p(- u) / (scale * shape))
    }
    ## similar function with stats::rweibull but with different parametrization
    ## reduces to exponential distribution when shape == 1
    rWeibull <- function(n, shape = 1, scale = 1, ...) {
        u <- runif(n)
        (- log1p(- u) / scale) ^ (1 / shape)
    }

    ## generate cure indicator for each subject based on logistics model.
    cure_p <- 1 / (1 + exp(- as.numeric(cureMat %*% cureCoef)))
    cure_ind <- rbinom(nSubject, size = 1, prob = cure_p) < 1
    num_risk_subjects <- sum(! cure_ind)
    ## censoring times
    censorTime <- runif(n = nSubject, min = censorMin, max = censorMax)
    ## event times
    expXbeta <- as.numeric(exp(coxMat %*% coxCoef))
    type <- match.arg(type)
    eventTime <- if (type == "gompertz")
                     rGompertz(nSubject, shape, scale * expXbeta)
                 else
                     rWeibull(nSubject, shape, scale * expXbeta)
    ## event indicator
    status <- as.integer(eventTime < censorTime & ! cure_ind)
    ## observed times
    obsTime <- ifelse(status, eventTime, censorTime)
    ## prepare covariate data
    colnames(coxMat) <- paste0("x", seq_len(ncol(coxMat)))
    if (missing(cureMat)) {
        cureMat <- NULL
    } else {
        colnames(cureMat) <- paste0("z", seq_len(ncol(cureMat)))
    }
    ## return
    data.frame(cbind(Time = obsTime, Event = status, coxMat, cureMat))
}


##' Check, Install and Attach Multiple R packages Specified
##'
##' The function first Checks whether the packages given were installed. Then
##' install them if they are not, then attach them to the search path.
##'
##' @usage need.packages(pkg)
##' @param pkg A character vector specifying the packages needed to reproduce
##'     this document.
##' @param ... Other arguments passed to function \code{\link[base]require}.
##' @return NULL invisibly.
##' @examples
##' need.pacakges(c("ggplot2", "geepack"))
need.packages <- function(pkg, ...)
{
    new.pkg <- pkg[! (pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
        install.packages(new.pkg, repos = "https://cloud.r-project.org")
    foo <- function(a, ...) suppressMessages(require(a, ...))
    sapply(pkg, foo, character.only = TRUE)
    invisible(NULL)
}


##' Summarize Simulation Outputs from Random Survival Forest Model
summarize_rsf <- function(fit, pred)
{
    nTree <- fit$ntree
    c(train_cStat = 1 - fit$err.rate[nTree],
      test_cStat = 1 - pred$err.rate[nTree])
}


##' Harrel's c-statistics for cure model
##'
##' This function computes the Harrel's c-statistics for cure model proposed by
##' Asano and Hirakawa (2017).
##'
##' @param time event times or censoring times.
##' @param status event indicators.
##' @param risk estimated risk score from the fitted model.
##' @param cure estimated cure probability from the fitted model.
##'
##' @references
##'
##' Asano, J., & Hirakawa, A. (2017). Assessing the prediction accuracy of a
##' cure model for censored survival data with long-term survivors: Application
##' to breast cancer data. \emph{Journal of biopharmaceutical statistics},
##' 27(6), 918--932.
##'
harrel_cure <- function(time, status, riskScore, cureScore = NULL, ...)
{
    ## sort all the input vectors by time increasingly
    sortIdx <- order(time)
    y <- time[sortIdx]
    delta <- status[sortIdx]
    srisk <- riskScore[sortIdx]
    scure <- if (is.null(cureScore))
                 Inf
             else
                 cureScore[sortIdx]
    prob_cure <- ifelse(delta > 0, 1, quasibinomial()[["linkinv"]](scure))
    numSub <- length(y)
    seq_numSub <- seq_len(numSub)
    idx <- which(delta > 0)
    ## for each event, find its comparable pair
    numComparable <- numConcordant <- numTied <- tiedTime <- 0
    for (i in idx) {
        tmpIdx <- seq_numSub[- seq_len(i)]
        noTiedTime <- y[tmpIdx] > y[i] | delta[tmpIdx] == 0
        ## incomparable pairs
        tiedTime <- tiedTime + sum(y[tmpIdx] == y[i] & delta[tmpIdx] == 1)
        numComparable <- numComparable + sum(noTiedTime * prob_cure[tmpIdx])
        idx1 <- srisk[tmpIdx] < srisk[i]
        idx2 <- srisk[tmpIdx] == srisk[i]
        numConcordant <- numConcordant + sum(idx1 * noTiedTime * prob_cure[tmpIdx])
        numTied <- numTied + sum(idx2 * prob_cure[tmpIdx])
    }
    setNames(c((numConcordant + numTied / 2) / numComparable,
               numComparable, numConcordant, numTied, tiedTime),
             c("cScore", "comparable", "concordant",
               "tiedRisk", "tiedTime"))
}
