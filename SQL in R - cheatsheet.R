# Some tips and examples of SQL in R using SMRA views, which can be applied to other databases
# 
# Why would you want to use SQL?:
#   Faster - you extract the data you need quicker and further analysis will
#            be more efficient as well
#   Easy - the syntax of SQL is similar to how we construct phrases.
#   Transportable - can be used within Python, SPSS, R, on its own...
#   Good for R - R can run in to memory issues if your data sets are too large.
#                With SQL you reduce the size of your objects.
# 
# SQL always needs two parameters: SELECT (what fields you want) and 
# FROM (what table you want).
# WHERE is a command very oftenly used, it is used to add any condition 
# (e.g. time period, age, diagnosis).
# There are other many other commands such like JOIN (for linking tables), 
# GROUP BY (to aggregate) and ORDER BY (to sort cases).
# 
# With SQL, Internet is your friend, search for an answer and you shall find it.
# This is an useful web to learn SQL: http://www.w3schools.com/sql/default.asp
# And this a good summary of using SQL in SMRA (from where some of this info comes from):
# https://github.com/Public-Health-Scotland/R-Resources/blob/master/using%20SMRA%20with%20R.md
# 
# Common problems/errors while writing SQL code in R:
#   Problems with simple and double quotation marks. 
#   Commas before FROM, or lack of commas between fields.
#   No grouping by expressions or missing some, if you use any command to aggregate
#   the data you will need a group by

# Use the table of contents to get to the right bit of information

# This script cover examples using native SQL within R, but another approach
# is to use the package dbplyr which translates R code (based on dplyr) into SQL.

###############################################.
## Let's start ----
###############################################.
# You will need access to SMR01 and the deaths catalogue
# To connect to a database first you need the package odbc
library(odbc)
library(dplyr) # and dplyr for a couple of things

# And now connect to the database with your login details
channel <- suppressWarnings(dbConnect(odbc(),  dsn="SMRA",
                                      uid=.rs.askForPassword("SMRA Username:"), 
                                      pwd=.rs.askForPassword("SMRA Password:")))

# Show all tables/views available 
dbListTables(channel)
# Look at the table 'scheme' types that are available by running the code below
odbcListObjects(channel)  
# "Analysis" schemes are the analysis views, likely the ones you want to use. 
# Tables with a 'scheme' which is a username are data uploaded by individual users. 
# Show tables/views again, but this time restrict to "Analysis" views only.
odbcListObjects(channel, schema="ANALYSIS")
# You can now see the names of the analysis views, these are the same names/data 
# Most of the views are versions of the various SMR databases: 
# SMR00 (outpatients), SMR01 (Acute hospital activity), SMR04 etc.
# The "_PI" suffix means that these views contain personally identifying 
# information (names, dates of birth etc). SMRXX_PI is the usual version used 
# for analyses. SMRA also includes NRS death records (GRO_DEATHS_C). 
# Other files are reference files which contain information about coded fields
# e.g. if you have a list of codes referring to hospitals and you want to know 
# the hospital names or postcodes, you would use the LOCATION view to look up 
# this information.
# 
# In order to view the variables, we can preview the table. 
# Further details of variable names and attributes in each of the SMR views 
# can also be found in the view layout files.
odbcPreviewObject(channel, table="ANALYSIS.SMR01_PI", rowLimit=0)

