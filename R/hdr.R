#' Highest Density Regions
#'
#' Calculates highest density regions in one dimension
#'
#' Either \code{x} or \code{den} must be provided. When \code{x} is provided,
#' the density is estimated using kernel density estimation. A Box-Cox
#' transformation is used if \code{lambda!=1}, as described in Wand, Marron and
#' Ruppert (1991). This allows the density estimate to be non-zero only on the
#' positive real line. The default kernel bandwidth \code{h} is selected using
#' the algorithm of Samworth and Wand (2010).
#'
#' Hyndman's (1996) density quantile algorithm is used for calculation.
#'
#' @param x Numeric vector containing data. If \code{x} is missing then
#' \code{den} must be provided, and the HDR is computed from the given density.
#' @param prob Probability coverage required for HDRs
#' @param den Density of data as list with components \code{x} and \code{y}.
#' If omitted, the density is estimated from \code{x} using
#' \code{\link[stats]{density}}.
#' @param h Optional bandwidth for calculation of density.
#' @param lambda Box-Cox transformation parameter where \code{0 <= lambda <=
#' 1}.
#' @param nn Number of random numbers used in computing f-alpha quantiles.
#' @param all.modes Return all local modes or just the global mode?
#' @return A list of three components: \item{hdr}{The endpoints of each interval
#' in each HDR} \item{mode}{The estimated mode of the density.}
#' \item{falpha}{The value of the density at the boundaries of each HDR.}
#' @author Rob J Hyndman
#' @seealso \code{\link{hdr.den}}, \code{\link{hdr.boxplot}}
#' @references Hyndman, R.J. (1996) Computing and graphing highest density
#' regions. \emph{American Statistician}, \bold{50}, 120-126.
#'
#' Samworth, R.J. and Wand, M.P. (2010). Asymptotics and optimal bandwidth
#' selection for highest density region estimation.  \emph{The Annals of
#' Statistics}, \bold{38}, 1767-1792.
#'
#' Wand, M.P., Marron, J S., Ruppert, D. (1991) Transformations in density
#' estimation. \emph{Journal of the American Statistical Association},
#' \bold{86}, 343-353.
#' @keywords smooth distribution
#' @examples
#' # Old faithful eruption duration times
#' hdr(faithful$eruptions)
#' @export hdr
hdr <- function(x=NULL, prob=c(50,95,99), den=NULL, h=hdrbw(BoxCox(x,lambda),mean(prob)), lambda=1, nn=5000, all.modes=FALSE)
{
    if(!is.null(x))
    {
        r <- diff(range(x))
        if(r==0)
            stop("Insufficient data")
    }
    if(is.null(den))
        den <- tdensity(x,bw=h,lambda=lambda)
    alpha <- sort(1-prob/100)
    falpha <- calc.falpha(x,den,alpha,nn=nn)
    hdr.store <- matrix(NA,length(alpha),100)
    for(i in 1:length(alpha))
    {
        junk <- hdr.ends(den,falpha$falpha[i])$hdr
        if(length(junk) > 100)
        {
            junk <- junk[1:100]
            warning("Too many sub-intervals. Only the first 50 returned.")
        }
        hdr.store[i,] <- c(junk,rep(NA,100-length(junk)))
    }
    cj <- colSums(is.na(hdr.store))
    hdr.store <- matrix(hdr.store[,cj < nrow(hdr.store)],nrow=length(prob))
    rownames(hdr.store) <- paste(100*(1-alpha),"%",sep="")
    if(all.modes)
    {
        y <- c(0,den$y,0)
        n <- length(y)
        idx <- ((y[2:(n-1)] > y[1:(n-2)]) & (y[2:(n-1)] > y[3:n])) | (den$y == max(den$y))
        mode <- den$x[idx]
    }
    else
        mode <- falpha$mode
    return(list(hdr=hdr.store,mode=mode,falpha=falpha$falpha))
}

