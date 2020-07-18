#Create directory and download file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#Unzip file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

path_data <- file.path("./data" , "UCI HAR Dataset")

#Read text files
activitytest  <- read.table(file.path(path_data, "test" , "Y_test.txt" ),
header = FALSE)
activitytrain <- read.table(file.path(path_data, "train", "Y_train.txt")
,header = FALSE)

subjecttrain <- read.table(file.path(path_data, "train", "subject_train.txt"),
header = FALSE)
subjecttest  <- read.table(file.path(path_data, "test" , "subject_test.txt"),
header = FALSE)

featurestest  <- read.table(file.path(path_data, "test" , "X_test.txt" ),
header = FALSE)
featurestrain <- read.table(file.path(path_data, "train", "X_train.txt"),
header = FALSE)

#Merge data
subject <- rbind(subjecttrain, subjecttest)
activity<- rbind(activitytrain, activitytest)
features<- rbind(featurestrain, featurestest)

#Change variable names
names(subject)<-c("subject")
names(activity)<- c("activity")
featuresnames <- read.table(file.path(path_data, "features.txt"),head=FALSE)
names(features)<- featuresnames$V2

#Merge data
combine <- cbind(subject, activity)
Data <- cbind(features, combine)

#Search for mean and standard deviation on the variables names and subset those columns
meanandstd<-featuresnames$V2[grep("mean\\(\\)|std\\(\\)", featuresnames$V2)]

selectedcol<-c(as.character(meanandstd), "subject", "activity" )
Data<-subset(Data,select=selectedcol)

#Change activity values to descriptive names
activitylabels <- read.table(file.path(path_data, "activity_labels.txt"),header = FALSE)
Data<-mutate(Data,activity2=factor(Data[,"activity"],labels=activitylabels[,"V2"]))
Data<-rename(Data,activitycode=activity,activity=activity2)

#Change part of variable names to be more explicit
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#Create second independent data set
Datanew<-aggregate(. ~subject + activity, Data, mean)
Datanew<-Datanew[order(Datanew$subject,Datanew$activity),]
write.table(Datanew, file = "tidydataset.txt",row.name=FALSE)

#Create codebook
library(dataMaid)
makeCodebook(Data)