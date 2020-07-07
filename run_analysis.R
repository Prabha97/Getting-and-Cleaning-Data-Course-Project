
library(dplyr)

## Reading test dataset
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Reading train dataset
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## Reading the data description
desc_var <- read.table("./UCI HAR Dataset/features.txt")

## Reading labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## 1
# Merges the Training dataset and testing dataset to creat one dataset
X_set <- rbind(X_train, X_test)
Y_set <- rbind(Y_train, Y_test)
Sub_set <- rbind(subject_train, subject_test)

## 2
# Extracts only the measurements on the mean and standard deviation for each measurement
selected_var <- desc_var[grep("mean\\(\\)|std\\(\\)",desc_var[,2]),]
X_set <- X_set[,selected_var[,1]]

## 3
# Uses descriptive activity names to name the activities in the data set
colnames(Y_set) <- "activity"
Y_set$activitylabel <- factor(Y_set$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_set[,-1]

## 4
# Appropriately labels the data set with descriptive variable names
colnames(X_set) <- desc_var[selected_var[,1],2]

## 5
# From the data set in step 4, Creates a second, independent tidy data set with the average of each variable for each activity and each subject
colnames(Sub_set) <- "subject"
d_set <- cbind(X_set, activitylabel, Sub_set)

# Creates a second tidy dataset
avg <- d_set %>% group_by(activitylabel, subject) %>% summarize_all(funs(mean)) 

# Writing tidy dataset as txt file
write.table(avg, file = "./UCI HAR Dataset/tidy_data.txt", row.names = FALSE, col.names = TRUE)
