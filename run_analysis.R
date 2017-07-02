
##download and unzip the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="Dataset.zip",method="auto")
unzip(zipfile="Dataset.zip",exdir="C:/Users/HI/Desktop/Coursera")
path_rf <- file.path( "C:/Users/HI/Desktop/Coursera", "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

##load train datasets
x_train <- read.table("C:/Users/HI/Desktop/Coursera/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/HI/Desktop/Coursera/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/HI/Desktop/Coursera/UCI HAR Dataset/train/subject_train.txt")

##load test datasets
x_test <- read.table("C:/Users/HI/Desktop/Coursera/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/HI/Desktop/Coursera/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/HI/Desktop/Coursera/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('C:/Users/HI/Desktop/Coursera/UCI HAR Dataset/features.txt')
activityLabels = read.table('C:/Users/HI/Desktop/Coursera/UCI HAR Dataset/activity_labels.txt')

##set the column names
colnames(x_train) <- features[,2]
colnames(y_train)<- "activityId"
colnames(subject_train)<- "subjectId"
colnames(x_test)<-features[,2]
colnames(y_test)<- "activityId"
colnames(subject_test)<- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

##merge datasets
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)
colNames <- colnames(setAllInOne)

##extract columns with mean and std
mean_and_std <- (grepl("activityId" , colNames) | 
                     +                      grepl("subjectId" , colNames) | 
                     +                      grepl("mean.." , colNames) | 
                     +                      grepl("std.." , colNames) 
                   + )
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                                +                               by='activityId',
                                +                               all.x=TRUE)

##write the tidy dataset into text file
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
