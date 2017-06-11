run_analyis<-function(){
  setwd("C:/Users/uawe/Desktop/Coursera/Data Science Specialization/Course 3 Getting and Cleaning Data/Course Project/UCI HAR Dataset")
  var_names<-read.table("features.txt", stringsAsFactors = FALSE)
  
  X_test<-read.table("X_test.txt")
  ## takes features and puts them as column names for X_test, can't subset on column names without giving the columns names
  names(X_test)<-var_names[ ,2]
  ## subset on desired mean/st. dev. Measurements and name DF test_data
  test_data<-X_test[grep("std|-[Mm]ean", names(X_test), value = TRUE)]
  
  ##read in subject and activity number columns
  sub_test<-read.table("subject_test.txt")
  act_num1<-read.table("y_test.txt")
  
  ## puts sub_test and act_num as front columns of test_data
  test_data<-data.frame(sub_test, act_num1, test_data)
  
  ## read in training data and put labels on it
  X_train<-read.table("X_train.txt")
  ## takes features and puts them as column names for X_train, otherwise rbind won't work
  names(X_train)<-var_names[ ,2]
  ## subset on desired mean/st. dev. Measurements and name DF train_data
  train_data<-X_train[grep("std|-[Mm]ean", names(X_train), value = TRUE)]
  
  ## puts sub_train and act_num2 as front columns of X_train
  sub_train<-read.table("subject_train.txt")
  act_num2<-read.table("y_train.txt")
  train_data<-data.frame(sub_train, act_num2, train_data)
  
  ## merge both datasets
  data<-rbind(test_data, train_data)
  
  actlab<-read.table("activity_labels.txt")
  ## have to load qdapTools package for lookup function
  library(qdapTools)
  ## apply descriptive names from 
  data$V1.1<-lookup(data$V1.1, actlab)
  
  ## renames first two columns subject and activity respectively
  names(data)[1]<-"subject"
  names(data)[2]<-"activity"
  
  library(dplyr)
  ## group by subject, activity and apply mean function to each subsequent column (summarize would only do one column)
  grouped_data<-data %>% group_by(subject, activity) %>% summarize_each(funs(mean))
  write.table(grouped_data, file="Matt's tidy data.txt", row.names = FALSE)
}