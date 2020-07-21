
Acknowledgment
==================================================================
- A warm thank you to David Hood for providing a thorough guide on how to approach this assignment. 
here is the link to the blogpost : https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/

- Various part of the script xxxxxxxxxxx

Package requirements
==================================================================
- In order to run the "run_analysis.R" script,  you will need to install the tidyverse package which is a collection of R packages designed for data science.
It contains the following packages : 
#> ✔ ggplot2 3.3.0     ✔ purrr   0.3.4
#> ✔ tibble  3.0.1     ✔ dplyr   0.8.5
#> ✔ tidyr   1.0.3     ✔ stringr 1.4.0
#> ✔ readr   1.3.1     ✔ forcats 0.5.0
- It is possible to load the packages individually since they are not all used. The following packages are not used :
#> ✔ ggplot2 3.3.0
#> ✔ forcats 0.5.0
- tidyr version must be at least be : 1.0.0 


How all of the scripts work and how they are connected ?
==================================================================

0) Initial step : This initial step allows to get a list of dataframes in one place with their original name for easy access.
- After downloading and unzipping the dataset, the file list is read by using the list.files() function. 
The "recursive" and "full.names" option are set to TRUE in order to read the subfolders and get the file names with their respective paths.
- The name list is then filtered to remove the inertial data file names which are not used. The inertial data contain "body"|"total"|"subject" in their names. This step can be skipped if all of the data is needed.
- The readr::read_table() function inside the purrr::map() function is then used to read all of the files in the file list (with the full path). 
The output is a big list which contains 8 tibbles (which are the same as tbl_df). Note that the col_names option is set to FALSE to avoid the column name to be set as the first line of each tibble. This creates a column name starting with X.
This can also be achieved with apply() but the map anonymous function call is easier to write and since the tidyverse package  is already loaded, it is fine to stick with it.
- The file names without the full path is  extracted using the basename() function. The name generated is then used to replace the list name.

** The output is a list of 8 tibbles with their names set as the file names which contains the following :
    * "activity_labels" "features_info" "features" "readme" "x_test" "y_test" "x_train" "y_train"

1) Merges the training and the test sets to create one data set
- The test set and its labels are bound together using dplyr::bind_cols(). Note that this can also be achieved using base R do.call(cbind, dfs).
- The X1100 column is then renamed into "labels" with dplyr::rename and the columns rearranged with dplyr::select(). An additional column named "source" (with the value "test") is created with dplyr::mutate() in order to identify the data source when it is merged with the training set.
- The same thing is done with the training set and its corresponding labels.
- The two tibbles are then merged using dplyr::bind_rows(). This can also be achieved with the base R do.call(rbind, dfs). It is named "tidydata"
- The features is extracted from the data and transformed into a character vector with the unlist() function. It is then used to rename all of the columns of "tidydata" that starts with X using dplyr::rename_at() which renames in place all of the columns starting with "X" (using grep to "look" into each column name) into all of the content of "features". Note that the renaming step could be done later in the analysis but it is more convenient to have it at this time because it facilitates the answer to the next question.

** The outupt is a tibble with 10299 rows and 563 columns with the column names from features. Note that it is not a tidy data yet and the column names are still  messy.

2) Extracts only the measurements on the mean and standard deviation for each measurement.
- In order to extract the measurements on the mean and standard deviation for each measurement, the dplyr::select() is used with the "contains()" helper to filter  every column that contains "mean" and "std".


** The output is a tibble with 88 columns


3) Uses descriptive activity names to name the activities in the data set



4) Appropriately labels the data set with descriptive variable names.



5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



Is the output file really tidy ?
==================================================================
According to the Tidy Data paper published in the Journal of Statistical Software (http://www.jstatsoft.org/v59/i10/paper), 
a Tidy data is data where:
- Every column is variable.
- Every row is an observation.
- Every cell is a single value.


Variable names
==================================================================




Sources
==================================================================
- The dataset was provided by :
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012



==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

