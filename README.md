# hdrcde: Highest Density Regions and Conditional Density Estimation

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/hdrcde)](https://cran.r-project.org/package=hdrcde)
[![Downloads](http://cranlogs.r-pkg.org/badges/hdrcde)](https://cran.r-project.org/package=hdrcde)
[![Licence](https://img.shields.io/badge/licence-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

The R package *hdrcde* provides tools for computing highest density regions in one and two dimensions, kernel estimates of univariate density functions conditional on one covariate, and multimodal regression.

Author: Rob J Hyndman with contributions from Jochen Einbeck and Matt Wand

This package implements the methods described in

 * [Rob J Hyndman (1996) Computing and graphing highest density regions. *American Statistician*, **50**, 120-126.](/publications/computing-and-graphing-highest-density-regions/)
 * [Rob J Hyndman and David Bashtannyk (1996) Estimating and visualizing conditional densities. *Journal of Computational and Graphical Statistics*, **5**, 315-336.](/publications/estimating-and-visualizing-conditional-densities/)
 * [David Bashtannyk, Rob J Hyndman (2001) Bandwidth selection for kernel conditional density estimation. *Computational Statistics and Data Analysis* **36**(3), 279-298.](/publications/bandwidth-selection-for-kernel-conditional-density-estimation/)
 * [Rob J Hyndman and Qiwei Yao (2002) "Nonparametric estimation and symmetry tests for conditional density functions". *Journal of Nonparametric Statistics*, **14**(3), 259-278.](/publications/nonparametric-estimation-and-symmetry-tests-for-conditional-density-functions/)
 * Einbeck, J., and Tutz, G. (2006). "Modelling beyond regression functions: an application of multimodal regression to speed-flow data". *Journal of the Royal Statistical Society, Series C*, **55**, 461-475.
 * Richard J Samworth and Matthew P Wand (2010) Asymptotics and optimal bandwidth  selection for highest density region estimation.  *The Annals of Statistics*, **38**, 1767-1792.


## Installation
You can install the **stable** version on
[R CRAN](https://cran.r-project.org/package=hdrcde).

```r
install.packages('hdrcde', dependencies = TRUE)
```

You can install the **development** version from
[Github](https://github.com/robjhyndman/hdrcde)

```r
# install.packages("devtools")
devtools::install_github("robjhyndman/hdrcde")
```

## License

This package is free and open source software, licensed under GPL 3.
