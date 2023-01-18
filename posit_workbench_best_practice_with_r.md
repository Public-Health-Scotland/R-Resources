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

If you want to know if you’ve accidentally left sessions running, your home page will display a list of currently active sessions.

![image](https://user-images.githubusercontent.com/45657289/213185308-ee5eed27-8622-478a-a80f-ae2edf63fa54.png)

You will usually see this page when you log in to Posit Workbench, but if you are currently in an active session and want to view the home page, click on the home icon ![image](https://user-images.githubusercontent.com/45657289/213185415-f8ed533f-a3f2-49c5-be4b-e8bf5528eca8.png) in the
top-right of the workspace window, or navigate in the menus to _File → ![image](https://user-images.githubusercontent.com/45657289/213185415-f8ed533f-a3f2-49c5-be4b-e8bf5528eca8.png) RStudio Server Home_.

![image](https://user-images.githubusercontent.com/45657289/213185696-5b562c9a-c957-4de4-9043-5d61d1e81d3a.png)

It is recommended that the server home page be displayed when you log in, to list any active sessions. You can configure this to happen for your account by accessing the settings inside a session: In the menus, visit Tools → Global Options…, then under the "General" menu, click on the "Advanced" tab. Set the option for "Show server home page" to be "Always":

![image](https://user-images.githubusercontent.com/45657289/213186007-16746c3d-bab0-45fe-81b7-fed363d94dfa.png)

If you have no sessions running, then the home page will list no active sessions, and instead have a link to create a new session.

![image](https://user-images.githubusercontent.com/45657289/213186065-769c4008-a4c3-47f6-9ed8-200d667c4e73.png)

### Leave a clean workspace

It can feel counter-intuitive to exit a session without saving the variables in your environment, given the obvious fact that those values will be lost. But what really matters is the R script that you produced, which loaded or generated that data in the first place—this is what you want to save for a number of reasons:

* A well-written R script can recreate your analysis in an automated way and using the most up-to-date datasets. You don't need to store old results as variables when you can quickly generate new ones on demand.
* Good scripts will be portable, meaning they can be run in different sessions, on different computers and even by different people who want to perform your analysis.
* R scripts have small file sizes, causing minimal impact to your available storage and making them easy to transfer to other computers or users.

In order to write a good script that can run in any session by any computer, you should always assume the script is working in a brand-new, clean and empty environment, and is completely self-sufficient for the tasks it wants to do. If you create a script that uses a variable that only existed in your working environment and pass it onto someone else, they won’t be able to run the script since it relies on something only your session contains.

To avoid accidentally using an existing variable in your environment, there are some steps we can take which all focus around keeping a clean working environment:

* Set Posit Workbench to _never_ save your environment to an .RData file when exiting a session.
  * Access the RStudio Global Options menu by going to _Tools → Global Options…_
  * In the "General" menu, open the "Basic" tab.
  * Untick the "Restore .RData into workspace at startup" tab.
  * Set "Save workspace to .RData on exit" to "Never".

![image](https://user-images.githubusercontent.com/45657289/213186998-363ac925-5812-4d50-9bff-64c18f72f8bf.png)

* If you have the {usethis} package installed, you can run `usethis::use_blank_slate()` to automatically change the settings described above.

By avoiding a .RData file, there are no large objects stored that are consuming storage space, and opening and closing sessions is faster, thanks to reduced loading and saving times.

## Coding with R

### Removing intermediate variables

Suppose we have two large data frames, `a_data` and `b_data`, that we join together to create a third data frame, `combined_data` that we will use for the rest of our analysis. Our environment will now have 3 large data frames stored in memory, even though `a_data` and `b_data` may now be redundant. We can free up that occupied memory by deleting `a_data` and `b_data` from the environment using the `rm()` function:

```
rm(a_data, b_data)
```

This allows R to use that memory to store other potentially large objects without running out of memory.

R will automatically perform _garbage collection_ — the process of freeing-up unused system memory that's no longer used — where necessary. But we can also manually trigger garbage collection by running `gc()` in the R console at any time, which can be especially effective after large objects have just been deleted from the environment.

### Overwriting existing objects




### Avoiding intermediate variables



### Automatically close an R session