"calc.falpha" <-
function(x=NULL, den, alpha, nn=5000)
{
    # Calculates falpha needed to compute HDR of density den.
    # Also finds approximate mode.
    # Input: den = density on grid.
    #          x = independent observations on den
    #      alpha = level of HDR
    # Called by hdr.box and hdr.conf

    if(is.null(x))
        calc.falpha(x=sample(den$x, nn, replace=TRUE, prob=den$y), den, alpha)
    else
    {
        fx <- approx(den$x,den$y,xout=x,rule=2)$y
        falpha <- quantile(sort(fx), alpha)
        mode <- den$x[den$y==max(den$y)]
        return(list(falpha=falpha,mode=mode,fx=fx))
    }
}

"hdr.ends" <-
function(den,falpha)
{
    miss <- is.na(den$x) # | is.na(den$y)
    den$x <- den$x[!miss]
    den$y <- den$y[!miss]
    n <- length(den$x)
    # falpha is above the density, so the HDR does not exist
    if(falpha > max(den$y))
        return(list(falpha=falpha,hdr=NA) )
    f <- function(x, den, falpha) {
      approx(den$x, den$y-falpha, xout=x)$y
    }
    intercept <- all_roots(f, interval=range(den$x), den=den, falpha=falpha)
    ni <- length(intercept)
    # No roots -- use the whole line
    if(ni == 0L)
      intercept <- c(den$x[1],den$x[n])
    else {
      # Check behaviour outside the smallest and largest intercepts
      if(f(0.5*(head(intercept,1) + den$x[1]), den, falpha) > 0)
        intercept <- c(den$x[1],intercept)
      if(f(0.5*(tail(intercept,1) + den$x[n]), den, falpha) > 0)
        intercept <- c(intercept,den$x[n])
    }
    # Check behaviour -- not sure if we need this now
    if(length(intercept) %% 2)
      warning("Some HDRs are incomplete")
      #  intercept <- sort(unique(intercept))
    return(list(falpha=falpha,hdr=intercept))
}

