rm(list=ls())
all.files <- list.files(path ="Z:/zhuxiaorui/Dropbox/assessment9/", full.names = T)
all.files <- all.files[-1]
all.files[1:10]

getpath <- function(up.path){
    af.under <- list.files(path = up.path, full.names = F)
    whole.path <- paste(up.path,af.under, "fields.html", sep="/")
    return(whole.path)
}
all.files[1:10]
mylist <- lapply(all.files, getpath)
mylist[1:2]

### mydata <- do.call('rbind',mylist)

library(XML)
### read in the field.html file into R
shoetower <- function(path){
### filetest <- "submitter8087/submission1941/fields.html" ### Doesn't need it
###    filetest
    ## try to change the path into characters
    cha.path <- as.character(path)
### Use XML package to transfer html file into text
    root <- htmlParse(cha.path)

### use getNodeSet to find right position of answers.
    getIDs <- getNodeSet(root, '//head//title')

### here for the ID
    ID <- sapply(getIDs, xmlValue)
    ### regexpr("coursera_user_id:", ID)

### Extract answers
## ans <- getNodeSet(root, '//body//div[@class="field-value"]')
    ans <- getNodeSet(root, '//body//div')

    answers <- sapply(ans, xmlValue) ### Just get those text answers, image lost
### image saving!!!!!!
    answers2 <- getNodeSet(root, '//body//div[@class="field-value"]//img[@src]')
    answerimage <- sapply(answers2, function(els) xmlGetAttr(els, "src"))
    if (length(answerimage)>=1) {
        image <- answerimage[1] }
    else {
        image <- "No Image data"}
    list(IDS = ID, Answers = answers, Image = image)
}

## Test staff
## aaa <- as.character(mylist[2])
## try02 <- htmlParse(aaa)
## try02
## trytree <- htmlTreeParse(aaa)
## trytree


QandA <- shoetower(mylist[2])
## No need to
## QandA$Answers[9]
## iconv(QandA$Answers[9],"UTF-8","")

## Now, what I need to do is to rearrage the structure of these four questions

shoetowerout <- function(rawlist){
    Q1.position <- grep("Please provide",rawlist$Answers)
    Q2.position <- grep("How tall",rawlist$Answers)
    Q3.position <- grep("How beautiful",rawlist$Answers)
    Q4.position <- grep("Where would",rawlist$Answers)
    clean.A <- c(rawlist$IDS,rawlist$Answers[Q1.position+1],rawlist$Answers[Q2.position+1],rawlist$Answers[Q3.position+1],rawlist$Answers[Q4.position+1],rawlist$Image)
    return(clean.A)
}

whole <- lapply(mylist, function(files) shoetowerout(shoetower(files)))
summary(whole[1])

## missimagefiles <- length(whole[lapply(whole,length)==5])

IDs <- sapply(whole,'[[',1)
IDs[1:3]
Q1 <- sapply(whole,'[[',2)
Q2 <- sapply(whole,'[[',3)
Q3 <- sapply(whole,'[[',4)
Q4 <- sapply(whole,'[[',5)
Image <- sapply(whole,'[[',6)
Q1[1:10]
length(IDs)
data <- matrix(IDs, nrow = length(IDs), ncol = 6, byrow = FALSE)
data[,2] <- Q1
data[,3] <- Q2
data[,4] <- Q3
data[,5] <- Q4
data[,6] <- Image
data[1,]

ls()
rm(list = c("mylist","all.files"))
## Finished saving!!!!!!!!!!!!!!!!!!!!!!!!!!
## ## And to extract the two IDs of submitter
### Finished all the answers extraction!!
IDs[1]
cosr.ID <- sapply(IDs, function(ex) sub(",", "", strsplit(ex, "\\s")[[1]][6]))
cosr.ID <- matrix(cosr.ID, nrow = length(cosr.ID), ncol = 1, dimnames= list(c(1:length(cosr.ID)),c("Coursera_UserID")))
length(cosr.ID)
cosr.ID[1:10]                           # Here is User ID

sesn.ID <- sapply(IDs, function(ex) sub(")", "", strsplit(ex, "\\s")[[1]][8]))
length(sesn.ID)
sesn.ID[1]
sesn.ID <- matrix(sesn.ID, nrow = length(sesn.ID), ncol = 1, dimnames= list(c(1:length(sesn.ID)),c("Session_UserID")))
sesn.ID[1:3]                            # Here is session ID


