\name{plot.cde}
\alias{plot.cde}
\title{Plots conditional densities}
\description{
Produces stacked density plots or highest density region plots for a univariate density conditional on one covariate.
}
\usage{
\method{plot}{cde}(x, firstvar = 1, mfrow = n2mfrow(dim(x$z)[firstvar]), plot.fn = "stacked",
	x.name, margin = NULL, ...)
}
\arguments{
  \item{x}{Output from \code{\link{cde}}.}
  \item{firstvar}{If there is more than one conditioning variable, \code{firstvar} specifies which variable to fix first.}
  \item{mfrow}{If there is more than one conditioning variable, \code{mfrow} is passed to \code{\link[graphics]{par}} before plotting.}
  \item{plot.fn}{Specifies which plotting function to use: "stacked" results in stacked conditional densities and "hdr" results in highest density regions.}
  \item{x.name}{Name of x (conditioning) variable for use on x-axis.}
  \item{margin}{Marginal density of conditioning variable. If present, only conditional densities corresponding to non-negligible marginal densities will be plotted.}
  \item{\dots}{Additional arguments to plot.}
}
\value{If \code{plot.fn=="stacked"} and there is only one
conditioning variable, the function returns the output from \code{\link[graphics]{persp}}.
	If \code{plot.fn=="hdr"} and there is only one
conditioning variable, the function returns the output from \code{\link{hdr.cde}}. When there is more than one
conditioning variable, nothing is returned.}

\references{Hyndman, R.J., Bashtannyk, D.M. and Grunwald, G.K. (1996)
"Estimating and visualizing conditional densities". \emph{Journal of
Computational and Graphical Statistics}, \bold{5}, 315-336.
}

\author{Rob J Hyndman}

\seealso{\code{\link{hdr.cde}}, \code{\link{cde}}, \code{\link{hdr}}}

\examples{
faithful.cde <- cde(faithful$waiting,faithful$eruptions, 
	x.name="Waiting time", y.name="Duration time")
plot(faithful.cde)
plot(faithful.cde,plot.fn="hdr")
}

\keyword{smooth}
\keyword{distribution}
\keyword{hplot}
