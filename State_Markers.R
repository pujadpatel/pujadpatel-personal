#Specific markers of S0, S1, S2, S3

source("load/LoadData.R")

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

#State Markers

SIG_THRESH = 0.05
jt_s0 = S0
jt_s1 = S1.id[S1.id %notin% S0]
jt_s2 = S2.id
jt_s3 = S3.id
jt_s4 = S4.id
jt_s5 = S5.id
jt_sA = SA.id

jt_s0_vs_s1_df <-signature(jt[c(jt_s0,jt_s1)],jt_s0,sig_thresh = SIG_THRESH); jt_s0_vs_s1_gene = rownames(jt_s0_vs_s1_df);
jt_s0_vs_s2_df <-signature(jt[c(jt_s0,jt_s2)],jt_s0,sig_thresh = SIG_THRESH); jt_s0_vs_s2_gene = rownames(jt_s0_vs_s2_df);
jt_s0_vs_s3_df <-signature(jt[c(jt_s0,jt_s3)],jt_s0,sig_thresh = SIG_THRESH); jt_s0_vs_s3_gene = rownames(jt_s0_vs_s3_df);
jt_s0_vs_s4_df <-signature(jt[c(jt_s0,jt_s4)],jt_s0,sig_thresh = SIG_THRESH); jt_s0_vs_s4_gene = rownames(jt_s0_vs_s4_df);
jt_s0_vs_s5_df <-signature(jt[c(jt_s0,jt_s5)],jt_s0,sig_thresh = SIG_THRESH); jt_s0_vs_s5_gene = rownames(jt_s0_vs_s5_df);

jt_s0_genes = Reduce(intersect, list(jt_s0_vs_s1_gene,jt_s0_vs_s2_gene,jt_s0_vs_s3_gene,jt_s0_vs_s4_gene,jt_s0_vs_s5_gene))

jt_s1_vs_s0_df <-signature(jt[c(jt_s1,jt_s0)],jt_s1,sig_thresh = SIG_THRESH); jt_s1_vs_s0_gene = rownames(jt_s1_vs_s0_df);
jt_s1_vs_s2_df <-signature(jt[c(jt_s1,jt_s2)],jt_s1,sig_thresh = SIG_THRESH); jt_s1_vs_s2_gene = rownames(jt_s1_vs_s2_df);
jt_s1_vs_s3_df <-signature(jt[c(jt_s1,jt_s3)],jt_s1,sig_thresh = SIG_THRESH); jt_s1_vs_s3_gene = rownames(jt_s1_vs_s3_df);
jt_s1_vs_s4_df <-signature(jt[c(jt_s1,jt_s4)],jt_s1,sig_thresh = SIG_THRESH); jt_s1_vs_s4_gene = rownames(jt_s1_vs_s4_df);
jt_s1_vs_s5_df <-signature(jt[c(jt_s1,jt_s5)],jt_s1,sig_thresh = SIG_THRESH); jt_s1_vs_s5_gene = rownames(jt_s1_vs_s5_df);

jt_s1_genes = Reduce(intersect, list(jt_s1_vs_s0_gene,jt_s1_vs_s2_gene,jt_s1_vs_s3_gene,jt_s1_vs_s4_gene,jt_s1_vs_s5_gene))

jt_s2_vs_s0_df <-signature(jt[c(jt_s2,jt_s0)],jt_s2,sig_thresh = SIG_THRESH); jt_s2_vs_s0_gene = rownames(jt_s2_vs_s0_df);
jt_s2_vs_s1_df <-signature(jt[c(jt_s2,jt_s1)],jt_s2,sig_thresh = SIG_THRESH); jt_s2_vs_s1_gene = rownames(jt_s2_vs_s1_df);
jt_s2_vs_s3_df <-signature(jt[c(jt_s2,jt_s3)],jt_s2,sig_thresh = SIG_THRESH); jt_s2_vs_s3_gene = rownames(jt_s2_vs_s3_df);
jt_s2_vs_s4_df <-signature(jt[c(jt_s2,jt_s4)],jt_s2,sig_thresh = SIG_THRESH); jt_s2_vs_s4_gene = rownames(jt_s2_vs_s4_df);
jt_s2_vs_s5_df <-signature(jt[c(jt_s2,jt_s5)],jt_s2,sig_thresh = SIG_THRESH); jt_s2_vs_s5_gene = rownames(jt_s2_vs_s5_df);

