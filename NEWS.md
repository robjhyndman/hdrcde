## Version 3.4
  * Bug fixes and documentation updates
  * Added labels to hdrscatterplot (thanks to Fan Cheng)

## Version 3.3
  * More options for hdr.boxplot (thanks to Simon Carrignon)
  * More flexible hdr.den plots (thanks to Simon Carrignon)
  * Fixed colours in hdrscatterplot
  
## Version 3.2
  * Updated hdr.den() to demonstrate the calculation of hdr more clearly (thanks to Dennis Freuer for the suggestion)
  * Added hdrscatterplot() function
  * Roxygenized the package
  * Added pkgdown site

## Version 3.1
  * Added dependency on mvtnorm to avoid problems with ks.

## Version 3.0
  * Reduced dependency on KernSmooth and changed ::: calls to ::
  * New functions hdr.2d() and plot.hdr2d() to return and plot bivariate HDR information.
  * Rewritten hdr.boxplot.2d() function.

## Version 2.16
  * Replaced .Internal() calls with new .filled.contour() function.

## Version 2.15
  * Added option to control limits of density estimate in hdr.boxplot.2d()

## Version 2.14
  * Updated references for hdrbw().

## Version 2.13
	* Added color options to hdr.boxplot.2d().

## Version 2.12
	* Modified hdr(), hdr.boxplot() and hdr.den() to allow a Box-Cox transformation to be used when computing the density. This allows the density estimate to be non-zero only on the positive real line.

## Version 2.11
  * Added hdrbw() from Matt Wand to compute better bandwidths for hdr(), hdr.den() and hdr.boxplot().
  * Fixed a few bugs in the help files.

## Version 2.10
  * Bug fix in hdr.boxplot.2d(). The show.points option was not working.

## Version 2.09
  * Bug fix: the a bandwidth in cde() when fw=TRUE and use.locfit=TRUE was twice as large as it should have been.

## Version 2.08
    * Bug fix in hdr.boxplot.2d(). It would sometimes plot outliers on a separate plot.
    * New argument to hdr.boxplot.2d() to allow the density to be estimated using the kde() function from the ks package.
