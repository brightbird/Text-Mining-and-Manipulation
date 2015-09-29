################# Read data ###########################
## xlsReadWrite包中的write.xls函数，可以保存为xls格式的
## library(XLConnect)
Sys.setenv(JAVA_HOME='C:\\Program Files (x86)\\Java\\jre1.8.0_45') # for 64-bit version
## C:\Program Files\Java\jre1.8.0_31
library(rJava)
library(xlsx)
## library(xlsx) just try the following:
## Does it work? Done!!

## Import peer assessment data; contains all variables include demographic variables: Evaluator UserID; Submitter UserID; Submitter Session UserID; Comments.
#######################################################
## save file ##
## write.xlsx2(x = combined, file = "Y:/PH.D/PSU/Part-time job/MOOC/CleanedData/Consolidate/Peer_Assessment(4372_samples).xlsx",sheetName = "PeerAssessment", row.names = FALSE)

PeerComments <- read.xlsx2("Y:/PH.D/PSU/Part-time job/MOOC/CleanedData/Consolidate/Peer_Assessment(4372_samples).xlsx", 1)
head(PeerComments)
subshoe <- gsub("shoe","",PeerComments$Comments)
subshoe <- gsub("shoes","",subshoe)
subshoe <- gsub("tower","",subshoe)
subshoe <- gsub("towers","",subshoe)
subshoe <- gsub("think","",subshoe)
subshoe <- gsub("Tower","",subshoe)
subshoe <- gsub("Shoe","",subshoe)

subshoe[1:3]
Results <- cbind(PeerComments,subshoe)
write.xlsx2(x = Results, file = "Y:/PH.D/PSU/Part-time job/MOOC/CleanedData/Consolidate/Peer_Assessment(4372_samples_Added_Comments).xlsx",sheetName = "PeerAssessment", row.names = FALSE)
