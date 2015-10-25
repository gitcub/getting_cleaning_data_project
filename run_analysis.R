library(plyr)

# read in data
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "raw_data.zip", method = "curl", mode = "wb")
unzip("raw_data.zip")

activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
features       <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
xTest          <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
yTest          <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subjectTest    <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
xTrain         <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
yTrain         <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subjectTrain   <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# apply initial column labels
names(xTest)          <- features[, 2]
names(yTest)          <- "activityID"
names(subjectTest)    <- "subjectID"
names(xTrain)         <- features[, 2]
names(yTrain)         <- "activityID"
names(subjectTrain)   <- "subjectID"
names(activityLabels) <- c("activityID", "activityType")

# merge activityID with descriptive activityType
yTest  <- merge(yTest, activityLabels, by = 'activityID', all.x = TRUE);
yTrain <- merge(yTrain, activityLabels, by = 'activityID', all.x = TRUE);

# merge training and test sets
test  <- cbind(subjectTest, yTest, xTest)
train <- cbind(subjectTrain, yTrain, xTrain)
data  <- rbind(test, train)


# subset data to only include mean and std measurements
dataCols <- colnames(data)
measures <- dataCols[grep("*mean()*|*std()*", dataCols)]
selectedData <- c("subjectID", "activityType", as.character(measures))
data <- subset(data, select = selectedData)

# make column names descriptive and readable
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))

# aggregate and order data
aggData <- aggregate(. ~subjectID + activityType, data, mean)
tidyData <- aggData[order(aggData$subjectID , aggData$activityType), ]

# write both full data and tidy data to flat files
write.table(data, file = "data.txt", row.name = FALSE)
write.table(tidyData, file = "tidydata.txt", row.name = FALSE)