Q2[1:3]

Q3[1:3]
## Two complicated, because there are too many situations. "3.First", " 10.", "&&& 10, %%%"
b.r <- function(ex){
    try1 <- c(1:10)[is.element(c(1:10),sub("\\,", "", sub("\\.", "", unlist(lapply(strsplit(ex, "\\s"), function(e) strsplit(e, "/"))))))]
    return(try)
}
## strsplit(r"[;,\s]\s*", Q3[10])

betf.rate <- sapply(Q3, b.r)
betf.rate[1:3]

############### Q4 #############################
Q4[1:3]

crtv.rate <- sapply(Q4, b.r)
crtv.rate[1:3]

##################################################################
rowname <- c(1:length(cosr.ID))
colname <- c("CourseraUserID","SessionUserID", "Q2","NumShoes","Tscore","PhotoPath","Q1","Beauty rate","Q3","Screativity Scale","Q4")
length(rowname);length(colname)

tbc <- rep("TBC",times=length(rowname))
results2 <- data.frame(cbind(cosr.ID,sesn.ID,Q2,tbc,tbc,Image,Q1,betf.rate,Q3,crtv.rate,Q4))
length(results2)
#######################################################
#######################################################
## Above is the first time I tried ##


################# Save data ###########################

write.xlsx2(x = results2, file = "Y:/PH.D/PSU/Part-time job/MOOC/results2.xlsx",sheetName = "TestSheet", row.names = FALSE)

## xlsReadWrite包中的write.xls函数，可以保存为xls格式的
## library(XLConnect)
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_31') # for 64-bit version
## C:\Program Files\Java\jre1.8.0_31
library(rJava)
library(xlsx)
## library(xlsx) just try the following:
## Does it work? Done!!
############################################
ls()

wholedata <- read.xlsx2(file = "Y:/PH.D/PSU/Part-time job/MOOC/results2.xlsx", sheetName = "TestSheet", as.data.frame=TRUE, header=TRUE, )

wholedata[1,]
wholedata$Coursera_UserID
wholedata$betf.rate
wholedata[,8]                           # result
wholedata[,9]                           # original text

wholedata[8:10,8:9]
## ## To be continue.

################### Try ##############################
tryfor5 <- as.character(wholedata[5,9])
tryfor5
tryfor8 <- as.character(wholedata[8,9])
tryfor9 <- as.character(wholedata[9,9])
tryfor10 <- as.character(wholedata[10,9])
textnum <- c("two","three","four","five","six","seven","eight","nine","ten")
summary(wholedata[8,9])


strsplit(tryfor9, "/")
test5 <- c(1:10)[is.element(c(1:10),sub("\\,", "", sub("\\.", "", unlist(lapply(strsplit(tryfor5, "\\s"), function(e) strsplit(e, "/"))))))]
test5[1]

test8 <- textnum[is.element(textnum,sub("\\,", "", sub("\\.", "", unlist(lapply(strsplit(tryfor8, "\\s"), function(e) strsplit(e, "/"))))))]
test9 <- c(1:10)[is.element(c(1:10),sub("\\,", "", sub("\\.", "", unlist(lapply(strsplit(tryfor9, "\\s"), function(e) strsplit(e, "\\."))))))]
test10 <- c(1:10)[is.element(c(1:10),sub("\\,", "", sub("\\.", "", unlist(lapply(strsplit(tryfor10, "\\s"), function(e) strsplit(e, "\\."))))))]

test8
which(textnum==test8)+1

tryfor9
test9

test10
################# All above for try ###########################

