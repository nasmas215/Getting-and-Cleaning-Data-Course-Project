# Getting-and-Cleaning-Data-Course-Project
Author: Daniel Mendoza
Date: 17/07/20

Packages used:
-dply
-dataMaid

The run_analysis.R script performs the following operations:

1. Checks if the directory existes, if not then it creates the directory "data".
2. Downloads the file with the url given in the assignment.
3. Unzips the downloaded file in the same directory.
4. Reads the data from the text files with the read.table function (the file path
   is stored in the data_path variable).
5. Merges the rows from "test" and "train" parts for each variable. This combination
   represents the total observations in the data set.
6. Change the name of the variables, the names of the variables for the "features"
   data frame can be found in the "features.txt".
7. Merge the "activity" and "subject" vectores as columns, and merge them with the
   features data frame resulting in the complete data set named "Data".
8. Search for the variable names which have "mean" or "std".
9. Overwrite the "Data" data frame as a subset with the "activity", "subject" and the
   variables obteined in step 8.
10. The "activity" column has values from 1 to 6 which refer to different activities,
    the names of these activities can be found in the "activity_labels" text file.
11. After reading the "activity_labels" text file, the mutate function is applied to 
    the "Data" data frame and the columns renamed. The column previously named "activity"
    now is called "activitycode" and a new column named "activity" will have the names
    of the respective activities.
12. The gsub function is used to change the name of the variables for them be more explicit.
13. Using the aggregate function the second independent data frame is created and this
    data frame is stored in a text file named "tidydataset" using the write.table function.
14. Using the makeCodebook function of the dataMaid package