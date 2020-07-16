# Loading the packages
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
  basename() %>%
  gsub(pattern =".txt",replacement = "") %>% 
  tolower
# putting all the data into a list and adding name
data <- list %>% 
  map(~read_table(., col_names =FALSE, progress = show_progress(), ))
names(data) <- filenames

# Merging test data
test_data <-  data[grep("_test", names(data))] %>% 
  list_modify("subject_test"=NULL, "x_test"=NULL, "y_test"=NULL)

# adding a column with the name of the dataframe
acceleration_test <- test_data[grep("body|total", names(test_data))] %>% 
  map2_df(names(.), ~ mutate(.x, type = .y)) %>% 
  select(type, everything()) # %>% 
  # rename_at(vars(contains("X")),   .funs = list(~sub("X", "", .)))
names(test_data)

# Putting the data into long form
acceleration <-  acceleration_test %>% 
  pivot_longer(
    cols = starts_with("X"),
    names_to = "readings",
    values_to = "values",
  ) %>% 
  mutate(readings = str_remove(readings, "X"))


head(acceleration, 20)
# Tyding the data


train_data <- data[grep("_train", names(data))]



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


# 