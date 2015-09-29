################# Read data ###########################
## xlsReadWrite包中的write.xls函数，可以保存为xls格式的
## library(XLConnect)
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_31') # for 64-bit version
## C:\Program Files\Java\jre1.8.0_31
library(rJava)
library(xlsx)
## library(xlsx) just try the following:
#######################################################
## deleted samples with missing items ##
combined <- read.xlsx2("Y:/PH.D/PSU/Part-time job/MOOC/CleanedData/Consolidate/STower_Demo_CStyle (1287 samples).xlsx",1)

#######################################################
## Simple analysis ##
height <- as.numeric(as.character(combined$TowerHeight))
summary(height)
par(mfrow=c(1,2))
boxplot(height,xlab="shoe tower height")
hist(height)
## qqnorm(height)

numshoes <- as.numeric(as.character(combined$NumShoes))
summary(numshoes)
par(mfrow=c(1,2))
boxplot(numshoes,main="number of shoes")
hist(numshoes)


T.value <- as.numeric(as.character(combined$T.VALUE))
summary(T.value)
par(mfrow=c(1,2))
boxplot(T.value)
hist(T.value)

betf.rate <- as.numeric(as.character(combined$betf.rate))

par(mfrow=c(1,2))
boxplot(betf.rate)
hist(betf.rate)

crtv.rate <- as.numeric(as.character(combined$crtv.rate))
par(mfrow=c(1,2))
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
par(mfrow=c(1,2))
boxplot(Score)
hist(Score)


# Add boxplots to a scatterplot
par(fig=c(0,0.8,0,0.8), new=TRUE)
plot(betf.rate, crtv.rate, xlab="Beautiful rate",
  ylab="Creativity Rate")
par(fig=c(0,0.8,0.55,1), new=TRUE)
boxplot(crtv.rate, horizontal=TRUE, axes=FALSE)
par(fig=c(0.65,1,0,0.8),new=TRUE)
boxplot(betf.rate, axes=FALSE)
mtext("Enhanced Scatterplot", side=3, outer=TRUE, line=-3)

# Add boxplots to a scatterplot
par(fig=c(0,0.8,0,0.8), new=TRUE)
plot(betf.rate, Score, xlab="Beautiful rate",
  ylab="Score")
par(fig=c(0,0.8,0.55,1), new=TRUE)
boxplot(Score, horizontal=TRUE, axes=FALSE)
par(fig=c(0.65,1,0,0.8),new=TRUE)
boxplot(betf.rate, axes=FALSE)
mtext("Enhanced Scatterplot", side=3, outer=TRUE, line=-3)

length(Score)
length(betf.rate)
Sco.betf <- aov(Score~betf.rate+crtv.rate)
summary(Sco.betf)
Sco.betf2 <- lm(Score~betf.rate+crtv.rate)
summary(Sco.betf2)

#######################################################
## beautiful rate over height and number of shoes ##
betf.HeiSho <- lm(betf.rate~height+numshoes)
summary(betf.HeiSho)

## creativity rate over height and number of shoes ##
crtv.HeiSho <- lm(crtv.rate~height+numshoes)
summary(crtv.HeiSho)
