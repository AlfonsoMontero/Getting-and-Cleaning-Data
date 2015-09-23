library(dplyr)
library(plyr)
library(reshape2)

testFile<-"UCI HAR Dataset/test/X_test.txt"
testLabels<-"UCI HAR Dataset/test/y_test.txt"
testSubjectFile<-"UCI HAR Dataset/test/subject_test.txt"
trainFile<-"UCI HAR Dataset/train/X_train.txt"
trainLabels<-"UCI HAR Dataset/train/y_train.txt"
trainSubjectFile<-"UCI HAR Dataset/train/subject_train.txt"
activitiesFile<-"UCI HAR Dataset/activity_labels.txt"
variableFile<-"UCI HAR Dataset/features.txt"

# 1.-Merging training, test, and activity labels data sets
testData<-read.table(testFile)
testActivity<-read.table(testLabels)
testData<-cbind(testData,testActivity)
testSubject<-read.table(testSubjectFile)
testData<-cbind(testData,testSubject)

trainData<-read.table(trainFile)
trainActivity<-read.table(trainLabels)
trainData<-cbind(trainData,trainActivity)
trainSubject<-read.table(trainSubjectFile)
trainData<-cbind(trainData,trainSubject)

allData<-rbind(trainData,testData)
colnames(allData)[562]<-"ActivityID"
colnames(allData)[563]<-"Subject"

# 2.-Selecting only the mean and standard deviation measurements
meanStdData<-select(allData,1:6,41:46,81:86,121:126,161:166,201:202,214:215,
                    227:228,240:241,253:254,266:271,345:350,424:429,503:504,
                    516:517,529:530,542:543,562,563)

# 3.-Use descriptive activity names
activities<-read.table(activitiesFile)
meanStdData<-merge(meanStdData,activities,by.x="ActivityID",by.y="V1")
colnames(meanStdData)[69]<-"Activity"
meanStdData<-meanStdData[,-1] # Remove ActivityID

# 4.-Use descriptive variable names
variableNames<-read.table(variableFile)
variableNames<-as.vector(variableNames$V2)
colnames(meanStdData)[1:66]<-variableNames[c(1:6,41:46,81:86,121:126,161:166,201:202,
                                       214:215,227:228,240:241,253:254,266:271,
                                       345:350,424:429,503:504,516:517,529:530,
                                       542:543)]

# 5.-Create a new tidy data set with the average of each variable for each activity and subject
meltedData<-melt(meanStdData,id.vars=c("Activity","Subject"))
tidyData<-dcast(meltedData,Activity+Subject ~ variable,mean)
write.table(tidyData,file="tidyData.txt",col.names=FALSE)

