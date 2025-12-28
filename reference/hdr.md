# Highest Density Regions

Calculates highest density regions in one dimension

## Usage

``` r
hdr(
  x = NULL,
  prob = c(0.5, 0.95, 0.99),
  den = NULL,
  h = hdrbw(BoxCox(x, lambda), mean(prob)),
  lambda = 1,
  nn = 5000,
  all.modes = FALSE
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

- nn:

  Number of random numbers used in computing f-alpha quantiles.

- all.modes:

  Return all local modes or just the global mode?

## Value

A list of three components:

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

[`hdr.den()`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.den.md),
[`hdr.boxplot()`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.boxplot.md)

## Author

Rob J Hyndman

## Examples

``` r
# Old faithful eruption duration times
hdr(faithful$eruptions)
#> Highest Density Regions
#>   50%: [1.923, 2.025], [3.942, 4.772]
#>   95%: [1.501, 2.521], [3.500, 5.092]
#>   99%: [1.324, 2.819], [3.152, 5.282]
#> 
#> f-alpha values: 0.3610 0.1529 0.06747
#> Mode: 4.378
```
