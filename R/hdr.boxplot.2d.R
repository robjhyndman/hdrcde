hdr.boxplot.2d <- function(x, y, prob=c(0.01,0.50), h, show.points=FALSE, xlab="", ylab="", kde.package=c("ash","ks"),
    shadecols=gray((9:1)/10), pointcol=1, xextend=0.15,yextend=0.15,...)
{
    # Plots bivariate HDRs in form of boxplot.
    kde.package <- match.arg(kde.package)
    # Find ranges for estimates
    xr <- diff(range(x,na.rm=TRUE))
    yr <- diff(range(y,na.rm=TRUE))
    xr <- c(min(x)-xr*xextend,max(x)+xr*xextend)
    yr <- c(min(y)-yr*yextend,max(y)+yr*yextend)
    
    if(kde.package=="ash")
    {
        require(ash)
        if(missing(h))
            h <- c(5,5)
        den <- ash2(bin2(cbind(x,y),rbind(xr,yr)),h)
    }
    else
    {
        require(ks)
        X <- cbind(x,y)
        if(missing(h))
            h <- Hpi.diag(X,binned=TRUE)
        else
            h <- diag(h)
        den <- kde(x=X,H=h,xmin=c(xr[1],yr[1]),xmax=c(xr[2],yr[2]))
        den <- list(x=den$eval.points[[1]],y=den$eval.points[[2]],z=den$estimate)
    }
    plothdr2d(x, y, den, prob, show.points=show.points, xlab=xlab, ylab=ylab, shadecols=shadecols, pointcol=pointcol, ...)
}

plothdr2d <- function(x, y, den, alpha=c(0.01,0.05,0.50), shaded=TRUE, show.points=TRUE,
        outside.points=TRUE, pch=19, shadecols, pointcol, ...)
{
    hdr <- hdr.info.2d(x, y, den, alpha=alpha)
    if(shaded)
        hdrcde.filled.contour(den$x,den$y,den$z,levels=c(hdr$falpha,1e10),col=shadecols,...)
    else
        contour(den,levels=hdr$falpha,labcex=0,...)
    if(show.points)
        points(x,y,pch=pch,col=pointcol)
    else if(outside.points)
    {
        index <- (hdr$fxy < 0.99999*min(hdr$falpha))
        points(x[index], y[index], pch=pch,col=pointcol)
    }
    points(hdr$mode[1],hdr$mode[2],pch="o",col=pointcol)
    invisible(hdr)
}

hdrcde.filled.contour <- function (x,y,z, xlim = range(x, finite = TRUE), 
    ylim = range(y, finite = TRUE), zlim = range(z, finite = TRUE), 
    levels = pretty(zlim, nlevels), nlevels = 20, color.palette = cm.colors, 
    col = color.palette(length(levels) - 1), plot.title, plot.axes, 
    asp = NA, xaxs = "i", yaxs = "i", las = 1, 
    axes = TRUE, frame.plot = axes, ...) 
{
  if (any(diff(x) <= 0) || any(diff(y) <= 0)) 
      stop("increasing 'x' and 'y' values expected")
  plot.new()
  plot.window(xlim, ylim, "", xaxs = xaxs, yaxs = yaxs, asp = asp)
  .filled.contour(x,y,z,levels,col)
  if (missing(plot.axes)) {
    if (axes) {
      title(main = "", xlab = "", ylab = "")
      Axis(x, side = 1)
      Axis(y, side = 2)
    }
  }
  else plot.axes
  if (frame.plot) 
      box()
  if (missing(plot.title)) 
      title(...)
  else plot.title
  invisible()
}


"hdr.info.2d" <- function(x, y, den, alpha)
{
    # Calculates falpha needed to compute HDR of bivariate density den.
    # Also finds approximate mode.
    # Input: den = bivariate density on grid.
    #      (x,y) = indpendent observations on den
    #      alpha = level of HDR
    # Called by plothdr2d

    fxy <- interp.2d(den$x,den$y,den$z,x,y)
    falpha <- quantile(sort(fxy), alpha)
    index <- (fxy==max(fxy))
    mode <- c(x[index],y[index])
    return(list(falpha=falpha,mode=mode,fxy=fxy))
}

"interp.2d" <- function(x, y, z, x0, y0)
{
    # Bilinear interpolation of function (x,y,z) onto (x0,y0).
    # Taken from Numerical Recipies (second edition) section 3.6.
    # Called by hdr.info.2d
    # Vectorized version of old.interp.2d. 
    # Contributed by Mrigesh Kshatriya (mkshatriya@zoology.up.ac.za)

    nx <- length(x)
    ny <- length(y)
    n0 <- length(x0)
    z0 <- numeric(length = n0)
    xr <- diff(range(x))
    yr <- diff(range(y))
    xmin <- min(x)
    ymin <- min(y)
    j <- ceiling(((nx - 1) * (x0 - xmin))/xr)
    k <- ceiling(((ny - 1) * (y0 - ymin))/yr)
    j[j == 0] <- 1
    k[k == 0] <- 1
    j[j == nx] <- nx - 1
    k[k == ny] <- ny - 1
    v <- (x0 - x[j])/(x[j + 1] - x[j])
    u <- (y0 - y[k])/(y[k + 1] - y[k]) 
    AA <- z[cbind(j, k)]
    BB <- z[cbind(j + 1, k)]
    CC <- z[cbind(j + 1, k + 1)]
    DD <- z[cbind(j, k + 1)]
    z0 <- (1 - v) * (1 - u) * AA + v * (1 - u) * BB + v * u * CC + (1 - v) * u * DD
    return(z0)
}
