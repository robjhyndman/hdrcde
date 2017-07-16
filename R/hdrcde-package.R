#' @importFrom utils packageVersion
#' @importFrom grDevices cm.colors gray n2mfrow
#' @importFrom graphics .filled.contour Axis abline axis
#' @importFrom graphics box contour lines matpoints mtext par
#' @importFrom graphics persp plot plot.default plot.new plot.window
#' @importFrom graphics points polygon text title
#' @importFrom stats approx density deviance dnorm fitted
#' @importFrom stats ksmooth lm nlm pnorm predict qnorm
#' @importFrom stats quantile residuals rnorm runif sd var
#' @importFrom utils head
#'
#' @useDynLib hdrcde, .registration = TRUE
NULL



#' Speed-Flow data for Californian Freeway
#'
#' These are two data sets collected in 1993 on two individual lanes (lane 2
#' and lane 3) of the 4-lane Californian freeway I-880. The data were collected
#' by loop detectors, and the time units are 30 seconds per observation (see
#' Petty et al., 1996, for details).
#'
#' The data is examined in Einbeck and Tutz (2006), using a nonparametric
#' approach to multi-valued regression based on conditional mean shift.
#'
#' @aliases lane2 lane3
#' @usage lane2; lane3
#' @format Two data frames (\code{lane2} and \code{lane3}) each with 1318
#' observations on the following two variables:
#'  \describe{
#'    \item{flow}{a numeric vector giving the traffic flow in vehicles per lane per hour.}
#'    \item{speed}{a numeric vector giving the speed in miles per hour.}
#' }
#' @references Einbeck, J., and Tutz, G. (2006). ``Modelling beyond regression
#' functions: an application of multimodal regression to speed-flow data''.
#' \emph{Journal of the Royal Statistical Society, Series C (Applied
#' Statistics)}, \bold{55}, 461-475.
#' @source Petty, K.F., Noeimi, H., Sanwal, K., Rydzewski, D., Skabardonis, A.,
#' Varaiya, P., and Al-Deek, H.  (1996). ``The Freeway Service Patrol
#' Evaluation Project: Database Support Programs, and Accessibility''.
#' \emph{Transportation Research Part C: Emerging Technologies}, \bold{4},
#' 71-85.
#'
#' The data is provided by courtesy of CALIFORNIA PATH, Institute of
#' Transportation Studies, University of California, Berkeley.
#' @keywords datasets
#' @examples
#'
#' plot(lane2)
#' plot(lane3)
"lane2"


#' Daily maximum temperatures in Melbourne, Australia
#'
#' Daily maximum temperatures in Melbourne, Australia, from 1981-1990. Leap
#' days have been omitted.
#'
#'
#' @format Time series of frequency 365.
#' @source Hyndman, R.J., Bashtannyk, D.M. and Grunwald, G.K. (1996)
#' "Estimating and visualizing conditional densities". \emph{Journal of
#' Computational and Graphical Statistics}, \bold{5}, 315-336.
#' @keywords datasets
#' @examples
#' plot(maxtemp)
#'
"maxtemp"



