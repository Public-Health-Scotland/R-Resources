# Posit Team Applications - Frequently Asked Questions

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform.

## Purpose

This document aims to answer frequently asked questions from users in relation to the use of Posit Team applications.

## Posit Workbench

### Accessing Posit Workbench

####  What web browser should I use?

Microsoft Edge is the recommended, and supported, web browser for accessing Posit Workbench.

### Installing Packages

#### How do I install the `{phsmethods}` package?

The `{phsmethods}` package has a dependency on the the `{gdata}` package.  The `{gdata}` package cannot be installed as a pre-compiled binary; attempting this gives an error.  Therefore, you need to force R to install the source version by specifying the URL for the source version of packages on Package Manager: 

```
install.packages("gdata", repos = c("https://ppm.publichealthscotland.org/phs-cran/latest"))
```

You can then install the `{phsmethods}` package and all of its other dependencies as follows:

```
install.packages("phsmethods")
```

## Posit Package Manager

### Accessing Posit Package Manager

####  What web browser should I use?

Microsoft Edge is the recommended, and supported, web browser for accessing Posit Package Manager.

## Posit Connect

### Accessing Posit Connect

####  What web browser should I use?

Microsoft Edge is the recommended, and supported, web browser for accessing Posit Connect.
