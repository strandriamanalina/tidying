Content of the output table
==================================================================
- Content of the output data frame
'data.frame':	396 obs. of  5 variables:
 $ measurement_type: Factor w/ 2 levels "mean","std": 1 1 1 1 1 1 1 1 1 1 ...
 $ activity_label  : Factor w/ 6 levels "laying","sitting",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ feature         : Factor w/ 17 levels "fBodyAcc","fBodyAccJerk",..: 1 1 1 2 2 2 3 4 5 6 ...
 $ axis            : Factor w/ 3 levels "X","Y","Z": 1 2 3 1 2 3 NA NA NA NA ...
 $ average         : num  -0.967 -0.953 -0.96 -0.98 -0.971 ...


- Levels of the factors :
$measurement_type
02 Levels : mean std

$activity_label
06 Levels : laying sitting standing walking walking_downstairs walking_upstairs

$feature
 [1] fBodyAcc             fBodyAccJerk         fBodyAccMag          fBodyBodyAccJerkMag 
 [5] fBodyBodyGyroJerkMag fBodyBodyGyroMag     fBodyGyro            tBodyAcc            
 [9] tBodyAccJerk         tBodyAccJerkMag      tBodyAccMag          tBodyGyro           
[13] tBodyGyroJerk        tBodyGyroJerkMag     tBodyGyroMag         tGravityAcc         
[17] tGravityAccMag      
17 Levels : fBodyAcc fBodyAccJerk fBodyAccMag fBodyBodyAccJerkMag ... tGravityAccMag

$axis
[1] X    Y    Z    <NA>
Levels: X Y Z

