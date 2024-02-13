This repository is for Getting and Cleaning Data course project.

## Project instruction and Dataset
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
 

Here are the data for the project:
 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



## Files
- `README.md` explains the analysis files.
- `codebook.md` is a code book that indicate all the variables and summaries calculated, along with units, and any other relevant information.
- `run_analysis.R` is an analysis file that produces final data.
- `FinalData.txt` is the exported tidy final data from analysis file.



## Explain about run_analysis.R
```
# load the library
library(dplyr)

# Download and unzip the dataset
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
```
