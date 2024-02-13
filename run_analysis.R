#Coursera
#Getting and Cleaning Data Course Project

library(dplyr)

# Download the dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- file.path(getwd(), "data.zip")
download.file(url, f)
unzip("data.zip")

# Assigning all data frames
features <- read.table("UCI HAR Dataset/features.txt", col.names=c("n","functions"))
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names="code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names= "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names="code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names= "subject")


# 1. Merges the training and the test sets to create one data set.
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
m <- cbind(Subject, Y, X)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
m1 <- m %>% select(subject, code, contains(".mean."), contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set.
m1$code <- act_labels[m1$code, 2]

# 4. Appropriately labels the data set with descriptive variable names.
names(m1)[2] = "activity"
names(m1) <- gsub("\\.\\.","", names(m1))
names(m1) <- gsub("\\.","_", names(m1))


# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.

final <- m1 %>% 
  group_by(subject, activity) %>%
  summarise_all(mean, na.rm=T)
write.table(final, "FinalData.txt", row.name=FALSE)

