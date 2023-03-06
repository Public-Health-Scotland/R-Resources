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

#### How do I install the `{phsmethods}` package?

The `{phsmethods}` package has a dependency on the the `{gdata}` package.  The `{gdata}` package cannot be installed as a pre-compiled binary; attempting this gives an error.  Therefore, you need to force R to install the source version by specifying the URL for the source version of packages on Package Manager: 

```
install.packages("gdata", repos = c("https://ppm.publichealthscotland.org/phs-cran/latest"))
```

You can then install the `{phsmethods}` package and all of its other dependencies as follows:

```
install.packages("phsmethods")
```

#### How do I install and use geospatial packages?

##### Setting environment variables

For R packages to find the geospatial libraries, the session's environment variables need to be updated to point to where the geospatial libraries are installed:

```r
old_ld_path <- Sys.getenv("LD_LIBRARY_PATH") 

Sys.setenv(LD_LIBRARY_PATH = paste(old_ld_path,
                                   "/usr/gdal34/lib",
                                   "/usr/proj81/lib",
                                   sep = ":"))

# Specify additional proj path in which pkg-config should look for .pc files
Sys.setenv("PKG_CONFIG_PATH" = "/usr/proj81/lib/pkgconfig")

# Specify the path to GDAL data
Sys.setenv("GDAL_DATA" = "/usr/gdal34/share/gdal")
```

The above code should be run first before anything else.  It would be a good idea to include the above code in a project-level `.Rprofile` file so that it is run every time the project is loaded.

##### Installing the `{sf}` and `{sp}` packages

Both the `{sf}` and `{sp}` packages require to be installed from source, and pointed to where the GDAL and PROJ libraries are installed:

```r
install.packages(
    c("sf", "sp"),
    configure.args = c("--with-gdal-config=/usr/gdal34/bin/gdal-config",
                       "--with-proj-include=/usr/proj81/include",
                       "--with-proj-lib=/usr/proj81/lib"),
    INSTALL_opts = "--no-test-load",
    repos = c("https://ppm.publichealthscotland.org/all-r/latest")
)
```

##### Installing the `{rgeos}` package

The `{rgeos}` package needs to be installed from source, as follows:

```r
install.packages("rgeos", repos = c("https://ppm.publichealthscotland.org/all-r/latest"))
```

##### Loading geospatial R packages

It is necessary to load the GDAL library module before loading the `{sf}` package

```r
dyn.load("/usr/gdal34/lib/libgdal.so")
library(sf)
```

Otherwise, geospatial R packages can be loaded as normal, with calls to the `library()` function.

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
