# HDRs with confidence intervals

Calculates Highest Density Regions with confidence intervals.

## Usage

``` r
hdrconf(x, den, prob = 0.9, conf = 0.95)
```

## Arguments

- x:

  Numeric vector containing data.

- den:

  Density of data as list with components `x` and `y`.

- prob:

  Probability coverage for for HDRs.

- conf:

  Confidence for limits on HDR.

## Value

`hdrconf` returns list containing the following components:

- hdr:

  Highest density regions

- hdr.lo:

  Highest density regions corresponding to lower confidence limit.

- hdr.hi:

  Highest density regions corresponding to upper confidence limit.

- falpha:

  Values of \\f\_\alpha\\ corresponding to HDRs.

- falpha.ci:

  Values of \\f\_\alpha\\ corresponding to lower and upper limits.

## References

Hyndman, R.J. (1996) Computing and graphing highest density regions
*American Statistician*, **50**, 120-126.

## See also

[`hdr()`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.md),
[`plot.hdrconf()`](https://pkg.robjhyndman.com/hdrcde/reference/plot.hdrconf.md)

## Author

Rob J Hyndman

## Examples

``` r
x <- c(rnorm(100, 0, 1), rnorm(100, 4, 1))
den <- density(x, bw = hdrbw(x, 50))
hdr_conf <- hdrconf(x, den)
plot(hdr_conf, den, main = "50% HDR with 95% CI")
```
