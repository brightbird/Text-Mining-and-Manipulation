################# Read data ###########################
## xlsReadWrite包中的write.xls函数，可以保存为xls格式的
## library(XLConnect)
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_31') # for 64-bit version
## C:\Program Files\Java\jre1.8.0_31
library(rJava)
library(xlsx)
## library(xlsx) just try the following:
## Does it work? Done!!
submitters <- read.xlsx2("Y:/PH.D/PSU/Part-time job/MOOC/CleanedData/Consolidate/STower_Demo_CStyle (1953 samples).xlsx", 1)
head(submitters)

hyperlink <- read.xlsx2("Y:/PH.D/PSU/Part-time job/MOOC/CleanedData/Consolidate/hyperlink.xlsx", 1)
head(hyperlink)

sub.list <- split(submitters, rownames(submitters))
sub.list[1]
## tryID <- sub.list$'538'$Session_UserID
## as.character(tryID)

## demo$Shoe_Tower_Session_UserID == as.character(tryID)
## pos <- match(as.character(tryID),demo$Shoe_Tower_Session_UserID)
## matched <- demo[demo$Shoe_Tower_Session_UserID == as.character(tryID),1:6]
## matched
## cbind(sub.list$'1',demo[pos,])

consolida <- function(row){
    sesoID <- row$Session_UserID
    pos <- match(as.character(sesoID),hyperlink$Session_UserID)
    ## matched <- demo[demo$Shoe_Tower_Session_UserID == as.character(sesoID),1:6]
    return(cbind(row,hyperlink[pos,]))
}

results <- lapply(sub.list,consolida)
length(results$'1')
length(results)
results$'2'

is.list(results)
combined <- do.call(rbind.data.frame, results)
combined[1:5,]
#######################################################
## save file ##
write.xlsx2(x = combined, file = "Y:/PH.D/PSU/Part-time job/MOOC/CleanedData/Consolidate/STower_Demo_CStyle (1953 samples)_hyperlink.xlsx",sheetName = "submitter", row.names = FALSE)
combined[,3]
combined[1,6]
as.numeric(as.character(combined[1,6]))
summary(combined[1,6])
