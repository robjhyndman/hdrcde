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

9 packages

|package         |version | errors| warnings| notes|
|:---------------|:-------|------:|--------:|-----:|
|ArchaeoPhases   |1.3     |      0|        0|     0|
|condvis         |0.4-2   |      0|        0|     0|
|curvHDR         |1.2-0   |      0|        1|     0|
|rainbow         |3.4     |      0|        0|     0|
|RChronoModel    |0.4     |      0|        0|     0|
|siar            |4.2     |      0|        0|     6|
|SIBER           |2.1.3   |      0|        0|     0|
|SimpleTable     |0.1-2   |      0|        1|     2|
|tRophicPosition |0.7.3   |      0|        0|     0|

## ArchaeoPhases (1.3)
Maintainer: Anne Philippe <anne.philippe@univ-nantes.fr>  
Bug reports: https://github.com/marieannevibet/ArchaeoPhases/issues

0 errors | 0 warnings | 0 notes

## condvis (0.4-2)
Maintainer: Mark O'Connell <mark_ajoc@yahoo.ie>  
Bug reports: https://github.com/markajoc/condvis/issues

0 errors | 0 warnings | 0 notes

## curvHDR (1.2-0)
Maintainer: Matt Wand <matt.wand@uts.edu.au>

0 errors | 1 warning  | 0 notes

```
checking whether package ‘curvHDR’ can be installed ... WARNING
Found the following significant warnings:
  Warning: no DISPLAY variable so Tk is not available
See ‘/home/hyndman/git/R/hdrcde/revdep/checks/curvHDR.Rcheck/00install.out’ for details.
```

## rainbow (3.4)
Maintainer: Han Lin Shang <hanlin.shang@anu.edu.au>

0 errors | 0 warnings | 0 notes

## RChronoModel (0.4)
Maintainer: Anne Philippe <anne.philippe@univ-nantes.fr>

0 errors | 0 warnings | 0 notes

## siar (4.2)
Maintainer: Andrew Parnell <Andrew.Parnell@ucd.ie>

0 errors | 0 warnings | 6 notes

```
checking package dependencies ... NOTE
Depends: includes the non-default packages:
  ‘hdrcde’ ‘coda’ ‘MASS’ ‘bayesm’ ‘mnormt’ ‘spatstat’
Adding so many packages to the search path is excessive and importing
selectively is preferable.

checking DESCRIPTION meta-information ... NOTE
Malformed Description field: should contain one or more complete sentences.

checking dependencies in R code ... NOTE
Packages in Depends field not imported from:
  ‘MASS’ ‘bayesm’ ‘coda’ ‘hdrcde’ ‘mnormt’ ‘spatstat’
  These packages need to be imported from (in the NAMESPACE file)
  for when this namespace is loaded but not attached.

checking R code for possible problems ... NOTE
Found an obsolete/platform-specific call in the following function:
  ‘newgraphwindow’
Found the platform-specific devices:
  ‘quartz’ ‘windows’ ‘x11’
dev.new() is the preferred way to open a new device, in the unlikely
event one is needed.
bayesMVN: no visible global function definition for ‘rmultireg’
bayestwoNorm: no visible global function definition for ‘runireg’
convexhull: no visible global function definition for ‘chull’
... 111 lines ...
Consider adding
  importFrom("grDevices", "chull", "devAskNewPage", "gray", "quartz",
             "x11")
  importFrom("graphics", "axis", "close.screen", "contour", "hist",
             "legend", "lines", "mtext", "pairs", "par", "plot",
             "points", "polygon", "rect", "screen", "split.screen",
             "strwidth", "text")
  importFrom("stats", "bw.nrd0", "cor", "cov", "cov2cor", "median",
             "pnorm", "qf", "sd")
  importFrom("utils", "menu", "read.table")
to your NAMESPACE file.

checking Rd line widths ... NOTE
Rd file 'siarmcmcdirichletv4.Rd':
  \usage lines wider than 90 characters:
     siarmcmcdirichletv4(data, sources, corrections = 0, concdep = 0, iterations=200000, burnin=50000, howmany=10000, thinby=15, prior = rep ... [TRUNCATED]

Rd file 'siarplotdata.Rd':
  \usage lines wider than 90 characters:
     siarplotdata(siardata, siarversion = 0, grp=1:siardata$numgroups,panel=NULL,isos=c(0,0),leg=1)

Rd file 'siarproportionbygroupplot.Rd':
  \usage lines wider than 90 characters:
     siarproportionbygroupplot(siardata, siarversion=0,probs=c(95,75,50),xlabels=NULL, grp=NULL, type="boxes",clr=gray((9:1)/10),scl=1,xspc= ... [TRUNCATED]

Rd file 'siarproportionbysourceplot.Rd':
  \usage lines wider than 90 characters:
     siarproportionbysourceplot(siardata, siarversion=0,probs=c(95,75,50),xlabels=NULL, grp=NULL, type="boxes",clr=gray((9:1)/10),scl=1,xspc ... [TRUNCATED]

Rd file 'siarsolomcmcv4.Rd':
  \usage lines wider than 90 characters:
     siarsolomcmcv4(data, sources, corrections = 0, concdep = 0, iterations=200000, burnin=50000, howmany=10000, thinby=15, prior = rep(1, n ... [TRUNCATED]

These lines will be truncated in the PDF manual.

checking compiled code ... NOTE
File ‘siar/libs/siar.so’:
  Found no calls to: ‘R_registerRoutines’, ‘R_useDynamicSymbols’

It is good practice to register native routines and to disable symbol
search.

See ‘Writing portable packages’ in the ‘Writing R Extensions’ manual.
```

## SIBER (2.1.3)
Maintainer: Andrew Jackson <a.jackson@tcd.ie>

0 errors | 0 warnings | 0 notes

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

## tRophicPosition (0.7.3)
Maintainer: Claudio Quezada-Romegialli <clquezada@harrodlab.net>  
Bug reports: https://groups.google.com/d/forum/trophicposition-support

0 errors | 0 warnings | 0 notes

