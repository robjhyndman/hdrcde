# Box Cox Transformation

BoxCox() returns a transformation of the input variable using a Box-Cox
transformation. InvBoxCox() reverses the transformation.

## Usage

``` r
BoxCox(x, lambda)
```

## Arguments

- x:

  a numeric vector or time series

- lambda:

  transformation parameter

## Value

a numeric vector of the same length as x.

## Details

The Box-Cox transformation is given by \$\$f\_\lambda(x)
=\frac{x^\lambda - 1}{\lambda}\$\$ if \\\lambda\ne0\\. For
\\\lambda=0\\, \$\$f_0(x) = \log(x).\$\$

## References

Box, G. E. P. and Cox, D. R. (1964) An analysis of transformations.
*JRSS B* **26** 211–246.

## Author

Rob J Hyndman
