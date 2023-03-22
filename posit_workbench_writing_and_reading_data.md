> **Warning**
> This repository has been archived and is no longer maintained. All documentation has moved to (and maintained on) the [technical-docs](https://github.com/Public-Health-Scotland/technical-docs) repo and now available on the [PHS Data Science Knowledge Base](https://public-health-scotland.github.io/knowledge-base/). Please see these resources for up-to-date guidance.

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

### Results of benchmarking

#### Writing to Stats

Writing an extract of 1 million rows from the SMR01 dataset to the Stats server.  Each method of writing was run three times, and the median time taken to write the file to Stats calculated.  Times presented below are in seconds.

|Package|File Format|Compression|Minimum Time|Median Time|
|---|---|---|---|---|
|{arrow}|parquet|ZStandard|39.57|39.77|
|{arrow}|parquet|Snappy|46.53|46.59|
|{qs}|qs|ZStandard|4.69|46.92|
|{vroom}|csv|ZStandard|72|73.2|
|{vroom}|csv|Gzip|150|150|
|{readr}|csv|Uncompressed|174|174|
|{vroom}|csv|Uncompressed|172.8|174|
|{base}|rds|Default Compression|222.6|227.4|
|{fst}|fst|Default Compression|978|980.4|

#### Reading from Stats

Reading an extract of the SMR01 dataset containing 1 million rows, and aggregating to present a count of the number of episodes by location.  Each method was run three times to calculate the median time taken to read the file and aggregate the data.  Times presented below are in seconds.

|Package|File Format|Compression|Minimum Time|Median Time|
|---|---|---|---|---|
|{fst}|fst|Default Compression|0.34799|0.35548|
|{arrow}|parquet|ZStandard|0.37768|0.38025|
|{arrow}|parquet|Snappy|0.38535|0.3921|
|{vroom}|csv|ZStandard|3.97|4.02|
|{vroom}|csv|Uncompressed|4.03|4.11|
|{readr}|csv|Uncompressed|4.06|4.13|
|{vroom}|csv|Gzip|4.15|4.16|
|{qs}|qs|ZStandard|6.3|6.31|
|{base}|rds|Default Compression|17.43|17.52|
