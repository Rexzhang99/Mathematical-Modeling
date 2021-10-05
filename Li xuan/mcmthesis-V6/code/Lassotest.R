library(RColorBrewer) ##载入RColorBrewer程序包
library(readxl)
library(readr)
library(ggplot2)
library(dplyr)
library(glmnet)
library (plyr)

rm(list = ls())

display.brewer.all() ;##显示所有调色板以供选择
cols <- brewer.pal(n=11,name="Spectral") ;##设定颜色为set3调色板，n根据调色 板相应的改变
cols_x<-cols[1:445]; ##设定颜色矩阵


dev.new


allmainfactor=c();

for (z in 10:16) 
{
MCM_NFLIS_Data <- read_excel("/Users/rexzhang/Downloads/2019_MCM-ICM_Problems/2018_MCMProblemC_DATA/MCM_NFLIS_Data.xlsx", 
                               sheet = "Data")
Book <- read_excel("/Users/rexzhang/Downloads/Book2.xlsx")  
ACS_10_5YR_DP02_with_ann <- read_csv(paste("/Users/rexzhang/Downloads/2019_MCM-ICM_Problems/2018_MCMProblemC_DATA/ACS_",z,"_5YR_DP02/ACS_",z,"_5YR_DP02_with_ann.csv",sep=""))
ACS_10_5YR_DP02_with_ann <- ACS_10_5YR_DP02_with_ann[-1,]
CS_10_5YR_DP02_metadata <- read_csv(paste("/Users/rexzhang/Downloads/2019_MCM-ICM_Problems/2018_MCMProblemC_DATA/ACS_",z,"_5YR_DP02/ACS_",z,"_5YR_DP02_metadata.csv",sep=""))


#连接某一年数据
Book=Book[which(Book$YYYY == paste("20",z,sep="")),]

#除去了多余的县，all=F
CombinedData=merge(x=Book,y=ACS_10_5YR_DP02_with_ann,by.x="FIPS_Combined",by.y = "GEO.id2",all=F);

#处理空值
CombinedData[CombinedData=="(X)"]<-0
CombinedData[CombinedData=="*****"]<-NA
CombinedData[CombinedData=="**"]<-100


#提取误差率HC04<10%的变量名HC01goodname
HC04columIndices=seq(from=14,to=length(CombinedData),by=4)
HC04=CombinedData[,HC04columIndices];

Socio_Economic_Factor=1:dim(HC04)[2];
Percentage=HC04[1,]
HC04=as.matrix(sapply(HC04,as.numeric))

setwd("/Users/rexzhang/Downloads/mcmthesis-V6/figures")
jpeg(file=paste("PercentMarginErrorDataGraphVariable20",z,".jpeg",sep=""),width=500,height=500,quality = 75)

par(mar=c(5,5,3,2)+0.1, oma=c(0, 0, 0, 0))
plot(Socio_Economic_Factor,Percentage,'l',col=cols_x[1],main=paste("Percent Margin of Error and Variable Line Diagram of 20",z,sep=""),cex=0.5)
for (i in 2:dim(CombinedData)[1])
{Percentage=HC04[i,]
j=i
lines(Socio_Economic_Factor,Percentage,type='l',col=cols_x[j])
} 
#误差率平均线
lines(Socio_Economic_Factor+1,colMeans(HC04),type='l','black',lwd=2)
#10%误差率截断线
abline(h =10, col ="black",lwd=1)

dev.off()

HC04goodname=names(subset(colMeans(HC04),colMeans(HC04)<10))
HC01goodname=gsub("HC04", "HC01", HC04goodname)





#采用总数而非比率HC_01
#HC03_VC93	Percent; EDUCATIONAL ATTAINMENT - Percent high school graduate or higher 仅有比率
columIndices=seq(from=11,to=length(CombinedData),by=4)


x=CombinedData[,columIndices];
#除去x中的误差率HC04>10%的指标
x=subset(x,select=HC01goodname)
x=as.matrix(sapply(x,as.numeric)) 
#x=matrix(x,nrow=437,ncol=152,byrow=FALSE)
y=as.numeric(CombinedData[,7]);



#lasso
#,lambda.min.ratio=0.001 , nlambda=100
fit=glmnet(x, y, family="gaussian", alpha=1)
#print(fit)

setwd("/Users/rexzhang/Downloads/mcmthesis-V6/figures")
jpeg(file=paste("ChangesofInterpretationVariableandCoefficientsinLASSORegressionof20",z,".jpeg",sep=""),width=500,height=500,quality = 75)

par(mar=c(5,4,9,2)+0.1, oma=c(0, 0, 0, 0))
plot(fit, xvar="lambda",label=TRUE,col=cols,main=paste("Changes of Interpretation Variable and Coefficients \n in LASSO Regression of 20",z,sep=""));
mtext("Coefficients number", side=3,line=2);
###lambda变化趋势
n=1:length(fit$lambda)
#qplot(x=n,fit$dev.ratio,ylab =expression(R^2))

#par(mar=c(5,4,2,2)+0.1, oma=c(0, 0, 0, 0))
#plot(x=n,y=fit$lambda,ylab ='Log Lambda',cex=0.7,pch=20)

dev.off()


coef=coef(fit, s=c(fit$lambda[length(fit$lambda)*0.2]))
coef@Dimnames[[1]][coef@i+1]

#交互检验 lasso ,lambda.min.ratio=0.00005
cvfit = cv.glmnet(x, y, family = "gaussian",alpha=1)


setwd("/Users/rexzhang/Downloads/mcmthesis-V6/figures")
jpeg(file=paste("CVLASSOLambdaCorrespondingMSEGraphof20",z,".jpeg",sep=""),width=500,height=500,quality = 75)

par(mar=c(5,5,7,2)+0.1, oma=c(0, 0, 0, 0))
plot(cvfit,main=paste("CV LASSO Lambda Corresponding MSE Graph of 20",z,sep=""))
mtext("Coefficients number", side=3,line=2)
dev.off()

###lambda变化趋势

jpeg(file=paste("SelectedLambdaCorrespondingRegressR2Graphof20",z,".jpeg",sep=""),width=500,height=500,quality = 75)
par(mar=c(5,4,2,2)+0.1, oma=c(0, 0, 0, 0))
m=1:length(cvfit$lambda)
plot(cvfit[["glmnet.fit"]][["lambda"]],cvfit[["glmnet.fit"]][["dev.ratio"]],xlab ='Log Lambda',ylab =expression(R^2),cex=0.7,pch=20,main=paste("Scatter Plot of Lambda's Value of 20",z,sep=""))
abline(v =c(cvfit$lambda.min, cvfit$lambda.1se), col ="black",lwd=3)
dev.off()

c(cvfit$lambda.min, cvfit$lambda.1se)
#coef_cvfit=coef(fit,s=c(cvfit$lambda.min, cvfit$lambda.1se))
coef_cvfit=coef(fit,s=c(cvfit$lambda.min))
abbr=data.frame(coef_cvfit@Dimnames[[1]][coef_cvfit@i+1],coef_cvfit@x)
names(abbr)[1]="abbr"
mainfactor=merge(x=abbr,y=CS_10_5YR_DP02_metadata,by.y= "GEO.id",by.x = names(abbr)[1],all=F)
mainfactor$year=2000+z
mainfactor$CorrespondingR2=cvfit[["glmnet.fit"]][["dev.ratio"]][which(cvfit[["glmnet.fit"]][["lambda"]] == cvfit$lambda.min)]

#setwd("/Users/rexzhang/Downloads/mcmthesis-V6/figures")
#yourfilenamecsv=paste("mainfactor20",z,".csv",sep="")#循环命名
#write.csv(mainfactor, file =yourfilenamecsv)



allmainfactor$abbr=c(allmainfactor$abbr,as.character(mainfactor$abbr));
allmainfactor$Id=c(allmainfactor$Id,mainfactor$Id);
allmainfactor$year=c(allmainfactor$year,mainfactor$year);
allmainfactor$coef_cvfit.x=c(allmainfactor$coef_cvfit.x,mainfactor$coef_cvfit.x);
allmainfactor$CorrespondingR2=c(allmainfactor$CorrespondingR2,mainfactor$CorrespondingR2);


#标准化x
#处理空值
CombinedData[CombinedData=="(X)"]<-0
nx<- matrix(nrow=dim(x)[1],ncol=dim(x)[2])
colnames(nx)=colnames(x)
for (i in 1:dim(x)[2]) {
  nx[,i]=scale(x[,i],center=T,scale=T);  
}



#绘制标准化数据
Variable=1:dim(x)[2];
Value=nx[1,]

setwd("/Users/rexzhang/Downloads/mcmthesis-V6/figures")
jpeg(file=paste("StandardDataLASSOVariableof20",z,".jpeg",sep=""),width=500,height=500,quality = 75)


par(mar=c(5,5,3,2)+0.1, oma=c(0, 0, 0, 0))
plot(Variable,Value,'l',col=cols_x[1],main=paste("Standardized Data Graph and LASSO Selected Variable of 20",z,sep=""),ylim=c(-2,2),cex=0.5)
for (i in 2:dim(CombinedData)[1])
{Value=nx[i,]
j=i
lines(Variable,Value,type='l',col=cols_x[j])
} 
#绘制选择的变量位置
abline(v =coef_cvfit@i+1, col ="black",lwd=1)

dev.off()
}
dataframeallmainfactor=data.frame(t(rbind(allmainfactor$Id,allmainfactor$abbr,allmainfactor$year,allmainfactor$coef_cvfit.x,allmainfactor$CorrespondingR2)))
freqx1=data.frame(table(dataframeallmainfactor))
#publicmainfactor=merge(x=freqx1,y=CS_10_5YR_DP02_metadata,by.x=names(freqx1)[1],by.y=names(CS_10_5YR_DP02_metadata)[2],all.x=TRUE)
write.csv(dataframeallmainfactor, file =paste("Publicmainfactor.csv",sep=""))

avd=merge(x=data.frame(table(dataframeallmainfactor$X2)),y=data.frame(CS_10_5YR_DP02_metadata),by.y= names(data.frame(CS_10_5YR_DP02_metadata))[1],by.x = names(data.frame(table(dataframeallmainfactor$X2)))[1],all.x=T)
write.csv(avd, file =paste("PublicmainfactorCount.csv",sep=""))

#publicmainfactor=data.frame(table(dataframeallmainfactor$X1,dataframeallmainfactor$X2))