#' Density plot with Highest Density Regions
#'
#' Plots univariate density with highest density regions displayed
#'
#' Either \code{x} or \code{den} must be provided. When \code{x} is provided,
#' the density is estimated using kernel density estimation. A Box-Cox
#' transformation is used if \code{lambda!=1}, as described in Wand, Marron and
#' Ruppert (1991). This allows the density estimate to be non-zero only on the
#' positive real line. The default kernel bandwidth \code{h} is selected using
#' the algorithm of Samworth and Wand (2010).
#'
#' Hyndman's (1996) density quantile algorithm is used for calculation.
#'
#' @param x Numeric vector containing data. If \code{x} is missing then
#' \code{den} must be provided, and the HDR is computed from the given density.
#' @param prob Probability coverage required for HDRs
#' @param den Density of data as list with components \code{x} and \code{y}.
#' If omitted, the density is estimated from \code{x} using
#' \code{\link[stats]{density}}.
#' @param h Optional bandwidth for calculation of density.
#' @param lambda Box-Cox transformation parameter where \code{0 <= lambda <=
#' 1}.
#' @param xlab Label for x-axis.
#' @param ylab Label for y-axis.
#' @param ylim Limits for y-axis.
#' @param plot.lines If \code{TRUE}, will show how the HDRs are determined
#' using lines.
#' @param col Colours for regions.
#' @param bgcol Colours for the background behind the boxes. Default \code{"gray"}, if \code{NULL} no box is drawn.
#' @param legend If \code{TRUE} add a legend on the right of the boxes.
#' @param \dots Other arguments passed to plot.
#' @return a list of three components: \item{hdr}{The endpoints of each interval
#' in each HDR} \item{mode}{The estimated mode of the density.}
#' \item{falpha}{The value of the density at the boundaries of each HDR.}
#' @author Rob J Hyndman
#' @seealso \code{\link{hdr}}, \code{\link{hdr.boxplot}}
#' @references Hyndman, R.J. (1996) Computing and graphing highest density
#' regions. \emph{American Statistician}, \bold{50}, 120-126.
#'
#' Samworth, R.J. and Wand, M.P. (2010). Asymptotics and optimal bandwidth
#' selection for highest density region estimation.  \emph{The Annals of
#' Statistics}, \bold{38}, 1767-1792.
#'
#' Wand, M.P., Marron, J S., Ruppert, D. (1991) Transformations in density
#' estimation. \emph{Journal of the American Statistical Association},
#' \bold{86}, 343-353.
#' @keywords smooth distribution hplot
#' @examples
#' # Old faithful eruption duration times
#' hdr.den(faithful$eruptions)
#'
#' # Simple bimodal example
#' x <- c(rnorm(100,0,1), rnorm(100,5,1))
#' hdr.den(x)
#' @export hdr.den
hdr.den <- function(x, prob=c(50,95,99), den, h=hdrbw(BoxCox(x,lambda),mean(prob)),
    lambda=1, xlab=NULL, ylab="Density", ylim=NULL, plot.lines=TRUE, col=2:8,bgcol="gray",legend=FALSE, ...)
{
  if(missing(den))
    den <- tdensity(x,bw=h,lambda=lambda)
  else if(missing(x))
    x <- sample(den$x, 500, replace=TRUE, prob=den$y)

  maxden <- max(den$y)
  stepy <- maxden*0.02
  if(is.null(ylim))
    ylim <- c((1-length(prob))*stepy, maxden)

  plot(den, type="n", xlab=xlab, ylab=ylab, ylim=ylim, xaxt="n", yaxt="n", ...)
  rangex <- range(x, na.rm=TRUE)
  minx <- rangex[1]
  maxx <- rangex[2]
  rangex <- maxx-minx
  if(!is.null(bgcol))
    polygon(c(minx-0.5*rangex, maxx+0.5*rangex, maxx+0.5*rangex, minx-0.5*rangex),
      c(0,0,rep(-length(prob)*stepy*2,2)),col=bgcol,border=FALSE)
  #abline(h=0, col="gray")
  lines(den$x,den$y)
  box()
  axis(1)
  axis(2, at=pretty(c(0,maxden)))

  hd <- hdr(x=x, prob=prob, den=den, h=h)
  nregions <- nrow(hd$hdr)

  leng <- dim(hd$hdr)[[2]]

  # Colours for HDRs
  if(nregions > 8)
  {
    repcol <- ceiling(length(prob)/8)
    col <- rep(col, repcol)
  }

  if(plot.lines)
  {
    for(i in 1:nregions)
    {
      abline(h=hd$falpha[i], col=col[i], lty=2)
      for(j in 1:length(hd$hdr[i,]))
        lines(rep(hd$hdr[i,j],2), c(stepy*(i-nregions),hd$falpha[i]),col=col[i], lty=2)
    }
  }
  for(i in 1:nregions)
    add.hdr(hd$hdr[i,], (i-nregions-0.5)*stepy, stepy, col=col[i], horiz=TRUE)
  if(legend){
      rightlim=apply(hd$hdr,1,function(i)i[length(i[!is.na(i)])])
      text(rightlim, ((1:nregions)-nregions-0.5)*stepy, label=paste0(rownames(hd$hdr)," HDR"),cex=.8,pos=4)
  }
  return(hd)
}

