#Sahar Mozaffari
#comparing Lasso, Elastic Net, and Polygenic model for Nerve Tibia

LApvals <- read.table("Lasso/GTEx_pilot_predicted_alpha1_NT_GCOM1_2_3982_Pvals")
LAcorvec <- read.table("Lasso/GTEx_pilot_predicted_alpha1_NT_GCOM1_2_3982_Corvec")
ENcorvec <- read.table("Elastic_Net/GTEx_pilot_predicted_NT_GCOM1_2_3981_Corvec")
ENpvals <- read.table("Elastic_Net/GTEx_pilot_predicted_NT_GCOM1_2_3981_Pvals")
PSpvals<- read.table("Polygenic_score/GTEx_pilot_predicted_cis0.05_trans10e-05_NT_GCOM1_2_4621_Pvals")
PScorvec<- read.table("Polygenic_score/GTEx_pilot_predicted_cis0.05_trans10e-05_NT_GCOM1_2_4621_Corvec")

source("/group/im-lab/nas40t2/smozaffari/scripts/qqplot.R")


pdf("Poygenic_GTEX_NT_cis0.05trans10-6.pdf")
qqunif(PSpvals$x, main = "Polygenic qqplot") #from
m <- dim(PSpvals)[1]
n <- 95
nullcorvec = tanh(rnorm(m)/sqrt(n-3))
qqplot(nullcorvec^2,PScorvec^2); abline(0,1); grid()
dev.off()

pdf("Lasso_GTEX_NT.pdf")
qqunif(LApvals$x, main = "Lasso qqplot") #from 
m <- dim(LApvals)[1]
n <- 95
nullcorvec = tanh(rnorm(m)/sqrt(n-3))
qqplot(nullcorvec^2,LAcorvec^2); abline(0,1); grid()
dev.off()

pdf("ElasticNet_GTEX_NT.pdf")
m <- dim(ENpvals)[1]
n <- 95
nullcorvec = tanh(rnorm(m)/sqrt(n-3))
qqunif(ENpvals$x, main = "Elastic Net qqplot")
qqplot(nullcorvec^2,ENcorvec^2); abline(0,1); grid()
dev.off()

LApval <- LApvals$x
names(LApval) <- rownames(LApvals)
LAcor <- LAcorvec$x
names(LAcor) <- rownames(LAcorvec)
ENpval <- ENpvals$x
names(ENpval) <- rownames(ENpvals)
ENcor <- ENcorvec$x
names(ENcor) <- rownames(ENcorvec)
PSpval <- PSpvals$x
names(PSpval) <- rownames(PSpvals)
PScor <- PScorvec$x
names(PScor) <- rownames(PScorvec)


a <- which(rownames(ENcorvec)%in%rownames(LAcorvec))
ENcorboth <- ENcor[a]
b <- which(rownames(LAcorvec)%in%rownames(ENcorvec))
LAcorboth <- LAcor[b]
c <- which(rownames(PScorvec)%in%rownames(LAcorvec))
PScorbothLA <- PScor[c]
e <- which(rownames(LAcorvec)%in%rownames(PScorvec))
LAcorbothPS <- LAcor[e]
d <- which(rownames(PScorvec)%in%rownames(ENcorvec))
PScorbothEN <- PScor[d]
f <- which(rownames(ENcorvec)%in%rownames(PScorvec))
ENcorbothPS <- ENcor[f]



PSpvalnotLA <- PSpval[-c]
PSpvalnotEN <- PSpval[-d]
PSpvalonly <- PSpval[-c(c,d)]

LApvalonly <- LApval[-b]
ENpvalonly <- ENpval[-a]

pdf("Lasso_EN_GTEX_NT.pdf")
plot(ENcorboth^2, LAcorboth^2, xlab = "ENcor^2", ylab = "LASSOcor^2", main =paste( "Comparing overlapping genes R^2 ", length(b), sep = ""))
abline(0,1)
qqunif(ENpvalonly, main= paste("Elastic Net only genes -", length(ENpvalonly), sep=""))
qqunif(LApvalonly, main = paste("LASSO only genes -", length(LApvalonly), sep = ""))
dev.off()

t.test(LAcor, ENcor)
t.test(LAcor, PScor)
t.test(ENcor, PScor)

pdf("Polygenic_Lasso_EN_GTEX_NT.pdf")
plot(PScorbothEN^2, ENcorbothPS^2, xlab = "PScor^2", ylab = "ENcor^2", main =paste( "Comparing overlapping genes R^2 Polygenic + EN ", length(d), sep = ""))
abline(0,1)
plot(PScorbothLA^2, LAcorbothPS^2, xlab = "PScor^2", ylab = "LAcor^2", main =paste( "Comparing overlapping genes R^2 Polygenic + Lasso ", length(c), sep = ""))
abline(0,1)
qqunif(PSpvalnotLA, main= paste("Polygenic genes not in Lasso -", length(PSpvalnotLA), sep=""))
qqunif(PSpvalnotEN, main = paste("Polygenic genes not in Elastic Net -", length(PSpvalnotEN), sep = ""))
qqunif(PSpvalonly, main= paste("Polygenic genes not in Lasso or Elastic Net-", length(PSpvalonly), sep=""))
dev.off()
