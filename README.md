
Acknowledgment
==================================================================
- The dataset was provided by :
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

- A warm thank you to David Hood for providing a thorough guide on how to approach this assignment. 
Here is the link to the blogpost : https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/

Package requirements
==================================================================
- In order to run the "run_analysis.R" script,  the tidyverse package is required. It is a collection of R packages designed for data science. It contains the following packages : 
#> ✔ ggplot2 3.3.0     ✔ purrr   0.3.4
#> ✔ tibble  3.0.1     ✔ dplyr   0.8.5
#> ✔ tidyr   1.0.3     ✔ stringr 1.4.0
#> ✔ readr   1.3.1     ✔ forcats 0.5.0
- It is possible to load the packages individually since they are not all used. The following packages are not used :
#> ✔ ggplot2 3.3.0
#> ✔ forcats 0.5.0
- tidyr must be at least v1.0.0 (because of te use of tidyr::pivot_longer() function).
- Code for reading the data (assuming the "output.csv" file is the working directory)

data <- read.table("./output.txt", header = TRUE)

View(data)

- Note that running the analysis will create a data frame named "output.txt"

How do all of the scripts work and how they are connected ?
==================================================================

0) Initial step : This step allows to get a list of dataframes in one place with their original name for easy access.
- After downloading and unzipping the dataset, the file list is read by using the list.files() function. 
The "recursive" and "full.names" option are set to TRUE in order to read the subfolders and get the file names with their respective paths.
- The name list is then filtered to remove the inertial data file names which are not used. The inertial data contain "body"|"total"|"subject" in their names. This step can be skipped if all of the data is needed.
- The readr::read_table() function inside the purrr::map() function is then used to read all of the files in the file list (with the full path). 
The output is a big list which contains 8 tibbles (which are the same as tbl_df). Note that the col_names option is set to FALSE to avoid the column name to be set as the first line of each tibble. This creates a column name starting with X.
This can also be achieved with apply() but the map anonymous function call is easier to write and since the tidyverse package  is already loaded, it is fine to stick with it.
- The file names without the full path is  extracted using the basename() function. The name generated is then used to replace the list name.

** The output is a list of 8 tibbles with their names set as the file names which contains the following :
    * "activity_labels" "features_info" "features" "readme" "x_test" "y_test" "x_train" "y_train"
    The output is a list named "data".

1) Merges the training and the test sets to create one data set :
- The first step is renaming the column of "y_test" and "y_train" as these are named "X1". One way to achieve this is subsetting these two elemets inside one list and renaming the columns inside a purrr:map function by replacing all of the "X1" with "labels" with the stringr::str_replace_all() function inside a dply::rename_all. There are easier (and maybe clearer ways) to achieve this by sleecting the tables individually and transforming them into  a tibble or a data frame and renaming the columns.
- The test set and its labels are bound together using dplyr::bind_cols(). Note that this can also be achieved using base R do.call(cbind, dfs).
-  An additional column named "source" (with the value "test") is created with dplyr::mutate() in order to identify the data source when it is merged with the training set.
- The same thing is done with the training set and its corresponding labels.
- The two tibbles are then merged using dplyr::bind_rows(). This can also be achieved with the base R do.call(rbind, dfs). It is named "tidydata"
- The features is extracted from the data and transformed into a character vector with the unlist() function. It is then used to rename all of the columns of "tidydata" that starts with X using dplyr::rename_at() which renames in place all of the columns starting with "X" (using grep to "look" into each column name) into all of the content of "features". Note that the renaming step could be done later in the analysis but it is more convenient to have it at this time because it facilitates the answer to the next question.

** The outupt is a tibble with 10299 rows and 563 columns with the column names from features. Note that it is not a tidy data yet and the column names are still  messy.**
The output is a tibble named "tidydata".

2) Extracts only the measurements on the mean and standard deviation for each measurement.
- In order to extract the measurements on the mean and standard deviation for each measurement, the dplyr::select() is used with the "contains()" helper to filter  every column that contains "mean()" and "std()".
- Here, the choice was made to include only the columns that end with "mean()" or "std()". Columns that contains mean in general (like meanFreq) could be computed.

** The output is a tibble with 68 columns and 10 299 rows.**
The output is tibble named "measurement".

3) Uses descriptive activity names to name the activities in the data set :
- First, the activity labels are extracted from the data with the base R subset then transformed into a data frame. The choice here is motivated by the fact that for some reasons, a tibble did not work very well. The columns were renamed then the name column was put in lower case using tolower() inside the dplyr::mutate()function (by replacing the column with itself using the same column name).
- The "labels" and "measurement" data frame are merged using dplyr::left_join(). The columns are rearranged. The initial "labels" column is replaced with the new one "name" which contains the named activities.

** The output is a tibble with 68 columns and 10 299 rows with descriptive activity names. **
The output is tibble named "measurement_named".

4) Appropriately labels the data set with descriptive variable names :
- In order to label the dataset more appropriately, some transformation are necessary : 
   * First, the tidyr::pivot_longer() function is used to make the column names (that contain the feature name) parts into rows. This works by separating the column name into 3 as they are separated by "-".
   This introduces NAs in the axis column because some features do not have any XYZ axis. This is the choice made in tidying the data.
   * In addition, the tidyr::separate() function is used to have a cleaner name: by removing the parentheses and line number.
   * Lastly, the character columns are transformed into factors with the purrr::modify_if() function.

** The output is a long tibble with 6 named column and 679 734 rows with descriptive variable names. **
The output is tibble named "tidy".

5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject :
- This is done by using dplyr::group_by() then dplyr::summarise() : group_by uses the provided group "behind the scenes" then summarise takes the calculation by each provided group.

** The output is a tibble of 5 columns and 396 rows. **
The output is tibble named "result".


Is the output file really tidy ?
==================================================================
According to the Tidy Data paper published in the Journal of Statistical Software (http://www.jstatsoft.org/v59/i10/paper), 
a Tidy data is data where:
- Every column is variable.
- Every row is an observation.
- Every cell is a single value.

Does the output checks out ?
The data frame consists of	396 rows of  5 columns :
- Each row is an observation : The average of one measurement type for one specific feature in one axis. It could be argued that the axis column and feature column need not be separated. However, it may be useful if there is a need to have a value for each set of feature ignoring the axis. In addition to that, it is relatively easy to always consider the feature column and axis together qhen doing an analysis.
- Each column is a set of variables.
- As the notion of tidy data may vary from one person to another (even if the definition looks clear), the output may alwas differ.



