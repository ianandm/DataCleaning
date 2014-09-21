# The objective of this code is to generate a tidy data set from
# the Human Activity Recognition Using Smartphones Dataset
# The data set generated from this exercise will bring in data
# from multiple data sets in a way that its easier to analyze and 
# understand. Further analysis will be possible with greater ease
# on this data set

# The mergeDataSet function merges the data set given as a part of 
# UCI HAR Dataset into one data set. This function also makes the
# column names of activity and subject descriptive. 

library(data.table)
library(plyr)
library(tidyr)

mergeDataSet <- function(){
    
    varList1 <- data.frame()
    varList2 <- data.frame()
    varList <- data.frame()
    nam <- character()
    
    # read the txt files into multiple data frames
    dt1 <- read.table("train/y_train.txt", header=TRUE)
    dt2 <- read.table("train/X_train.txt", header=TRUE)
    dt3 <- read.table("train/subject_train.txt", header=TRUE)
    dt4 <- read.table("test/y_test.txt", header=TRUE)
    dt5 <- read.table("test/X_test.txt", header=TRUE)
    dt6 <- read.table("test/subject_test.txt", header=TRUE)
    
    # get the variable measurements
    
    v <- variableDS()
    dt2 <- dt2[c(v)]
    for(i in 1:length(dt2)){
        nam <- c(nam, paste("v",i,sep=""))
    }
    names(dt2) <- c(nam)
    nam <- character() 
  
    dt5 <- dt5[c(v)]
    for(i in 1:length(dt5)){
        nam <- c(nam, paste("v",i,sep=""))
    }
    names(dt5) <- c(nam)
    
    # change Column Names of the subject data set
    names(dt3)[1] <- "Subject"
    names(dt6)[1] <- "Subject"
    
    # change Column Names of the Training Label data set
    names(dt1)[1] <- "Activity"
    names(dt4)[1] <- "Activity"
    
    dtsub <- rbind(dt3, dt6)
    dtsub <- dtsub[order(dtsub$Subject),]
   
    dtAct <- rbind(dt1, dt4)

    for(i in 1:nrow(dtAct)){
        if (dtAct[i,]==1)
            dtAct[i,] <- "WALKING"
        else if (dtAct[i,]==2)
            dtAct[i,] <- "WALKING_UPSTAIRS"
        else if (dtAct[i,]==3)
            dtAct[i,] <- "WALKING_DOWNSTAIRS"
        else if (dtAct[i,]==4)
            dtAct[i,] <- "SITTING"
        else if (dtAct[i,]==5)
            dtAct[i,] <- "STANDING"
        else if (dtAct[i,]==6)
            dtAct[i,] <- "LAYING"
            

    }
    dtTest <- rbind(dt2, dt5)
    names(dtTest) <- c(getVariableNames())
    
    finDat <- cbind(dtsub,dtAct)
    finDat <- cbind(finDat, dtTest)
    names(finDat)[1] <- "Subject"
    
    #get the tidy data
    dTidy <- getTidyData(finDat)
    write.csv(dTidy,"fin.csv")
    write.table(dTidy, "dTidy.txt", sep="\t", row.names=FALSE)

    
}

variableDS <- function(){
    
    varList1 <- data.frame()
    varList2 <- data.frame()
    varList <- data.frame()
    v <- numeric()
    
    # Extract all measurements for mean and std deviation
    # for all measuremants. We will extract the mean of the
    # signals that were used to estimate variables of the 
    # feature vector for each pattern
    
    dtFeature <- read.table("features.txt", header=FALSE)
    
    feaList <- c("tBodyAcc", "tGravityAcc", "tBodyAccJerk", "tBodyGyro", "tBodyGyroJerk", "tBodyAccMag", "tGravityAccMag", "tBodyAccJerkMag", "tBodyGyroMag", "tBodyGyroJerkMag", "fBodyAcc", "fBodyAccJerk", "fBodyGyro", "fBodyAccMag", "fBodyAccJerkMag", "fBodyGyroMag", "fBodyGyroJerkMag")
    
    # choose the variables to extract from the test and train sets
    
    for(i in 1:length(feaList)){
        varList1 <- c(varList1, paste(feaList[i],"mean()", sep="-"))
    }
    
    for(i in 1:length(feaList)){
        varList2 <- c(varList2, paste(feaList[i],"std()", sep="-"))
    }
    
    varList <- c(varList1, varList2)
    
    for (i in 1: length(varList)){
        g <- grep(varList[i], dtFeature$V2)
        if(length(g)>0)
            v <- c(v, g)        
    }
    return(v)
    
}

# This function will help in getting the names of the columns of 
# the test and train data sets
getVariableNames <- function(){
    dtFeature <- read.table("features.txt", header=FALSE)
    
    v <- variableDS()
    nam<-character()
    for(i in 1:length(v)){
        #nam<- append(nam, as.character(dtFeature[v[i],2]))
        if(length(grep("mean",as.character(dtFeature[v[i],2])))>0)
            nam <- append(nam, paste("mean", i, sep=""))
        else if(length(grep("std",as.character(dtFeature[v[i],2])))>0)
            nam <- append(nam, paste("std", i, sep=""))
    }
    return(nam)
}

getTidyData <- function(dt){
    DT <- data.table()
    #get the data for the subjects 1 after the other
    for(i in 1:length(unique(dt1$Subject))){
        dtSub <- data.table()
        dtSub <- getDataSub(dt,i)
        
        DT <- rbind(DT, ddply(dtSub, .(dtSub$Activity), colwise(mean)))
    }
    DT$X <- NULL
    colnames(DT)[1] <- "Activity"
    DT <- subset(DT, select=c(2,1,3:72))
    return(DT)
}

getDataSub <- function(dt1, n){
    dt1 <- dt1[as.numeric(dt1$Subject)==n,]
    return(dt1)
}

