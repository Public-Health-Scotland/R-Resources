# Best Practice with R in Posit Workbench

Original author(s): Andrew Patterson (Jumping Rivers), Terry McLaughlin

Last updated: January 2023

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform. The platform has been designed and implemented as a high-performance, high-availability analytical environment to support the work of Public Health Scotland. However, despite the computing power available, we need to be mindful at all times that this is a shared resource with finite capacity, and as such, we each have individual responsibility to ensure our code is as optimised and efficient as possible, and that we use the Posit Team applications correctly and appropriately, to ensure what we all benefit from this resource equitably. Using inefficient code can cause your analysis to take longer or even cause the session to become unresponsive.

## Purpose

This document aims to offer guidance to users on good practices for efficient and effective use of R and Posit Applications (in particular Posit Workbench) on Microsoft Azure.

## Posit Workbench Sessions

### Close your session when you’re not using it

All active users on the server are sharing a part of the available resources. By closing your session when you are not using it, you free up the resources your session was using, allowing other users the resources needed to perform their analyses.

You can close your session in a number of ways, and may be prompted to save any unsaved changes before the session closes:

1. By clicking on the Power button ![image](https://user-images.githubusercontent.com/45657289/213184464-3a7b5e72-ff03-4dac-b99b-bec0c79167fe.png) icon in the top right of the workspace window.

![image](https://user-images.githubusercontent.com/45657289/213184555-0ef6290d-c381-4cec-9ee4-4c992bf4735a.png)

2. By navigating the menus to _Session → ![image](https://user-images.githubusercontent.com/45657289/213184464-3a7b5e72-ff03-4dac-b99b-bec0c79167fe.png) Quit Session..._

![image](https://user-images.githubusercontent.com/45657289/213184913-ab491f74-c6a3-48ff-bce1-1195a0ae0d68.png)

3. By typing `q()` in your R console. 

#### View all open sessions

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

R will automatically perform _garbage collection_ — the process of freeing-up unused system memory that's no longer used — where necessary. But we can also manually trigger garbage collection by running `gc()` in the R console at any time, which can be especially effective after large objects have just been deleted from the environment. _Garbage collection_ will never delete anything that is still in use and happens automatically, however if you have an automated process that involves large objects, building in _garbage collection_ with `gc()` may help freeing up system memory before the next step of the process.

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

If you aren’t that familiar with writing SQL code, then writing more advanced SQL queries can seem more daunting. The temptation then becomes to load all the data into R where you can perform all data manipulation in a language you’re more familiar with. But this may not be necessary.

The [{dbplyr}](https://dbplyr.tidyverse.org/) package allows you to create SQL queries by writing the [{dplyr}](https://dplyr.tidyverse.org/) methods you would normally use to perform data manipulation. To use {dbplyr}:

1. Run `library("dplyr")` at the start of your R script. Note that {dplyr} is loaded, but not {d**b**plyr}. When dplyr methods are applied to a database table connection instead of a data frame, {dbplyr} is automatically loaded in the background.
2. Establish a connection to an SQL database as normal.
3. Use common {dplyr} verbs to filter, select, join, summarise, etc. on the database table connection (not a data frame).
4. Pipe this into the `collect()` method to pull the data from the database.

Without the final `collect()` step, the result of your {dplyr} sequence of commands will be a "lazy data frame". This provides a preview of the first ten rows of your SQL query. You can use this to quickly preview what your data will look like, without accidentally causing an unnecessarily big query operation to occur and your computer memory to be filled. Once you are happy that your query is optimised, add `collect()` to get all the data from your query.

We can create a dummy database for demonstration purposes and create a table containing the iris dataset.

```r
con = DBI::dbConnect(RSQLite::SQLite(), path = ":memory:")
DBI::dbWriteTable(con, "iris_tbl", iris)
```

You would connect to your database in a similar method. Ask your database administrator for support if you don’t know the credentials needed to establish the database connection.

We can get a _lazy_ preview of the table by querying the table. At thetop, it will display `??` for the number of rows, as it has only asked the database to find the first 10.

```r
iris_tbl <- tbl(con, "iris_tbl")
iris_tbl
```

```
# Source:   table<iris_tbl> [?? x 5]
# Database: sqlite 3.39.2 []
   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
          <dbl>       <dbl>        <dbl>       <dbl> <chr>  
 1          5.1         3.5          1.4         0.2 setosa 
 2          4.9         3            1.4         0.2 setosa 
 3          4.7         3.2          1.3         0.2 setosa 
 4          4.6         3.1          1.5         0.2 setosa 
 5          5           3.6          1.4         0.2 setosa 
 6          5.4         3.9          1.7         0.4 setosa 
 7          4.6         3.4          1.4         0.3 setosa 
 8          5           3.4          1.5         0.2 setosa 
 9          4.4         2.9          1.4         0.2 setosa 
10          4.9         3.1          1.5         0.1 setosa 
# … with more rows
# ℹ Use `print(n = ...)` to see more rows
```

We can ask it to only show results for the "versicolor" species using {dplyr} functions:

```r
library("dplyr")
iris_tbl %>% 
  filter(Species == "versicolor")
```

```
# Source:   SQL [?? x 5]
# Database: sqlite 3.39.2 []
   Sepal.Length Sepal.Width Petal.Length Petal.Width Species   
          <dbl>       <dbl>        <dbl>       <dbl> <chr>     
 1          7           3.2          4.7         1.4 versicolor
 2          6.4         3.2          4.5         1.5 versicolor
 3          6.9         3.1          4.9         1.5 versicolor
 4          5.5         2.3          4           1.3 versicolor
 5          6.5         2.8          4.6         1.5 versicolor
 6          5.7         2.8          4.5         1.3 versicolor
 7          6.3         3.3          4.7         1.6 versicolor
 8          4.9         2.4          3.3         1   versicolor
 9          6.6         2.9          4.6         1.3 versicolor
10          5.2         2.7          3.9         1.4 versicolor
# … with more rows
# ℹ Use `print(n = ...)` to see more rows
```

Or we can specify anything that’s not a "setosa" species that also has a sepal length > 5, ordered by petal length in descending order:

```r
iris_tbl %>% 
  filter(Species != "setosa",
         Sepal.Length > 5) %>% 
  arrange(desc(Petal.Length))
```

```
# Source:     SQL [?? x 5]
# Database:   sqlite 3.39.2 []
# Ordered by: desc(Petal.Length)
   Sepal.Length Sepal.Width Petal.Length Petal.Width Species  
          <dbl>       <dbl>        <dbl>       <dbl> <chr>    
 1          7.7         2.6          6.9         2.3 virginica
 2          7.7         3.8          6.7         2.2 virginica
 3          7.7         2.8          6.7         2   virginica
 4          7.6         3            6.6         2.1 virginica
 5          7.9         3.8          6.4         2   virginica
 6          7.3         2.9          6.3         1.8 virginica
 7          7.2         3.6          6.1         2.5 virginica
 8          7.4         2.8          6.1         1.9 virginica
 9          7.7         3            6.1         2.3 virginica
10          6.3         3.3          6           2.5 virginica
# … with more rows
# ℹ Use `print(n = ...)` to see more rows
```

When we are happy with the preview provided, we collect all the results from our query using `collect()` and we'll notice the table knows how many rows it has since it will have all the data.

```r
iris_tbl %>% 
  filter(Species != "setosa",
         Sepal.Length > 5) %>% 
  arrange(desc(Petal.Length)) %>% 
  collect()
```

```
# A tibble: 96 × 5
   Sepal.Length Sepal.Width Petal.Length Petal.Width Species  
          <dbl>       <dbl>        <dbl>       <dbl> <chr>    
 1          7.7         2.6          6.9         2.3 virginica
 2          7.7         3.8          6.7         2.2 virginica
 3          7.7         2.8          6.7         2   virginica
 4          7.6         3            6.6         2.1 virginica
 5          7.9         3.8          6.4         2   virginica
 6          7.3         2.9          6.3         1.8 virginica
 7          7.2         3.6          6.1         2.5 virginica
 8          7.4         2.8          6.1         1.9 virginica
 9          7.7         3            6.1         2.3 virginica
10          6.3         3.3          6           2.5 virginica
# … with 86 more rows
# ℹ Use `print(n = ...)` to see more rows
```

Instead of collecting the values, we can ask it to print the SQL query it is making using `show_query()`, should we want to check what the query looks like behind-the-scenes:

```r
iris_tbl %>% 
  filter(Species != "setosa",
         Sepal.Length > 5) %>% 
  arrange(desc(Petal.Length)) %>% 
  show_query()
```

```sql
<SQL>
SELECT *
FROM `iris_tbl`
WHERE (`Species` != 'setosa') AND (`Sepal.Length` > 5.0)
ORDER BY `Petal.Length` DESC
```

Of course, don't forget to disconnect your database connection when you’re finished.

```r
DBI::dbDisconnect(con)
```

### Pick good file formats for storing data

If you want to store lots of data in a file, picking the right file format is an important decision that affects software compatibility, file size and how efficiently the file can be imported into R.

#### I'll only use my data in R

If you know your data will only be used in R, then the obvious choice is the **.rds** format. This stores and compresses data as R would internally store it in system memory. Use the `readRDS()` and `saveRDS()` functions to work with RDS files, for example:

```r
data("mtcars")
saveRDS(mtcars, "my_cars_data.rds")
rm(mtcars)
mtcars <- readRDS("my_cars_data.rds")
```

**Pros:**

* Fastest import/export, since very little processing needs to be performed to R objects.
* Smallest file sizes, thanks to compression of the file.
* All R objects can be stored (e.g. dates, shapefiles, lists, factors) and will be the same class when re-imported.

**Cons:**

* _Only_ compatible with R.

#### I'll use my data with cloud services or other programming languages

Consider using a column-oriented data storage format, such as [Apache Parquet](https://parquet.apache.org/) . This is optimised for fast import/export and compressing the data to small sizes. You can read more about it on the [Jumping Rivers blog](https://www.jumpingrivers.com/blog/parquet-file-format-big-data-r/).

**Pros:**

* Fast import/export.
* Small file sizes thanks to intelligent ways of compressing each column of data.
* Open-source means there is good support for this file type in other programming languages, such as Python, Java, C++.
* Encodes basic data types correctly (e.g. character, integer, double).

**Cons:**

* Requires finding packages or add-ins for use with different languages/software.
* Slower to import and export from R compared to .rds files due to the additional processing required.

#### I'll use my data in Excel / SAS / SPSS / Stata

To get data in and out of these formats, you’ll want to look at:

* [{readxl}](https://readxl.tidyverse.org/) for reading data from Excel files.
* [{openxlsx}](https://cran.r-project.org/web/packages/openxlsx/index.html) for reading and writing .xlsx Excel files.
* [{haven}](https://haven.tidyverse.org/) for reading and writing data for SAS, SPSS and Stata.

#### I'll need my data to be compatible with anything

Use a CSV file if you need to share data openly so that it is compatible with virtually all software. This is also the best solution if you need "human-readable" data files, that can be viewed and edited with software as simple as a text editor. Consider using the [{readr}](https://readr.tidyverse.org/index.html) package for importing and exporting CSV files.

**Pros:**

* Compatible with pretty much any software.
* Human-readable.
* Easy to get passed email virus scans as the file is essentially just plain text.

**Cons:**

* Largest file sizes as all values are stored in plain text.
* Slowest and most memory-consuming when importing and exporting large CSV files.
* You need to specify the value separator and any text delimiters on every import:
  * Using commas (,) is not always appropriate as a value separator, as some countries use this to mark decimal places. Consider using tab (\t) or semi-colon (;) in those situations.
  * Text entries that contain commas and line-breaks can break CSV files if the text is not delimited by quotation marks to mark the start and end of that entry.









