##----------------------------------------------------------------------------------------------------------------------------------------------------
##  EXTRA -Tidying the inertial dataset (This part was not explicitly part of the assignment)
##----------------------------------------------------------------------------------------------------------------------------------------------------
# This is not explicitly part of the assignment as it is asked to drop most of the data.

# Loading the packages - This code needs tidyverse to work as it is using readr, tidyr, purrr, stringr and forcats
suppressPackageStartupMessages(library(tidyverse))

# Downloading data
# url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(url, "Dataset.zip")


# unzipping
# unzip("Dataset.zip")
# list.dirs("./UCI HAR Dataset")

# listing the files with their full paths
directory <- "UCI HAR Dataset"
initial <- list.files(directory,pattern = ".txt" , recursive = TRUE, full.names = TRUE)

# Tidying the inertial dataset
inertial <- initial %>% 
  map(~read_table(., col_names =FALSE, progress = show_progress(), )) # creates a Big list of all of the data

allnames <- initial %>%
  basename() %>% # This takes the list with full paths and returns only the names
  gsub(pattern =".txt",replacement = "") %>% # This removes the extension
  tolower
names(inertial) <- allnames

# Selecting the inertial signal files and loading them into data
test_data <-  inertial %>% 
  list_modify("subject_test"=NULL, "x_test"=NULL, "y_test"=NULL,
              "subject_train"=NULL, "x_train"=NULL, "y_train"=NULL)

# adding a column with the name of the dataframe and putting data into long tidy form
inertial_signal <- test_data[grep("body|total", names(test_data))] %>% 
  map2_df(names(.), ~ mutate(.x, type = .y)) %>% # This puts the dataframe name in a column and transforms the list into a data frame 
  select(type, everything()) %>%  # Reordering columns
  pivot_longer(cols = starts_with("X"), names_to = "readings", values_to = "values",) %>% # use this instead of gather 
  mutate(readings = str_remove(readings, "X")) %>% # removes the X from the reading. did not remove it earlier because it makes the use of  pivot longer easier
  separate(type, into = c("status", "sensor_type", "axe", "data_source"), sep = "_") %>% 
  mutate_if(is.character, .funs = list(~as.factor(.))) %>% # changing all char columns into factor 
  mutate (sensor_type = fct_recode(sensor_type, accelerometer = "acc", gyroscope = "gyro")) # changing factor names

str(inertial_signal)