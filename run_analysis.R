install.packages("data.table")
install.packages("dplyr")
library(dplyr)
library(data.table)
features <- read.table("C:/Users/NP/Desktop/R_specialization/Cleaning/project/UCI_HAR_Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("C:/Users/NP/Desktop/R_specialization/Cleaning/project/UCI_HAR_Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("C:/Users/NP/Desktop/R_specialization/Cleaning/project/UCI_HAR_Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("C:/Users/NP/Desktop/R_specialization/Cleaning/project/UCI_HAR_Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("C:/Users/NP/Desktop/R_specialization/Cleaning/project/UCI_HAR_Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("C:/Users/NP/Desktop/R_specialization/Cleaning/project/UCI_HAR_Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("C:/Users/NP/Desktop/R_specialization/Cleaning/project/UCI_HAR_Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("C:/Users/NP/Desktop/R_specialization/Cleaning/project/UCI_HAR_Dataset/train/y_train.txt", col.names = "code")

x <- rbind(x_train ,x_test)
y <- rbind(y_train, y_test)
subjects <- rbind(subject_train, subject_test)
mgdata <- cbind(x,y, subjects)


tidydata <- mgdata %>% select(subject, code, contains("mean"), contains("std"))

colnames(activities) <- c("ClassLables", "Activityname")
tidydata$code <- activities[tidydata$code, 2]
names(tidydata)[2] = "activity"

names(tidydata) <- gsub("ACC" , "Accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))





dataset <- tidydata %>% group_by(subject , activity) %>% summarise_if(is.numeric, mean)
write.table(dataset, "finaldata.txt", row.names = FALSE)
str(dataset)
