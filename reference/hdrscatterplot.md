# Scatterplot showing bivariate highest density regions

Produces a scatterplot where the points are coloured according to the
bivariate HDRs in which they fall.

## Usage

``` r
hdrscatterplot(
  x,
  y,
  levels = c(1, 50, 99),
  kde.package = c("ash", "ks"),
  noutliers = NULL,
  label = NULL
)
```

## Arguments

- x:

  Numeric vector or matrix with 2 columns.

- y:

  Numeric vector of same length as `x`.

- levels:

  Percentage coverage for HDRs

- kde.package:

  Package to be used in calculating the kernel density estimate when
  `den=NULL`.

- noutliers:

  Number of outliers to be labelled. By default, all points outside the
  largest HDR are labelled.

- label:

  Label of outliers of same length as `x` and `y`. By default, all
  outliers are labelled as the row index of the point `(x, y)`.

## Details

The bivariate density is estimated using kernel density estimation.
Either [`ash2`](https://rdrr.io/pkg/ash/man/ash2.html) or
[`kde`](https://rdrr.io/pkg/ks/man/kde.html) is used to do the
calculations. Then Hyndman's (1996) density quantile algorithm is used
to compute the HDRs. The scatterplot of (x,y) is created where the
points are coloured according to which HDR they fall. A ggplot object is
returned.

## See also

[`hdr.boxplot.2d`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.boxplot.2d.md)

## Author

Rob J Hyndman

## Examples

``` r
x <- c(rnorm(200, 0, 1), rnorm(200, 4, 1))
y <- c(rnorm(200, 0, 1), rnorm(200, 4, 1))
hdrscatterplot(x, y)
#> Warning: `aes_string()` was deprecated in ggplot2 3.0.0.
#> ℹ Please use tidy evaluation idioms with `aes()`.
#> ℹ See also `vignette("ggplot2-in-packages")` for more information.
#> ℹ The deprecated feature was likely used in the hdrcde package.
#>   Please report the issue at <https://github.com/robjhyndman/hdrcde/issues>.

hdrscatterplot(x, y, label = paste0("p", 1:length(x)))
```
