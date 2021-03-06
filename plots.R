#Sahar Mozaffari
#input two files with pvalue and correlation and will compare
#ex: compare cis+ trans vs trans alone:
#Rscript plotstrans.R /group/im-lab/nas40t2/Polygenic_score/GTEx_pilot_predicted_trans10-6_WB_ /group/im-lab/nas40t2/Polygenic_score/GTEx_pilot_predicted_cis0.05_trans10-6_WB_GCOM1_1_4548

args <- commandArgs(TRUE)

pvals1 <- read.table(paste(args[1], "_Pvals", sep = ""))
corvec1 <- read.table(paste(args[1], "_Corvec",sep = ""))
pvals2 <- read.table(paste(args[2], "_Pvals", sep = ""))
corvec2 <- read.table(paste(args[2], "_Corvec",sep = ""))

source("/group/im-lab/nas40t2/smozaffari/scripts/qqplot.R")

pdf(paste(args[3],".pdf", sep = ""))
qqunif(pvals1$x, main = args[3]) #from
m <- dim(pvals1)[1]
n <- 167
nullcorvec = tanh(rnorm(m)/sqrt(n-3))
qqplot(nullcorvec^2,corvec1^2); abline(0,1); grid()
dev.off()

pdf(paste(args[4],".pdf", sep =	""))
qqunif(pvals2$x, main = args[4]) #from 
m <- dim(pvals2)[1]
n <- 167
nullcorvec = tanh(rnorm(m)/sqrt(n-3))
qqplot(nullcorvec^2,corvec2^2); abline(0,1); grid()
dev.off()

LApvals <- pvals1
LAcorvec <- corvec1
ENpvals <- pvals2
ENcorvec <- corvec2

LApval <- LApvals$x
names(LApval) <- rownames(LApvals)
LAcor <- LAcorvec$x
names(LAcor) <- rownames(LAcorvec)
ENpval <- ENpvals$x
names(ENpval) <- rownames(ENpvals)
ENcor <- ENcorvec$x
names(ENcor) <- rownames(ENcorvec)

a <- which(rownames(ENcorvec)%in%rownames(LAcorvec))
ENcorboth <- ENcor[a]
b <- which(rownames(LAcorvec)%in%rownames(ENcorvec))
LAcorboth <- LAcor[b]

LApvalonly <- LApval[-b]
ENpvalonly <- ENpval[-a]

t.test(LAcor, ENcor)

pdf(paste(args[3],":",args[4],".pdf", sep =""));
plot(ENcorboth^2, LAcorboth^2, xlab = args[4], ylab = args[3], main =paste( "Comparing overlapping genes R^2 ", length(b), sep = ""))
abline(0,1)
qqunif(ENpvalonly, main= paste(args[4], " only genes -", length(ENpvalonly), sep=""))
qqunif(LApvalonly, main = paste(args[3], "only genes -", length(LApvalonly), sep = ""))
dev.off()