#' Highest Density Region Boxplots
#'
#' Calculates and plots a univariate highest density regions boxplot.
#'
#' The density is estimated using kernel density estimation. A Box-Cox
#' transformation is used if \code{lambda!=1}, as described in Wand, Marron and
#' Ruppert (1991). This allows the density estimate to be non-zero only on the
#' positive real line. The default kernel bandwidth \code{h} is selected using
#' the algorithm of Samworth and Wand (2010).
#'
#' Hyndman's (1996) density quantile algorithm is used for calculation.
#'
#' @param x Numeric vector containing data or a list containing several vectors.
#' @param prob Probability coverage required for HDRs
#' \code{\link[stats]{density}}.
#' @param h Optional bandwidth for calculation of density.
#' @param lambda Box-Cox transformation parameter where \code{0 <= lambda <=
#' 1}.
#' @param boxlabels Label for each box plotted.
#' @param col Colours for regions of each box.
#' @param main Overall title for the plot.
#' @param xlab Label for x-axis.
#' @param ylab Label for y-axis.
#' @param pch Plotting character.
#' @param border Width of border of box.
#' @param outline If not <code>TRUE</code>, the outliers are not drawn.
#' @param space The space between each box, between 0 and 0.5.
#' @param \dots Other arguments passed to plot.
#' @return nothing.
#' @author Rob J Hyndman
#' @seealso \code{\link{hdr.boxplot.2d}}, \code{\link{hdr}}, \code{\link{hdr.den}}
#' @references Hyndman, R.J. (1996) Computing and graphing highest density
#' regions. \emph{American Statistician}, \bold{50}, 120-126.
#'
#' Samworth, R.J. and Wand, M.P. (2010). Asymptotics and optimal bandwidth
#' selection for highest density region estimation.  \emph{The Annals of
#' Statistics}, \bold{38}, 1767-1792.
#'
#' Wand, M.P., Marron, J S., Ruppert, D. (1991) Transformations in density
#' estimation. \emph{Journal of the American Statistical Association},
#' \bold{86}, 343-353.
#' @keywords smooth distribution hplot
#' @examples
#' # Old faithful eruption duration times
#' hdr.boxplot(faithful$eruptions)
#'
#' # Simple bimodal example
#' x <- c(rnorm(100,0,1), rnorm(100,5,1))
#' par(mfrow=c(1,2))
#' boxplot(x)
#' hdr.boxplot(x)
#'
#' # Highly skewed example
#' x <- exp(rnorm(100,0,1))
#' par(mfrow=c(1,2))
#' boxplot(x)
#' hdr.boxplot(x,lambda=0)
#'
#' @export hdr.boxplot
hdr.boxplot <- function(x, prob=c(99,50), h=hdrbw(BoxCox(x,lambda),mean(prob)), lambda=1, boxlabels="", col= gray((9:1)/10),
    main = "", xlab="",ylab="", pch=1, border=1,outline=TRUE,space=.25,...)
{
    if(!is.list(x))
        x <- list(x)
    prob <- -sort(-prob)
    nplots <- length(x)
    junk <- unlist(x)
    ends.list <- list()
    for(j in 1:nplots)
        ends.list[[j]] <- hdr.box(x[[j]],prob,h=h,lambda=lambda)
    plot(c(0.5,nplots+0.5),range(junk,unlist(ends.list)),type="n",xlab=xlab,main=main,
        ylab=ylab,xaxt="n",...)
    if(length(boxlabels)==1 & boxlabels[1]=="")
    {
        junk <- names(x)
        if(is.null(junk))
            boxlabels <- rep("",nplots)
        else
            boxlabels <- junk
    }
    axis(1,at=c(1:nplots),labels=boxlabels,tick=FALSE,...)

    sp <- 0.5 - min(max(space, 0), 0.5)
    nint <- length(prob)
    cols <- rep(col,5)
    for(j in 1:nplots)
    {
        xx <- x[[j]]
        ends <- ends.list[[j]]
        for(i in 1:nint)
        {
            endsi <- ends[[i]]
            for(k in 1:(length(endsi)/2))
            {
                polygon( c(j-sp,j-sp,j+sp,j+sp,j-sp),
                    c(endsi[k*2-1],endsi[k*2],
                    endsi[k*2],endsi[k*2-1],endsi[k*2-1]),
                    col =cols[i], border=border)
            }
        }
        for(k in 1:length(ends$mode))
            lines(c(j-0.35,j+0.35),rep(ends$mode[k],2),lty=1)
        if(outline) {
            outliers <- xx[xx<min(ends[[1]]) | xx>max(ends[[1]])]
            points(rep(j,length(outliers)),outliers,pch=pch)
        }
    }
    invisible()
}


