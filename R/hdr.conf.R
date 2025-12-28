#' HDRs with confidence intervals
#'
#' Calculates Highest Density Regions with confidence intervals.
#'
#'
#' @param x Numeric vector containing data.
#' @param den Density of data as list with components `x` and `y`.
#' @param prob Probability coverage for for HDRs.
#' @param conf Confidence for limits on HDR.
#' @return `hdrconf` returns list containing the following components:
#' \item{hdr}{Highest density regions} \item{hdr.lo}{Highest density regions
#' corresponding to lower confidence limit.} \item{hdr.hi}{Highest density
#' regions corresponding to upper confidence limit.} \item{falpha}{Values of
#' \eqn{f_\alpha}{f[alpha]} corresponding to HDRs.} \item{falpha.ci}{Values of
#' \eqn{f_\alpha}{f[alpha]} corresponding to lower and upper limits.}
#' @author Rob J Hyndman
#' @seealso [hdr()], [plot.hdrconf()]
#' @references Hyndman, R.J. (1996) Computing and graphing highest density
#' regions *American Statistician*, **50**, 120-126.
#' @keywords smooth distribution
#' @examples
#' x <- c(rnorm(100, 0, 1), rnorm(100, 4, 1))
#' den <- density(x, bw = hdrbw(x, 50))
#' hdr_conf <- hdrconf(x, den)
#' plot(hdr_conf, den, main = "50% HDR with 95% CI")
#' @export hdrconf
hdrconf <- function(x, den, prob = 0.9, conf = 0.95) {
  # Returns hdr with confidence limits
  # Assumes x is a sorted sample from the density den.
  if (any(prob > 1)) {
    prob <- prob / 100
  }
  if (any(conf > 1)) {
    conf <- conf / 100
  }
  alpha <- 1 - prob
  info <- calc.falpha(x, den, alpha)
  hdr <- hdr.ends(den, info$falpha)$hdr
  nint <- length(hdr)
  delta <- range(x) / 1000
  f2 <- approx(den$x, den$y, hdr + delta)$y
  fprime <- (f2 - info$falpha) / delta
  g <- info$falpha * sum(abs(1 / fprime))
  var.falpha <- alpha * (1 - alpha) / (length(x) * g * g)
  z <- abs(qnorm(0.5 - conf / 2))
  falpha.ci <- z * sqrt(var.falpha)
  falpha.ci <- info$falpha + c(-falpha.ci, falpha.ci)
  if (falpha.ci[1] < 0) {
    hdr1 <- c(NA, NA)
  } else {
    hdr1 <- hdr.ends(den, falpha.ci[1])$hdr
  }
  if (falpha.ci[2] < 0) {
    hdr2 <- c(NA, NA)
  } else {
    hdr2 <- hdr.ends(den, falpha.ci[2])$hdr
  }
  return(structure(
    list(
      hdr = hdr,
      hdr.lo = hdr1,
      hdr.hi = hdr2,
      falpha = info$falpha,
      falpha.ci = falpha.ci,
      prob = prob,
      conf = conf
    ),
    class = "hdrconf"
  ))
}

#' @export
print.hdrconf <- function(x, ...) {
  cat(paste0(x$prob * 100, "%"), "Highest Density Region:")
  print_intervals(x$hdr)
  cat(paste0("           ", x$conf * 100, "%"), "Lower Limit:")
  print_intervals(x$hdr.lo)
  cat(paste0("           ", x$conf * 100, "%"), "Upper Limit:")
  print_intervals(x$hdr.hi)
  cat("\nf-alpha value: ")
  cat(show4(x$falpha))
  cat(paste0("   ", x$conf * 100, "% CI:"))
  print_intervals(x$falpha.ci)
}
