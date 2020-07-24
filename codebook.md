Content of the output table
==================================================================

The data frame consists of	396 rows of  5 columns :
- Each row is an observation : The average of one measurement type for one specific feature in one axis.

- Each column is a set of variables.

  - $ measurement_type: Factor w/ 2 levels "mean","std": 

  - $ activity_label  : Factor w/ 6 levels "laying","sitting",..: 
laying sitting standing walking walking_downstairs walking_upstairs
 
  - $ feature         : Factor w/ 17 levels : 
 [1] fBodyAcc             fBodyAccJerk         fBodyAccMag          fBodyBodyAccJerkMag 
 [5] fBodyBodyGyroJerkMag fBodyBodyGyroMag     fBodyGyro            tBodyAcc            
 [9] tBodyAccJerk         tBodyAccJerkMag      tBodyAccMag          tBodyGyro           
[13] tBodyGyroJerk        tBodyGyroJerkMag     tBodyGyroMag         tGravityAcc         
[17] tGravityAccMag      
 
  - $ axis            : Factor w/ 3 levels "X","Y","Z": 
 
 
  - $ average         : num  


