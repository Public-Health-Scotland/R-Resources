# Recommended R packages

This list of recommended R packages is aimed primarily at beginners. It introduces some commonly used R packages across PHI and groups them into relevant categories. The majority of packages listed cover routine tasks such as reading and writing data files and data manipulation, however there are also recommendations for more niche areas such as spatial analysis and statistical modelling.

Some packages are listed in multiple categories (such as the [DT](https://github.com/rstudio/DT) package which is relevant to both RMarkdown and shiny). Where possible, a link to the relevant GitHub repository for each package is provided.


### Reading and writing data

Package | Description
--- | ---
[odbc](https://github.com/r-dbi/odbc) | To connect to database management systems, such as the SMRA datasets.
[readr](https://github.com/tidyverse/readr) | For reading and writing flat files, such as CSV files.
[haven](https://github.com/tidyverse/haven) | For reading and writing SPSS, SAS and Stata files.
[readxl](https://github.com/tidyverse/readxl) | For reading excel files.
[writexl](https://github.com/ropensci/writexl) | For writing excel files.
[here](https://github.com/r-lib/here) | For defining relative filepaths when using [RStudio Projects](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects).


### Data manipulation

Package | Description
--- | ---
[tidyverse](https://github.com/tidyverse) | A suite of related R packages used for data manipulation.
[dplyr](https://github.com/tidyverse/dplyr) | For selecting, filtering, aggregating and other basic operations.
[tidyr](https://github.com/tidyverse/tidyr) | For 'tidying' data, primarily by converting columns to rows and vice-versa.
[stringr](https://github.com/tidyverse/stringr) | For manipulation of character strings.
[lubridate](https://github.com/tidyverse/lubridate) | For working with dates.
[janitor](https://github.com/sfirke/janitor) | For 'cleaning' variable names and data.
