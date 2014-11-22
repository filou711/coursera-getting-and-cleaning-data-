# Select and clean repository
setwd("/Users/mac1/Desktop/DataCours/UCI HAR Dataset")
rm(list=ls())

# Install packages
sapply("data.table","reshape2", require, character.only = TRUE)
library(ggplot2)
library(plyr)

# Load raw data
features <- read.table("./features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
activity_labels <- read.table("./activity_labels.txt", col.names =c("labels","name"))
subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")

# 1: Merge data
training_data<-cbind(subject_train,y_train,X_train)
test_data<-cbind(subject_test,y_test,X_test)
data_set<-rbind(test_data,training_data)
names_col<-c("subject","labels",features$V2)
names(data_set) <- names_col

# 2: Extract data
col_mean_std<- grepl("mean\\(\\)|std\\(\\)", names(data_set)[3:ncol(data_set)], ignore.case=TRUE)
col_mean_std<-c(TRUE,TRUE,col_mean_std)
data_set_mean_std<-data_set[,col_mean_std]

# 3: Name the activities in the data set
data_set_mean_std$labels <- activity_labels[data_set_mean_std$labels, 2]

# 4: Labels the data
names(data_set_mean_std) <- gsub('\\(|\\)',"",names(data_set_mean_std))
names(data_set_mean_std) <- make.names(names(data_set_mean_std))
names(data_set_mean_std) <- gsub('gravity',"Gravity",names(data_set_mean_std))
names(data_set_mean_std) <- gsub('Acc',"Acceleration",names(data_set_mean_std))
names(data_set_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(data_set_mean_std))
names(data_set_mean_std) <- gsub('Gyro',"AngularSpeed",names(data_set_mean_std))
names(data_set_mean_std) <- gsub('Mag',"Magnitude",names(data_set_mean_std))
names(data_set_mean_std) <- gsub('^t',"TimeDomain.",names(data_set_mean_std))
names(data_set_mean_std) <- gsub('^f',"FrequencyDomain.",names(data_set_mean_std))
names(data_set_mean_std) <- gsub('angle',"Angle",names(data_set_mean_std))
names(data_set_mean_std) <- gsub("BodyBody",'Body',names(data_set_mean_std))
names(data_set_mean_std) <- gsub('\\.mean',".Mean",names(data_set_mean_std))
names(data_set_mean_std) <- gsub('\\.std',".Std",names(data_set_mean_std))
names(data_set_mean_std) <- gsub('subject',"Subject",names(data_set_mean_std))
names(data_set_mean_std) <- gsub('labels',"Descriptive.Activity",names(data_set_mean_std))

# 5: Tidy data set with the average of each variable
aggrdata <- aggregate(data_set_mean_std[, 3:ncol(data_set_mean_std)], by=list(Subject = data_set_mean_std$Subject, label = data_set_mean_std$Descriptive.Activity), mean)
write.table(aggrdata, file = "tidydata.txt",row.name=FALSE,col.names=FALSE)



