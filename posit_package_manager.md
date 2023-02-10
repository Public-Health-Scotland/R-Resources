# Posit Package Manager

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform. The platform has been designed and implemented as a high-performance, high-availability analytical environment to support the work of Public Health Scotland.

## Purpose

This document aims to offer guidance to users on the [Posit Package Manager](https://posit.co/products/enterprise/package-manager/) application, including a brief introduction to what Posit Package Manager is, how a user might interact with the application and a summary of its benefits.

## Extending the funtionality of R and Python

The functionality of both [R](https://en.wikipedia.org/wiki/R_(programming_language)) and [Python](https://en.wikipedia.org/wiki/Python_(programming_language)) can be extended through the use of extensions.  In R, these are known as [packages](https://en.wikipedia.org/wiki/R_package), and in Python these can be either [modules or packages](https://dev.to/bowmanjd/python-module-vs-package-4m8e) (groups of modules).

Focussing on R, packages can generally either be downloaded from a [CRAN mirror](https://en.wikipedia.org/wiki/R_package#Comprehensive_R_Archive_Network_(CRAN)) or a [GitHub](https://en.wikipedia.org/wiki/GitHub) (or Github-like) repo.

## What is Posit Package Manager?

Posit Package Manager is an application that sits between an R session and a CRAN mirror and/or repos on GitHub hosting R packages.  Essentially, it allows an organisation such as Public Heath Scotland to organise and centralise R and Python packages.

## How is Posit Package Manager configured in Public Health Scotland?

Posit Package Manager has been configured to act as a CRAN mirror.  There are no restrictions on what packages can be installed via Posit Package Manager; everything available on any other CRAN mirror is also available via Posit Package Manager.

Two repos have been configured on Posit Package Manager:

* phs-cran - providing access to CRAN packages within Public Health Scotland
* all-r - providing access to all R packages available from CRAN and internally-developed packages (default)

In addition, Python users have access to the 'all-python' repo which provides all Python packages available from PyPI and internally-developed packages.

## What do I need to do be able to install packages from Posit Package Manager?

Absolutely nothing! :ok_hand:  Your R session in Posit Workbench is pre-configured to install packages from the 'all-r' repo by default.  Packages will also, by default, install as pre-compiled binary packages (if available).  This significantly reduces the amount of time it takes to install packages into your library. 🏎️

### Installing packages published on CRAN

Installing a package that is published on CRAN is as simple as providing the package name to the `install.packages()` function e.g.

```r
install.packages("tidyverse")
```

### Installing PHS packages e.g. `{phsmethods}`

PHS packages are now available through Posit Package Manager and can also be installed using the `install.packages()` function e.g.

```r
install.packages("phsmethods")
```

### Installing packages from source

If you are experiencing issues installing or using a pre-compiled binary package from Posit Package Manager, it could be worth trying to compile and install the package from source.  To do this, you need to supply an additional argument to the `install.packages()` function as follows:

```r
install.packages("gdata", repos = c("https://ppm.publichealthscotland.org/all-r/latest"))
```

The URL in the example above points to the "source" repo on Posit Workbench.
