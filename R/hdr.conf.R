#' HDRs with confidence intervals
#' 
#' Calculates Highest Density Regions with confidence intervals.
#' 
#' 
#' @param x Numeric vector containing data.
#' @param den Density of data as list with components \code{x} and \code{y}.
#' @param prob Probability coverage for for HDRs.
#' @param conf Confidence for limits on HDR.
#' @return \code{hdrconf} returns list containing the following components:
#' \item{hdr}{Highest density regions} \item{hdr.lo}{Highest density regions
#' corresponding to lower confidence limit.} \item{hdr.hi}{Highest density
#' regions corresponding to upper confidence limit.} \item{falpha}{Values of
#' \eqn{f_\alpha}{f[alpha]} corresponding to HDRs.} \item{falpha.ci}{Values of
#' \eqn{f_\alpha}{f[alpha]} corresponding to lower and upper limits.}
#' @author Rob J Hyndman
#' @seealso \code{\link{hdr}}, \code{\link{plot.hdrconf}}
#' @references Hyndman, R.J. (1996) Computing and graphing highest density
#' regions \emph{American Statistician}, \bold{50}, 120-126.
#' @keywords smooth distribution
#' @examples
#' 
#' x <- c(rnorm(100,0,1),rnorm(100,4,1))
#' den <- density(x,bw=hdrbw(x,50))
#' trueden <- den
#' trueden$y <- 0.5*(exp(-0.5*(den$x*den$x)) + exp(-0.5*(den$x-4)^2))/sqrt(2*pi)
#' sortx <- sort(x)
#' 
#' par(mfcol=c(2,2))
#' for(conf in c(50,95))
#' {
#'     m <- hdrconf(sortx,trueden,conf=conf)
#'     plot(m,trueden,main=paste(conf,"% HDR from true density"))
#'     m <- hdrconf(sortx,den,conf=conf)
#'     plot(m,den,main=paste(conf,"% HDR from empirical density\n(n=200)"))
#' }
#' 
#' @export hdrconf
hdrconf <- function(x,den,prob=95,conf=95)
{
    # Returns hdr with confidence limits
    # Assumes x is a sorted sample from the density den.

    alpha <- 1-conf/100
    info <- calc.falpha(x,den,alpha)
    hdr <- hdr.ends(den,info$falpha)$hdr
    nint <- length(hdr)
    delta <- range(x)/1000
    f2 <- approx(den$x,den$y,hdr+delta)$y
    fprime <- (f2-info$falpha)/delta
    g <- info$falpha*sum(abs(1/fprime))
    var.falpha <- alpha*(1-alpha)/(length(x)*g*g)
    z <- abs(qnorm(0.5-conf/200))
    falpha.ci <- z*sqrt(var.falpha)
    falpha.ci <- info$falpha + c(-falpha.ci,falpha.ci)
    if(falpha.ci[1] < 0)
        hdr1 <- c(NA,NA)
    else
        hdr1 <- hdr.ends(den,falpha.ci[1])$hdr
    if(falpha.ci[2] < 0)
        hdr2 <- c(NA,NA)
    else
        hdr2 <- hdr.ends(den,falpha.ci[2])$hdr
    return(structure(list(hdr=hdr, hdr.lo=hdr1, hdr.hi=hdr2,
            falpha=info$falpha, falpha.ci=falpha.ci),class="hdrconf"))
}
