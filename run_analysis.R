# Download the dataset, unzip it and move it to the working directory
# Open the file
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt")
y_train <- readLines("./UCI HAR Dataset/train/y_train.txt")
subject_train <- readLines("./UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/x_test.txt")
y_test <- readLines("./UCI HAR Dataset/test/y_test.txt")
subject_test <- readLines("./UCI HAR Dataset/test/subject_test.txt")
feature <- readLines("./UCI HAR Dataset/features.txt")

# merge the same name files in train and test files to create 3 datasets
subject <- c(subject_train, subject_test)
x<-rbind(x_train, x_test)
y <- c(y_train, y_test)

# merge subject, x and y into one dataset
data <- data.frame(subject, y, x)

# label the data with descriptive variable names
colnames(data) <- c("subject", "activity", feature)
write.table(data, file = "./UCI HAR Dataset/data.txt")

# extracts only the measurements on the mean and standard deviation
cname <- grep("mean|std", colnames(data))
subdata <- data[,c(1, 2, cname)]

# create a second dataset with average of each variable for each activity and each subject
datas<-split(subdata, subdata$subject)
dataa<-lapply(datas, function(x) aggregate(.~activity, data=x, mean))
library(plyr)
data_second<-rbind.fill(dataa)

# rename the activities in the data set
activity<-data_second[, 1]
activity<-gsub(pattern="1", replacement="Walking", activity)
activity<-gsub(pattern="2", replacement="Walking_Upstairs", activity)
activity<-gsub(pattern="3", replacement="Walking_Downstairs", activity)
activity<-gsub(pattern="4", replacement="Sitting", activity)
activity<-gsub(pattern="5", replacement="Standing", activity)
activity<-gsub(pattern="6", replacement="Laying", activity)
data_second<-cbind(data_second[,-1],activity)

# save the data. optionally, write.csv((data_second, file = "./UCI HAR Dataset/data_second.csv")
write.table(data_second, file = "./UCI HAR Dataset/data_second.txt", row.name = FALSE)

