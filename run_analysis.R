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
##  1. Merging the training and the test sets to create one data set   -
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

##-----------------------------------------------------------------------------------------
##  2. Extracting the measurements on the mean and standard deviation for each measurement   -
##-----------------------------------------------------------------------------------------

# Selecting the columns that contain mean and std
measurement <- tidydata %>% 
  select(labels, source, contains("mean()")|contains("std()")) 

##-----------------------------------------------------------------------------
##  3. Using descriptive activity names to name the activities in the data set   -
##-----------------------------------------------------------------------------
# Adding the training labels
labels <- data[c("activity_labels")] %>%  as.data.frame() # selecting the activity labels and transforming it into data frame
names(labels) <- c("labels", "name") # renaming the columns
labels <- labels %>% mutate(name = tolower(name)) # putting the name column into lower case

measurement <- left_join(measurement, labels, by="labels") %>%  # This keep all the variables in the measurement table and don't consider the variables that do not have a key-paired in the labels table
  select(name, source, everything()) %>% # arranging columns
  select(-labels) %>% # selecting out the initial label column
  rename(activity_label = name)

##------------------------------------------------------------------------
##  4. Appropriately labels the data set with descriptive variable names.   -
##------------------------------------------------------------------------

tidy <- measurement %>% 
  pivot_longer(
    cols = "1 tBodyAcc-mean()-X":"543 fBodyBodyGyroJerkMag-std()",
    names_to = c("feature", "measurement", "axis"),
    names_sep ="-"
  ) %>% # This does the same thing as the (now deprecated) gather() function
  separate(feature, into = c("line_number", "feature")) %>% 
  separate(measurement, into = c("measurement_type", "parentheses")) %>% 
  select(-c("line_number", "parentheses")) %>% 
  select(activity_label, feature, axis, measurement_type, value, source) %>% 
  modify_if(is.character, as.factor)


##----------------------------------------------------------------------------------------------------------------------------------------------------
##  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.   -
##----------------------------------------------------------------------------------------------------------------------------------------------------

# average of each variable for each activity and each subject
result <- tidy %>% 
  group_by(measurement_type, activity_label, feature, axis) %>% 
  summarise(average =mean(value))

# Saving the output
write.table(result, "output.csv", row.name=FALSE)

