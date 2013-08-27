\name{hdr.cde}
\alias{hdr.cde}

\title{Calculate highest density regions continously over some conditioned variable.
}

\description{ Calculates and plots highest density regions for a conditional 
density estimate. Uses output from \code{\link{cde}}. }

\usage{
hdr.cde(den, prob = c(50, 95, 99), plot = TRUE, plot.modes = TRUE, 
   mden = rep(1, length(den$x)), threshold = 0.05, nn = 1000, 
   xlim, ylim, xlab, ylab, border=TRUE, font=1, cex=1, ...)
}
\arguments{
  \item{den}{Conditional density in the same format as the output from \code{\link{cde}}.}
  \item{prob}{Probability coverage level for HDRs}
  \item{plot}{Should HDRs be plotted? If FALSE, results are returned.}
  \item{plot.modes}{Should modes be plotted as well as HDRs?}
  \item{mden}{Marginal density in the \code{x} direction. When small, the HDRs won't be plotted. Default is uniform so all HDRs are plotted.}
  \item{threshold}{Threshold for margin density. HDRs are not plotted if the margin density \code{mden} is lower than this value.}
  \item{nn}{Number of points to be sampled from each density when estimating the HDRs.}
  \item{xlim}{Limits for x-axis.}
  \item{ylim}{Limits for y-axis.}
  \item{xlab}{Label for x-axis.}
  \item{ylab}{Label for y-axis.}
  \item{border}{Show border of polygons}
  \item{font}{Font to be used in plot.}
  \item{cex}{Size of characters.}
  \item{\dots}{Other arguments passed to plotting functions.}
}
\value{
  \item{hdr}{array (a,b,c) where where a specifies conditioning value, b gives
        the HDR endpoints and c gives the probability coverage.}
  \item{modes}{estimated mode of each conditional density}
}

\references{Hyndman, R.J., Bashtannyk, D.M. and Grunwald, G.K. (1996)
"Estimating and visualizing conditional densities". \emph{Journal of
Computational and Graphical Statistics}, \bold{5}, 315-336.
}

\author{Rob Hyndman}

\seealso{\code{\link{cde}}, \code{\link{hdr}}}
\examples{
faithful.cde <- cde(faithful$waiting,faithful$eruptions)
plot(faithful.cde,xlab="Waiting time",ylab="Duration time",plot.fn="hdr")
}
\keyword{smooth}
\keyword{distribution}
\keyword{hplot}