###############################################.
## 1 - Look for data on an specific period of time ----
###############################################.
# In this example data is retrieved between the 1st and 2nd of April 16
sql_example1 <- tbl_df(dbGetQuery(channel, statement=
  "SELECT admission_date
   FROM ANALYSIS.SMR01_PI 
   WHERE admission_date between '1 April 2016' and '2 April 2016' ")) %>% 
  setNames(tolower(names(.))) # converting variable names into lower case

View(sql_example1)

###############################################.
## 2 - Select data for a field ----
###############################################.
# In this example data is retrieved for the Monkland hospital patients over 65.
# Logic operators are used to indicate the conditions of the query: and, or, =, >, <, >=, =<, <>.
sql_example2 <- tbl_df(dbGetQuery(channel, statement=
  "SELECT location, age_in_years
   FROM ANALYSIS.SMR01_PI 
   WHERE admission_date between '1 April 2016' and '2 April 2016' 
         AND age_in_years > 65
         AND location = 'L106H' ")) %>% 
  setNames(tolower(names(.))) # converting variable names into lower case

View(sql_example2)

###############################################.
## 3 - Select data for a field ----
###############################################.
# When you want to extract more than one value in a string field, the function IN 
# is very useful. It is equivalent to a series of OR each one with a different string value.
# In this example data is retrieved for Monkland and Southern General patients.
sql_example3 <- tbl_df(dbGetQuery(channel, statement=
  "SELECT location, age_in_years
   FROM ANALYSIS.SMR01_PI 
   WHERE admission_date between '1 April 2016' and '2 April 2016' 
        AND location in ('L106H', 'G405H') ")) %>% 
  setNames(tolower(names(.))) # converting variable names into lower case

View(sql_example3)

###############################################.
## 4 - Exclude missing values ----
###############################################.
# This is done with the expression is not null. If you wanted to pull out the 
# records with missing values you should use "is null".
sql_example4 <- tbl_df(dbGetQuery(channel, statement=
   "SELECT postcode
   FROM ANALYSIS.SMR01_PI 
   WHERE admission_date between '1 April 2016' and '2 April 2016' 
        AND postcode is not null  ")) %>% 
  setNames(tolower(names(.))) # converting variable names into lower case

View(sql_example4)

###############################################.
## 5 - Look for an specific string expression (e.g, diagnosis, word) ----
###############################################.
# This is done through the regexp_like expression. This looks for the text that 
# you want in the field, in a particular position or in any.
# Regular expressions are very powerful and for example can be adjusted to look 
# for strings in specific parts of the field.
# In these examples we retrieve patients that had a diganosis of C51 to C58. 
# We show two ways of doing it.
sql_example5_1 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT main_condition
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '10 April 2016' 
          AND REGEXP_LIKE(main_condition,'C51|C52|C53|C54|C55|C56|C57|C58') ")) 

View(sql_example5_1)

sql_example5_2 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT main_condition
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '10 April 2016' 
          AND REGEXP_LIKE(main_condition,'C5[1-8]') ")) 

View(sql_example5_2)

# In some simpler cases, the function "like" can be used as well, faster but more limited.
sql_example5_3 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT main_condition
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '10 April 2016' 
          AND main_condition like 'C5%' ")) 

View(sql_example5_3)

# We use the function lower to make the search case insensitive. 
# We could use the function upper as well.
# In this example we look for a series of surnames for which we are not sure if, 
# they are in upper, lower case or a combination.
sql_example5_4 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT surname
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '10 April 2016' 
          AND REGEXP_LIKE(Lower(surname),'taylor|smith|jones|williams') ")) 

View(sql_example5_4)

###############################################.
## 6 - Sort cases ----
###############################################.
# This is done with the ORDER BY command that is placed at the end of the SQL code. 
# More than one variable can be used to sort.
sql_example6_1 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT admission_date, length_of_stay, location
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '2 April 2016' 
    ORDER BY length_of_stay, location ")) 

View(sql_example6_1)

# To obtain the same sort order than in the old linked catalog file, you can sort it this way:
# You don't need to include your order by variables in your select command if you don't want.
# For more information about this, consult SAF bulletin no 16.
sql_example6_2 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT admission_date, length_of_stay, location
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '2 April 2016' 
    ORDER BY link_no, admission_date, discharge_date, admission, discharge, uri ")) 

View(sql_example6_2)

###############################################.
## 7 - Combine two fields into one ----
###############################################.
# This is done with the ORDER BY command that is placed at the end of the SQL code. 
# More than one variable can be used to sort.
sql_example7 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT first_forename || ' ' || surname as full_name
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '2 April 2016' 
    ORDER BY length_of_stay, location ")) 

View(sql_example7)

###############################################.
## 8 - Aggregate data ----
###############################################.
# The group_by/summarise R functions have an equivalent in SQL. 
# There are several ways of doing it, with different functions for it: count, average, sum, max, min. 
# Median is not calculated in a straightforward way 
# (sort by the field you are interested and calculate the mid value) - probably better through R
# The command GROUP By needs to be used together with these functions. 
# More than one field can be included in the group by command.
# In this example we calculate the count of episodes
# and the mean, sum, max and min lenght of stay by hospital.
sql_example8_1 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT location, count(link_no) count, avg(length_of_stay) mean, 
          sum(length_of_stay) sum, max(length_of_stay) max, min(length_of_stay) min
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '5 April 2016' 
    GROUP BY location ")) 

View(sql_example8_1)

# SQL can also provide totals for each group category. This is done using rollup.
# In this case it will provide the total for all the hospitals.
sql_example8_2 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT location, count(link_no) count, avg(length_of_stay) mean, 
          sum(length_of_stay) sum, max(length_of_stay) max, min(length_of_stay) min
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '5 April 2016' 
    GROUP BY rollup(location) ")) 

View(sql_example8_2)

###############################################.
## 9 -  Select distinct-unique values ----
###############################################.
# Many times you might be interested in just getting to know the range of 
# values of an specific field. This is quickly done with the select distinct 
# expression. In this case we look to the list of different hospitals/locations in Scotland.
# If you add more than one variable it will provide you a list of all the combinations found.
sql_example9_1 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT distinct location
    FROM ANALYSIS.SMR01_PI ")) 

View(sql_example9_1)

# Distinct can be used for other purposes, for example to avoid only extracting 
# one row per admissions instead of one row per episode.
# In this example, we count the number of different episodes, admissions and 
# patients in each hospital, using the distinct and the total method.
# The distinct method counts only once each different link_no for each hospital, 
# the total one counts how many rows have that value (excluding missing).
sql_example9_2 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT location, count (link_no) total_count, count(distinct link_no) patient_count, 
          count(distinct link_no || '-' || cis_marker) admission_count
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '5 April 2016' 
    GROUP BY location ")) 

View(sql_example9_2)


###############################################.
## 10 -  Calculate calendar year, financial year, month, month-year, weekday ----
###############################################.
# Many times you might be interested in just getting to know the range of 
# values of an specific field. This is quickly done with the select distinct 
# expression. In this case we look to the list of different hospitals/locations in Scotland.
# If you add more than one variable it will provide you a list of all the combinations found.
sql_example10 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT extract(year from admission_date) as calendar_year,
        CASE WHEN extract(month from admission_date) > 3 
            THEN extract(year from admission_date) 
              ELSE extract(year from admission_date) -1 END as financial_year,
        extract(month from admission_date) month, 
        to_date(to_char(admission_date, 'MON-YY'), 'MON-YY') month_year,
        TO_CHAR(admission_date, 'Q') quarter,
        to_char(admission_date, 'Day') weekday,
        to_char(admission_date, 'YY-WW') week_number,
        count(link_no) episodes
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 July 2016' and '5 August 2017' 
    GROUP BY extract(year from admission_date), TO_CHAR(admission_date, 'Q'), 
        extract(month from admission_date), CASE WHEN extract(month from admission_date) > 3 
        THEN extract(year from admission_date) ELSE extract(year from admission_date) -1 END, 
        to_date(to_char(admission_date, 'MON-YY'), 'MON-YY'), 
        to_char(admission_date, 'Day'), to_char(admission_date, 'YY-WW') 
    ORDER BY week_number ")) 

View(sql_example10)

###############################################.
## 11 - Extracting a part of a string ----
###############################################.
# In this example, we are extracting the first 3 characters of the main cause of death.
sql_example11 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT substr(underlying_cause_of_death, 1, 3) pcause, count(link_no) number_deaths
    FROM ANALYSIS.GRO_DEATHS_C 
    WHERE date_of_registration between '1 January 2016' and '31 December 2016' 
    GROUP BY substr(underlying_cause_of_death, 1, 3) ")) 

View(sql_example11)

###############################################.
## 12 - Retrieving the lenght of a string----
###############################################.
# In this example, we are extracting the first 3 characters of the main cause of death.
sql_example12 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT postcode, LENGTH(postcode) len_pc
    FROM ANALYSIS.GRO_DEATHS_C 
    WHERE date_of_registration between '1 January 2016' and '31 December 2016'  ")) 

View(sql_example12)

###############################################.
## 13 - Create a variable based on a condition ----
###############################################.
# In this case we selected patients with an specific diagnosis and we create a 
# category to indicate if they have more than 65 years.
sql_example13 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT count(distinct link_no || '-' || cis_marker) admission_count,
        CASE WHEN age_in_years > 65  then 'Y' else 'N' end over_65
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '5 April 2017'  
        AND main_condition like 'C1%' 
    GROUP BY CASE WHEN age_in_years>65  then 'Y' else 'N' end")) 

View(sql_example13)

###############################################.
## 14 - Create categories of cases ----
###############################################.
# Using the case function we can aggregate data based on categories.
# In this case we count episoder, split in different categories based on their type.
sql_example14 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT hbtreat_currentdate,
            count(*) ip_dc,  
            count(CASE WHEN inpatient_daycase_identifier ='D' THEN discharge_date END) daycases,  
            count(CASE WHEN inpatient_daycase_identifier ='I' THEN discharge_date END) total_ip,  
            count(CASE WHEN admission_type in ('10', '11', '12', '19')  
                  AND inpatient_daycase_identifier='I' THEN discharge_date END) elective_ip,  
            count(CASE WHEN admission_type in ('20', '21', '22', '30', '31', '32', 
                  '33', '34', '35', '36', '38', '39') THEN discharge_date END) emergency,  
            count(CASE WHEN admission_type = 18 
                  AND inpatient_daycase_identifier='I' 
                  THEN discharge_date END) transfers  
    FROM ANALYSIS.SMR01_PI 
    WHERE discharge_date between '1 April 2016' and '2 April 2017'  
    GROUP BY hbtreat_currentdate ")) 

View(sql_example14)

###############################################.
## 15 - Extract data from one table if it exists in another table/query ----
###############################################.
# The table we are extracting data from receives an alias (z in this case), 
# and the linking variable (UAI in this case) needs to have that alias in front.
# In this example we extract all episode for a patient from the inpatient 
# table if that individual have had a previous admission due to COPD .
# *Another case when this function could be useful is to look into inpatient
# information of individuals that have gone through an appointment
# in an specific clinic.
sql_example15 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT link_no, cis_marker, age_in_years, admission_date, main_condition
    FROM ANALYSIS.SMR01_PI Z
    WHERE admission_date between '1 April 2016' and '5 April 2017' 
          AND exists(SELECT * FROM ANALYSIS.SMR01_PI 
              WHERE link_no = z.link_no AND cis_marker = z.cis_marker
                  AND regexp_like(main_condition, 'J4[0-4]')
                  AND admission_date between '1 April 2016' and '5 April 2017')")) 

View(sql_example15)

###############################################.
## 16 - Extract information from two tables at the same time ----
###############################################.
# This is done through the INNER JOIN, FULL OUTER JOIN and LEFT JOIN commands.
# The LEFT JOIN keyword returns all rows from the left table (the one included in from), 
# with the matching rows in the right table (the one in the join command). 
# The result is NULL in the right side when there is no match.
# The INNER JOIN keyword selects all rows from both tables as long as there is a
# match between the columns in both tables.
# The FULL OUTER JOIN keyword returns all rows from the left table (table1) and 
# from the right table (table2).    
sql_example16_1 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT z.year_of_registration, h.location, count(distinct h.link_no) patients, 
          sum(length_of_stay) sum, max(length_of_stay) max, min(length_of_stay) min
    FROM ANALYSIS.SMR01_PI H
    LEFT JOIN ANALYSIS.GRO_DEATHS_C Z ON h.link_no = z.link_no 
    WHERE h.admission_date between '1 April 2016' and '5 August 2016' 
          AND inpatient_daycase_identifier='I'
    GROUP BY h.location, z.year_of_registration ")) 

View(sql_example16_1)

# In this example, we retrieve information about road traffic casualties, 
# both admissions and deaths. Union all brings all the information from two or 
# more tables, but they have to have the same column names, that's why in the first 
# select we extract a variable as null
sql_example16_2 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT link_no, year_of_registration year, age, sex sex_grp, postcode pc7, 
        null as cis_marker
    FROM ANALYSIS.GRO_DEATHS_C
    WHERE date_of_registration between '1 April 2016' and '5 April 2017' 
          AND regexp_like(underlying_cause_of_death, 'V[0-8]') 
    UNION ALL
    SELECT link_no, extract(year from admission_date) year, age_in_years age, 
          sex sex_grp, dr_postcode pc7, cis_marker
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '5 April 2017' 
          AND admission_type = 32 
          AND admission_date between '1 April 2002' and '5 April 2017' ")) 

View(sql_example16_2)

###############################################.
## 17 - Select the values of the last record when aggregating ----
###############################################.
# You can use KEEP DENSE_RANK for this task. Sorting order is important and
# using the wrong one could bring slightly different/wrong results
# Try it with a small dataset before applying it
sql_example17_1 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT  link_no, cis_marker, main_condition, admission_date, discharge_date,
       MAX(main_condition) KEEP ( DENSE_RANK LAST ORDER BY link_no, admission_date, 
                          discharge_date, admission, discharge, uri) 
          OVER(PARTITION BY link_no, cis_marker) last_diag
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '5 April 2016' 
    ORDER BY link_no, cis_marker  "))

View(sql_example17_1)

###############################################.
## 18 - Select the values of the first record when aggregating ----
###############################################.
# The two methods produce the same results, but the order by variables are important
# as if not completely unequivocal each method might differ in which one first,
# for example if only sorted by admission date and two episodes have same date
sql_example18_1 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT link_no, cis_marker, main_condition, admission_date, discharge_date,
        FIRST_VALUE(main_condition) OVER (PARTITION BY link_no, cis_marker 
                             ORDER BY link_no, admission_date, discharge_date, 
                                admission, discharge, uri) first_diag
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '5 April 2016' 
    ORDER BY link_no, cis_marker  ")) 

View(sql_example18_1)

sql_example18_2 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT  link_no, cis_marker, main_condition, admission_date, discharge_date,
       MAX(main_condition) KEEP ( DENSE_RANK FIRST ORDER BY link_no, admission_date, 
                  discharge_date, admission, discharge, uri) 
          OVER(PARTITION BY link_no, cis_marker) first_diag
    FROM ANALYSIS.SMR01_PI 
    WHERE admission_date between '1 April 2016' and '5 April 2016' 
    ORDER BY link_no, cis_marker  "))

View(sql_example18_2)

###############################################.
## 19 - Concatenating strings from multiple rows into one  ----
###############################################.
# The key command here is LISTAGG, which also requires within group and order by 
# it can also include a partition like in this example.
# This example retrieves one row per admission with its first main diagnosis 
# and the concantenated list of diagnosis (combining all different episodes ones)
# Again be mindful of your sorting variables if you care about the order in the
# concatenated string
sql_example19 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT distinct link_no, cis_marker,
            FIRST_VALUE(main_condition) OVER (PARTITION BY link_no, cis_marker 
                             ORDER BY admission_date, discharge_date) diag,
            LISTAGG(main_condition, '|') WITHIN GROUP 
                (ORDER BY admission_date, discharge_date) 
                  OVER (PARTITION BY link_no, cis_marker ) AS diag_string
    FROM ANALYSIS.SMR01_PI  
    WHERE admission_date between '1 April 2016' and '5 April 2016'
    ORDER BY link_no, cis_marker")) 

View(sql_example19)

###############################################.
## 20 - Simplify queries when they get overly complicated with conditions ----
###############################################.
# To reduce risk of problems with brackets and and/or's.
# This example selects a series of inpatient cases for a certain period and
# a certain location and a different period for a different hospital.
# Using and/s and or/s and parenthesis syntax would be long and complex.
sql_example20 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT admission_date, discharge_date, location, link_no
    FROM ANALYSIS.SMR01_PI  
    WHERE inpatient_daycase_identifier = 'I'
        AND CASE WHEN(admission_date between '1 April 2016' and '5 April 2016'
            OR discharge_date between '1 April 2016' and '5 April 2016')
            AND location='G405H' THEN 1
        WHEN location='L106H'
              AND admission_date between '1 April 2016' and '5 April 2016'
              THEN 1 ELSE 0 END = 1
    ORDER BY link_no, admission_date")) 

View(sql_example20)

###############################################.
## 21 -Select only if more than x results ----
###############################################.
# Using the case function we can aggregate data based on categories.
# Two ways of doing, but they extract the same data. Both of them use the 
# function having, which includes the count condition.
# In the example, we are pulling the number of patients with more than one 
# episode to an speciffic hospital during a period of time.
sql_example21_1 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT count(*) count_episode, link_no 
    FROM ANALYSIS.SMR01_PI  
    WHERE admission_date between '1 April 2016' and '5 June 2016'
        AND location='L106H' 
        AND link_no IN
          (SELECT link_no FROM ANALYSIS.SMR01_PI
          WHERE admission_date between '1 April 2016' and '5 June 2016'
                AND location='L106H'
          GROUP BY link_no HAVING COUNT(link_no)>1 )
    GROUP BY link_no")) 

View(sql_example21_1)

# This approach can retrieve the same results as the previous one. 
# However is coded to retrieve the information on the episodes of 
# patients with more than episode, instead of providing a count.
sql_example21_2 <- tbl_df(dbGetQuery(channel, statement=
    "SELECT z.link_no, z.admission_date, z.discharge_date
    FROM ANALYSIS.SMR01_PI  Z
    JOIN(SELECT z2.link_no FROM ANALYSIS.SMR01_PI z2 
        WHERE z2.admission_date between '1 April 2016' and '5 June 2016'
            AND z2.location = 'L106H' 
        GROUP BY z2.link_no having count(*)>1) 
        z2 on z2.link_no = z.link_no
    WHERE z.discharge_date between '1 April 2016' and '5 June 2016'
        AND z.location = 'L106H' ")) 

View(sql_example21_2)

###############################################.
## 22 - Subqueries with WITH ----
###############################################.
# WITH creates a table that you can query in the second part of the query
# This query extracts all episodes from admissions in which one of their episodes
# had a specific diagnosis during a particular time period (exists), 
# then brings one row per admission with the start and end dates of their 
# admission, apart from selecting their first relevant hb (WITH subquery) and in 
# the last part it selects only the ones with a final discharge date in the period required.
# You could run the three subqueries separately to understand what each one pulls.
sql_example22 <- tbl_df(dbGetQuery(channel, statement=
    "WITH adm_table AS (
        SELECT distinct link_no || '-' || cis_marker admission_id, 
            FIRST_VALUE(hbres_currentdate) OVER (PARTITION BY link_no, cis_marker 
                ORDER BY admission_date, discharge_date) hb,
            MIN(admission_date) OVER (PARTITION BY link_no, cis_marker) start_cis,
            MAX(discharge_date) OVER (PARTITION BY link_no, cis_marker) end_cis
        FROM ANALYSIS.SMR01_PI  z
        WHERE exists(
          SELECT * 
          FROM ANALYSIS.SMR01_PI  
          WHERE link_no=z.link_no and cis_marker=z.cis_marker
              AND regexp_like(main_condition, 'C')
              AND discharge_date between '1 June 2018' and '31 December 2018' 
        )
    )
    SELECT admission_id, start_cis, end_cis,  hb
    FROM adm_table 
    WHERE end_cis between '1 June 2018' and '31 December 2018' ")) 

###############################################.
## 23 - Create tables  ----
###############################################.
# Similarly as with the command WITH you can create temporary tables that then
# you can use in other queries
# In this example we will create a table with information on a set of patients
# that will be used to extract more information about these patients.

# First we create the dataframe with the list of patients we are interested in.
# Variable names must be in ALL CAPITALS to be used in an SQL query later.
# Tables with non-capitalised variable names will upload, but you will not be 
# able to use the non-capitalised names in an SQL query.

test_data <- data.frame(LINK_NO = c(00000119, 75881029, 45960570, 00019300, 01959251, 
                                    01959200, 11949200, 02939132, 00000383),
                        INCOHORT = rep("yes", 9))

# Upload to SMRA using the dbWriteTable function
dbWriteTable(channel, "test", test_data)

# The table will be uploaded to a schema that is your username. 
# To see a list of tables that you have uploaded run:
dbListTables(channel, schema="USERNAME")
# Replacing with the username you use to access SMRA, in all capitals.

# The table name must be enclosed in double quotes, this only applies to your 
# uploaded tables, NOT to SMRA tables/views generally. The query statement as a 
# whole must therefore be enclosed in single quotes when using a temporary table.
# Example:
# This syntax works:
sql_example23_1 <- dbGetQuery(channel, statement='SELECT * FROM USERNAME."test" ') 
# This syntax, with the double and single quote positions inverted, will result in an error.
sql_example23_1 <- dbGetQuery(channel, statement="select * from 'USERNAME.test'")

# You can now use the uploaded table in another query . We will use the table to 
# retrieve information from SMRA using a JOIN command.
sql_example23_2 <- tbl_df(dbGetQuery(channel, statement=
  'SELECT t2.link_no, t2.cis_marker, t2.location, t2.admission_date, 
          t2.discharge_date, t2.main_condition, t1.incohort
   FROM USERNAME."test" T1 
   LEFT JOIN ANALYSIS.SMR01_PI T2 ON t1.link_no = t2.link_no ' ))

# Delete the table once you have finished using it using dbRemoveTable
dbRemoveTable(channel, "test")
# To check it has been removed:
dbListTables(channel, schema="USERNAME")

# It is of course possible to extract information based on a personal table
# containing other fields in addition to LINK_NO to further refine the selection, 
# perhaps years of interest in combination with LINK_NO.

# Uploading dates from R to SMRA is a little complicated, you will need to do some
# formatting in SQL. Before uploading, you first need to convert the dates in the 
# cohort file to a numeric field in CCYYMMDD format. You will then nee to alter 
# the type of the SMR dates to the same numeric format during the extraction.

# The example below extracts SMR01 data in the year to infection. 
# The uploaded file contains a list of patient UPIs and two dates, indicating a 
# sample date and a date one year before the sample, and these dates are used 
# to limit the data extracted.
test_data2 <- data.frame(LINK_NO = c(00000119, 75881029, 45960570, 00019300, 01959251, 
                                    01959200, 11949200, 02939132, 00000383),
                        SPECDATE = c(20141114, 20140412, 20130530, 20130607, 
                                     20140125, 20141118, 20130701, 20141212, 20140503)) %>% 
  mutate(SPECDATE1YR = SPECDATE-10000)

dbWriteTable(channel, "test2", test_data2)

sql_example23_3 <- tbl_df(dbGetQuery(channel, statement=
  'SELECT t0.link_no, t0.specdate, t0.specdate1yr, t1.link_no, t1.admission_date, 
        to_number(to_char(t1.admission_date,\'YYYYMMDD\')) AS adm_date_num
   FROM JAMIEV01."test2" T0, ANALYSIS.SMR01_PI T1 
   WHERE t0.link_no = t1.link_no (+)
        AND to_number(to_char(t1.admission_date,\'YYYYMMDD\')) >= t0.specdate1yr 
        AND to_number(to_char(t1.admission_date,\'YYYYMMDD\')) <= t0.specdate'))

###############################################.
## 24 - Combine R and SQL with paste ----
###############################################.
# Example of looking in all diagnosis positions? diabetes?
# The SQL query is a string of text so combined with R through paste to reduce
# duplication or use values obtained in a previous analysis in your query
# In this example we have a list of diagnosis that we want to search in all
# diagnostic positions
diabetes_diag <- "E1[0-4]"

sql_example24 <- tbl_df(dbGetQuery(channel, statement = paste0(
 "SELECT main_condition, other_condition_1, other_condition_2, other_condition_3,
        other_condition_4, other_condition_5
    FROM ANALYSIS.SMR01_PI 
    WHERE discharge_date between '1 April 2009' and '14 April 2009'
      AND (regexp_like(main_condition, '", diabetes_diag, "') 
          OR regexp_like(other_condition_1, '", diabetes_diag, "') 
          OR regexp_like(other_condition_2, '", diabetes_diag, "') 
          OR regexp_like(other_condition_3, '", diabetes_diag, "') 
          OR regexp_like(other_condition_4, '", diabetes_diag, "') 
          OR regexp_like(other_condition_5, '", diabetes_diag, "') ) "))) 

View(sql_example24)

###############################################.
## 25 - Limit number of rows retrieved ----
###############################################.
# Particularly when you are trying a query you want to limit how many rows
# you are bringing back to test that the query is working as desired.
# You can do this in many way: looking to a particular date, patient, location
# or just limiting how rows  the query will retrieved using ROWNUM.
# The example below will just bring 10 rows
sql_example25 <- tbl_df(dbGetQuery(channel, statement=
  "SELECT admission_date
   FROM ANALYSIS.SMR01_PI 
   WHERE ROWNUM <= 10 ")) 

View(sql_example25)

###############################################.
## 26 - Note on variables with leading zeros ----
###############################################.
# Any number with leading zeros will have these dropped by default when you 
# query the database. E.g. '00001234' will be returned as '1234'. To retrieve 
# the variable with leading zeros included, we use the LPAD function: 
# e.g. the variable "LINK_NO" which should be 
# 10 characters long and sometimes contains leading zeros:
#  "SELECT LPAD(LINK_NO,10,0), ....." Will return 1234 as 0000001234.
sql_example26 <- tbl_df(dbGetQuery(channel, statement=
  "SELECT LPAD(link_no, 10, 0) as link_no
   FROM ANALYSIS.SMR01_PI 
   WHERE ROWNUM <= 100 ")) 

View(sql_example26)


##END
