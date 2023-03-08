# Posit Team Applications - Frequently Asked Questions

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform.

## Purpose

This document aims to answer frequently asked questions from users in relation to the use of Posit Team applications.

## Posit Workbench

### Accessing Posit Workbench

####  What web browser should I use?

Microsoft Edge is the recommended, and supported, web browser for accessing Posit Workbench.

#### Do I need to be connected to the VPN?

If you are working remotely, yes: ensure that when you login to Windows that you first connect to the VPN by selecting "vpn1.nss.scot" or "vpn2.nss.scot".  If these VPN servers are not available to you, please raise a call to have this rectified in [ServiceNow](https://nhsnss.service-now.com/phs/).

### Installing Packages

#### How do I install the `{hablar}` package?

The `{hablar}` package cannot be installed as a pre-compiled binary; attempting this gives an error.  Therefore, you need to force R to install the source version by specifying the URL for the source version of packages on Package Manager.  However, `{hablar}`'s dependencies can be installed as binaries first.

```r
# Get list of dependencies and imports for {hablar}
available_pkgs <- available.packages()

deps <- tools::package_dependencies(
  packages = available_pkgs["hablar", "Package"],
  recursive = TRUE)[[1]]

# Install these dependencies as binaries
install.packages(
  pkgs = deps,
  repos = c(
    "https://ppm.publichealthscotland.org/all-r/__linux__/centos7/latest"))

# Compile and install the {hablar} package from source
install.packages(
  pkgs = "hablar",
  repos = c("https://ppm.publichealthscotland.org/all-r/latest"))

# Test if {hablar} can be loaded
library(hablar)
```

#### How do I install the `{phsmethods}` package?

The `{phsmethods}` package has a dependency on the the `{gdata}` package.  The `{gdata}` package cannot be installed as a pre-compiled binary; attempting this gives an error.  Therefore, you need to force R to install the source version by specifying the URL for the source version of packages on Package Manager: 

```
install.packages("gdata", repos = c("https://ppm.publichealthscotland.org/phs-cran/latest"))
```

You can then install the `{phsmethods}` package and all of its other dependencies as follows:

```
install.packages("phsmethods")
```

#### I can't install / use a package because it needs `{rJava}`

Some packages, e.g. `{xlsx}`, `{XLconnect}`, depend on an installation of [Java](https://en.wikipedia.org/wiki/Java_(software_platform)) in order to work.  There are no current or future plans to support Java on Posit Workbench.  Alternative packages such as `{openxlsx}` that do not rely on Java should be used instead.

### Projects

#### What is a project (in Posit Workbench)?

Projects in Posit Workbench allow you to divide your work into different working directories, each with their own workspace, history, and source code files.  A project directory will, as a minimum, contain a single file with a .Rproj extension.  This file will often have the same name as the parent directory.  It's this .Rproj file that tells Posit Workbench that this directory and all of its contents belong to a single project.

#### How do I open or switch to another project?

Posit Workbench provides several ways to open or switch to another project, but only one way works consistently without producing an error.  Please ensure that you always follow these steps to open a project:

1. If you do not already have a Posit Workbench session open, or you want to open the project in a new Posit Workbench session, please first of all open a new Posit Workbench session.
2. Once the session has started, navigate to the 'File' menu and select "Open Project..."
3. Use the file browser to navigate to the directory that contains your project.
4. Select the .Rproj file in the project directory.
5. Click the "Open Project" button.

Posit Workbench will then

* Restart the current session on the Kubernetes cluster, configured with the same number of CPUs and memory requested when the session was first started.
* Set the current working directory to the project directory.

!!! IMPORTANT !!!

Please do not attempt to switch to another project using the 'Project' drop down menu at the top-right of the Posit Workbench interface:

![image](https://user-images.githubusercontent.com/45657289/215759371-64028dc2-a02e-4779-91c9-6bacf1369244.png)

Doing so will almost always result in the following error:

![image](https://user-images.githubusercontent.com/45657289/215759609-fa3ecbd3-36fc-4985-8abe-bd05af07bba4.png)

This is a [known issue](https://github.com/rstudio/rstudio/issues/11914) in older versions of Posit Workbench which will likely be fixed when the Posit Workbench environment is next updated.

## Posit Package Manager

### Accessing Posit Package Manager

####  What web browser should I use?

Microsoft Edge is the recommended, and supported, web browser for accessing Posit Package Manager.

## Posit Connect

### Accessing Posit Connect

####  What web browser should I use?

Microsoft Edge is the recommended, and supported, web browser for accessing Posit Connect.
