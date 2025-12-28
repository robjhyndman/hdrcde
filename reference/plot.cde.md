# Plots conditional densities

Produces stacked density plots or highest density region plots for a
univariate density conditional on one covariate.

## Usage

``` r
# S3 method for class 'cde'
plot(
  x,
  firstvar = 1,
  mfrow = n2mfrow(dim(x$z)[firstvar]),
  plot.fn = "stacked",
  x.name,
  margin = NULL,
  ...
)
```

## Arguments

- x:

  Output from
  [`cde()`](https://pkg.robjhyndman.com/hdrcde/reference/cde.md).

- firstvar:

  If there is more than one conditioning variable, `firstvar` specifies
  which variable to fix first.

- mfrow:

  If there is more than one conditioning variable, `mfrow` is passed to
  [`graphics::par()`](https://rdrr.io/r/graphics/par.html) before
  plotting.

- plot.fn:

  Specifies which plotting function to use: "stacked" results in stacked
  conditional densities and "hdr" results in highest density regions.

- x.name:

  Name of x (conditioning) variable for use on x-axis.

- margin:

  Marginal density of conditioning variable. If present, only
  conditional densities corresponding to non-negligible marginal
  densities will be plotted.

- ...:

  Additional arguments to plot.

## Value

If `plot.fn=="stacked"` and there is only one conditioning variable, the
function returns the output from
[`graphics::persp()`](https://rdrr.io/r/graphics/persp.html). If
`plot.fn=="hdr"` and there is only one conditioning variable, the
function returns the output from
[`hdr.cde()`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.cde.md).
When there is more than one conditioning variable, nothing is returned.

## References

Hyndman, R.J., Bashtannyk, D.M. and Grunwald, G.K. (1996) "Estimating
and visualizing conditional densities". *Journal of Computational and
Graphical Statistics*, **5**, 315-336.

## See also

[`hdr.cde()`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.cde.md),
[`cde()`](https://pkg.robjhyndman.com/hdrcde/reference/cde.md),
[`hdr()`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.md)

## Author

Rob J Hyndman

## Examples

``` r
faithful.cde <- cde(faithful$waiting, faithful$eruptions,
  x.name = "Waiting time", y.name = "Duration time"
)
plot(faithful.cde)

plot(faithful.cde, plot.fn = "hdr")
```
