# Bandwidth calculation for conditional density estimation

Calculates bandwidths for kernel conditional density estimates. Methods
described in Bashtannyk and Hyndman (2001) and Hyndman and Yao (2002).

## Usage

``` r
cde.bandwidths(
  x,
  y,
  deg = 0,
  link = "identity",
  method = 1,
  y.margin,
  passes = 2,
  ngrid = 8,
  min.a = NULL,
  ny = 25,
  use.sample = FALSE,
  GCV = TRUE,
  b = NULL,
  ...
)
```

## Arguments

- x:

  Numerical vector: the conditioning variable.

- y:

  Numerical vector: the response variable.

- deg:

  Degree of local polynomial used in estimation.

- link:

  Link function used in estimation. Default "identity". The other
  possibility is "log" which is recommended if degree \> 0.

- method:

  method = 1:

  :   Hyndman-Yao algorithm if deg\>0; Bashtannyk-Hyndman algorithm if
      deg=0;

  method = 2:

  :   Normal reference rules;

  method = 3:

  :   Bashtannyk-Hyndman regression method if deg=0;

  method = 4:

  :   Bashtannyk-Hyndman bootstrap method if deg=0.

- y.margin:

  Values in y-space on which conditional density is calculated. If not
  specified, an equi-spaced grid of 50 values over the range of y is
  used.

- passes:

  Number of passes through Bashtannyk-Hyndman algorithm.

- ngrid:

  Number of values of smoothing parameter in grid.

- min.a:

  Smallest value of a to consider if method=1.

- ny:

  Number of values to use for y margin if `y.margin` is missing.

- use.sample:

  Used when regression method (3) is chosen.

- GCV:

  Generalized cross-validation. Used only if method=1 and deg\>0. If
  GCV=FALSE, method=1 and deg=0, then the AIC is used instead. The
  argument is ignored if deg=0 or method\>1.

- b:

  Value of b can be specified only if method=1 and deg\>0. For deg=0 or
  method\>1, this argument is ignored.

- ...:

  Other arguments control details for individual methods.

## Value

- a:

  Window width in `x` direction.

- b:

  Window width in `y` direction.

## Details

Details of the various algorithms are in Bashtannyk and Hyndman (2001)
and Hyndman and Yao (2002).

## References

Hyndman, R.J., Bashtannyk, D.M. and Grunwald, G.K. (1996) "Estimating
and visualizing conditional densities". *Journal of Computational and
Graphical Statistics*, **5**, 315-336.

Bashtannyk, D.M., and Hyndman, R.J. (2001) "Bandwidth selection for
kernel conditional density estimation". *Computational statistics and
data analysis*, **36**(3), 279-298.

Hyndman, R.J. and Yao, Q. (2002) "Nonparametric estimation and symmetry
tests for conditional density functions". *Journal of Nonparametric
Statistics*, **14**(3), 259-278.

## See also

[`cde()`](https://pkg.robjhyndman.com/hdrcde/reference/cde.md)

## Author

Rob J Hyndman

## Examples

``` r
bands <- cde.bandwidths(faithful$waiting, faithful$eruptions, method = 2)
plot(cde(faithful$waiting, faithful$eruptions, a = bands$a, b = bands$b))
```
