run_analysis <- function( ) {
  #Download the file to local directory
  pathtofile1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  if(!file.exists("./sensordata")) {dir.create("./sensordata")}
  download.file(pathtofile1, destfile = "./sensordata/zippedpckg")
  #Unzip the files to created directory
  unzip("./sensordata/zippedpckg", exdir = "./sensordata")
  #Identify the files within the zip folder
  pathtofiles <- list.files("./sensordata", recursive = TRUE)
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
  #Find names of mean and std_dev variables
  tidy_names <- names(tidy_data_set)
  selected_mean <- grep(("mean\\(\\)"), tidy_names, value = TRUE)
  selected_stddev <- grep(("std\\(\\)"), tidy_names, value = TRUE)
  selected_meanstdev <- c("Subject", "Activity", selected_mean, selected_stddev)
  #Create second tidy data set
  tidy_meanstd_data <- tidy_data_set[,selected_meanstdev]
  #Use the labels to name the activities in the data set
  activity_labels <- read.table(pathtofiles[1], header = FALSE)
  levels(tidy_meanstd_data$Activity) <- activity_labels$V2
  #Use descriptive names for variables
  names(tidy_meanstd_data) <- gsub("t", "time", names(tidy_meanstd_data))
  names(tidy_meanstd_data) <- gsub("f", "freq", names(tidy_meanstd_data))
  names(tidy_meanstd_data) <- gsub("Acc", "Accel", names(tidy_meanstd_data))
  #Employ the aggregate function to create a second data set
  tempdf <- aggregate.data.frame( x = tidy_meanstd_data, by = list(tidy_meanstd_data$Subject, tidy_meanstd_data$Activity), FUN = "mean")
  #Output both data sets
  write.table(tidy_data_set,"First merged tidy dataset.txt")
  write.table(tempdf,"Second Indep tidy dataset.txt")
}