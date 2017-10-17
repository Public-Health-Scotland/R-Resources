# Codename - R_style_guide
# Original Authors - Anna Price and David Caldwell
# Original Date - September 2017
#                                                                
# Type - documentation
# Written/run on - R Studio SERVER
# Description - This document is a coding style guide for analysts using R within ISD.
# It is designed to allow enough flexibility for analysts working on different projects,
# while maintaining consistency across the organisation and ensuring that code can
# be easily shared.
#
# Approximate run time: <1 second


### 1 - Information at the start of a script ----

# Every script should begin with the following basic information: 
#   Name of file
#   Data release (if applicable)
#   Original author(s)
#   Orginal date
#   Type of script (e.g. extraction, preparation, modelling)                          
#   Written/run on (e.g. R Studio SERVER)
#   Description of content
#   Approximate run time  


### 2 - Sections ----

# All scripts should be split into numbered sections. Use 3 hashes at the start of a 
# section header in order to clearly differentiate section titles from general annotations. 
# Follow the section header with four dashes so that sections can be collapsed and an 
# automatic contents table is created in the Jump To menu at the bottom of the editor
# for navigation. 

# We recommend using sub-sections, especially if particular sections are very long.


### 3 - Structure ----

# The exact structure of a script should be decided by the analyst writing the code and should be 
# appropriate for the analyses being carried out. However, as a general rule there should be a
# housekeeping section at the start - this should be the only section of the script which 
# requires manual changes for future updates and includes:
# - loading packages
# - setting filepaths and extract dates
# - functions (defined here or sourced from another file)
# - setting plot parameter
# - specifying codes (e.g. ICD-10 codes) once for generic calculations such as incidence rates

# It is useful to mark the end of a script e.g. ### END OF SCRIPT ###


### 4 - Commenting ----

# Scripts should be appropriately commented. Comments are used to explain your code to other
# analysts. They should be succinct, so that the script is readable, but detailed enough so 
# that another analyst could understand, run and edit it.

# Comments can also be used for instruction and if so this should be clearly marked e.g.
# "# TO DO - Needs re-written to reduce looping"

# Use one hash to comment out annotations.


### 5 - Functions ----

# R is a functional language. Using functions improves code readability, testability and
# share ability. Functions should generally be used in preference to loops in order to
# reduce the amount of code needed. 

# Small functions which are specific to one piece of analysis should be defined in the 
# housekeeping section at the start, but generic functions which are used across a project 
# or multiple projects should be saved in a separate script and sourced in.


### 6 - Checks and warnings ----

# Checks, conditional operations and warnings should be built into code in order to 
# automate processes as much as possible. For example, the following code produces NA if a 
# number of less than 10 is given, and returns a warning.

# x <- 9
# if (x <= 10) {
#   warning ("This analysis is incorrect as sample sizes less than 10 are not allowed") 
#   result <- NA
# } else {
#   result <- coef(glm(rpois(x, lambda = 5) ~ 1))
# }


### 7 - Recommended packages ----

# We recommend the following packages:
# - "RODBC" for accessing SMRA data
# - "foreign" for reading spss files
# - "tidyverse" for data manipulation and more generally for writing R code in the "tidy" way

# NOTE: tidyverse conflicts with the plyr package so should be reloaded after you are
# finished using plyr


### 8 - Recommended style guide ----

# We recommend following Hadley Wickham's style guide (http://adv-r.had.co.nz/Style.html).
# Please refer to this document for guidance on:
# - file names
# - object names
# - spacing
# - indentation
# - curly brackets
# - assignment

# An example R script written in the recommended style is also available for further reference.

### END OF SCRIPT ###