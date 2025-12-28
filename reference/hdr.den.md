# Density plot with Highest Density Regions

Plots univariate density with highest density regions displayed

## Usage

``` r
hdr.den(
  x,
  prob = c(0.5, 0.95, 0.99),
  den,
  h = hdrbw(BoxCox(x, lambda), mean(prob)),
  lambda = 1,
  xlab = NULL,
  ylab = "Density",
  ylim = NULL,
  plot.lines = TRUE,
  col = 2:8,
  bgcol = "gray",
  legend = FALSE,
  ...
)
```

## Arguments

- x:

  Numeric vector containing data. If `x` is missing then `den` must be
  provided, and the HDR is computed from the given density.

- prob:

  Probability coverage required for HDRs

- den:

  Density of data as list with components `x` and `y`. If omitted, the
  density is estimated from `x` using
  [`stats::density()`](https://rdrr.io/r/stats/density.html).

- h:

  Optional bandwidth for calculation of density.

- lambda:

  Box-Cox transformation parameter where \\0 \le \lambda \le 1\\.

- xlab:

  Label for x-axis.

- ylab:

  Label for y-axis.

- ylim:

  Limits for y-axis.

- plot.lines:

  If `TRUE`, will show how the HDRs are determined using lines.

- col:

  Colours for regions.

- bgcol:

  Colours for the background behind the boxes. Default `"gray"`, if
  `NULL` no box is drawn.

- legend:

  If `TRUE` add a legend on the right of the boxes.

- ...:

  Other arguments passed to plot.

## Value

a list of three components:

- hdr:

  The endpoints of each interval in each HDR

- mode:

  The estimated mode of the density.

- falpha:

  The value of the density at the boundaries of each HDR.

## Details

Either `x` or `den` must be provided. When `x` is provided, the density
is estimated using kernel density estimation. A Box-Cox transformation
is used if `lambda!=1`, as described in Wand, Marron and Ruppert (1991).
This allows the density estimate to be non-zero only on the positive
real line. The default kernel bandwidth `h` is selected using the
algorithm of Samworth and Wand (2010).

Hyndman's (1996) density quantile algorithm is used for calculation.

## References

Hyndman, R.J. (1996) Computing and graphing highest density regions.
*American Statistician*, **50**, 120-126.

Samworth, R.J. and Wand, M.P. (2010). Asymptotics and optimal bandwidth
selection for highest density region estimation. *The Annals of
Statistics*, **38**, 1767-1792.

Wand, M.P., Marron, J S., Ruppert, D. (1991) Transformations in density
estimation. *Journal of the American Statistical Association*, **86**,
343-353.

## See also

[`hdr()`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.md),
[`hdr.boxplot()`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.boxplot.md)

## Author

Rob J Hyndman

## Examples

``` r
# Old faithful eruption duration times
hdr.den(faithful$eruptions)

#> Highest Density Regions
#>   50%: [1.923, 2.024], [3.944, 4.771]
#>   95%: [1.501, 2.521], [3.500, 5.091]
#>   99%: [1.324, 2.819], [3.151, 5.282]
#> 
#> f-alpha values: 0.3622 0.1526 0.06702
#> Mode: 4.381

# Simple bimodal example
x <- c(rnorm(100, 0, 1), rnorm(100, 5, 1))
hdr.den(x)

#> Highest Density Regions
#>   50%: [-0.4301, 1.090], [4.340, 5.606]
#>   95%: [-1.518, 6.710], [   NA,    NA]
#>   99%: [-2.226, 7.392], [   NA,    NA]
#> 
#> f-alpha values: 0.1057 0.07410 0.04932
#> Mode: 0.2942
```