"hdr.box" <- function(x, prob=c(99,50), h, lambda, ...)
{
    # Does all the calculations for an HDR boxplot of x and returns
    # the endpoints of the HDR sub-intervals and the mode in a list.
    # Called by hdr.boxplot().

    r <- diff(range(x))
    if(r>0)
    {
        den <- tdensity(x,bw=h,lambda)
        info <- calc.falpha(x,den,1-prob/100)
    }
    hdrlist <- list()
    for(i in 1:length(prob))
    {
        if(r>0) hdrlist[[i]] <- hdr.ends(den,info$falpha[i])$hdr
        else hdrlist[[i]] <- c(x[1],x[1])
    }
    if(r>0) hdrlist$mode <- info$mode
    else hdrlist$mode <- x[1]
    return(hdrlist)
}

# Transformed density estimate

tdensity <- function(x,bw="SJ",lambda=1)
{
    if(is.list(x))
        x <- x[[1]]
    if(lambda==1)
        return(density(x,bw=bw,n=1001))
    else if(lambda < 0 | lambda > 1)
        stop("lambda must be in [0,1]")
    # Proceed with a Box-Cox transformed density
    y <- BoxCox(x,lambda)
    g <- density(y,bw=bw, n=1001)
    j <- g$x > 0.1 - 1/lambda # Stay away from the edge
    g$y <- g$y[j]
    g$x <- g$x[j]
    xgrid <- InvBoxCox(g$x,lambda) # x
    g$y <- c(0,g$y * xgrid^(lambda-1))
    g$x <- c(0,xgrid)
    return(g)
}



#' Box Cox Transformation
#'
#' BoxCox() returns a transformation of the input variable using a Box-Cox
#' transformation. InvBoxCox() reverses the transformation.
#'
#' The Box-Cox transformation is given by \deqn{f_\lambda(x) =\frac{x^\lambda -
#' 1}{\lambda}}{f(x;lambda) = (x^lambda - 1)/lambda} if
#' \eqn{\lambda\ne0}{lambda is not equal to 0}. For \eqn{\lambda=0}{lambda=0},
#' \deqn{f_0(x) = \log(x).}{f(x;0) = log(x).}
#'
#' @aliases BoxCox InvBoxCox
#' @param x a numeric vector or time series
#' @param lambda transformation parameter
#' @return a numeric vector of the same length as x.
#' @author Rob J Hyndman
#' @references Box, G. E. P. and Cox, D. R. (1964) An analysis of
#' transformations. \emph{JRSS B} \bold{26} 211--246.
#' @keywords math
#' @export BoxCox
BoxCox <- function (x, lambda)
{
    if(is.list(x))
        x <- x[[1]]
    if (lambda == 0)
        log(x)
    else (x^lambda - 1)/lambda
}
InvBoxCox <- function (x, lambda)
{
    if(is.list(x))
        x <- x[[1]]
    if (lambda == 0)
        exp(x)
    else (x * lambda + 1)^(1/lambda)
}

all_roots <- function (f, interval,
  lower = min(interval), upper = max(interval), n = 100L, ...)
{
  x <- seq(lower, upper, len = n + 1L)
  fx <- f(x, ...)
  roots <- x[which(fx == 0)]
  fx2 <- fx[seq(n)] * fx[seq(2L,n+1L,by=1L)]
  index <- which(fx2 < 0)
  for (i in index)
    roots <- c(roots, uniroot(f, lower = x[i], upper = x[i+1L], ...)$root)
  return(roots)
}
