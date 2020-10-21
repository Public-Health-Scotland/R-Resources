# R style guide for PHS analysts
## Anna Price and David Caldwell
## September 2017

***

Type - documentation  
Written/run on - R Studio SERVER  
Description - This document is a coding style guide for analysts using R within ISD. It is designed to allow enough flexibility for analysts working on different projects, while maintaining consistency across the organisation and ensuring that code can be easily shared.

***

### 1 - Information at the start of a script

Every script should begin with the following basic information:  

* Name of file
* Data release (if applicable)
* Original author(s)\*
* Original date\*

* Written/run on (e.g. R Studio SERVER)
* Version of R that the script was written for
* Versions of packages that the script requires (these can be retrieved using the `sessionInfo()` function)

* Description of content

* Approximate run time  

\*This information is not required if Git (or another version control system) is being used to track changes to a script. If this is not the case, then the most recent analyst to edit the file and the date that this was done should also be recorded.

### 2 - Sections

All scripts should be split into numbered sections. Use at least three hashes at the start of a section header in order to clearly differentiate section titles from general annotations. Follow the section header with at least four dashes or hashes so that sections can be collapsed and an automatic contents table is created in the Jump To menu at the bottom of the editor for navigation. (Note that when writing Rmarkdown scripts, collapsable sections are created using at least one hash at the start of a line.)

![](https://i.imgur.com/KwT2GBl.png)

We recommend using sub-sections, especially if particular sections are very long.

RStudio has a shortcut for creating sections - either press ctrl+shift+R or go to Code in the main menu and select Insert section.


### 3 - Structure

The exact structure of a script should be decided by the analyst writing the code and should be appropriate for the analyses being carried out. However, as a general rule there should be a housekeeping section at the start - this should be the only section of the script which requires manual changes for future updates and includes:

* loading packages
* setting filepaths and extract dates
* functions (defined here or sourced from another file)
* setting plot parameter
* specifying codes (e.g. ICD-10 codes) once for generic calculations such as incidence rates

It is useful to mark the end of a script e.g. `### END OF SCRIPT ###`


### 4 - Commenting

Scripts should be appropriately commented. Comments are used to explain your code to other analysts. They should be succinct, so that the script is readable, but detailed enough so that another analyst could understand, run and edit it.

Comments can also be used for instruction and if so this should be clearly marked e.g.
`# TO DO - Needs re-written to reduce looping`

Use one hash to comment out annotations.


### 5 - Functions

R is a functional language. Using functions improves code readability, testability and shareability. Functions should generally be used in preference to loops in order to reduce the amount of code needed. 

Small functions which are specific to one piece of analysis should be defined in the housekeeping section at the start, but generic functions which are used across a project or multiple projects should be saved in a separate script and sourced in. Function names should be verbs which describe what the function does.


### 6 - Checks and warnings

Checks, conditional operations and warnings should be built into code in order to automate processes as much as possible. For example, the following code produces NA if a number of less than 10 is given, and returns a warning.

```{r}
x <- 9
if (x <= 10) {
  warning ("This analysis is incorrect as sample sizes less than 10 are not allowed") 
  result <- NA
} else {
  result <- coef(glm(rpois(x, lambda = 5) ~ 1))
}
```

### 7 - Projects

It is recommended that you use RStudio projects, which organize your work into different contexts each one with a different working directory. Projects eliminate the need to set up your working directory each time, allow you to use Git for version control and allow you to have multiple R sessions open at the same time (each one with a different project), as well other perks to help you manage your work. 

A blank R project structure can be downloaded from [this repository](https://github.com/Public-Health-Scotland/r-project-structure). A similar blank structure for R Shiny apps can be found [here](https://github.com/Public-Health-Scotland/rshiny-project-structure).

### 8 - Recommended packages and tidyverse

We recommend the following packages:

* `odbc` for accessing SMRA data
* `haven` for reading spss files (NOTE: haven now supports .zsav files, from version 1.1.2 onwards)
* The `tidyverse` suite of packages for data manipulation and more generally for writing R code in the "tidy" way. The [tidyverse](https://www.tidyverse.org/) includes packages such as dplyr, magrittr, ggplot2, tidyr and readr. Since the tidyverse is now a large collection of packages, we recommend that you do not load all of them at once (e.g. using `library(tidyverse)`), but instead load the specific tidyverse packages required in your code.

We recommend using the pipe operator (%>%) from the magrittr (and now dplyr) packages in order to make code more readable. This operator is used to pass a value forward into the first argument of an expression or function and can be pronounced as "then". Pipes should be used to link a sequence of functions into one call, with a new line after each pipe. Also note that "tidy" data analysis is best performed on data in a tidy (long) format, where each column represents one variable and each row represents one observation ([Hadley Wickham, 2014](https://www.jstatsoft.org/article/view/v059i10)).

NOTE: tidyverse conflicts with the plyr package so should be reloaded after you are finished using plyr


### 9 - Recommended style guide

We recommend following Hadley Wickham's [tidyverse style guide](http://style.tidyverse.org/).
Please refer to this document for guidance on:

* file names
* object names
* spacing
* indentation
* curly brackets
* assignment

To help clean up your code, the `lintr` package provides an automated check for compliance with the tidyverse style guide and warns you about potential mistakes or problems.


### 10 - R User Group

The PHI R User Group shares good practice amoungst the user community and is a useful support system for users requiring assistance. For more information and to sign up to the mailing list contact: phs.rusergp@phs.scot
