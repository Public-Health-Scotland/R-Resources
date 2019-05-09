# Recommended R packages

This non-exhaustive list of recommended R packages is aimed primarily at beginners. It introduces some commonly used R packages across PHI and groups them into relevant categories. The majority of packages listed cover routine tasks such as reading and writing data files and data manipulation, however there are also recommendations for more niche areas such as statistical modelling and spatial analysis.

Some packages are listed in multiple categories (such as the [DT](https://github.com/rstudio/DT) package which is relevant to data visualisation, RMarkdown and shiny). Where possible, a link to the relevant GitHub repository for each package is provided.


### Reading and writing data

Package | Description
--- | ---
[odbc](https://github.com/r-dbi/odbc) | For connecting to database management systems, such as the SMRA datasets.
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


### Data visualisation

Package | Description
--- | ---
[ggplot2](https://github.com/tidyverse/ggplot2) | For creating static charts for reports.
[plotly](https://github.com/ropensci/plotly) | For creating interactive charts.
[gganimate](https://github.com/thomasp85/gganimate) | For 'animating' ggplot2 charts.
[leaflet](https://github.com/rstudio/leaflet) | For creating interactive maps.
[DT](https://github.com/rstudio/DT) | For creating interactive tables.


### RMarkdown

Package | Description
--- | ---
[rmarkdown](https://github.com/rstudio/rmarkdown) | For creating dynamic Word, HTML, PDF and PowerPoint documents using R.
[knitr](https://github.com/yihui/knitr) | For rendering RMarkdown documents.
[DT](https://github.com/rstudio/DT) | For creating interactive tables in HTML documents generated using RMarkdown.


### shiny

Package | Description
--- | ---
[shiny](https://github.com/rstudio/shiny) | For creating interactive web applications using R.
[shinydashboard](https://github.com/rstudio/shinydashboard) | For customising the layout of shiny applications.
[shinyWidgets](https://github.com/dreamRs/shinyWidgets) | For extending the widgets available in shiny.
[shinyjs](https://github.com/daattali/shinyjs) | For performing common JavaScript operations in shiny applications.


### Creating packages

Package | Description
--- | ---
[devtools](https://github.com/r-lib/devtools) | For simplifying common tasks in package development.
[testthat](https://github.com/r-lib/testthat) | For unit testing of functions.
[roxygen2](https://github.com/klutometis/roxygen) | For generating `.Rd` files required to pass `R CMD Check`.
[usethis](https://github.com/r-lib/usethis) | For automating repetitive tasks during package setup.


### Statistical modelling

Package | Description
--- | ---
[tidymodels](https://github.com/tidymodels) | A suite of tidyverse-inspired related R packages used for statistical modelling.
[broom](https://github.com/tidymodels/broom) | For converting statistical analyses objects into 'tidy' format.
[car](https://github.com/cran/car) | For conducting analysis of variance (ANOVA).
[lme4](https://github.com/lme4/lme4) | For fitting mixed-effects models.
[mgcv](https://github.com/cran/mgcv) | For fitting flexible, non-linear models such as Generalised Additive (Mixed) Models.
[survival](https://github.com/therneau/survival) | For survival analysis.


### Spatial analysis

Package | Description
--- | ---
[sp](https://github.com/edzer/sp) | For loading and manipulating spatial data.
[leaflet](https://github.com/rstudio/leaflet) | For creating interactive maps.
