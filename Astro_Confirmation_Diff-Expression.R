#### Differential Expression ####

#Computes expression patterns in the astrogenic direction across pseudotime for Jaden and Ana datasets
#Uses biased (signature genes) and unbiased (all genes) methods

source("src/Waterfall.R")
source("load/LoadData.R")
source("src/HyperGeoTerms.R")
source("load/LoadData-Ana.R")
source("utils/baseB.R")
#source("script/Astro_Confirmation_Ana_Signature.R")

#Signature genes
SIG_THRESH = .01
num_genes = 50;
enrich_thresh = 500;
all_a_notStr = all_a[,c(at_Ctx, at_TAP, at_n)] #all cells in Ana dataset except Str

at_ctx_df <-signature(all_a_notStr,at_Ctx,sig_thresh = SIG_THRESH); at_ctx_gene = rownames(at_ctx_df); 
jt_a_df <-signature(all_j_s1,jt_a,sig_thresh = SIG_THRESH); jt_a_gene = rownames(jt_a_df);
jt_s1_df <-signature(all_j,jt_1,sig_thresh = SIG_THRESH); jt_s1_gene = rownames(jt_s1_df); 
jt_s2_df <-signature(all_j,jt_2,sig_thresh = SIG_THRESH); jt_s2_gene = rownames(jt_s2_df); 
jt_s3_df <-signature(all_j,jt_3,sig_thresh = SIG_THRESH); jt_s3_gene = rownames(jt_s3_df); 

sig_Genes_j=unique(c(jt_a_gene, jt_s1_gene,jt_s2_gene,jt_s3_gene))
sig_Genes_a=at_ctx_gene
j_genes_only = sig_Genes_j[sig_Genes_j %notin% sig_Genes_a]; a_genes_only = sig_Genes_a[sig_Genes_a %notin% sig_Genes_j] 
sig_both = c(sig_Genes_j[sig_Genes_j %notin% c(j_genes_only,a_genes_only)])

#Pseudotime in Astrogenic direction 
jt.PT = Waterfall.Pseudotime( jt, angle=0, col = jt.cols, plot_title = " Adult", nclust = 5, seed = 5, scalePCA = F,lines=T, invert_pt = T)
jta.PT = jt.PT[c(S1.id,S2.id,S3.id),]

pt.rescale = function(X){
  return(100/(max(jta.PT[,1])-min(jta.PT[,1]))*(X-100)+100)}
jta.PT[,1] <- sapply(jta.PT[,1],pt.rescale)
jta.PT = jta.PT[order(jta.PT[,1]),]

jta.cols=jt.cols[rownames(jta.PT)]
plot(jta.PT, col = jta.cols, cex=2, pch=20, main = paste0("Pseudotime Astrogenesis Jaden"),xlab = "Pseudotime" )
jta=jt[,rownames(jta.PT)]
jta["Pseudotime",rownames(jta.PT)] = jta.PT[,1]

#Check for outliers in jta 
jta_outliers = c()
distMap1D_jta = apply(jta.PT,2,distMap1D)[,1]
for (i in length(distMap1D_jta))
{
  if (distMap1D_jta[i] >= (6*sd(distMap1D_jta)+mean(distMap1D_jta)))
  {
    jta_outliers <- append(jta_outliers, rownames(jta.PT)[i])
  }
}

at.PT = Waterfall.Pseudotime( at, col = at.cols, angle = 0,  plot_title = " Ana, original", nclust = 5, seed = 5, scalePCA = T, invert_pt = T)
ata.PT = at.PT[at.PT[,1]>40,]
pt.rescale = function(X){
  return(100/(max(ata.PT[,1])-min(ata.PT[,1]))*(X-100)+100)}
ata.PT[,1] <- sapply(ata.PT[,1],pt.rescale)
ata.cols=at.cols[rownames(ata.PT)]
plot(ata.PT, col = ata.cols, cex=2, pch=20, main = paste0("Pseudotime Astrogenesis Ana"),xlab = "Pseudotime" )
ata=at[,rownames(ata.PT)]
ata["Pseudotime",rownames(ata.PT)] = ata.PT[,1]

