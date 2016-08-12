---
title: "CodeBook"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Getting and Cleaning Data Course Project - Task 1

The first action is to get the data. First, download the data from the link provided. Next, unzip the files. Idenitfy the files and read the data into R.

The first task is to merge the training set and the test sets to create one data set. 

Here is the code to download and identify the files:

```{r}
  #Download the file to local directory
  pathtofile1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  if(!file.exists("./sensordata")) {dir.create("./sensordata")}
  download.file(pathtofile1, destfile = "./sensordata/zippedpckg")
  #Unzip the files to created directory
  unzip("./sensordata/zippedpckg", exdir = "./sensordata")
  #Identify the files within the zip folder
  pathtofiles <- list.files("./sensordata", recursive = TRUE)
  pathtofiles
```

Next we combine the training set and test set. View the path of files to choose the appropriate sets.
I'm choosing not to include the Inertial data from both sets as I don't think that it adds value to the exercise (though I might be wrong!).
The merged data set is labeled "tidy_data_set".
```{r}
  #Read and combine sensor outputs from training and test data set
  train_table <- read.table(pathtofiles[27], header = FALSE)
  test_table <- read.table(pathtofiles[15], header = FALSE)
  merged_data_table <- rbind(train_table, test_table)
  #Read and combine Activity labels from training and test data set
  train_activity <- read.table(pathtofiles[28], header = FALSE)
  test_activity <- read.table(pathtofiles[16], header = FALSE)
  merged_activity <- rbind(train_activity, test_activity)
  #Read and combine Subject identifiers from training and test data set
  sub_train_table <- read.table(pathtofiles[26], header = FALSE)
  sub_test_table <- read.table(pathtofiles[14], header = FALSE)
  sub_merged <- rbind(sub_train_table, sub_test_table)
  #Read the labels of the sensor data
  feature_table <- read.table(pathtofiles[2], header = FALSE)
  #Name the columns appropriately
  names(merged_activity) <- c("Activity")
  names(sub_merged) <- c("Subject")
  names(merged_data_table) <- feature_table$V2
  #Merge to get to single tidy data set with descriptive labels
  tidy_data_set <- cbind(sub_merged, merged_activity)
  tidy_data_set <- cbind(tidy_data_set, merged_data_table)

```


## Getting and Cleaning Data Course Project - Task 2

The next task is to extract from the merged data set only mean and standard deviation for each measurement. 
First step is to find the variable names that include mean and std i.e. standard deviation. With the list of variable names and including the subject and activity, subset the merged data set to extract the necessary data. The resulting data set is labeled "tidy_meanstd_data".

```{r}
  #Find names of mean and std_dev variables
  tidy_names <- names(tidy_data_set)
  selected_mean <- grep(("mean\\(\\)"), tidy_names, value = TRUE)
  selected_stddev <- grep(("std\\(\\)"), tidy_names, value = TRUE)
  selected_meanstdev <- c("Subject", "Activity", selected_mean, selected_stddev)
  #Create second tidy data set
  tidy_meanstd_data <- tidy_data_set[,selected_meanstdev]
```


## Getting and Cleaning Data Course Project - Task 3
The task is to take the labels from the activity labels and use them in the extracted merged data set.
First, read it the activity labels and factorize the Activity column using the activity labels.
```{r}
  #Use the labels to name the activities in the data set
  activity_labels <- read.table(pathtofiles[1], header = FALSE)
  levels(tidy_meanstd_data$Activity) <- activity_labels$V2
```
## Getting and Cleaning Data Course Project - Task 4
The task is to use descriptive variable names.
Use the gsub() fn with the names () fn to replace "BodyBody" with "Body", "t" with "time", "f" with "freq", "Acc" with "Accel".
```{r}
names(tidy_meanstd_data) <- gsub("t", "time", names(tidy_meanstd_data))
  names(tidy_meanstd_data) <- gsub("f", "freq", names(tidy_meanstd_data))
  names(tidy_meanstd_data) <- gsub("Acc", "Accel", names(tidy_meanstd_data))
```

## Getting and Cleaning Data Course Project - Task 5
The task is to create a second, independednt tidy data set wuth average of each variable for each activity and each subject.
Use the aggregate function to find the mean of the variables on the grouping of activity and subject.
```{r}
tempdf <- aggregate.data.frame( x = tidy_meanstd_data, by = list(tidy_meanstd_data$Subject, tidy_meanstd_data$Activity), FUN = "mean")
```
## Getting and Cleaning Data Course Project - Outputs
The outputs of the project are two data sets (merged data set) and (selected, descriptive, averaged valued data set)
```{r}
 write.table(tidy_data_set,"First merged tidy dataset.txt")
  write.table(tempdf,"Second Indep tidy dataset.txt")
```
