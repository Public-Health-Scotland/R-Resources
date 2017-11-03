############################################### 
## Run Chart Production                      ##
## Quality Indicators Team                   ##
## November 2017                             ##
##                                           ##
## Written to be run on R desktop            ##
## R version 3.3.2 (Sincere Pumpkin Patch)   ##  
## Requires tidyverse package, may require   ##
## may also require haven (for spss)  and    ##
## xlsx (for excel)                          ##
##                                           ##
## Script prepares run chart data            ##
## Script does NOT produce run charts        ##
## chart visualisation must be done in an    ##
## external tool. Produced data includes:    ##
##                                           ##
## - Centreline                              ##
## - Shift markers                           ##
## - Trend markers                           ##
##                                           ##
###############################################

### SECTION 0 - INSTRUCTIONS FOR RUNNING ---- 

# Step 1: Ensure data meets requirements:
#
#         - Data must be in a "long" format (one row per observation)
#         - Data must contain a time period (e.g. quarter, year etc)
#         - Data must contain a geography/location variable (e.g. hospital, health board)
#         - Data must contain an "indicator name" variable (e.g. "crude mortality rates" etc)
#         - Data must contain an "indicator value" variable (e.g. the actual crude mortality rates) 
#
# Step 2: Set appropriate working directories and load in appropriate data (see: SECTION 1 - HOUSEKEEPING)
#
# Step 3: Change variable names in data.Variable and object names in script below are generic
#         so corresponding variable names must be changed in the data to match. These can be 
#         changed back at the end of the script. Code for doing this
#         can be found in SECTION 1 - HOUSEKEEPING. The variable/object names are:
#
#         - "data" is the name of the dataframe/object containing the data
#         - "geography" is the name of the variable for geography/location e.g. hospital
#         - "measure" is the name of the "indicator name" variable
#         - "mval" is the name of the "indicator value" variable
#
# NOTE: If you require either tidyverse, xlsx or haven, install them by running the following code:

install.packages('PACKAGE_NAME')



### SECTION 1 - HOUSEKEEPING ----

# 1 - Loading packages
library(tidyverse)

# 2 -  Setting working directory (filepath containing your data files) ----

setwd("INSERT FILEPATH HERE")

# 3 -  Reading in data (delete unnecessary lines) ----

data <- read.csv('FILENAME.csv')           # If csv file
data <- read.table('FILENAME.xlsx')        # If xls file
data <- foreign::read.spss('FILENAME.sav') # If sav file

# Changing variable names to match script. Replace "VARIABLE_NAME" with the variable name found in data
# If you only have a single geography or measure, delete the corresponding rows from the command below:
data <- data %>% 
  rename(geography = VARIABLE_NAME,
         measure   = VARIABLE_NAME,
         mval      = VARIABLE_NAME)


# NOTE: if you only have one measure or one geography (e.g. all of Scotland),
# then uncomment the appropriate line(s) of code (below) as this will ensure
# that the loop still works without segmenting the data based on geography/measure 

#data$geography <- "All"
#data$measure   <- "All"

# NOTE: the text "All" doesn't matter or have an impact on the output, but you can choose
# a different piece of text if there is something else which would be more meaningful


### SECTION 2 - DATA PRODUCTION ----

# 1 - Creating vectors containing all unique geographies and Measures ----

geography       <- as.character(unique(data$geography))
Measure         <- as.character(unique(data$Measure))

### Declaring output data frame

output_data     <- data.frame(matrix(nrow = 1, ncol = 7)) 
names(output_data) <- c("Measure", "geography", "time period", "chart_value", "median", 
                                      "shift", "trend")

### Creating run charts for all combinations of Measures and geographies:

