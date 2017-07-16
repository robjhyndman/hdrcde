#' Nonparametric Multimodal Regression
#' 
#' Nonparametric multi-valued regression based on the modes of conditional
#' density estimates.
#' 
#' Computes multi-modal nonparametric regression curves based on the maxima of
#' conditional density estimates. The tool for the estimation is the
#' conditional mean shift as outlined in Einbeck and Tutz (2006).  Estimates of
#' the conditional modes might fluctuate highly if \code{deg=1}.  Hence,
#' \code{deg=0} is recommended. For bandwidth selection, the hybrid rule
#' introduced by Bashtannyk and Hyndman (2001) is employed if \code{deg=0}.
#' This corresponds to the setting \code{method=1} in function
#' \code{cde.bandwidths}. For \code{deg=1} automatic bandwidth selection is not
#' supported.
#' 
#' @param x Numerical vector: the conditioning variable.
#' @param y Numerical vector: the response variable.
#' @param xfix Numerical vector corresponding to the input values of which the
#' fitted values shall be calculated.
#' @param a Optional bandwidth in \eqn{x}-direction.
#' @param b Optional bandwidth in \eqn{y}-direction.
#' @param deg Degree of local polynomial used in estimation (0 or 1).
#' @param iter Positive integer giving the number of mean shift iterations per
#' point and branch.
#' @param P Maximal number of branches.
#' @param start Character determining how the starting points are selected.
#' \code{"q"}: proportional to quantiles; \code{"e"}: equidistant; \code{"r"}:
#' random.  All, \code{"q"}, \code{"e"}, and \code{"r"}, give starting points
#' which are constant over \code{x}.  As an alternative, the choice \code{"v"}
#' gives variable starting points, which are equal to \code{"q"} for the
#' smallest \code{x}, and equal to the previously fitted values for all
#' subsequent \code{x}.
#' @param prun Boolean. If TRUE, parts of branches are dismissed (in the
#' plotted output) where their associated kernel density value falls below the
#' threshold \code{1/(prun.const*(max(x)-min(x))*(max(y)-min(y)))}.
#' @param prun.const Numerical value giving the constant used above (the
#' higher, the less pruning)
#' @param plot.type Vector with two elements. The first one is
#' character-valued, with possible values \code{"p"}, \code{"l"}, and
#' \code{"n"}.  If equal to \code{"n"}, no plotted output is given at all. If
#' equal to \code{"p"}, fitted curves are symbolized as points in the graphical
#' output, otherwise as lines.  The second vector component is a numerical
#' value either being 0 or 1. If 1, the position of the starting points is
#' depicted in the plot, otherwise omitted.
#' @param labels Vector of three character strings.  The first one is the
#' "main" title of the graphical output, the second one is the label of the
#' \eqn{x} axis, and the third one the label of the \eqn{y} axis.
#' @param pch Plotting character. The default corresponds to small bullets.
#' @param \dots Other arguments passed to \code{\link{cde.bandwidths}}.
#' @return A list with the following components: \item{xfix}{Grid of predictor
#' values at which the fitted values are calculated.} \item{fitted.values}{A
#' \code{[P x length(xfix)]}- matrix with fitted j-th branch in the j-th row
#' (\eqn{1 \le j \le P}{1 <=j <=P}) } \item{bandwidths}{A vector with
#' bandwidths \code{a} and \code{b}.} \item{density}{A \code{[P x
#' length(xfix)]}- matrix with estimated kernel densities. This will only be
#' computed if \code{prun=TRUE}.} \item{threshold}{The pruning threshold.}
#' @author Jochen Einbeck (2007)
#' @seealso \code{\link{cde.bandwidths}}
#' @references Einbeck, J., and Tutz, G. (2006) "Modelling beyond regression
#' functions: an application of multimodal regression to speed-flow data".
#' \emph{Journal of the Royal Statistical Society, Series C (Applied
#' Statistics)}, \bold{55}, 461-475.
#' 
#' Bashtannyk, D.M., and Hyndman, R.J. (2001) "Bandwidth selection for kernel
#' conditional density estimation". \emph{Computational Statistics and Data
#' Analysis}, \bold{36}(3), 279-298.
#' 
#' %Hyndman, R.J. and Yao, Q. (2002) "Nonparametric estimation and %symmetry
#' tests for conditional density functions". \emph{Journal of %Nonparametric
#' Statistics}, \bold{14}(3), 259-278.
#' 
#' @keywords regression nonparametric
#' @examples
#' 
#'   lane2.fit <- modalreg(lane2$flow, lane2$speed, xfix=(1:55)*40, a=100, b=4)
#' 
#' @export modalreg
`modalreg` <-
function (x, y, xfix = seq(min(x), max(x), l = 50), a, b, deg = 0, 
    iter = 30, P = 2, start = "e", prun = TRUE, prun.const = 10, 
    plot.type = c("p", 1), labels = c("", "x", "y"), pch = 20, 
    ...) 
{
    # Automatic bandwith selection
    if (missing(a) || missing(b)){
        if (deg==0){
           if (!missing(a) || !missing(b)){
              cat("Warning: If either a or b is missing for deg=0, then both bandwidths are selected automatically. \n")
           }
           h <- cde.bandwidths(x, y, method = 1, deg = 0, ...)
        }   
        else if (deg==1){
           stop("No automatic bandwidth selection for deg=1. Specify the bandwidths by hand or choose deg=0 (recommended).")
        }        
        a <- h$a
        b <- h$b
      }
 
    
        
    # Starting point selection
    if (P == 1) 
        ynull <- quantile(y, probs = 0.5)
    else {
        if (start == "q") 
            ynull <- quantile(y, probs = seq(0, 1, by = 1/(P - 1)))
        else if (start == "e" || start == "v") 
            ynull <- seq(min(y), max(y), length = P)
        else ynull <- runif(P, min(y), max(y))
    }

    # Vector and matrix  intializations
    n <- length(x)
    save.regression <- matrix(0, P, length(xfix))
    Alphabet <- c("A", "B", "C", "D", "E", "F", "G", "H")
    alphabet <- c("+", "x", "*", "d", "e", "f", "g", "h")

    # Plot data and starting points
    if (plot.type[1] != "n") {
        plot(x, y, pch = pch, main = labels[1], xlab = labels[2], 
            ylab = labels[3], col = "grey")
        if (plot.type[2] == 1) 
            points(rep(min(x), P), ynull, col = 2:(P + 1), pch = Alphabet[1:P])
    }

    
    # Multifunction fitting through conditional mean shift
    for (i in 1:length(xfix)) {
        for (p in 1:P) {
            if (start != "v" || i == 1) 
                current.regression <- ynull[p]
            else current.regression <- save.regression[p, i - 1]
            old.regression <- -1000
            for (j in 1:iter) {
                old.regression <- current.regression
                if (deg == 1) 
                  current.regression <- cond.linear.meanshift(x, y, xfix[i], current.regression, a, b)
                else if (deg == 0) 
                  current.regression <- cond.meanshift(x, y, xfix[i], current.regression, a, b)
                else stop("Polynomial degree not supported: Choose 0 or 1.")
                if (current.regression == "NaN") {
                  current.regression <- old.regression
                  break()
                }
              }
            save.regression[p, i] <- current.regression
        }
        if (i%%10 == 0) 
            cat(i, "..")
    }
    cat("\n")

    # Pruning
    span.area <- (max(x) - min(x)) * (max(y) - min(y))
    kde       <- matrix(0, P, length(xfix))
    Threshold <- -1
    if (prun == TRUE) {
        Threshold <-  1/(prun.const * span.area)
        for (i in 1:length(xfix)) {
            for (p in 1:P) {
                kde[p, i] <- kde2d.point(x, y, xfix[i], save.regression[p, i], a, b)
            }
        }
    }

    # Plotting of pruned fitted curves
    if (plot.type[1] != "n") {
        for (p in 1:P) {
            if (plot.type[1] == "p") 
                points(xfix[kde[p,]>Threshold], save.regression[p, ][kde[p,]>Threshold], cex = 1, col = p + 
                  1, pch = alphabet[p])
            else lines(xfix[kde[p,]>Threshold], save.regression[p, ][kde[p,]>Threshold], cex = 2)
        }
    }

    # Value
    h <- c(a, b)
    names(h) <- c("a", "b")
    list(xfix= xfix,  fitted.values = save.regression, bandwidths = h, density = kde, 
        threshold = Threshold)
}



######### Auxiliary functions


cond.meanshift <- function(x,y,x0, y0, a, b){
    sum(kern(x,x0,a)*gern(y,y0,b)*y)/(sum(kern(x,x0,a)*gern(y,y0,b)))
}

cond.linear.meanshift <- function(x,y,x0, y0, a, b){
    sn1<-sum(kern(x,x0,a)*(x0-x))
    sn2<-sum(kern(x,x0,a)*(x0-x)^2)
    sum(kern(x,x0,a)*(sn2-(x0-x)*sn1)*gern(y,y0,b)*y)/(sum(kern(x,x0,a)*(sn2-(x0-x)*sn1)*gern(y,y0,b)))
}

# Kernel function K1 (horizontal, "kern") 
kern <- function(x, x0 = 0, h = 1){
      1/h * dnorm((x0 - x)/h)
}
# Kernel function G (vertical, "gern"), is equal to K2 if G Gaussian.
gern <- kern

# Fast kernel density estimate   (faster than kde in package ks)
kde2d.point <- function(x, y, x0, y0, a, b){
    1/(length(x))*sum(kern(x,x0,a)*gern(y,y0,b))
}
