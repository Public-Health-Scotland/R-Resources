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

* If you have the [{usethis}](https://usethis.r-lib.org/) package installed, you can run `usethis::use_blank_slate()` to automatically change the settings described above.

By avoiding a .RData file, there are no large objects stored that are consuming storage space, and opening and closing sessions is faster, thanks to reduced loading and saving times.

## Coding with R

### Removing intermediate variables

Suppose we have two large data frames, `a_data` and `b_data`, that we join together to create a third data frame, `combined_data` that we will use for the rest of our analysis. Our environment will now have 3 large data frames stored in memory, even though `a_data` and `b_data` may now be redundant. We can free up that occupied memory by deleting `a_data` and `b_data` from the environment using the `rm()` function:

```r
rm(a_data, b_data)
```

This allows R to use that memory to store other potentially large objects without running out of memory.

R will automatically perform _garbage collection_ — the process of freeing-up unused system memory that's no longer used — where necessary. But we can also manually trigger garbage collection by running `gc()` in the R console at any time, which can be especially effective after large objects have just been deleted from the environment.

### Overwriting existing objects

It's quite common to modify existing objects on a step-by-step basis. One strategy for reducing the amount of variables you create in your environment is to modify and overwrite the existing object, by saving the result into the same object.

Let's imagine we are working with the iris dataset:

```r
data("iris")
head(iris)
```

```
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
4          4.6         3.1          1.5         0.2  setosa
5          5.0         3.6          1.4         0.2  setosa
6          5.4         3.9          1.7         0.4  setosa
```

and we want to approximate the area of the sepal and petal by multiplying "Length" × "Width", and convert the Species values to upper-case.

When working with standard R methods, we could modify the existing iris by adding and modifying columns.

```r
data("iris")
iris$Sepal.Area <- iris$Sepal.Length * iris$Sepal.Width
iris$Petal.Area <- iris$Petal.Length * iris$Petal.Width
iris$Species <- toupper(iris$Species)
head(iris)
```

```
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species Sepal.Area
1          5.1         3.5          1.4         0.2  SETOSA      17.85
2          4.9         3.0          1.4         0.2  SETOSA      14.70
3          4.7         3.2          1.3         0.2  SETOSA      15.04
4          4.6         3.1          1.5         0.2  SETOSA      14.26
5          5.0         3.6          1.4         0.2  SETOSA      18.00
6          5.4         3.9          1.7         0.4  SETOSA      21.06
  Petal.Area
1       0.28
2       0.28
3       0.26
4       0.30
5       0.28
6       0.68
```

Meanwhile, using tidyverse methods, we can use mutate to create the modified table and overwrite the original iris table:

```r
library("dplyr")
data("iris")
iris <- mutate(iris,
               Sepal.Area = Sepal.Length * Sepal.Width,
               Petal.Area = Petal.Length * Petal.Width,
               Species = toupper(Species))
head(iris)
```

```
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species Sepal.Area
1          5.1         3.5          1.4         0.2  SETOSA      17.85
2          4.9         3.0          1.4         0.2  SETOSA      14.70
3          4.7         3.2          1.3         0.2  SETOSA      15.04
4          4.6         3.1          1.5         0.2  SETOSA      14.26
5          5.0         3.6          1.4         0.2  SETOSA      18.00
6          5.4         3.9          1.7         0.4  SETOSA      21.06
  Petal.Area
1       0.28
2       0.28
3       0.26
4       0.30
5       0.28
6       0.68
```

This overwriting action prevents unnecessary redundant datasets being stored. But care must be taken as the overwriting cannot be undone. If you accidentally overwrite some data you needed, you'll need to recreate it again using your R script.

### Avoiding intermediate variables

It's common to perform a sequence of steps when preparing your data. This can lead to a series of intermediate variables being created to store the result of each step. Overwriting the results from the last step is one possible solution, but an alternative is to _pipe_ the result from one stage directly into the next.

The [{magrittr}](https://magrittr.tidyverse.org/) package provides a _pipe_ operator, which is written in R as `%>%`. It takes the object to its left and "pipes" it into the function on the right as its first unset argument. In general terms, the following two lines of code are equivalent ways of running a function called `f`:

```r
f(x, y)
x %>% f(y)
```

Typing Ctrl + Shift + M is a keyboard shortcut for inserting `%>%` in RStudio.

This feature becomes very powerful in the tidyverse, where many of the commonly used functions take in a data frame as their first argument and output a data frame. This allows a chain of modifications to be made linked together without having to store the intermediate stages of the process.

Suppose we want to plot the iris `Sepal.Area` against the `Petal.Area`. If we don't need to store these results for anything else, we can pipe the modified data frame directly into our plotting code, and avoid having to store any of the intermediate stages.

 ```r
library("ggplot2")
data(iris)
iris %>% 
  transmute(Sepal.Area = Sepal.Length * Sepal.Width,
            Petal.Area = Petal.Length * Petal.Width,
            Species = toupper(Species)) %>% 
  ggplot(mapping = aes(x = Petal.Area, y = Sepal.Area, colour = Species)) +
  geom_point()
 ```

Avoiding the process of saving intermediate stages means your workspace does not get cluttered with unnecessary datasets that use up memory and you may have to remove later.

But this does not mean you should should never save an intermediate stage in a calculation. If a single modified data frame needs to be used in two separate calculations, it's more efficient to store the value to use in both calculations rather than recalculating it twice from scratch. Store only what you _need_ to prevent yourself repeating calculating the same thing twice:

```r
library("gridExtra")
data(iris)
iris_areas <- iris %>% 
  transmute(Sepal.Area = Sepal.Length * Sepal.Width,
            Petal.Area = Petal.Length * Petal.Width,
            Species = toupper(Species))

g1 <- ggplot(data = iris_areas,
             mapping = aes(x = Petal.Area, y = Sepal.Area, colour = Species)) +
  geom_point()

g2 <- ggplot(data = iris_areas, mapping = aes(x = Sepal.Area)) +
  geom_histogram(bins = 10) +
  facet_wrap(Species ~ .)

grid.arrange(g1, g2, nrow = 2)
```

### Automatically close an R session

If you want your script to end the session automatically when it completes all its tasks, then include the `q()` or `quit()` function in your script. Both functions perform the same task of terminating the current session.

The first argument, `save`, specifies whether the current environment should be saved. The default behaviour will often ask you interactively, which means it won’t automatically close by itself. As discussed earlier, it’s considered best practice to never save your environment, so we should pre-emptively tell it not to save the workspace variables:

```r
quit(save = "no")
```

## Importing and exporting data

### Make good use of databases

A well designed database is purpose-built and highly optimised to reliably, rapidly and efficiently handle the storage and retrieval of large amounts of data. Databases often contain pre-computed indexes, which mean the database knows exactly where to find the data you need without having to wade through what could potentially be terabytes worth of data.

Let's suppose you have a database containing 100,000 data points covering a whole country and you need to extract 1,000 data points corresponding to a certain region. There's two methods you could use to get those regional data points:

1. Send a query to the database that loads all 100,000 data points from the database into R, then filter for the 1,000 data points you want in R.
2. Send a query to the database to find the 1,000 regional data points out of its table of 100,000 entries, and send those to R.

Of the two methods above, option 2 will _always_ be faster and more efficient; the database will always filter the data faster than R can. Even in the compromised situation where the region is not indexed in the database, the additional overhead of transferring 99,000 unnecessary data points to R — which have to be parsed and allocated memory in R — mean that the database will still be the faster and more efficient option.

In short, querying the database for more than you need — for example, by using an SQL query of `SELECT * FROM HospitalRecords;` — wastes your time and everyone's shared resources.

Make full use of your database's filtering and table-joining methods to take full advantage of the optimised algorithms and column indexing, before the data reaches R. In the case of SQL, that could be as simple as adding conditions, such as:

```sql
SELECT Hospital, PatientCount, AvgWaitingTime
    FROM HospitalRecords
    WHERE Region='NorthernArea';
```

### Get R to make good use of the database



### Pick good file formats for storing data
