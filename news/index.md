# Changelog

## hdrcde (development version)

- Added print methods for hdr2d, hdrconf and hdrcde
- Added plot method for hdrcde
- Improved docs
- Added unit tests
- Bug fixes and documentation updates

## hdrcde 3.4

CRAN release: 2021-01-18

- Bug fixes and documentation updates
- Added labels to hdrscatterplot (thanks to Fan Cheng)

## hdrcde 3.3

CRAN release: 2018-12-21

- More options for hdr.boxplot (thanks to Simon Carrignon)
- More flexible hdr.den plots (thanks to Simon Carrignon)
- Fixed colours in hdrscatterplot

## hdrcde 3.2

CRAN release: 2018-01-29

- Updated hdr.den() to demonstrate the calculation of hdr more clearly
  (thanks to Dennis Freuer for the suggestion)
- Added hdrscatterplot() function
- Roxygenized the package
- Added pkgdown site

## hdrcde 3.1

CRAN release: 2013-10-19

- Added dependency on mvtnorm to avoid problems with ks.

## hdrcde 3.0

CRAN release: 2013-08-28

- Reduced dependency on KernSmooth and changed ::: calls to ::
- New functions hdr.2d() and plot.hdr2d() to return and plot bivariate
  HDR information.
- Rewritten hdr.boxplot.2d() function.

## hdrcde 2.16

CRAN release: 2012-03-30

- Replaced .Internal() calls with new .filled.contour() function.

## hdrcde 2.15

CRAN release: 2010-11-11

- Added option to control limits of density estimate in hdr.boxplot.2d()

## hdrcde 2.14

CRAN release: 2010-04-20

- Updated references for hdrbw().

## hdrcde 2.13

CRAN release: 2010-01-26

``` R
* Added color options to hdr.boxplot.2d().
```

## hdrcde 2.12

CRAN release: 2009-10-13

``` R
* Modified hdr(), hdr.boxplot() and hdr.den() to allow a Box-Cox transformation to be used when computing the density. This allows the density estimate to be non-zero only on the positive real line.
```

## hdrcde 2.11

CRAN release: 2009-09-18

- Added hdrbw() from Matt Wand to compute better bandwidths for hdr(),
  hdr.den() and hdr.boxplot().
- Fixed a few bugs in the help files.

## hdrcde 2.10

CRAN release: 2009-08-19

- Bug fix in hdr.boxplot.2d(). The show.points option was not working.

## hdrcde 2.09

CRAN release: 2008-11-20

- Bug fix: the a bandwidth in cde() when fw=TRUE and use.locfit=TRUE was
  twice as large as it should have been.

## hdrcde 2.08

CRAN release: 2008-10-08

- Bug fix in hdr.boxplot.2d(). It would sometimes plot outliers on a
  separate plot.
- New argument to hdr.boxplot.2d() to allow the density to be estimated
  using the kde() function from the ks package.