jt_s2_genes = Reduce(intersect, list(jt_s2_vs_s0_gene,jt_s2_vs_s1_gene,jt_s2_vs_s3_gene,jt_s2_vs_s4_gene,jt_s2_vs_s5_gene))

jt_s3_vs_s0_df <-signature(jt[c(jt_s3,jt_s0)],jt_s3,sig_thresh = SIG_THRESH); jt_s3_vs_s0_gene = rownames(jt_s3_vs_s0_df);
jt_s3_vs_s1_df <-signature(jt[c(jt_s3,jt_s1)],jt_s3,sig_thresh = SIG_THRESH); jt_s3_vs_s1_gene = rownames(jt_s3_vs_s1_df);
jt_s3_vs_s2_df <-signature(jt[c(jt_s3,jt_s2)],jt_s3,sig_thresh = SIG_THRESH); jt_s3_vs_s2_gene = rownames(jt_s3_vs_s2_df);
jt_s3_vs_s4_df <-signature(jt[c(jt_s3,jt_s4)],jt_s3,sig_thresh = SIG_THRESH); jt_s3_vs_s4_gene = rownames(jt_s3_vs_s4_df);
jt_s3_vs_s5_df <-signature(jt[c(jt_s3,jt_s5)],jt_s3,sig_thresh = SIG_THRESH); jt_s3_vs_s5_gene = rownames(jt_s3_vs_s5_df);

jt_s3_genes = Reduce(intersect, list(jt_s3_vs_s0_gene,jt_s3_vs_s1_gene,jt_s3_vs_s2_gene,jt_s3_vs_s4_gene,jt_s3_vs_s5_gene))


#Including SA

par(mfrow=c(1,1))
jt = read.table("data/Jaden_TPM_NSC.txt") #the full Dataset is jt
jt = ScaleTPM(jt)            #the full Dataset is jt
grx = Waterfall.Cluster(jt, nClusters = 6)
jt.cols = grx[,1] #Includes SA
#Color S0: Purple
S0 = c("C11","C16","C25","C28","C13")
grx[S0,1] = "purple"
jt.all = jt 
anno = grx;
anno[anno=="6"] = "A" 
anno = list("V1" = anno[,2])
jt.cols.all = grx[,1] 
jt.PT = Waterfall.Pseudotime(jt, angle=180, col = jt.cols, plot_title = " Adult", nclust = 6, seed = 6, invert_pt = F,scalePCA = F,lines=F,mst=F)
jt.cols = jt.cols[rownames(jt.PT)]
jt = jt[,rownames(jt.PT)]
jt["Pseudotime",] = jt.PT[,1]

SIG_THRESH=0.01
jt_s0_df <-signature(jt,jt_s0,sig_thresh = SIG_THRESH); jt_s0_gene = rownames(jt_s0_df);
jt_s1_df <-signature(jt,jt_s1,sig_thresh = SIG_THRESH); jt_s1_gene = rownames(jt_s1_df);
jt_s2_df <-signature(jt,jt_s2,sig_thresh = SIG_THRESH); jt_s2_gene = rownames(jt_s2_df);
jt_s3_df <-signature(jt,jt_s3,sig_thresh = SIG_THRESH); jt_s3_gene = rownames(jt_s3_df);
jt_s4_df <-signature(jt,jt_s4,sig_thresh = SIG_THRESH); jt_s4_gene = rownames(jt_s4_df);
jt_s5_df <-signature(jt,jt_s5,sig_thresh = SIG_THRESH); jt_s5_gene = rownames(jt_s5_df);

for (geneName in jt_s2_gene)
{
  PTgeneplot(geneName, jt, jt["Pseudotime",],col=jt.cols)
}

