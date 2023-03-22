> **Warning**
> This repository has been archived and is no longer maintained. All documentation has moved to (and maintained on) the [technical-docs](https://github.com/Public-Health-Scotland/technical-docs) repo and now available on the [PHS Data Science Knowledge Base](https://public-health-scotland.github.io/knowledge-base/). Please see these resources for up-to-date guidance.

# Recommendations on Global Options in Posit Workbench

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform. [Posit Workbench](https://posit.co/products/enterprise/workbench/) makes use of the managed [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service/#overview) to provide a scalable, performant and highly-available analytical environment.

## Purpose

This document aims to provide users of Posit Workbench with guidance and best practice on setting Global Options in Posit Workbench.

## Global Options in Posit Workbench

### How to change Global Options settings

The Global Options window can be accessed from a Posit Workbench session through the Tools menu:

![Tools_-_Global_Options PNG](https://user-images.githubusercontent.com/45657289/212679908-5cb53c40-de93-4010-8fae-6420d6bc4a64.png)

### Workspace

The workspace contains all the objects (vectors, matrices, data frames, etc.) and their values that have been defined in the current R session.  There are two options that can be set in the Global Options window that affect the behaviour of sessions and their workspaces:

![Global_Options_-_Workspace](https://user-images.githubusercontent.com/45657289/212689097-9c1d3aed-0373-4d9f-9095-884d1651e0fc.png)

#### Saving workspace to .RData file on exit

A ‘.RData’ file is used by R to save the current workspace, which includes all the objects (vectors, matrices, data frames, etc.) and their values that have been defined in the current R session. When you quit R or close the R session, you have the option to save the current workspace to an .RData file so that you can later restore it and continue working with the same objects and their values.  Posit Workbench enables saving .RData files by default when the session closes.
However, there are two main reasons why you would not want to save your R environment to an .RData file when your session closes:

* Firstly, .RData files can become quite large and take up a lot of disk space, especially if you have large data sets or many objects defined in your workspace.
* However, more importantly, the .RData file may be inadvertently saved to a location that does not comply with Public Health Scotland’s Information Governance and Data Security policies.  This is very likely to happen if your project’s working directory is not in a secure location, such as on the Stats server.

**It is for these two reasons above that the option to save .RData files by default when the session closes has been turned off for all users.**

#### Restoring .RData file to workspace at startup

In the situation where a project’s working directory contains a .RData file, by default, the contents of that ‘.RData’ file will be loaded into the session’s environment when opening the project.  There are two main reasons why we would not want this to happen:

* By opening a project and restoring that project’s .RData file, the data and variables that were saved in the file will be loaded into the R environment, replacing any data and variables that were already there. This can cause confusion for users because they may not be aware of the contents of the .RData file and how they relate to the current project.

For example, imagine you are working on a project that uses a specific dataset and a set of variables. You save the project and close your Posit Workbench session. Later, another user opens the project and this action, by default, restores the .RData file. However, this .RData file contains a different dataset and a different set of variables to those that the user is expecting. If they continue working on the project without noticing this, they may inadvertently be analysing the wrong data or using the wrong variables in their analysis. This can lead to incorrect results, wasted time, and confusion.

* The process of loading a .RData file into the R environment can, particularly if it is a large file, take a very long time.  In fact, the Posit Workbench session will crash, if the amount of memory required to restore the .RData file exceeds the amount of memory available to the session.

**For these reasons, it is highly recommended that users untick the “Restore .RData into workspace at startup” option in the Global Options window.**
