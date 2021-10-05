library(RColorBrewer) ##载入RColorBrewer程序包
library(readxl)
library(readr)
library(ggplot2)
library(dplyr)
library(glmnet)


display.brewer.all() ;##显示所有调色板以供选择
cols <- brewer.pal(n=11,name="Spectral") ;##设定颜色为set3调色板，n根据调色 板相应的改变
cols_x<-cols[1:445]; ##设定颜色矩阵

MCM_NFLIS_Data <- read_excel("/Users/rexzhang/Downloads/2019_MCM-ICM_Problems/2018_MCMProblemC_DATA/MCM_NFLIS_Data.xlsx", 
                             sheet = "Data")
Book <- read_excel("/Users/rexzhang/Downloads/Book2.xlsx")
ACS_10_5YR_DP02_with_ann <- read_csv("/Users/rexzhang/Downloads/2019_MCM-ICM_Problems/2018_MCMProblemC_DATA/ACS_10_5YR_DP02/ACS_10_5YR_DP02_with_ann.csv")
ACS_10_5YR_DP02_with_ann <- ACS_10_5YR_DP02_with_ann[-1,]
CS_10_5YR_DP02_metadata <- read_csv("/Users/rexzhang/Downloads/2019_MCM-ICM_Problems/2018_MCMProblemC_DATA/ACS_10_5YR_DP02/ACS_10_5YR_DP02_metadata.csv")


#连接某一年数据
Book=Book[which(Book$YYYY == "2010"), ]

#除去了多余的县，all=F
CombinedData=merge(x=Book,y=ACS_10_5YR_DP02_with_ann,by.x="FIPS_Combined",by.y = "GEO.id2",all=F)

#处理空值
CombinedData[CombinedData=="(X)"]<-0


#lasso
#采用总数而非比率
#HC03_VC93	Percent; EDUCATIONAL ATTAINMENT - Percent high school graduate or higher 仅有比率
columIndices=seq(from=11,to=length(CombinedData),by=4)
x=CombinedData[,columIndices];
x=as.matrix(sapply(x,as.numeric)) 
y=as.numeric(CombinedData[,7]);
#,lambda.min.ratio=0.001 , nlambda=100
fit=glmnet(x, y, family="gaussian", alpha=1)
print(fit)

#par(mar=c(5,4,4,2)+0.1, oma=c(0, 0, 0, 0))
plot(fit, xvar="lambda",label=TRUE,col=cols);
mtext("Coefficients number", side=3,line=3);
###lambda变化趋势
n=1:length(fit$lambda)
qplot(x=n,fit$dev.ratio,ylab =expression(R^2))

#par(mar=c(5,4,2,2)+0.1, oma=c(0, 0, 0, 0))
plot(x=n,y=fit$lambda,ylab ='Log Lambda',cex=0.7,pch=20)

plot(fit$lambda,fit$dev.ratio,xlab ='Log Lambda',ylab =expression(R^2),cex=0.7,pch=20)
###lambda变化趋势

coef=coef(fit, s=c(fit$lambda[length(fit$lambda)*0.2]))
coef;
coef@Dimnames[[1]][coef@i+1]


#交互检验 lasso
cvfit = cv.glmnet(x, y, family = "gaussian", type.measure = "mse",alpha=1,lambda.min.ratio=0.00005)
plot(cvfit)
mtext("Coefficients number", side=3,line=3)

par(mar=c(5,4,2,2)+0.1, oma=c(0, 0, 0, 0))
m=1:length(cvfit$lambda)
plot(x=m,y=log(cvfit$lambda),ylab ='Lambda',cex=0.7,pch=20)

c(cvfit$lambda.min, cvfit$lambda.1se)
coef_cvfit=coef(fit,s=c(cvfit$lambda.min, cvfit$lambda.1se))
abbr=data.frame(coef_cvfit@Dimnames[[1]][coef_cvfit@i+1])
mainfactor=merge(x=abbr,y=CS_10_5YR_DP02_metadata,by.y= "GEO.id",by.x = "coef_cvfit.Dimnames..1...coef_cvfit.i...1.",all=F)

yourfilenamecsv=paste("mainfactor",2010,".csv",sep="")#循环命名
write.csv(mainfactor, file =yourfilenamecsv)
#绘制原始数据
variable=1:length(columIndices);
value=x[1,]
plot(variable,value,type='l',col=cols_x[1])
for (i in 2:dim(CombinedData)[1])
{value=x[i,]
j=i
lines(variable,value,type='l',col=cols_x[j])
} 
#绘制选择的变量位置
abline(v =coef_cvfit@i, col ="black")

