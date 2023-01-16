# Recommendations on Global Options in Posit Workbench

Original author(s): Terry McLaughlin

Last updated: January 2023

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform. [Posit Workbench](https://posit.co/products/enterprise/workbench/) makes use of the managed [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service/#overview) to provide a scalable, performant and highly-available analytical environment.

## Purpose

This document aims to provide users of Posit Workbench with guidance and best practice on setting Global Options in Posit Workbench

## Global Options in Posit Workbench

### Workspace

#### Saving workspace to .RData file on exit

A ‘.RData’ file is used by R to save the current workspace, which includes all the objects (vectors, matrices, data frames, etc.) and their values that have been defined in the current R session. When you quit R or close the R session, you have the option to save the current workspace to an .RData file so that you can later restore it and continue working with the same objects and their values.  Posit Workbench enables saving .RData files by default when the session closes.
However, there are two main reasons why you would not want to save your R environment to an .RData file when your session closes:

* Firstly, .RData files can become quite large and take up a lot of disk space, especially if you have large data sets or many objects defined in your workspace.
* However, more importantly, the .RData file may be inadvertently saved to a location that does not comply with Public Health Scotland’s Information Governance and Data Security policies.  This is very likely to happen if your project’s working directory is not in a secure location, such as on the Stats server.

It is for these two reasons above that the option to save .RData files by default when the session closes has been turned off for all users.

#### Restoring .RData file to workspace at startup



## How to change Global Options settings
