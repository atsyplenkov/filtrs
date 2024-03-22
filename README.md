
<!-- README.md is generated from README.Rmd. Please edit that file -->

# filtrs

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/filtrs)](https://CRAN.R-project.org/package=filtrs)
![GitHub R package
version](https://img.shields.io/github/r-package/v/atsyplenkov/filtrs?label=github)
![GitHub last
commit](https://img.shields.io/github/last-commit/atsyplenkov/filtrs)
<!-- badges: end -->

## Installation

You can install the development version of `filtrs` like so:

``` r
#install.packages(pak)
pak::pak("atsyplenkov/filtrs")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(filtrs)
## basic example code

data("airquality")

airquality$Ozone_smooth <- 
 fil_wt(as.double(airquality$Ozone), 10, 2)

plot(airquality$Ozone, type = "l", xlab = "Days", ylab = "Ozone")
lines(airquality$Ozone_smooth, co = "red")
```

<img src="man/figures/README-example-1.png" width="100%" />
