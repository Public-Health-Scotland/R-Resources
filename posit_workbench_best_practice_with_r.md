# Best Practice with R in Posit Workbench

Original author(s): Andrew Patterson (Jumping Rivers), Terry McLaughlin

Last updated: January 2023

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform. The platform has been designed and implemented as a high-performance, high-availability analytical environment to support the work of Public Health Scotland. However, despite the computing power available, we need to be mindful at all times that this is a shared resource with finite capacity, and as such, we each have individual responsibility to ensure our code is as optimised and efficient as possible, and that we use the Posit Team applications correctly and appropriately, to ensure what we all benefit from this resource equally. Using inefficient code can cause your analysis to take longer or even cause the session to become unresponsive.

## Purpose

This document aims to offer guidance to users on good practices for efficient and effective use of R and Posit Applications (in particular Posit Workbench) on Microsoft Azure.

## Posit Workbench Sessions

### Close your session when you’re not using it

All active users on the server are sharing a part of the available resources. By closing your session when you are not using it, you free up the resources your session was using, allowing other users the resources needed to perform their analyses.

You can close your session in a number of ways:

1. By clicking on the Power button ![image](https://user-images.githubusercontent.com/45657289/213184464-3a7b5e72-ff03-4dac-b99b-bec0c79167fe.png) icon in the top right of the workspace window.

![image](https://user-images.githubusercontent.com/45657289/213184555-0ef6290d-c381-4cec-9ee4-4c992bf4735a.png)

2. By navigating the menus to _Session → ![image](https://user-images.githubusercontent.com/45657289/213184464-3a7b5e72-ff03-4dac-b99b-bec0c79167fe.png) Quit Session..._

![image](https://user-images.githubusercontent.com/45657289/213184913-ab491f74-c6a3-48ff-bce1-1195a0ae0d68.png)

3. By typing `q()` in your R console. You may be prompted to save any unsaved changes before the session closes.

### View all open sessions



### Leave a clean workspace
