****************************************************
*  Getting and Cleaning Data Week 3 Class Assignment
*  April 21, 2015                  Richard Ellison
****************************************************
*
library(plyr)
*****************************************************************
* Step 1 Merge the training and test sets to create one data set.
*
x_test <- read.table("./Coursera/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Coursera/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Coursera/UCI Har Dataset/test/subject_test.txt")

x_train <- read.table("./Coursera/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Coursera/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Coursera/UCI HAR Dataset/train/subject_train.txt")

* create x data set
x_data <- rbind(x_test, x_train)

* create y data set
y_data <- rbind(y_test, y_train)

* create subject data set
subject_data <- rbind(subject_test, subject_train)

*************************************************************************
* Step 2 Extract only the measurements on the mean and stand dev for each
*
features <- read.table("./Coursera/UCI HAR Dataset/features.txt")

* get only cols with mean or std in their names
* first build a search pattern for -mean() or -std()
mean_std_features <- grep("-(mean|std)\\(\\)",features[,2])
* subset the columns
x_data <- x_data[,mean_std_features]
* correct column names
names(x_data) <- features[mean_std_features, 2]

**********************************************************************
* Step 3 User descriptive activity names to name the activities
*
activities <- read.table("./Coursera/UCI HAR Dataset/activity_labels.txt")

* update values with correct activity names
y_data[,1] <- activities[y_data[,1],2]
* correct column name
names(y_data) <- "activity"

*************************************************************************
* Step 4 Appropriately label the data set with descriptive variable names
*
* correct column name
names(subject_data) <- "subject"

* bind all the data together
all_data <- cbind(x_data, y_data, subject_data)

************************************************************************
* Step 5 Create a second, independent tidy dataset with the average for 
*      each activity and each subject
*
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "./Coursera/averages_data.txt", row.name=FALSE)

