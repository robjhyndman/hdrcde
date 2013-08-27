\name{hdr.boxplot.2d}
\alias{hdr.boxplot.2d}
\title{Bivariate Highest Density Regions}
\description{
Calculates and plots highest density regions in two dimensions, including the
bivariate HDR boxplot.}
\usage{
hdr.boxplot.2d(x, y, prob=c(0.01,0.50), h, show.points = FALSE, 
    xlab="", ylab="",  kde.package=c("ash","ks"), shadecols, pointcol, xextend=0.15, yextend=0.15, ...)
}

\arguments{
  \item{x}{Numeric vector}
  \item{y}{Numeric vector of same length as \code{x}.}
  \item{prob}{Probability coverage required for HDRs}
  \item{h}{Pair of bandwidths passed to either \code{\link[ash]{ash2}} or \code{\link[ks]{kde}}. If missing,
    a reasonable default is used.}
  \item{show.points}{If TRUE, will plot points over the top of contours.}
  \item{xlab}{Label for x-axis.}
  \item{ylab}{Label for y-axis.}
  \item{kde.package}{Package to be used in calculating the kernel density estimate.}
  \item{shadecols}{Colors for shaded regions}
  \item{pointcol}{Color for outliers and mode}
  \item{xextend}{Proportion of range of \code{x}. The density is estimated on a grid extended by \code{xextend} beyond the range of \code{x}.}
  \item{yextend}{Proportion of range of \code{y}. The density is estimated on a grid extended by \code{yextend} beyond the range of \code{y}.}
  \item{\dots}{Other arguments to be passed to plot.}
}

\details{The density is estimated using kernel density estimation. Either \code{\link[ash]{ash2}} or \code{\link[ks]{kde}} is used to 
do the calculations. Then Hyndman's (1996) density quantile algorithm is used to compute the HDRs.}

\references{Hyndman, R.J. (1996) Computing and graphing highest density regions
\emph{American Statistician}, \bold{50}, 120-126.}

\author{Rob Hyndman}

\value{Some information about the HDRs is returned. See code for details.}


\seealso{\code{\link{hdr.boxplot}}}

\examples{
x <- c(rnorm(200,0,1),rnorm(200,4,1))
y <- c(rnorm(200,0,1),rnorm(200,4,1))
par(mfrow=c(1,2))
plot(x,y)
hdr.boxplot.2d(x,y)
}

\keyword{smooth}
\keyword{distribution}
\keyword{hplot}
