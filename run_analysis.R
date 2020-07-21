# installing tidyverse if not present


# Loading the packages - This code needs tidyverse to work as it is using readr, tidyr, purrr, stringr and forcats
suppressPackageStartupMessages(library(tidyverse))

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
initial <- list.files(directory,pattern = ".txt" , recursive = TRUE, full.names = TRUE)
list <- initial[!str_detect(initial,pattern="body|total|subject|readme")] # removes inertial data from the list

# putting all the data into a list and adding name. This puts everything into a big list. 
data <- list %>% 
  map(~read_table(., col_names =FALSE, progress = show_progress(), )) # creates a Big list of all of the data

# listing the filenames without the extension and using it to name the columns
filenames <- list %>%
  basename() %>% # This takes the list with full paths and returns only the names
  gsub(pattern =".txt",replacement = "") %>% # This removes the extension
  tolower
names(data) <- filenames # assigning names to the list
glimpse(filenames)

# Extracting the training and test sets
data_test <- bind_cols(data[c("x_test", "y_test")]) %>% 
  rename(labels = X1100) %>%  # renaming the y_test label
  mutate(source = "test_set") %>% # adding a column to identify the source of the data
  select(labels, source, everything()) # arranging column order
# doing the same with the training sets
data_train <- bind_cols(data[c("x_train", "y_train")]) %>% rename(labels = X1100) %>%  mutate(source = "training_set") %>% select(labels, source, everything())

# Merging the training and test sets and adding the features name
features <- data[("features")] %>%  unlist
tidydata <- bind_rows(data_test, data_train) %>% 
  rename_at(vars(grep("X", names(.))), ~features) # This renames all of the columns that contain X
str(tidydata)

##-----------------------------------------------------------------------------------------
##  Extracting the measurements on the mean and standard deviation for each measurement   -
##-----------------------------------------------------------------------------------------

# Selecting the columns that contain mean and std
measurement <- tidydata %>% 
  select(labels, source, contains("mean()")|contains("std()")) 
str(measurement)

##-----------------------------------------------------------------------------
##  Using descriptive activity names to name the activities in the data set   -
##-----------------------------------------------------------------------------
# Adding the training labels
labels <- data[c("activity_labels")] %>%  as.data.frame() # selecting the activity labels and transforming it into data frame
names(labels) <- c("labels", "name") # renaming the columns
labels <- labels %>% mutate(name = tolower(name)) # putting the name column into lower case

measurement <- left_join(measurement, labels, by="labels") %>% 
  select(name, source, everything()) %>% select(-labels) %>% rename(activity_label = name) 
  

##------------------------------------------------------------------------
##  Appropriately labels the data set with descriptive variable names.   -
##------------------------------------------------------------------------

names(measurement)

tidy <- measurement %>% 
  pivot_longer(
    cols = "1 tBodyAcc-mean()-X":"543 fBodyBodyGyroJerkMag-std()",
    names_to = c("feature", "measurement", "axis"),
    names_sep ="-"
  ) %>% 
  separate(feature, into = c("line_number", "feature")) %>% 
  separate(measurement, into = c("measurement", "parentheses")) %>% 
  select(-c("line_number", "parentheses"))


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