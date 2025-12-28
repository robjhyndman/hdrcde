# Plots highest density regions continuously over some conditioned variable.

Plots highest density regions continuously over some conditioned
variable.

## Usage

``` r
# S3 method for class 'hdrcde'
plot(
  x,
  plot.modes = TRUE,
  mden,
  threshold = 0.05,
  xlim,
  ylim,
  xlab,
  ylab,
  border = TRUE,
  font = 1,
  cex = 1,
  ...
)
```

## Arguments

- x:

  Output from
  [`hdr.cde()`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.cde.md).

- plot.modes:

  Should modes be plotted as well as HDRs?

- mden:

  Marginal density in the `x` direction. When small, the HDRs won't be
  plotted. Default is uniform so all HDRs are plotted.

- threshold:

  Threshold for margin density. HDRs are not plotted if the margin
  density `mden` is lower than this value.

- xlim:

  Limits for x-axis.

- ylim:

  Limits for y-axis.

- xlab:

  Label for x-axis.

- ylab:

  Label for y-axis.

- border:

  Show border of polygons

- font:

  Font to be used in plot.

- cex:

  Size of characters.

- ...:

  Other arguments passed to plotting functions.

## Value

None.

## References

Hyndman, R.J., Bashtannyk, D.M. and Grunwald, G.K. (1996) "Estimating
and visualizing conditional densities". *Journal of Computational and
Graphical Statistics*, **5**, 315-336.

## See also

[`hdr.cde()`](https://pkg.robjhyndman.com/hdrcde/reference/hdr.cde.md),
[`cde()`](https://pkg.robjhyndman.com/hdrcde/reference/cde.md),

## Author

Rob J Hyndman

## Examples

``` r
faithful.cde <- cde(faithful$waiting, faithful$eruptions)
faithful.hdr <- hdr.cde(faithful.cde, prob = c(0.50, 0.95), plot = FALSE)
plot(faithful.hdr, xlab = "Waiting time", ylab = "Duration time")
```
