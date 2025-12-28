
#' Box Cox Transformation
#'
#' BoxCox() returns a transformation of the input variable using a Box-Cox
#' transformation. InvBoxCox() reverses the transformation.
#'
#' The Box-Cox transformation is given by
#' \deqn{f_{\lambda}(x) =\frac{x^{\lambda} - 1}{\lambda}}{f(x;lambda) = (x^lambda - 1)/lambda}
#' if \eqn{\lambda\ne0}{lambda is not equal to 0}. For \eqn{\lambda=0}{lambda=0},
#' \deqn{f_0(x) = \log(x).}{f(x;0) = log(x).}
#'
#' @aliases BoxCox InvBoxCox
#' @param x a numeric vector or time series
#' @param lambda transformation parameter
#' @return a numeric vector of the same length as x.
#' @author Rob J Hyndman
#' @references Box, G. E. P. and Cox, D. R. (1964) An analysis of
#' transformations. *JRSS B* **26** 211--246.
#' @keywords math
#' @export BoxCox
BoxCox <- function(x, lambda) {
  if (is.list(x)) {
    x <- x[[1]]
  }
  if (lambda == 0) {
    log(x)
  } else {
    (x^lambda - 1) / lambda
  }
}
InvBoxCox <- function(x, lambda) {
  if (is.list(x)) {
    x <- x[[1]]
  }
  if (lambda == 0) {
    exp(x)
  } else {
    (x * lambda + 1)^(1 / lambda)
  }
}

all_roots <- function(
  f,
  interval,
  lower = min(interval),
  upper = max(interval),
  n = 100L,
  ...
) {
  x <- seq(lower, upper, len = n + 1L)
  fx <- f(x, ...)
  roots <- x[which(fx == 0)]
  fx2 <- fx[seq(n)] * fx[seq(2L, n + 1L, by = 1L)]
  index <- which(fx2 < 0)
  for (i in index) {
    roots <- c(roots, uniroot(f, lower = x[i], upper = x[i + 1L], ...)$root)
  }
  return(sort(roots))
}

# Transformed density estimate

tdensity <- function(x, bw = "SJ", lambda = 1) {
  if (is.list(x)) {
    x <- x[[1]]
  }
  if (lambda == 1) {
    return(density(x, bw = bw, n = 1001))
  } else if (lambda < 0 | lambda > 1) {
    stop("lambda must be in [0,1]")
  }
  # Proceed with a Box-Cox transformed density
  y <- BoxCox(x, lambda)
  g <- density(y, bw = bw, n = 1001)
  j <- g$x > 0.1 - 1 / lambda # Stay away from the edge
  g$y <- g$y[j]
  g$x <- g$x[j]
  xgrid <- InvBoxCox(g$x, lambda) # x
  g$y <- c(0, g$y * xgrid^(lambda - 1))
  g$x <- c(0, xgrid)
  return(g)
}

show4 <- function(x) {
  formatC(x, digits = 4, format = "fg", flag = "#")
}

print_intervals <- function(x) {
  intervals <- matrix(x, ncol = 2, byrow = TRUE)
  for (j in seq_len(nrow(intervals))) {
    cat(paste0(" [", show4(intervals[j,1]), ", ", show4(intervals[j,2]), "]"))
    cat(ifelse(j < nrow(intervals), ",", "\n"))
  }
}