################### Extra.rate Function for two rate (beauty, creativity)#########################
Extra.rate <- function(ex){
    ex <- as.character(ex)
    textnum <- c("two","three","four","five","six","seven","eight","nine","ten")
################## For "??? 7 ???" ##########################
    sepTry1 <- c(1:10)[is.element(c(1:10),sub("\\,", "", sub("\\.", "", unlist(lapply(strsplit(ex, "\\s"), function(e) strsplit(e, "/"))))))]
################## For "??? seven ???" ##########################
    sepTry2 <- textnum[is.element(textnum,sub("\\,", "", sub("\\.", "", unlist(lapply(strsplit(ex, "\\s"), function(e) strsplit(e, "/"))))))]
################## For "??? 7.???" ##########################
    sepTry3 <- c(1:10)[is.element(c(1:10),sub("\\,", "", sub("\\.", "", unlist(lapply(strsplit(ex, "\\s"), function(e) strsplit(e, "\\."))))))]

    if (length(sepTry1)!=0) {
        rate <- sepTry1[1]
    } else if (length(sepTry2)!=0) {
        rate <- which(textnum==sepTry2[1])+1
    } else if (length(sepTry3)!=0) {
        rate <- sepTry3
    } else rate <- "Check again"

    return(rate)
}

##################### Test function above ##################################
wholedata[1:5,9]                           # original text

betf.rate <- sapply(wholedata[,9], Extra.rate)
betf.rate
wholedata$betf.rate <- betf.rate

wholedata$Q4[1:2]

crtv.rate <- sapply(wholedata$Q4, Extra.rate)
crtv.rate
wholedata$crtv.rate <- crtv.rate

wholedata[1952,]
wholedata[1929,]
############################################
## save again ##
write.xlsx2(x = wholedata, file = "Y:/PH.D/PSU/Part-time job/MOOC/results2.xlsx",sheetName = "NewResults", row.names = FALSE)
## Saved as "NewResults" sheet ##


######################################################################
wholedata2 <- read.xlsx2(file = "Y:/PH.D/PSU/Part-time job/MOOC/New results3.xlsx", sheetName = "NewResults", as.data.frame=TRUE, header=TRUE, )

#######################################################
test <- as.character(wholedata2$Q2[13])
testSep <- strsplit(test,"\\s")
testSep
which(testSep[[1]] %in% c("cm", "cm.", "cms", "cms."))
length(which(testSep[[1]] %in% c("cm", "cm.", "cms", "cms.")))
wholedata2$Q2[2]
testSep[[1]]
testSep[[2]][which(testSep[[2]] %in% c("cm", "cm."))-1]

#######################################################
## test for situation like " 170cm ", "12cms" ##
aaa1 <- strsplit(as.character(wholedata2$Q2[13]),"\\s")
aaa1
grepl("cms", aaa1[[1]])
aaa1[[1]][grepl("cms", aaa1[[1]])]
sub("cms","", aaa1[[1]][grepl("cms", aaa1[[1]])])
#######################################################

## function for tough situations. &^%%^&*( ##
cmsep <- function(ex){
    text <- as.character(ex)
    words <- strsplit(text,"\\s")
    cm.pos <- which(words[[1]] %in% c("cm","cm.","cms","cms.","centimeter","centimeters"))
    if (length(cm.pos)!=0) {
        height <- words[[1]][cm.pos-1]
    } else {
        height <- sub("cms", "", words[[1]][grepl("cms", words[[1]])])
    }
    return(height)
}
wholedata2$Q2[13]                       # very special case
cmsep(wholedata2$Q2[13])
#######################################################
## Save height ##
height <- lapply(wholedata2$Q2, cmsep)
height[1:20]
wholedata2$TowerHeight <- height


ShoeSep <- function(ex){
    text <- as.character(ex)
    words <- strsplit(text,"\\s")
    cm.pos <- which(words[[1]] %in% c("shoes","shoes.","shoes,","shoes("))
    height <- words[[1]][cm.pos-1]
    return(height)
}

wholedata2$Q2[3]

#######################################################
## change name of height, number of shoes ##
names(wholedata2)[names(wholedata2)=="tbc"]="TowerHeight"
names(wholedata2)[names(wholedata2)=="tbc.1"]="NumShoes"
names(wholedata2)
#######################################################

## Save number of shoes ##
shoes <- lapply(wholedata2$Q2, ShoeSep)
shoes[1:5]
wholedata2$Q2[1:5]
wholedata2$NumShoes <- shoes

wholedata2[1,]

#######################################################
## Saved as new file ##
## The only left thing is those strange answers ##
############################################
## save again ##
write.xlsx2(x = wholedata2, file = "Y:/PH.D/PSU/Part-time job/MOOC/results4.xlsx",sheetName = "NewResults", row.names = FALSE)
## Saved as "NewResults" sheet ##
