# Scatterplots coloured by HDR regions


#' Scatterplot showing bivariate highest density regions
#' 
#' Produces a scatterplot where the points are coloured according to the
#' bivariate HDRs in which they fall.
#' 
#' The bivariate density is estimated using kernel density estimation. Either
#' \code{\link[ash]{ash2}} or \code{\link[ks]{kde}} is used to do the
#' calculations. Then Hyndman's (1996) density quantile algorithm is used to
#' compute the HDRs. The scatterplot of (x,y) is created where the points are
#' coloured according to which HDR they fall. A ggplot object is returned.
#' 
#' @param x Numeric vector or matrix with 2 columns.
#' @param y Numeric vector of same length as \code{x}.
#' @param levels Percentage coverage for HDRs
#' @param kde.package Package to be used in calculating the kernel density
#' estimate when \code{den=NULL}.
#' @param noutliers Number of outliers to be labelled. By default, all points
#' outside the largest HDR are labelled.
#' @author Rob J Hyndman
#' @seealso \code{\link{hdr.boxplot.2d}}
#' @keywords smooth distribution hplot
#' @examples
#' 
#' x <- c(rnorm(200,0,1),rnorm(200,4,1))
#' y <- c(rnorm(200,0,1),rnorm(200,4,1))
#' hdrscatterplot(x,y)
#' 
#' @export hdrscatterplot
hdrscatterplot <- function(x, y, levels=c(1,50,99),
  kde.package=c("ash","ks"), noutliers=NULL)
{
  levels <- sort(levels)
  if(missing(y))
    data <- x
  else
  {
    data <- data.frame(x=x,y=y)
    names(data) <- c(deparse(substitute(x)), deparse(substitute(y)))
  }

  vnames <- names(data)

  den <- hdr.2d(data[,1], data[,2], prob=levels, kde.package=kde.package)

  region <- numeric(NROW(data)) + 100
  for(i in seq_along(levels))
    region[den$fxy > den$falpha[i]] <- 100-levels[i]
  if(is.null(noutliers))
    noutliers <- sum(region > max(levels))

  noutliers <- min(noutliers, NROW(data))


  xlim <- diff(range(data[,1]))
  ylim <- diff(range(data[,2]))

  # Construct region factor
  levels <- sort(unique(region[region < 100]), decreasing=TRUE)
  levels <- c(levels, 100)
  data$Region <- factor(region, levels=levels,
      labels=c(paste(head(levels,-1)), ">99"))
  # Sort data so the larger regions go first (other than outliers)
  k <- region
  k[region==100] <- 0
  ord <- order(k, decreasing=TRUE)
  data <- data[ord,]

  if(noutliers > 0)
    outliers <- order(den$fxy[ord])[seq(noutliers)]

  p <- ggplot2::ggplot(data, ggplot2::aes_string(vnames[1],vnames[2])) +
      ggplot2::geom_point(ggplot2::aes(col=data$Region))
  p <- p + ggplot2::scale_colour_manual(
      name="HDRs",
      breaks=c(paste(head(sort(levels),-1)), ">99"),
      values=c(RColorBrewer::brewer.pal(length(levels),"YlOrRd")[-1],"#000000"))

  #Show outliers
  if(noutliers > 0)
  {
    p <- p + ggplot2::annotate("text", x = data[outliers,1]+xlim/50, y=data[outliers,2]+ylim/50,
                      label=rownames(data)[outliers],col='blue',cex=2.5)
  }
  return(p)
}