for(i in 1:length(Measure)){
  for(h in 1:length(geography)){
    
    ### Extracting the Measure values for the current indicator and geography
    Measure_values    <- as.numeric(data$mval[which(data$geography == geography[h] & data$Measure == Measure[i])])
    
    if(length(Measure_values) <= 8){
      break
    }
        
    ### Creating an indexing vector from 1 to the latest time period
    q                 <- seq(1, length(Measure_values)) 
    
    ### Calculating the median of each Measure (i) for each geography (h)
    med               <- median(Measure_values)
    
    ### trend_value     = vector of Measure values that are part of a trend
    ### shift_value     = vector of Measure values for data points that are part of a shift
    ### trend_direction = vector identifying direction of trend
    ### shift_direction = vector identifying direction of shift
    trend_value       <- rep(NA, length(Measure_values)) 
    shift_value       <- rep(NA, length(Measure_values)) 

    ### trend up/down   = count of successive points that trend up or down
    trend_up          <- 0
    trend_down        <- 0
    
    ### count_above/below = count of successive data points that sit above/below the median
    count_above       <- 0
    count_below       <- 0
    
    ### TRENDS
    ### Setting starting point for calculation of trends (time period 2)
    k                 <- 2 
    ### Running through each time period and checking for trends:
    for (k in 2:length(Measure_values)){ 
      ### Checking if the data point is greater than or less than the previous data point.
      ### If 5 or more consecutive data points are all either increasing or decreasing
      ### then the Measure datapoints are stored in trend_value in the correct position.
      if (Measure_values[k] > Measure_values[k - 1]){
        trend_up                <- trend_up + 1
        trend_down              <- 0
        ### Marking the start of an upward trend so that full trend can be captured in output
        if (trend_up == 1){ 
          new_trend_start       <- k-1
        }
      }
      if (Measure_values[k] < Measure_values[k - 1]){
        trend_down              <- trend_down + 1
        trend_up                <- 0
        ### Marking the start of a downward trend so that full trend can be captured in output
        if (trend_down == 1){ 
          new_trend_start       <- k-1
        }
      }
      if (trend_up > 3 | trend_down > 3){
        trend_value[new_trend_start : k]  <- Measure_values[new_trend_start : k]
      }
      ### Checking if the current data point sits on the median line and if so skip to the 
      ### next data point and continue counting
      if (Measure_values[k] == med){ 
        next
      }
    } 

    ### SHIFTS
    ### Resetting k to 1 to look for shifts
    k <- 1
    ### Running through each time period and checking for shifts:
    for (k in 1:length(Measure_values)){
      ### Checking if the current data point sits on the median line and if so skip to the 
      ### next data point and continue counting
      if (Measure_values[k] == med){ 
        if(count_above > 6 | count_below > 6){}
        else{next}
      }
      ### Upward shift - checking if the current data point sits above the median line
      if (Measure_values[k] > med) {  
        count_above           <- count_above + 1 
        count_below           <- 0 
        ### Marking the start of an upward shift so that full shift can be captured in output
        if (count_above == 1){ 
          new_shift_start     <- k
        }
      }
      ### Downward shift - checking if the current data point sits below the median line
      if (Measure_values[k] < med) {
        count_below           <- count_below + 1
        count_above           <- 0
        ### Marking the start of a downward shift so that full shift can be captured in output
        if (count_below == 1){ 
          new_shift_start     <- k
        }
      } 
      ### If count below is high enough for there to be a downward shift (6 or more)
      ### then all points that form part of that shift are flagged as "shift"
      if (count_below > 5){
        shift_value[new_shift_start : k] <- Measure_values[new_shift_start : k]
      }
      ### If count above is high enough for there to be a upward shift (6 or more)
      ### then all points that form part of that shift are flagged as "shift"
      if (count_above > 5){
        shift_value[new_shift_start : k] <- Measure_values[new_shift_start : k]
      }
      ### Catches any shifts that end on the latest time period since these
      ### are lost otherwise (i.e. coded as NA)
      if (k == length(q) & (count_below > 5 | count_above > 5) & is.na(shift_value[k]) == TRUE) {
        shift_value[k]        <- Measure_values[k]
      }
      next
    } 
    ### Marking any geography with a median value of 0 as NA for both shift
    ### variables and also change the median to NA 
    if (med == 0){
      shift_value             <- rep(NA, length(Measure_values))
      shift_direction         <- rep(NA, length(Measure_values))
      med                     <- NA
    }
    ### Combine data for output file
    output_data_combined <- data.frame(
      cbind(rep(Measure[i],length(q)), rep(geography[h],length(q)), 
            q, Measure_values, rep(med, length(q)),
            shift_value, trend_value)
    )
    names(output_data_combined)  <- c("Measure", "geography", 
                                      "time period", "chart_value", "median", 
                                      "shift", "trend")
    output_data <- rbind(output_data, output_data_combined) 
    
  } # Closes the for loop for geography
}   # Closes the for loop for Measure

### Deleting first row (not needed)
output_data <- output_data[-1,]

### Save output as appropriate