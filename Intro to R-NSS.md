# Public Health & Intelligence <img align="right" src="https://www.aspenpeople.co.uk/immunology/images/logo.png" height="90px">

# Introduction to R in NSS

***

Type - documentation  
Written/run on - GitHub

***

## Table of contents

* [Introduction](#introduction)
* [Installation](#installation)
* [RStudio](#rstudio)
* [R particularities](#r-particularities)
  * [Scripts](#scripts)
  * [Objects](#objects)
  * [Functions](#functions)
  * [Data types](#data-types)
  * [Rounding](#rounding)
* [Packages](#packages)
  * [Install packages](#install-packages)
  * [Install previous versions of packages](#install-previous-versions-of-packages)
  * [Install packages from Github Offline](#install-packages-from-github-offline)
  * [Loading packages](#loading-packages)
  * [Most common packages](#most-common-packages)
* [Workspace](#workspace)
  * [Working directory and projects](#working-directory-and-projects)
* [Coding](#coding)
* [Getting help](#getting-help)
* [Load and save data](#load-and-save-data)
* [Connect to ODBC databases](#connect-to-odbc-databases)
* [Git](#git)
* [Useful resources](#useful-resources)


## Introduction 

The purpose of this document is to help new R users to set up the program and understand a few of the basic concepts behind this programming language. It will also cover some of the specific features of using R in NSS (Fig. 1). R tutorials and resources are widely and freely available on the Internet, so instead of duplicating efforts, this guide will point users towards some useful resources for each section. At the end of this document you will find a compilation of all of the links referenced throughout this document.  We have provided links to sites NSS staff have found helpful but there are many more resources available online.

<img src="https://imgur.com/hYOtPNI.png"  height="550px">

*Figure 1. Diagram summarizing the software infrastructure around R.*

## Installation

There are two ways you can use R: through a programme installed in your local computer (desktop) or through a version installed in an [NSS Server](http://nssrstudio.csa.scot.nhs.uk/). (server). 

To use R desktop you first need to ask CSD to install it for you. Request both R and RStudio as the latter makes writing programs/scripts a lot easier. RStudio is an interface to R. The latest version available for PHI is R 3.5.1 and RStudio 1.1.456 (October 2018). If you need to connect to SMRA databases using R desktop, you will need to specify that you need R Core 3.3.2 with SMRA ODBC collection. You need to install them from software center after IT has confirmed the availability.

If you want to use R server, please refer to the [R server guidelines](http://www.isdscotland.org/About-ISD/Methodologies/_docs/Using-R-with-SMRA-V1-0-FINAL.pdf). You will have to request a login -from CSD. The current R version for the server is 3.2.3 and for RStudio 0.99.896 (October 2018).

## RStudio
RStudio is a visual interface that facilitates the task of programming in R. This [short video](https://www.youtube.com/watch?v=5p04znmmgQ8) will guide you through the different parts and panels of the layout of RStudio.

One important thing to note is that any code you enter in the console panel and press enter will get automatically executed. If you write the same code in the source/script panel this will not run automatically. You will have to select it and press run or Ctrl+R. As a general rule, write your code in a script.

The appearance and layout of R/RStudio can be customized, for example panel sizes can be modified or color schemes changed. Read more about customization [here](https://support.rstudio.com/hc/en-us/articles/200549016-Customizing-RStudio) and [here](http://www.aliquote.org/articles/tech/RStudio.pdf).

Both R and RStudio are periodically updated and you may need to pay attention to the versions that you are running as most R packages have version dependency. To check your R version run the command “version”; to check your RStudio version go to “Help/About RStudio”.  

## R particularities 
### Scripts
An R script is a text file that holds a list of R commands. It is the equivalent to a SPSS syntax. Saving your code in a script file allows you to save it, re run it, share it, and modify it. You can also run code in the console panel, but this will not get saved anywhere. Generally you should write your code in scripts. A very useful feature of scripts is that you can call them using the [source function](http://www.dummies.com/programming/r/how-to-source-a-script-in-r/) and they will run automatically.

### Objects
R works through objects. This is a complicated topic and it will make more sense once you get more familiar with R. In a nutshell, an object is an element that R creates and manipulates. They can be many different things: a plot, a dataset, some text, etc. To create an object you need to assign an operation to a name, and this is done using the arrow operator (<-). For example: x <- 3 creates an object with value 3. The value gets stored in R memory and can be used in further operations, for example x*2 will result in 6. For more detailed information on objects you can read [this](https://cran.r-project.org/doc/manuals/r-release/R-intro.html#Preface).

### Functions
R commands are called functions and they allow you to perform almost any action. You can create your own functions and R is especially well designed to work with them. You can read more about this topic [here](http://adv-r.had.co.nz/Functional-programming.html) and [here](https:\www.datacamp.com\community\tutorials\functions-in-r-a-tutorial#gs.oYNGp38).

### Data types
R can be used to analyse many different types of data, such as vectors, data frames, matrixes and lists. You can find a good introduction to them [here](https://www.statmethods.net/input/datatypes.html) and
[here](http://www.aliquote.org/articles/tech/RStudio.pdf)

### Rounding
R rounds numbers slightly differently to the common method used in SPSS. Instead, R uses the 'round half to even' method to prevent biasing numbers upwards or downwards. For example, 1.5 and 2.5 would both become 2 when using the round() function, as this is the nearest even integer. Similarly, 3.5 would become 4 when rounded.
```{r}
round(1.5)
[1] 2

round(2.5)
[1] 2

round(3.5)
[1] 4
```
It is unlikely that this will affect your analysis but this is an important concept to be aware of. 

## Packages
The base R program contains a large number of functions to carry out many different tasks. However, to carry out certain tasks or to be more efficient with your coding you may need to use additional packages. A package is a bundle of code, data and documentation (read more about them [here](http://r-pkgs.had.co.nz/intro.html)). An example is the popular package for visualizations, ggplot2, which you will need to install and load in order to use. 

### Install packages

To install packages you can use the command install.packages(“nameofpackage”) or you can use the contextual menu (Fig.2). Make sure that you have defined the installation location to one where you have writing permits (Fig.2). There is nothing to change if using RServer. You can install specific versions of a package if you need to.

![](https://imgur.com/zWvH20p.png)

*Figure 2. Contextual menu to install packages.*

Sometimes the default installation location is not writable by you, which will preempt you from installing any package. This could be the case of “C:\Program Files”. In this situation you need to set the installation location to a folder where you have writing permissions. The process is as follows:

Create a new folder in a directory you can write to (e.g. C:\Users\username\Documents\R\win-library\3.3). Open up the Windows Start Menu and type into the search bar “environ” and then click “Edit environment variables for your account”. At the top, there is a list of variables for your account, click “New”. In Variable name, type “R_LIBS” and in Variable value, enter the path to the folder you created earlier to store R packages. Click Ok when done (Fig.3).

![](https://imgur.com/GcwS6Cx.png)

*Figure 3. Contextual menu to set up package installation folder.*

Open up R and check that it has worked by typing .libPaths() The first item should be the path to the new folder you created and the second item should be your original default directory for storing R packages.

New versions of packages are released all the time, with new functions, bug fixing, etc. To update a package you can just re-install it. Click on “Update” in the RStudio Packages tab or go to “Tools/Check for package update” to know which packages can be updated. You can tick what packages you want to update and click on “Install Updates” (Fig.4). You might not be able to install the latest version of a package if your R version is too old. Keep in mind that updating a package might cause your code to stop working or to function differently. You can read more about package installation and updating [here](http://www.dummies.com/programming/r/r-for-dummies-cheat-sheet/) and [here](http://neondataskills.org/R/Packages-In-R/).

![](https://imgur.com/h2YbCvb.png)

*Figure 4. Updating packages through the contextual menu.*

### Install previous versions of packages
Sometimes you may need a previous version of an R package rather than the latest version to run code that may have been written some time ago. For instance, you may need the same package version that was used when an analysis was originally carried out. This is because functionality within packages may change over time and some functions may even become [deprecated](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Deprecated.html) from one version to the next. 

Previous versions of packages can be installed in a number of ways - more information on this can be found in the [RStudio support](https://support.rstudio.com/hc/en-us/articles/219949047-Installing-older-versions-of-packages). These methods require [Rtools](https://cran.r-project.org/bin/windows/Rtools/) to build/compile the packages from source. If you do not have Rtools installed, then you can use this code instead (in this example, to install a specific version of [ggplot2](http://ggplot2.org/)):

```{r}
library(versions)
install.versions("ggplot2", "2.0.0")
```

If you need information on version numbers for previous packages, find your package from the [CRAN package list](https://cran.r-project.org/web/packages/available_packages_by_name.html), then look for '**Old sources**' and click the link to get to the archives. For example, previous versions of the [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) package can be found [here](https://cran.r-project.org/src/contrib/Archive/dplyr) and the version numbers are displayed on the filenames.

### Install packages from Github Offline
Many packages that are in development are hosted on Github, often with the intention of putting the package onto CRAN later when it is more *production-ready*. When using R within the NSS network, you will usually need to install packages hosted on Github offline as it is likely you will not be allowed to download packages directly from Github within R using `devtools::install_github()`. This requires [Rtools](https://cran.r-project.org/bin/windows/Rtools/) to be installed as well as the [devtools](https://www.rstudio.com/products/rpackages/devtools/) package. With these in place, the first thing is to navigate to the Github webpage hosting the package you want to install – here, the [bubbles package](https://github.com/jcheng5/bubbles) is used as an example. On the package's Github page, click the "Clone or download" box, then click "Download ZIP" (Fig.5) and save the zip file somewhere convenient on your computer.

![](https://github.com/alan-y/img/blob/master/github_download.png)

*Figure 5. Downloading packages from Github as a zip file.*

By default, the zip file will be named according to the pattern "packagename-master.zip" (for this example, "bubbles-master.zip"). The next step is to open RStudio and set the working directory to where the zip file is stored (See the [Working directory and projects](#working-directory-and-projects) section in this guide). Then type the following command in R

```{r}
devtools::install_local("bubbles-master.zip")
```

The code should run fine and install the package (test this by [loading the package](#loading-packages)) – the only thing you have to do is replace the filename as appropriate for other packages downloaded from Github.

### Loading packages
Before you can start to use a package you have installed, you need to load it in your R session. This means that if you close R and reopen it again you will have to go through this process again. You can use contextual menus to load packages into your sessions, but that is not good practice. Always code the loading of packages directly into your script, including this at the beginning of your code in a housekeeping section. To call packages you can use the function library(packagename).

### Most common packages
Sometimes it can be difficult to know what package to use for what. These curated lists, [one by RStudio](https://github.com/rstudio/RStartHere), [one by rOpenSci](https://ropensci.org/packages/) and [one by PHI](https://github.com/Health-SocialCare-Scotland/R-Resources/blob/master/PHI%20R%20style%20guide.md) summarize some of the most popular and useful packages used for different purposes.

Probably the most popular set of packages for data manipulation is the [tidyverse](https://www.tidyverse.org/). They share a common style and logic and they have changed how people code in R. One of the main characteristics of “tidy” coding is the use of the [pipe operator (%>%)](http://magrittr.tidyverse.org/) which structures the sequences of data operations in a logical way. This creates a much more readable and simpler code than the style of base R (the default functions of R).

## Workspace
The workspace is your current R working environment and includes any user-defined objects (vectors, matrices, data frames, lists), functions and packages (Fig.6).  Read more about it [here](https://www.statmethods.net/interface/workspace.html) and [here](https://support.rstudio.com/hc/en-us/articles/200711843-Working-Directories-and-Workspaces). [This site](http://stat545.com/block002_hello-r-workspace-wd-project.html) has a very good overview of this whole section.

![](https://imgur.com/CTb9sOp.png)

*Figure 6. Workspace including different types of objects and functions.*

It is best practice to never save the working environment. This means that every time you open R no data or packages will be loaded. This way you will avoid issues with calls to the wrong dataset or object, not writing down all the packages you need, etc. You can make sure R does not remember a work space by going to “Tools/Global Options/General”, un-ticking the “Restore .RData into workspace at startup” box, and changing to “Never” the dropdown on “Save workspace to .RData on exit”.

### Working directory and projects
There are several ways of setting up your working directory, which helps to organize your work in directories and avoid you having to type over and over filepaths. 

It is recommended that you use RStudio projects. Projects organize your work into different contexts each one with a different working directory. Projects eliminate the need to set up your working directory each time, allow you to use Git for version control and allow you to have multiple R sessions open at the same time (each one with a different project), as well having other perks to help you manage your work. Read [this page](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects) to know how to create and use projects. You can use a similar structure to the one outlined in this [blank R project structure](https://github.com/Health-SocialCare-Scotland/rshiny-project-structure).

You can also define your working directory using the function setwd(“filepath”) You can retrieve your working directory using getwd(“filepath”).

Another way of doing it is through saving your workspace in the location you want to be your working directory: open RStudio, click on “Save Workspace As” icon (the blue disc) under Environment (Fig.7). 

![](https://imgur.com/Fc6Bgz1.png)

*Figure 7. Environment panel where you can find the option to save the workspace.*

It will open a “Save Workspace As” dialogue box, and you can choose a file path and give it a file name. Close RStudio. Go to the location where the file has been saved. The file you created has an extension “.RData”. Click on this file, and RStudio will open again with this location as the working directory. You can check it by using the function getwd().

## Coding
To make your code more readable and shareable please read and follow the [PHI R style guide](https://github.com/Health-SocialCare-Scotland/R-Resources/blob/master/PHI%20R%20style%20guide.md) and this [general R coding guide](http://adv-r.had.co.nz/Style.html0). Using these guides will help anyone that has to use your code in the future, including yourself! They also include some useful tips that will make your life easier. One important thing to note is that R is case sensitive. This can cause many headaches. Try to keep all object, variable and file names in lower case.

There are two R packages that can help you to keep your coding style consistent and do part of the work for you: [formatR](https://yihui.name/formatr/) and [lintR](https://cran.r-project.org/web/packages/lintr/README.html). You can find some useful tips about coding [here](https://support.rstudio.com/hc/en-us/articles/200710523-Navigating-Code), [here](https://support.rstudio.com/hc/en-us/articles/200484568-Code-Folding-and-Sections) and [here](https://code.tutsplus.com/tutorials/3-key-software-principles-you-must-understand--net-25161).

## Getting help
There is loads of information to help you using R. The best way is usually to Google what you are trying to do. There are also ways of getting the help and understanding how a specific function works using R. Read this to get to know how to do it. There is also a PHI R user group (Nss.rusergroup@nhs.net) which you can email to see if anyone can help you.

## Load and save data
As a general rule you should save data objects in RDS format (the native R format). R can deal with them better and faster. They are also compressed, taking less space than a csv. For this file format use the functions saveRDS/readRDS. 

If you need to read or write csv files, especially if they are large, use the functions read_csv/write_csv (readr package) or fread/fwrite (data.table package). Keep in mind that these functions produce slightly different data structures and this might affect how you need to proceed with your analysis (read more [here](http://analyticstraining.com/2015/if-youre-a-data-analyst-you-should-read-this-review-of-hadleys-readr-0-1-0-right-now/)).

To load SPSS .sav files use the package [haven](http://haven.tidyverse.org/). However, when possible you should aim to try to use the least number of languages and carry out the whole analysis in one language.

R can work with Excel files as well, and for this purpose you can use the packages [readxl](http://readxl.tidyverse.org/) and [openxlsx](https://github.com/awalker89/openxlsx).

## Connect to ODBC databases
Refer to the [document on how to connect to SMRA databases](http://www.isdscotland.org/About-ISD/Methodologies/_docs/Using-R-with-SMRA-V1-0-FINAL.pdf). If you want to connect to the ODBC databases using R desktop you will have to have the following installation of R: R Core 3.3.2 with SMRA ODBC collection. You will not require anything special if using the server version.

## Git
Git is a version control programme. If you don’t know what version control is or why you would want to use it, read [this](https://stackoverflow.com/questions/1408450/why-should-i-use-version-control). RStudio can be used together with Git (and Subversion). You don’t need IT support to install Git in your computer; you can download a portable version of it. You can use Git both from R server and R desktop. To configure Git in RStudio read [this](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN) and [this](http://www.datasurg.net/2015/07/13/rstudio-and-github/). Keep in mind that Git will only work inside a project.

For more information on using Git with R read [this](http://happygitwithr.com/) and for a quick tutorial see [this](https://try.github.io/levels/1/challenges/1).

## Useful resources
* [NHS R Resources](https://scotland.shinyapps.io/nhs-r-resources/) - compilation of useful resources.
#### General sites 
* [R project - R official page](https://www.r-project.org/)
* [RStudio - RStudio official page](https://www.rstudio.com/)
#### Specific to NSS
* [PHI github account](https://github.com/Health-SocialCare-Scotland) - code repository.
* [PHI R style guide](https://github.com/Health-SocialCare-Scotland/R-Resources/blob/master/PHI%20R%20style%20guide.md)
* [Guide on how to connect to SMRA using R and R server](http://www.isdscotland.org/About-ISD/Methodologies/_docs/Using-R-with-SMRA-V1-0-FINAL.pdf)
* [Guide on how to connect to API’s using R](https://github.com/jsphdms/R_web_APIs)
* [Blank R project structure](https://github.com/Health-SocialCare-Scotland/rshiny-project-structure) and [blank R Shiny app structure](https://github.com/Health-SocialCare-Scotland/rshiny-project-structure)
#### Tutorials
* [NeonScience](http://www.neonscience.org/resources/data-tutorials)
* [Coursera ](https://www.coursera.org/learn/r-programming)
* [Datacamp](https://www.datacamp.com/)
* [Udacity](https://www.udacity.com/course/data-analysis-with-r--ud651)
* [RStudio compilation of resources ](https://www.rstudio.com/online-learning/)
#### Books
* [R for data science](http://r4ds.had.co.nz/) – book on using R for data science.
* [R in a nutshell](https://visualization.sites.clemson.edu/reu/resources/RText.pdf) -  reference book on R.
* [R Cookbook](http://www.bagualu.net/wordpress/wp-content/uploads/2015/10/R_Cookbook.pdf) – reference book on R.
* [R Graphics Cookbook](http://bioinformaticsonline.com/file/download/29638) – reference to create graphics.
* [R Inferno](http://www.burns-stat.com/pages/Tutor/R_inferno.pdf) - recopilation of tricks and advice for R common problems.
* [Efficient R programming](https://csgillespie.github.io/efficientR/) - on how to make code faster to type, to run and more scalable.
#### Some usegful sites where to dig information
* [RStudio cheatsheets](https://www.rstudio.com/resources/cheatsheets/) - Cheatsheets for different packages of R.
* [Statistical tools for high-throughput data analysis](http://www.sthda.com/english/) - Articles, guides on packages, wiki.
* [Stackoverflow R questions ](https://stackoverflow.com/questions/tagged/r)- Q&A forum for developers.
* [R-Bloggers](https://www.r-bloggers.com) - Blog compilation on R.
* [RStudio blog](https://rviews.rstudio.com/) - Blog by RStudio
* [Community RStudio](https://community.rstudio.com/) - Community forum for R and RStudio users
#### Specific packages
* [dplyr](http://dplyr.tidyverse.org/) – data manipulation
* [reshape2](http://seananderson.ca/2013/10/19/reshape.html) and [tidyr](http://tidyr.tidyverse.org/) - manipulate data from wide to long format and vice versa.
* [shiny](http://shiny.rstudio.com/) - web apps
* [ggplot2](http://www.sthda.com/english/wiki/be-awesome-in-ggplot2-a-practical-guide-to-be-highly-effective-r-software-and-data-visualization)  - visualizations
* [rmarkdown](http://rmarkdown.rstudio.com/) - reporting and web outputs.
