# Speed-Flow data for Californian Freeway

These are two data sets collected in 1993 on two individual lanes (lane
2 and lane 3) of the 4-lane Californian freeway I-880. The data were
collected by loop detectors, and the time units are 30 seconds per
observation (see Petty et al., 1996, for details).

## Usage

``` r
lane2; lane3
```

## Format

Two data frames (`lane2` and `lane3`) each with 1318 observations on the
following two variables:

- flow:

  a numeric vector giving the traffic flow in vehicles per lane per
  hour.

- speed:

  a numeric vector giving the speed in miles per hour.

## Source

Petty, K.F., Noeimi, H., Sanwal, K., Rydzewski, D., Skabardonis, A.,
Varaiya, P., and Al-Deek, H. (1996). “The Freeway Service Patrol
Evaluation Project: Database Support Programs, and Accessibility”.
*Transportation Research Part C: Emerging Technologies*, **4**, 71-85.

The data is provided by courtesy of CALIFORNIA PATH, Institute of
Transportation Studies, University of California, Berkeley.

## Details

The data is examined in Einbeck and Tutz (2006), using a nonparametric
approach to multi-valued regression based on conditional mean shift.

## References

Einbeck, J., and Tutz, G. (2006). “Modelling beyond regression
functions: an application of multimodal regression to speed-flow data”.
*Journal of the Royal Statistical Society, Series C (Applied
Statistics)*, **55**, 461-475.

## Examples

``` r
plot(lane2)

plot(lane3)
```
