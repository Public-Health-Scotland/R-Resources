# Optimum method for writing data to, and reading data from Stats

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform.

## Purpose

This document aims to provide users with information on the optimum method for writing data to, and reading data from Stats, when working in an R session in Posit Workbench.

## Summary and Key Points

Benchmarking of various methods for writing data to, and reading data from Stats has been undertaken.  A one million row extract from the SMR01 dataset was written to, and read from, Stats from an R session in Posit Workbench using different methods.  The results have informed the guidance in this document.

The optimum method uses the `{arrow}` package to read and write *parquet* files, using *ZStandard* compression.

The *parquet* files are smaller than both .rds and .csv files, and `{arrow}` is optimised to work with larger-than-memory datasets.  The result is faster reading and writing, with a much smaller memory footprint.

### Example

```r
# Install required packages
install.packages("tidyverse")
install.packages("arrow")
install.packages("parallelly")

# Load required packages
library(tidyverse)
library(arrow)

# Correctly identify the number of CPUs available to the session
n_cpus <- as.numeric(parallelly::availableCores())

# Tell {arrow} how many CPUs it can use
arrow::set_cpu_count(n_cpus)

# Write the 'iris' dataset to a ZStandard compressed parquet file with
# {arrow}
arrow::write_parquet(iris,
                     sink = "/conf/linkage/output/iris.parquet",
                     compression = "zstd")

# Calculate the mean petal length by species from the parquet file
# written above
data <- arrow::read_parquet(file = "/conf/linkage/output/iris.parquet",
                            col_select = c("Species", "Petal.Length")) |>
  dplyr::group_by(Species) |>
  dplyr::summarise(mean_petal_length = mean(Petal.Length)) |>
  dplyr::collect()
```

The key takeaway from the example above is that `{arrow}` does not need to read the whole *parquet* file into memory; instead only the required data for the `{dplyr}` operations are read into memory and this results in much faster reading of the data and reduced memory consumption, in comparison to all other methods.

## Detail

*to follow...*
