# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.4.3 (2017-11-30) |
|system   |x86_64, linux-gnu            |
|ui       |RStudio (1.1.414)            |
|language |en_AU:en                     |
|collate  |en_AU.UTF-8                  |
|tz       |Australia/Victoria           |
|date     |2018-01-29                   |

## Packages

|package      |*  |version |date       |source                        |
|:------------|:--|:-------|:----------|:-----------------------------|
|ash          |   |1.0-15  |2015-09-01 |cran (@1.0-15)                |
|ggplot2      |   |2.2.1   |2016-12-30 |cran (@2.2.1)                 |
|hdrcde       |   |3.2     |2018-01-28 |local (robjhyndman/hdrcde@NA) |
|ks           |   |1.11.0  |2018-01-16 |cran (@1.11.0)                |
|locfit       |   |1.5-9.1 |2013-04-20 |cran (@1.5-9.1)               |
|RColorBrewer |   |1.1-2   |2014-12-07 |cran (@1.1-2)                 |

# Check results

2 packages with problems

|package     |version | errors| warnings| notes|
|:-----------|:-------|------:|--------:|-----:|
|curvHDR     |1.2-0   |      0|        1|     0|
|SimpleTable |0.1-2   |      0|        1|     2|

## curvHDR (1.2-0)
Maintainer: Matt Wand <matt.wand@uts.edu.au>

0 errors | 1 warning  | 0 notes

```
checking whether package ‘curvHDR’ can be installed ... WARNING
Found the following significant warnings:
  Warning: no DISPLAY variable so Tk is not available
See ‘/home/hyndman/git/R/hdrcde/revdep/checks/curvHDR.Rcheck/00install.out’ for details.
```

## SimpleTable (0.1-2)
Maintainer: Kevin M. Quinn <kquinn@law.berkeley.edu>

0 errors | 1 warning  | 2 notes

```
checking whether package ‘SimpleTable’ can be installed ... WARNING
Found the following significant warnings:
  Warning: no DISPLAY variable so Tk is not available
See ‘/home/hyndman/git/R/hdrcde/revdep/checks/SimpleTable.Rcheck/00install.out’ for details.

checking top-level files ... NOTE
File
  LICENSE
is not mentioned in the DESCRIPTION file.
Non-standard file/directory found at top level:
  ‘HISTORY’

checking R code for possible problems ... NOTE
ConfoundingPlot.Control: no visible global function definition for
  ‘layout’
ConfoundingPlot.Control: no visible global function definition for
  ‘par’
ConfoundingPlot.Control: no visible global function definition for
  ‘plot’
ConfoundingPlot.Control: no visible global function definition for
  ‘text’
ConfoundingPlot.Control: no visible global function definition for
... 123 lines ...
  ‘quantile’
Undefined global functions or variables:
  abline arrows axis b00 b01 b10 b11 c00 c01 c10 c11 chull dbeta layout
  lines mtext na.omit par plot polygon predict quantile rbeta sd text
Consider adding
  importFrom("grDevices", "chull")
  importFrom("graphics", "abline", "arrows", "axis", "layout", "lines",
             "mtext", "par", "plot", "polygon", "text")
  importFrom("stats", "dbeta", "na.omit", "predict", "quantile", "rbeta",
             "sd")
to your NAMESPACE file.
```

