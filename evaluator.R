rm(list=ls())
all.files <- list.files(path ="Z:/zhuxiaorui/Dropbox/assessment9/", full.names = T)
all.files <- all.files[-1]
all.files[1:10]

under <- list.files(path = all.files[1], full.names = F)
under
length(whole)
whole[-2]
list.files(path = whole[1], full.names = T)

get.eval.path <- function(up.path){
    af.under <- list.files(path = up.path, full.names = T)
    wholefolder <- list.files(path = af.under, full.names = T)
    num <- length(wholefolder)
    evaluatorID <- list.files(path = af.under, full.names = F)[-num]
    fold.list <- c(evaluatorID, wholefolder[-num])
    return(evaluatorlist = fold.list)
}
all.files[1:4]
mylist <- lapply(all.files, get.eval.path)
mylist[1:2]

get.eva.path <- function(mylist.in){
    len <- length(mylist.in)
    eva.path <- mylist.in[(len/2+1):len]
    return(eva.path[!is.na(eva.path)])
}
eva.path <- lapply(mylist, get.eva.path)
eva.path[1:2]

get.eva.ID <- function(mylist.in){
    len <- length(mylist.in)
    eva.ID <- mylist.in[1:(len/2)]
    ## return(eva.ID[!is.na(eva.ID)])
    return(eva.ID)
}

eva.ID <- lapply(mylist, get.eva.ID)
eva.ID[1:10]

rm(list = 'eva.ID')
### mydata <- do.call('rbind',mylist)

############################################
## convert whole path of evaluators ##
all.eva.path <- unlist(eva.path)
all.eva.path[1:5]
all.eva.ID <- unlist(eva.ID)
all.eva.ID[1:5]

library(XML)
all.eva.path[1]

evaluator <- function(path){
### filetest <- "submitter8087/submission1941/fields.html" ### Doesn't need it
###    filetest
    ## try to change the path into characters
    cha.path <- list.files(as.character(path), full.names = T)
    ## cha.path <- as.character(path)
### Use XML package to transfer html file into text
    root <- htmlParse(cha.path)

### use getNodeSet to find right position of answers.
    getIDs <- getNodeSet(root, '//head//title')

## here for the ID
    ID <- sapply(getIDs, xmlValue)

    ### regexpr("coursera_user_id:", ID)

### Extract answers
## ans <- getNodeSet(root, '//body//div[@class="field-value"]')
    ans <- getNodeSet(root, '//body//div')

    answers <- sapply(ans, xmlValue)[2] ### Just get those text answers, image lost
    list(IDs = ID, Answers = answers)
}

all.answers <- lapply(all.eva.path,evaluator)
IDs <- sapply(all.answers,'[[',1)
IDs[1:3]
############################################
## Acquire coursera_ID, session_ID ##
cosr.ID <- sapply(IDs, function(ex) sub(",", "", strsplit(ex, "\\s")[[1]][6]))
cosr.ID <- matrix(cosr.ID, nrow = length(cosr.ID), ncol = 1, dimnames= list(c(1:length(cosr.ID)),c("Coursera_UserID")))
length(cosr.ID)
cosr.ID[1:10]                           # Here is User ID

sesn.ID <- sapply(IDs, function(ex) sub(")", "", strsplit(ex, "\\s")[[1]][8]))
length(sesn.ID)
sesn.ID[1]
sesn.ID <- matrix(sesn.ID, nrow = length(sesn.ID), ncol = 1, dimnames= list(c(1:length(sesn.ID)),c("Session_UserID")))
sesn.ID[1:3]                            # Here is session ID


############################################
## Revise the variable of evaluator ID ##
all.eva.ID[1:2]
clean.EvaID <- function(ID){
    return(sub("evaluator","",ID))
}
Evaluator.ID <- sapply(all.eva.ID, clean.EvaID)
Evaluator.ID[1:2]

all.answers <- sapply(all.answers,'[[',2)
all.answers[1:2]

############################################
## restructure the whole data ##
Evaluator_ID <- Evaluator.ID
Submitter_User_ID <- cosr.ID
Session_user_ID <- sesn.ID
## Evaluation <- as.character(all.answers)
Evaluation <- sapply(all.answers,function(row) iconv(row, "latin1", "ASCII", sub=""))
Evaluation[2]
all.evaluator <- cbind(Evaluator_ID, Submitter_User_ID, Session_user_ID, Evaluation)
names(all.evaluator) <- c(Evaluator_ID, Submitter_User_ID, Session_user_ID, Evaluation)
all.evaluator[1,]
################# Save data ###########################
## xlsReadWrite包中的write.xls函数，可以保存为xls格式的
## library(XLConnect)
Sys.setenv(JAVA_HOME='C:\\Program Files (x86)\\Java\\jre1.8.0_45') # for 64-bit version
## Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_31') # for 64-bit version
## C:\Program Files\Java\jre1.8.0_31
library(rJava)
library(xlsx)
## library(xlsx) just try the following:
## Does it work? Done!!
write.xlsx2(x = all.evaluator, file = "Y:/PH.D/PSU/Part-time job/MOOC/evaluators001.xlsx",sheetName = "Evaluators", row.names = FALSE)

############################################
