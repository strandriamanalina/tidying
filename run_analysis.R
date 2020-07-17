# Loading the packages - This code needs tidyverse to work as it is using readr, tidyr, purrr, stringr and forcats
library(tidyverse)

# Downloading data
# url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(url, "Dataset.zip")


# unzipping
# unzip("Dataset.zip")
# list.dirs("./UCI HAR Dataset")

##--------------------------------------------------------------------
##  Merging the training and the test sets to create one data set   -
##--------------------------------------------------------------------
# listing the files with their full paths
directory <- "UCI HAR Dataset"
list <- list.files(directory,pattern = ".txt" , recursive = TRUE, full.names = TRUE)
# listing the filenames without the extension 
filenames <- list %>%
  basename() %>% # This takes the list with full pats and returns only the names
  gsub(pattern =".txt",replacement = "") %>% # This removes the extension
  tolower

# putting all the data into a list and adding name. This puts everything into a big list. I did this only because I want to tidy the inertial data as extra work.
data <- list %>% 
  map(~read_table(., col_names =FALSE, progress = show_progress(), )) # creates a Big list of all of the data
names(data) <- filenames # assigning names to the list

# Extracting the training and test sets
labels <- data[c("activity_labels", "features")]
test <- data[c("x_test", "y_test", "x_train", "y_train")]

data_list <- data[c("x_test", "y_test")]
data_list <-  bind_cols(data_list)

features <- data[c("x_test", "x_train")] %>% # Merging training and test data
  map2_df(names(.), ~ mutate(.x, type = .y))  %>% # This puts the data frame name in a column and transforms the list into a data frame
  separate(type, into = c("var", "data_source"), sep="_") %>% # separating the source name
  select(-var) # removing unsed column

# Adding the training labels


# dropping unused data
# Tyding the data



##-----------------------------------------------------------------------------------------
##  Extracting the measurements on the mean and standard deviation for each measurement   -
##-----------------------------------------------------------------------------------------



##-----------------------------------------------------------------------------
##  Using descriptive activity names to name the activities in the data set   -
##-----------------------------------------------------------------------------



##------------------------------------------------------------------------
##  Appropriately labels the data set with descriptive variable names.   -
##------------------------------------------------------------------------




##----------------------------------------------------------------------------------------------------------------------------------------------------
##  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.   -
##----------------------------------------------------------------------------------------------------------------------------------------------------


# EXTRA
## This part was not explicitly part of the assignment but I did it for fun

# Selecting the inertial signal files and loading them into data
test_data <-  data %>% 
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