#check for outliers in ata
ata_outliers = c()
distMap1D_ata = apply(ata.PT,2,distMap1D)[,1]
for (i in length(distMap1D_ata))
{
  if (distMap1D_ata[i] >= (6*sd(distMap1D_ata)+mean(distMap1D_ata)))
  {
    ata_outliers <- append(ata_outliers ,rownames(ata.PT)[i])
  }
}

#removes outlier and rescales PT
removeIndex = which(rownames(ata.PT) == "ctx12" )
ata.PT = ata.PT[rownames(ata.PT)[-removeIndex],]
pt.rescale = function(X){
  return(100/(max(ata.PT[,1])-min(ata.PT[,1]))*(X-max(ata.PT[,1]))+100)}
ata.PT[,1] <- sapply(ata.PT[,1],pt.rescale)
plot(ata.PT, col = ata.cols, cex=2, pch=20, main = paste0("Pseudotime Astrogenesis Ana"),xlab = "Pseudotime" )

#Spearman Correlation on Signature Genes
j.spearm.siggenesUP = c()
a.spearm.siggenesUP = c()
j.spearm.siggenesDOWN = c()
a.spearm.siggenesDOWN = c()
rho = 0.75
p = 0.01
for (geneName in sig_both)
{
  j.spearm.test = cor.test(seq(0,100,1),PTgeneplot.trend(geneName,jta,jta["Pseudotime",]), method = "spearm")
  a.spearm.test = cor.test(seq(0,100,1),PTgeneplot.trend(geneName,ata,ata["Pseudotime",]), method = "spearm")
  if (j.spearm.test[[3]]<=p & j.spearm.test[[4]]>=rho) #p value and rho (correlation coefficient)
  {
    PTgeneplot(geneName,jta,jta["Pseudotime",],col=jta.cols, main = geneName)
    j.spearm.siggenesUP = append(j.spearm.siggenesUP,geneName)
  }
  if (a.spearm.test[[3]]<=p & a.spearm.test[[4]]>=rho) 
  {
    PTgeneplot(geneName,ata,ata["Pseudotime",],col=ata.cols, main = geneName)
    a.spearm.siggenesUP = append(a.spearm.siggenesUP,geneName)
  } 
  if (j.spearm.test[[3]]<=p & j.spearm.test[[4]]<=-rho) 
  {
    PTgeneplot(geneName,jta,jta["Pseudotime",],col=jta.cols, main = geneName)
    j.spearm.siggenesDOWN = append(j.spearm.siggenesDOWN,geneName)
  }
  if (a.spearm.test[[3]]<=p & a.spearm.test[[4]]<=-rho)
  {
    PTgeneplot(geneName,ata,ata["Pseudotime",],col=ata.cols, main = geneName)
    a.spearm.siggenesDOWN = append(a.spearm.siggenesDOWN,geneName)
  } 
}

a_j_siggenesUP = intersect(a.spearm.allgenesUP,j.spearm.allgenesUP)
a_j_siggenesDOWN = intersect(a.spearm.allgenesDOWN,j.spearm.allgenesDOWN)

#Spearman Correlation on All Genes- Matrix
jg = rownames(jt.all)
ag = rownames(at)
all_both = intersect(jg,ag)
j.spearman <- matrix(nrow = length(all_both), ncol = 2)
rownames(j.spearman) = all_both
colnames(j.spearman) = c("Rho", "P-value")
a.spearman <- matrix(nrow = length(all_both), ncol = 2)
rownames(a.spearman) = all_both
colnames(a.spearman) = c("Rho", "P-value")

for (geneName in all_both)
{
  j.spearm.test = cor.test(seq(0,100,1),PTgeneplot.trend(geneName,jta,jta["Pseudotime",]), method = "spearm")
  j.spearman[geneName,1] = j.spearm.test[[4]]
  j.spearman[geneName,2] = j.spearm.test[[3]]
  a.spearm.test = cor.test(seq(0,100,1),PTgeneplot.trend(geneName,ata,ata["Pseudotime",]), method = "spearm")
  a.spearman[geneName,1] = a.spearm.test[[4]]
  a.spearman[geneName,2] = a.spearm.test[[3]]
}

