#' Conditional Density Estimation
#'
#' Calculates kernel conditional density estimate using local polynomial
#' estimation.
#'
#' If bandwidths are omitted, they are computed using normal reference rules
#' described in Bashtannyk and Hyndman (2001) and Hyndman and Yao (2002). Bias
#' adjustment uses the method described in Hyndman, Bashtannyk and Grunwald
#' (1996). If deg>1 then estimation is based on the local parametric estimator
#' of Hyndman and Yao (2002).
#'
#' @param x Numerical vector or matrix: the conditioning variable(s).
#' @param y Numerical vector: the response variable.
#' @param deg Degree of local polynomial used in estimation.
#' @param link Link function used in estimation. Default "identity". The other
#' possibility is "log" which is recommended if degree > 0.
#' @param a Optional bandwidth in x direction.
#' @param b Optional bandwidth in y direction.
#' @param mean Estimated mean of y|x. If present, it will adjust conditional
#' density to have this mean.
#' @param x.margin Values in x-space on which conditional density is
#' calculated. If not specified, an equi-spaced grid of \code{nxmargin} values
#' over the range of x is used.  If x is a matrix, x.margin should be a list of
#' two numerical vectors.
#' @param y.margin Values in y-space on which conditional density is
#' calculated. If not specified, an equi-spaced grid of \code{nymargin} values
#' over the range of y is used.
#' @param x.name Optional name of x variable used in plots.
#' @param y.name Optional name of y variable used in plots.
#' @param use.locfit If TRUE, will use \code{\link[locfit]{locfit}} for
#' estimation. Otherwise \code{\link[stats]{ksmooth}} is used.
#' \code{\link[locfit]{locfit}} is used if degree>0 or link not the identity or
#' the dimension of x is greater than 1 even if \code{use.locfit=FALSE}.
#' @param fw If TRUE (default), will use fixed window width estimation.
#' Otherwise nearest neighbourhood estimation is used. If the dimension of x is
#' greater than 1, nearest neighbourhood must be used.
#' @param rescale If TRUE (default), will rescale the conditional densities to
#' integrate to one.
#' @param nxmargin Number of values used in \code{x.margin} by default.
#' @param nymargin Number of values used in \code{y.margin} by default.
#' @param a.nndefault Default nearest neighbour bandwidth (used only if
#' \code{fw=FALSE} and \code{a} is missing.).
#' @param \dots Additional arguments are passed to locfit.
#' @return A list with the following components: \item{x}{grid in x direction
#' on which density evaluated. Equal to x.margin if specified.} \item{y}{grid
#' in y direction on which density is evaluated. Equal to y.margin if
#' specified. } \item{z}{value of conditional density estimate returned as a
#' matrix. } \item{a}{window width in x direction.} \item{b}{window width in y
#' direction.} \item{x.name}{Name of x variable to be used in plots.}
#' \item{y.name}{Name of y variable to be used in plots.}
#' @author Rob J Hyndman
#' @seealso \code{\link{cde.bandwidths}}
#' @references Hyndman, R.J., Bashtannyk, D.M. and Grunwald, G.K. (1996)
#' "Estimating and visualizing conditional densities". \emph{Journal of
#' Computational and Graphical Statistics}, \bold{5}, 315-336.
#'
#' Bashtannyk, D.M., and Hyndman, R.J. (2001) "Bandwidth selection for kernel
#' conditional density estimation". \emph{Computational statistics and data
#' analysis}, \bold{36}(3), 279-298.
#'
#' Hyndman, R.J. and Yao, Q. (2002) "Nonparametric estimation and symmetry
#' tests for conditional density functions". \emph{Journal of Nonparametric
#' Statistics}, \bold{14}(3), 259-278.
#' @keywords smooth distribution hplot
#' @examples
#' # Old faithful data
#' faithful.cde <- cde(faithful$waiting, faithful$eruptions,
#'   x.name="Waiting time", y.name="Duration time")
#' plot(faithful.cde)
#' plot(faithful.cde, plot.fn="hdr")
#'
#' # Melbourne maximum temperatures with bias adjustment
#' x <- maxtemp[1:3649]
#' y <- maxtemp[2:3650]
#' maxtemp.cde <- cde(x, y,
#'   x.name="Today's max temperature", y.name="Tomorrow's max temperature")
#' # Assume linear mean
#' fit <- lm(y~x)
#' fit.mean <- list(x=6:45,y=fit$coef[1]+fit$coef[2]*(6:45))
#' maxtemp.cde2 <- cde(x, y, mean=fit.mean,
#' 	 x.name="Today's max temperature", y.name="Tomorrow's max temperature")
#' plot(maxtemp.cde)
#' @export cde
cde <- function(x, y, deg=0, link="identity", a, b, mean=NULL,
        x.margin,y.margin, x.name, y.name, use.locfit=FALSE, fw=TRUE, rescale=TRUE,
        nxmargin=15, nymargin=100, a.nndefault=0.3, ...)
{
    xname = deparse(substitute(x))
    yname = deparse(substitute(y))
    miss.xmargin=missing(x.margin)
    miss.ymargin=missing(y.margin)
    miss.a <- missing(a)
    miss.b <- missing(b)
    miss.xname <- missing(x.name)
    miss.yname <- missing(y.name)
    bias.adjust <- !is.null(mean)

    x <- as.matrix(x)
    nx <- ncol(x)

    if(bias.adjust & nx>1)
        stop("Bias adjustment not implemented for multiple conditioning variables")

    use.locfit <- (link!="identity" | deg>0 | use.locfit | nx>1 | !fw)
    fw <- (fw & nx==1)
    rescale <- (rescale | use.locfit)

    ## Get x.name
    if(miss.xname)
        x.name <- dimnames(x)[[2]]
    if(is.null(x.name))
    {
        if(nx==1)
            x.name <- xname
        else
            x.name <- paste(xname,"[,",1:nx,"]")
    }
    else if(length(x.name) != nx)
        stop("x.name has wrong length")
    dimnames(x) <- list(NULL,x.name)
    x.df <- as.data.frame(x)

    ## Get y.name
    if(miss.yname)
        y.name <- names(y)
    if(is.null(y.name))
        y.name <- yname
    else if(length(y.name)!=1)
        stop("y.name has wrong length")

    ##### Choose bandwidths
    if(miss.a | miss.b)
    {
        # Use reference rules
        # Only chooses bandwidth for first column of x.
        bands <- cdeband.rules(x[,1],y,deg=deg,link=link)
        if(miss.b)
            b <- bands$b
        if(miss.a)
        {
            if(fw)
                a <- bands$a ## Fixed width window
            else
                a <- a.nndefault  ## Nearest neighbourhood span
        }
    }
    if(use.locfit)
    {
        if(fw)
            locfit.a <- c(0,2.5*a)  ## For fixed bandwidth of a in locfit
        else
            locfit.a <- a
    }

    ##### Find y margin
    if(miss.ymargin)
    {
        yrange <- range(y)
        y.margin <- seq(yrange[1]-4*b,yrange[2]+4*b,l=nymargin)
    }
    else
        y.margin <- sort(y.margin)

    #### Find x margin
    if(miss.xmargin)
        x.margin <- NULL
    else if(is.matrix(x.margin)) # turn it into a list
        x.margin <- split(c(x.margin),rep(1:nx,rep(nrow(x.margin),nx)))
    else if(!is.list(x.margin))  #so is a vector
        x.margin <- list(x.margin)
    for(i in 1:nx)
    {
        if(miss.xmargin)
        {
            xrange <- range(x[,i])
            x.margin <- c(x.margin,list(seq(xrange[1],xrange[2],l=nxmargin)))
        }
        else
            x.margin[[i]] <- sort(x.margin[[i]])
    }
    names(x.margin) <- names(x.df)
    x.margin.grid <- expand.grid(x.margin)

    ##### Set up
    dim.cde <- c(length(y.margin),unlist(lapply(x.margin,length)))
    cde <- NULL
    GCV <- AIC <- numeric(dim.cde[1])
    n <- length(x)


    # If bias adjustment
    if(bias.adjust)
    {
        ymean <- mean(y)
        oldwarn <- options(warn=-1)
        approx.mean <- approx(mean$x,mean$y,xout=x)$y
        options(warn=oldwarn$warn)
        if(sum(is.na(approx.mean))>0)
            stop("Missing values in estimated mean")
        y <- y - approx.mean
        y.margin <- y.margin - ymean
    }


    ##### Do the calculations
    oldwarn <- options(warn=-1)
    xrange <- range(x[,1]) # How to handle multiple x??
    for(i in 1:dim.cde[1])
    {
        newy <- Kernel(y,y.margin[i],b,type="normal")
        if(max(abs(newy)) < 1e-20)
        {
            cde <- c(cde,rep(0,length(x.margin[[1]])))
        }
        else if(!use.locfit)
        {
            junk <- ksmooth(x[,1],newy,bandwidth=2.697959*a,kernel="normal",x.points=x.margin[[1]])$y
            junk[is.na(junk)] <- 0 ## No data in these areas
            cde <- c(cde,list(junk))
        }
        else
        {
            yscale <- mean(newy)
            newy <- newy/yscale
            junk <- locfit::locfit.raw(x,newy, alpha=locfit.a,deg=deg,link=link,family="qgauss",
                    kern="gauss",maxit=400,...)
            sum.coef <- sum(abs(junk$eva$coef))
            fits <- try(predict(junk,newdata=as.matrix(x.margin.grid)),silent=TRUE)
            if(class(fits)!="try-error")
            {
                AIC[i] <- -2 * junk$dp["lk"] + 2 * junk$dp["df2"]
                GCV[i] <- (-2 * n * junk$dp["lk"])/(n - junk$dp["df2"])^2
            }
            else
            {
                fits <- rep(NA,nrow(x.margin.grid))
                AIC[i] <- Inf  # or something huge
                GCV[i] <- Inf
            }
            cde <- c(cde,list(array(fits*yscale,dim.cde[-1])))
        }
    }
    options(warn=oldwarn$warn)

    AIC[AIC==Inf] <- 1.5*max(AIC[AIC<Inf])
    GCV[GCV==Inf] <- 1.5*max(GCV[GCV<Inf])
    z <- array(unlist(cde),dim=c(dim.cde[-1],dim.cde[1]))

    if(rescale)
    {
        delta <- y.margin[2]-y.margin[1]
        if(nx==1)
        {
            for(i in 1:dim.cde[2])
            {
                sumz <- sum(z[i,],na.rm=TRUE)
                if(sumz>0)
                    z[i,] <- z[i,] / sum(z[i,],na.rm=TRUE)
            }
        }
        else if(nx==2)
        {
            for(i in 1:dim.cde[2])
                for(j in 1:dim.cde[3])
                    z[i,j,] <- z[i,j,] / sum(z[i,j,],na.rm=TRUE)
        }
        z <- z/delta
    }
    z[z<0] <- 0

    # Bias adjustment
    if(bias.adjust)
    {
#        browser()
        oldwarn <- options(warn=-1)
        approx.mean <- approx(mean$x,mean$y,xout=x.margin[[1]],rule=2)$y
        options(warn=oldwarn$warn)
        for(i in 1:dim.cde[2])
        {
            amean <- approx.mean[i] - sum(z[i,]*y.margin)*(y.margin[2]-y.margin[1])
            z[i,] <- approx(y.margin+amean,z[i,],xout=y.margin+ymean)$y
        }
        z[is.na(z)] <- 0
        y.margin <- y.margin + ymean
    }

#    browser()

    ## Return the result
    if(nx==1)
        x.margin <- x.margin[[1]]  ## No need to keep it as a list.
    return(structure(list(x=x.margin,y=y.margin,z=z,a=a,b=b,deg=deg,link=link,
            fn=switch(use.locfit+1,"ksmooth","locfit"),x.name=x.name, y.name=y.name,
            fixed.width=fw,AIC=mean(AIC),GCV=mean(GCV),call=match.call()),class="cde"))
}


Kernel <- function(y,y0,b,type="epanech")
{
    if(type=="epanech")
        K <- epanech
    else
        K <- dnorm
    t(K(sweep(matrix(y0, nrow=length(y0), ncol=length(y)), 2, y),0,b))
}

"epanech" <- function(x,a,h)
{
    xx <- (x-a)/h
    0.75*(1-xx^2) * as.numeric(abs(xx)<1)
}


#' @export
print.cde <- function(x, ...)
{
    cat("Conditional density estimate:\n")
    cat(paste(x$y.name,"|",x$x.name,"\n\nCall: "))
    print(x$call)
    cat("\n  a=",x$a,"  b=",x$b)
    cat("\n  Degree=",x$deg,"  Link=",x$link,"\n")
}
