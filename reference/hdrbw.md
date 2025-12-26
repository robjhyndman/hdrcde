# Highest Density Region Bandwidth

Estimates the optimal bandwidth for 1-dimensional highest density
regions

## Usage

``` r
hdrbw(x, HDRlevel, gridsize = 801, nMChdr = 1e+06, graphProgress = FALSE)
```

## Arguments

- x:

  Numerical vector containing data.

- HDRlevel:

  HDR-level as defined in Hyndman (1996). Setting \`HDRlevel' equal to p
  (0\<p\<1) corresponds to a probability of 1-p of inclusion in the
  highest density region.

- gridsize:

  the number of equally spaced points used for binned kernel density
  estimation.

- nMChdr:

  the size of the Monte Carlo sample used for density quantile
  approximation of the highest density region, as described in Hyndman
  (1996).

- graphProgress:

  logical flag: if \`TRUE' then plots showing the progress of the
  bandwidth selection algorithm are produced.

## Value

A numerical vector of length 1.

## Details

This is a plug-in rule for bandwidth selection tailored to highest
density region estimation

## References

Hyndman, R.J. (1996). Computing and graphing highest density regions.
*The American Statistician*, **50**, 120-126.

Samworth, R.J. and Wand, M.P. (2010). Asymptotics and optimal bandwidth
selection for highest density region estimation. *The Annals of
Statistics*, **38**, 1767-1792.

## Author

Matt Wand

## Examples

``` r
HDRlevelVal <- 0.55
x <- faithful$eruptions
hHDR <- hdrbw(x,HDRlevelVal)
HDRhat <- hdr.den(x,prob=100*(1-HDRlevelVal),h=hHDR)
```