j.spearman = j.spearman[order(j.spearman[,2]),]
a.spearman = a.spearman[order(a.spearman[,2]),]

#All genes, specific rho/p values
j.spearm.allgenesUP = c()
a.spearm.allgenesUP = c()
j.spearm.allgenesDOWN = c()
a.spearm.allgenesDOWN = c()
rho = 0.75
p = 0.001
for (geneName in all_both)
{
  #if max tpm at least 50
  if (max(jta[geneName,])>=50 & max(ata[geneName,])>=50 & (mean(as.numeric(jta[geneName,S1.id])))>=100 & (mean(as.numeric(ata[geneName, All_A.id])))>=100){
    #j.spearm.test = cor.test(seq(0,100,1),PTgeneplot.trend(geneName,jta,jta["Pseudotime",]), method = "spearm")
    #a.spearm.test = cor.test(seq(0,100,1),PTgeneplot.trend(geneName,ata,ata["Pseudotime",]), method = "spearm")
    if (is.na(a.spearman[geneName,2]) | is.na(j.spearman[geneName,2])) {
      next();
      }
    if (j.spearman[geneName,2]<=p & j.spearman[geneName,1]>=rho) 
    {
      #PTgeneplot(geneName,jta,jta["Pseudotime",],col=jta.cols, main = geneName)
      j.spearm.allgenesUP = append(j.spearm.allgenesUP,geneName)
    }
    if (a.spearman[geneName,2]<=p & a.spearman[geneName,1]>=rho) 
    {
      #PTgeneplot(geneName,ata,ata["Pseudotime",],col=ata.cols, main = geneName)
      a.spearm.allgenesUP = append(a.spearm.allgenesUP,geneName)
    } 
    if (j.spearman[geneName,2]<=p & j.spearman[geneName,1]<=-rho) 
    {
      #PTgeneplot(geneName,jta,jta["Pseudotime",],col=jta.cols, main = geneName)
      j.spearm.allgenesDOWN = append(j.spearm.allgenesDOWN,geneName)
    }
    if (a.spearman[geneName,2]<=p & a.spearman[geneName,1]<=-rho) 
    {
      #PTgeneplot(geneName,ata,ata["Pseudotime",],col=ata.cols, main = geneName)
      a.spearm.allgenesDOWN = append(a.spearm.allgenesDOWN,geneName)
    } 
  }
}

path_to_file = paste0("~/Desktop/astrogenesis-up.pdf")
pdf(file=path_to_file, width=10, height=10)
par(mfrow=c(6,2), mar=c(1.2,1.2,1.2,1.2) + .5)

a_j_allgenesUP = intersect(a.spearm.allgenesUP, j.spearm.allgenesUP)
a_j_allgenesDOWN = intersect(a.spearm.allgenesDOWN, j.spearm.allgenesDOWN)

for (geneName in a_j_allgenesUP)
{
  PTgeneplot(geneName,jta,jta["Pseudotime",],col=jta.cols, main = geneName)
  PTgeneplot(geneName,ata,ata["Pseudotime",],col=ata.cols, main = geneName)
}

dev.off()

#Barres top 100 fold change genes for astrocytes
bt_a_gene = as.character(read.table("data/Barres_Enriched.txt",header=TRUE)[1:100,1])

bt_a_j_genes = intersect(bt_a_gene,a_j_allgenesUP)

if(FALSE){
  jt_a_gene2 = names(enrichment(all_j[jt_a],enrich_thresh,num_genes)); 
  
  #calculating p values <= 0.01
  all = all_j_s1
  group1 = jt_a
  r_group1 = colnames(all)[colnames(all) %notin% group1]
  groupA.idx = which(colnames(all) %in% group1)
  groupB.idx = which(colnames(all) %in% r_group1)

  pval <-apply(all,1,test.wilcox)
  
  #Enriched Genes
  for (GeneName in jt_a_gene2)
  {
    if (pval[GeneName]<= 0.01)
    {
      PTgeneplot(GeneName,PT=t(jt["Pseudotime",]),TPM_data=jt,col=jt.cols, main= GeneName)
      #pseudotime.foo(GeneName, as.numeric(jt),as.numeric((jt["Pseudotime",])))
      print (GeneName)
    }
  }
}
