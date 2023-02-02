# Posit Workbench, SMR01 and Memory Usage

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform.

## Purpose

This document aims to provide users with information on the minimum memory requirements in an R session for various sizes of extracts from the SMR01 dataset.

## SMR01 Memory Usage

Computer random access memory (RAM) gives applications a place to store and access data that are being actively used, and to do so quickly.

Executing an SQL query against the SMR01 database will result in that data being read into your R session's memory in it's entirety, and all subsequent operations on that data are performed *in-memory*. You therefore need to ensure that your session has access to sufficient free memory to hold the size of data you intend to work with in your analysis.

The following table presents various sizes of extracts from the SMR01 dataset, from 1 month's worth of data, to the whole of SMR01, along with the amount of memory required just to fetch these data into R, and the recommended amount of memory to request if you intend to work with a dataset of this size.

The extracts include all episodes in that time period, and all variables in the SMR01 dataset.  No filters have been applied, such as selecting on health board or diagnosis.

Remember that there are 1,024 Megabytes (MB) in 1 Gigabyte (GB).

| Time Period | Memory Usage (no R packages loaded) | Session Memory Recommendation |
|---|---|---|
| 1 month | 660.16 MB | between 2 GB (2048 MB) and 4 GB (4096 MB) |
| 3 months | 980.97 MB | between 2 GB (2048 MB) and 4 GB (4096 MB) |
| 6 months | 1.82 GB | between 3 GB (3072 MB) and 8 GB (8192 MB) |
| 1 year | 3.45 GB | between 5 GB (5120 MB) and 8 GB (8192 MB) |
| 2 years | 6.49 GB | between 8 GB (8192 MB) and 16 GB (16384 MB) |
| 5 years | 21.06 GB | between 23 GB (23552 MB) and 32 GB (32768 MB) |
| 10 years | xx.xx GB | xx GB (xxxxx MB) |
| All of SMR01 | xxx.xx GB | xxx GB (xxxxxx MB) |

If you have applied filters in your query, then the memory requirements to read these data into your R session and to work with that data will be reduced.

## Further Recommendations

Memory requirements in R can be reduced by querying the database for as small an initial dataset as possible.  This can be achieved by selecting only those variables required e.g.

```sql
SELECT LINK_NO,
       UPI_NUMBER,
       CIS_MARKER,
       ADMISSION_DATE,
       DISCHARGE_DATE,
       ADMISSION,
       DISCHARGE,
       URI,
       MAIN_CONDITION AS DIAG1
FROM   ANALYSIS.SMR01_PI
```

## Other Resources

Please also refer to the document [Posit Workbench and Kubernetes](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_and_kubernetes.md) for further guidance on memory usage in Posit Workbench.
