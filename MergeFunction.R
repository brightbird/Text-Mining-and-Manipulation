################# Read data ###########################
## xlsReadWrite包中的write.xls函数，可以保存为xls格式的
## library(XLConnect)
Sys.setenv(JAVA_HOME='C:\\Program Files (x86)\\Java\\jre1.8.0_45') # for 64-bit version
## Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_31') # for 64-bit version
## C:\Program Files\Java\jre1.8.0_31
library(rJava)
library(xlsx)
## library(xlsx) just try the following:
## Does it work? Done!!
## Be careful, check the file name every time when you want to use this procedure to mearge data sets.
## #######################################################
submitters <- normalizePath("Y:/PH.D/PSU/Part-time job/MOOC/Attempts/Categories/1222(Withoutoutlierinln_Tvalue)2.xlsx")

Ques <- normalizePath("Y:/PH.D/PSU/Part-time job/MOOC/Attempts/Categories/1953_samples_with_categories.xlsx")

data1 <- read.xlsx2(submitters, 1)
data2 <- read.xlsx2(Ques, 1)

mergeID <- "Coursera_UserID"


    ## function for mergeing.
    ## match each row by Coursera_UserID
    ## Ques is global data set
    ## rowname is splited raw data, which is "submitters"

merging <- function(original, new, mergeID){
    dataOriginal <- read.xlsx2(original, 1)
    dataNew <- read.xlsx2(new, 1)
    sub.list <- split(dataOriginal, rownames(dataOriginal))

    consolida <- function(row){
        sesoID <- row$Coursera_UserID
        pos <- match(as.character(sesoID), dataNew$Coursera_UserID)
        ## matched <- demo[demo$Shoe_Tower_Session_UserID == as.character(sesoID),1:6]
        return(cbind(row, dataNew[pos,]))
        ## combine all columns in the question data set to each row.
    }
    results <- lapply(sub.list, consolida)
    return (do.call(rbind.data.frame, results))
}

final <- merging(submitters, Ques, mergeID)

final[1,]
length(final[,1])

#######################################################
## save file ##
write.xlsx2(x = final, file = "Y:/PH.D/PSU/Part-time job/MOOC/Attempts/Categories/1222_with_categories.xlsx",sheetName = "submitter", row.names = FALSE)


##############

combined[,3]
combined[1,6]
as.numeric(as.character(combined[1,6]))
summary(combined[1,6])
#######################################################
## Simple analysis ##
height <- as.numeric(as.character(combined$TowerHeight))
summary(height)
boxplot(height,xlab="shoe tower height")
hist(height)
## qqnorm(height)

numshoes <- as.numeric(as.character(combined$NumShoes))
summary(numshoes)
boxplot(numshoes)
hist(numshoes)


T.value <- as.numeric(as.character(combined$T.VALUE))
summary(T.value)
boxplot(T.value)
hist(T.value)

betf.rate <- as.numeric(as.character(combined$betf.rate))
boxplot(betf.rate)
hist(betf.rate)

crtv.rate <- as.numeric(as.character(combined$crtv.rate))
boxplot(crtv.rate)
hist(crtv.rate)

Country <- combined$Country
table(Country)
hist(table(Country))
## pie(Country)
Gender <- combined$Gen_der
summary(Gender)
pie(table(Gender))
## Occupation <- combined$Occupation
Score <- as.numeric(as.character(combined$Score))
summary(Score)
boxplot(Score)
hist(Score)

