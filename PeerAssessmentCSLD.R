################# Read data ###########################
## xlsReadWrite包中的write.xls函数，可以保存为xls格式的
## library(XLConnect)
Sys.setenv(JAVA_HOME='C:\\Program Files (x86)\\Java\\jre1.8.0_45') # for 64-bit version
## C:\Program Files\Java\jre1.8.0_31
library(rJava)
library(xlsx)
## library(xlsx) just try the following:
## Does it work? Done!!

## Import peer assessment data; contains four variables: Evaluator UserID; Submitter UserID; Submitter Session UserID; Comments.
Evaluator <- read.xlsx2("Z:/zhuxiaorui/Dropbox/ShoeTower/Evaluator_Demo_CStyle/Cleaned_evaluators.xlsx", 1)
head(Evaluator)

demo <- read.xlsx2("Y:/PH.D/PSU/Part-time job/MOOC/CleanedData/Consolidate/submitters_CS_new1.xls", 1)
head(demo)

sub.list <- split(Evaluator, rownames(Evaluator))
sub.list[1]
## tryID <- sub.list$'538'$Session_UserID
## as.character(tryID)

## demo$Shoe_Tower_Session_UserID == as.character(tryID)
## pos <- match(as.character(tryID),demo$Shoe_Tower_Session_UserID)
## matched <- demo[demo$Shoe_Tower_Session_UserID == as.character(tryID),1:6]
## matched
## cbind(sub.list$'1',demo[pos,])

consolida <- function(row){
    sesoID <- row$Evaluator.UserID
    pos <- match(as.character(sesoID),demo$Shoe_Tower_Coursera_UserID)
    ## matched <- demo[demo$Shoe_Tower_Session_UserID == as.character(sesoID),1:6]
    return(cbind(row,demo[pos,]))
}

results <- lapply(sub.list,consolida)
length(results$'1')
length(results)
results$'3'

is.list(results)
combined <- do.call(rbind.data.frame, results)
combined[1:10,]
#######################################################
## save file ##
write.xlsx2(x = combined, file = "Y:/PH.D/PSU/Part-time job/MOOC/CleanedData/Consolidate/Peer_Assessment(4372_samples).xlsx",sheetName = "PeerAssessment", row.names = FALSE)
combined[,3]
combined[1,6]
as.numeric(as.character(combined[1,6]))
summary(combined[1,6])
#######################################################
################# Put all the analysis into SPSS ################

## ## Simple analysis ##
## height <- as.numeric(as.character(combined$TowerHeight))
## summary(height)
## boxplot(height,xlab="shoe tower height")
## hist(height)
## ## qqnorm(height)

## numshoes <- as.numeric(as.character(combined$NumShoes))
## summary(numshoes)
## boxplot(numshoes)
## hist(numshoes)


## T.value <- as.numeric(as.character(combined$T.VALUE))
## summary(T.value)
## boxplot(T.value)
## hist(T.value)

## betf.rate <- as.numeric(as.character(combined$betf.rate))
## boxplot(betf.rate)
## hist(betf.rate)

## crtv.rate <- as.numeric(as.character(combined$crtv.rate))
## boxplot(crtv.rate)
## hist(crtv.rate)

## Country <- combined$Country
## table(Country)
## hist(table(Country))
## ## pie(Country)
## Gender <- combined$Gen_der
## summary(Gender)
## pie(table(Gender))
## ## Occupation <- combined$Occupation
## Score <- as.numeric(as.character(combined$Score))
## summary(Score)
## boxplot(Score)
## hist(Score)

