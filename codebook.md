Content of the output table :
==================================================================
The data frame consists of	396 rows of  5 columns :
- Each row is an observation : The average of one measurement type for one specific feature in one axis.

- Each column is a set of variables.

  - $ measurement_type: Factor w/ 2 levels "mean","std": 
  The "mean" indicates that the value inside of the average column was part of the measurements on the mean that was extracted (see readme.md for the details of the extraction).
  The "std" indicates that the value inside of the average columnwas part of the measurements on the mean that was extracted "standard deviation".

  - $ activity_label  : Factor w/ 6 levels : 
laying sitting standing walking walking_downstairs walking_upstairs
  The levels were defined by merging the information in 'activity_labels.txt' with  train/y_train.txt' and 'test/y_test.txt'.
  The result is a more descriptive column.

  - $ feature         : Factor w/ 17 levels : 

 [1] fBodyAcc             fBodyAccJerk         fBodyAccMag          fBodyBodyAccJerkMag 
 [5] fBodyBodyGyroJerkMag fBodyBodyGyroMag     fBodyGyro            tBodyAcc            
 [9] tBodyAccJerk         tBodyAccJerkMag      tBodyAccMag          tBodyGyro           
[13] tBodyGyroJerk        tBodyGyroJerkMag     tBodyGyroMag         tGravityAcc         
[17] tGravityAccMag      
 
 The levels were obtained by merging the information in 'features.txt' with the training and test set. The names were cleaned by removing : the feature numbers, the "mean()" or "std()" information and the axis.
 
  - $ axis            : Factor w/ 3 levels "X","Y","Z": 
 The levels of axis were obtained by putting the ending into a separate column. When the value is NA, this means that there is no axis that goes with the feature.
 
  - $ average         : num
This is the average of each variable for each activity and each subject. In the data, it can be observed that each row is unique.


