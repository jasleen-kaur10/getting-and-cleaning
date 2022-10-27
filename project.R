
if(!file.exists("./getcleandata")){dir.create("./getcleandata")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./getcleandata/projectdataset.zip")

xtrain <- read.table("./getcleandata/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./getcleandata/UCI HAR Dataset/train/y_train.txt")
subtrain <- read.table("./getcleandata/UCI HAR Dataset/train/subject_train.txt")

xtest <- read.table("./getcleandata/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./getcleandata/UCI HAR Dataset/test/y_test.txt")
subtest <- read.table("./getcleandata/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./getcleandata/UCI HAR Dataset/features.txt")

activitylab = read.table("./getcleandata/UCI HAR Dataset/activity_labels.txt")

colnames(xtrain) <- features[,2]
colnames(ytrain) <- "activityID"
colnames(subtrain) <- "subjectID"

colnames(xtest) <- features[,2]
colnames(ytest) <- "activityID"
colnames(subtest) <- "subjectID"
colnames(activitylab) <- c("activityID", "activityType")

alltrain <- cbind(ytrain, subtrain, xtrain)
alltest <- cbind(ytest, subtest, xtest)
finaldataset <- rbind(alltrain, alltest)

colNames <- colnames(finaldataset)

meanstd <- (grepl("activityID", colNames) |
              grepl("subjectID", colNames) |
              grepl("mean..", colNames) |
              grepl("std...", colNames)
)

setmeanstd <- finaldataset[ , meanstd == TRUE]
setactivity <- merge(setmeanstd, activitylab,
                     by = "activityID",
                     all.x = TRUE)

tidyset <- aggregate(. ~subjectID + activityID, setactivity, mean)
tidyset <- tidyset[order(tidyset$subjectID, tidyset$activityID), ]

write.table(tidySet, "tidySet.txt", row.names = FALSE)

