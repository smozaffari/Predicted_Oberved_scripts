#Sahar Mozaffari
#makes GTEx genotype files in right format for SNP2GReX.pl

print("Reading files")

bim <- read.table("/group/im-lab/nas40t2/hwheeler/cross-tissue/gtex-genotypes/GTEx_Analysis_2014-06-13.hapmapSnpsCEU.bim")
SNPxID <- read.table("/group/im-lab/nas40t2/hwheeler/cross-tissue/gtex-genotypes/GTEx_Analysis_2014-06-13.hapmapSnpsCEU.SNPxID")
SNPlist <- read.table("/group/im-lab/nas40t2/hwheeler/cross-tissue/gtex-genotypes/GTEx_Analysis_2014-06-13.hapmapSnpsCEU.SNP.list")
ID <- read.table("/group/im-lab/nas40t2/hwheeler/cross-tissue/gtex-genotypes/GTEx_Analysis_2014-06-13.hapmapSnpsCEU.ID.list")

print("Merging files")
colnames(SNPxID) <- ID$V1

tab <- cbind(SNPlist, SNPlist, bim$V4, bim$V5, bim$V6, "NA", SNPxID)

colnames(tab)[1] <- "SNP"
colnames(tab)[2] <- "SNP"
colnames(tab)[3] <- "pos"
colnames(tab)[4] <- "Ref_allele"
colnames(tab)[5] <- "Dos_allele"
colnames(tab)[6] <- "MAF"

spt <- split(tab, bim$V1)
print("Writing Files")
lapply(names(spt), function(x){write.table(spt[[x]], file = paste("GTEx_chr", x,".dos", sep = ""), quote = F, row.names = F, col.names = F)})

write.table(ID, "GTExsamples.txt", col.names = F, row.names = F, quote = F)

print("Gunzipping files")
system("gzip GTEx_chr*")

