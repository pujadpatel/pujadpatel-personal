#comparing S0 in Jaden's data & Astrocytes from Barres paper

#TODO: Replace global variables from sourced scripts with unitary rdat file to be loaded 
source("utils/baseB.R")
source("src/HyperGeoTerms.R")
source("src/VennPlot.R")
source("load/LoadData_Barres.R")
source("load/LoadData.R")
source("load/LoadData-Ana.R")
source("load/LoadData_Zhang.R")
library(lmtest)
library(zoo)
library(mixtools)
library(diptest)
library(WeightedCluster)
library(gplots)
library(RColorBrewer)
library(VennDiagram)
library(venneuler)

#both variables contain genes that are in both Shin et al. (2015) & cmp datasets
bothA = intersect(rownames(jt),rownames(at))
rmi = which(bothA=="Pseudotime")
bothA = bothA[-rmi]

bothB = intersect(rownames(jt),rownames(bt))
bothZ = intersect(rownames(jt),rownames(zm))

#alpha value for wilcox tests (no error correction)
SIG_THRESH = .05

#quantile split of Shin et al. (2015) at median value into two groups 
pt = jt.PT[c(S1.id,S2.id,S3.id),1]
q = quantile(pt)

groupA = names(pt[pt<q[3]]) #S1.id
groupB = names(pt[pt>=q[3]]) #S2.id

### Up Signatures in Astrocytes ###
#generate UP signatures for groups A & B 
groupA_df  = signature(jt[1:(nrow(jt)-1),c(S1.id,S2.id,S3.id)],groupA,sig_thresh = SIG_THRESH,mean_thresh = 25); groupA_gene = rownames(groupA_df);
groupB_df  = signature(jt[1:(nrow(jt)-1),c(S1.id,S2.id,S3.id)],groupB,sig_thresh = SIG_THRESH,mean_thresh = 25); groupB_gene = rownames(groupB_df);

#generate UP signature for Barres (2014)
barres_astro_fc = names(foldChange(bt[bothB,],2:7,1,fc_thresh = 2)[1:500])

#generate UP signature for Ana (2015) 
at_allA_n_df = signature(at[bothA,c(at_allA,at_n)],at_allA,sig_thresh = SIG_THRESH); at_allA_n_gene = rownames(at_allA_n_df); 
at_allA_tap_df = signature(at[bothA,c(at_allA,at_TAP)],at_allA,sig_thresh = SIG_THRESH); at_allA_tap_gene = rownames(at_allA_tap_df); 
at_allA_genes = intersect(at_allA_n_gene,at_allA_tap_gene)

#generate UP signature for Zhang (2016)
zm_astro_facs_fc = names(foldChange(zm[bothZ,],7:21,1:2,fc_thresh = 2)[1:500])
zm_astro_hepacam_fc = names(foldChange(zm[bothZ,],7:21,3:6,fc_thresh = 2)[1:500])

gA_Bar = intersect(groupA_gene, barres_astro_fc)
gB_Bar = intersect(groupB_gene, barres_astro_fc)

gA_Ana = intersect(groupA_gene,at_allA_genes)
gB_Ana = intersect(groupB_gene,at_allA_genes)

#Fisher's Exact Test
bothABZ = Reduce(intersect, list(bothA, bothB, bothZ))
group1 = list(list(Barres=barres_astro_fc), list(Ana = at_allA_genes), list(Zhang_facs = zm_astro_facs_fc), list(Zhang_hepacam = zm_astro_hepacam_fc))
group2 = list(list(groupA=groupA_gene), list(groupB=groupB_gene))
up_reg_fisher= fisher_test(group1,group2, genes = bothABZ, heatmap = TRUE)

#Venn diagram of Ana's Astrocytes
vals1 = c(A=length(at_allA_genes),B=length(groupA_gene),C=length(groupB_gene),
  "A&B"=length(intersect(at_allA_genes,groupA_gene)),
  "A&C"=length(intersect(at_allA_genes,groupB_gene)))
names1 = c("Llorens-Bobadilla et al. (Astro)","A","B")
VennPlot(vals1,pvals=c(up_reg_fisher["Ana","groupA"],up_reg_fisher["Ana","groupB"]),names = names1,cex = 2)

#Venn diagram of Barres' Astrocytes
vals2 = c(A=length(barres_astro_fc),B=length(groupA_gene),C=length(groupB_gene),
         "A&B"=length(intersect(barres_astro_fc,groupA_gene)),
         "A&C"=length(intersect(barres_astro_fc,groupB_gene)))
names2 = c("Zhang et al. (Astro)","A","B")
VennPlot(vals2,pvals=c(up_reg_fisher["Barres","groupA"],up_reg_fisher["Barres","groupB"]),names = names2, cex = 2)

pdf(file = "~/Desktop/S1gtS2_astro.pdf")
par(mfrow = c(3,2),mar =c(1.7,1.7,1.7,1.7))
#for (gene in unique(c(gA_Ana,gA_Bar))){
for (gene in (groupA_gene)){
  PTgeneplot(gene,jt,hmm=TRUE,col=jt.cols)
  #PTgeneplot(gene,at,hmm=TRUE,col=at.cols)
  
}
dev.off()

#Comparison of Mean Up Regulated Gene Expression
gene_list_up = c(groupA_gene,groupB_gene) #, at_allA_gene, bares_astro_fc,zm_astro_facs_fc,zm_astro_hepacam_fc)
gene_list_up = unique(gene_list_up)
avg_exp_genes = matrix(data = NA, nrow =length(gene_list_up),ncol=2,dimnames = list(gene_list_up, c("groupA","groupB")))

for (gene in gene_list_up){
  avg_exp_genes[gene,1] = rowMeans(jt[groupA][gene,])
  avg_exp_genes[gene,2] = rowMeans(jt[groupB][gene,])
}
avg_exp_genes = avg_exp_genes[complete.cases(avg_exp_genes),]
avg_exp_genes = log2(avg_exp_genes)
avg_exp_genes[avg_exp_genes==-Inf] = range(avg_exp_genes, finite=TRUE)[1]
avg_exp_genes[avg_exp_genes==Inf] = range(avg_exp_genes, finite=TRUE)[2]

pheatmap(avg_exp_genes,cluster_row=T,cluster_col=F,legend=T,show_rownames=F,show_colnames=T,cellwidth=70,cellheight=1,main = "Mean Up Regulated Gene Expression")

#Comparison of Mean Down Regulated Gene Expression
groupA_down_df  = signature(jt[1:(nrow(jt)-1),c(S1.id,S2.id,S3.id)],groupB,sig_thresh = SIG_THRESH); groupA_down_gene = rownames(groupA_down_df);
groupB_down_df  = signature(jt[1:(nrow(jt)-1),c(S1.id,S2.id,S3.id)],groupA,sig_thresh = SIG_THRESH); groupB_down_gene = rownames(groupB_down_df);

barres_astro_fc_down = names(foldChange(bt[bothB,],2:7,1,fc_thresh = 0,decreasing=F)[1:500])

at_n_allA_df = signature(at[bothA,c(at_allA,at_n)],at_n,sig_thresh = SIG_THRESH); at_n_allA_gene = rownames(at_n_allA_df); 
at_tap_allA_df = signature(at[bothA,c(at_allA,at_TAP)],at_TAP,sig_thresh = SIG_THRESH); at_tap_allA_gene = rownames(at_tap_allA_df); 
at_allA_genes_down = intersect(at_n_allA_gene,at_tap_allA_gene)

zm_astro_facs_fc_down = names(foldChange(zm[bothZ,],7:21,1:2,fc_thresh = 0,decreasing=F)[1:500])
zm_astro_hepacam_fc_down = names(foldChange(zm[bothZ,],7:21,3:6,fc_thresh = 0,decreasing=F)[1:500])

group1 = list(list(Barres=barres_astro_fc_down), list(Ana = at_allA_genes_down), list(Zhang_facs = zm_astro_facs_fc_down), list(Zhang_hepacam = zm_astro_hepacam_fc_down))
group2 = list(list(groupA_down=groupA_down_gene), list(groupB_down=groupB_down_gene))
down_reg_fisher= fisher_test(group1,group2, genes=bothABZ, heatmap = TRUE)

########## GO TERMS #############
go_terms_groupA = getIntersectingGenesFromGo(groupA_gene); terms_groupA = keys(go_terms_groupA)
go_terms_groupB = getIntersectingGenesFromGo(groupB_gene); terms_groupB = keys(go_terms_groupB)
go_terms_Barres = getIntersectingGenesFromGo(bares_astro_fc); terms_Barres = keys(go_terms_Barres)
go_terms_Ana = getIntersectingGenesFromGo(at_allA_genes); terms_Ana = keys(go_terms_Ana)
go_terms_Zhang_facs = getIntersectingGenesFromGo(zm_astro_facs_fc); terms_Zhang_facs = keys(go_terms_Zhang_facs)
go_terms_Zhang_hepacam = getIntersectingGenesFromGo(zm_astro_hepacam_fc); terms_Zhang_hepacam = keys(go_terms_Zhang_hepacam)

#Fisher's Exact Test
group1 = list(list(Barres= terms_Barres), list(Ana = terms_Ana), list(Zhang_facs = terms_Zhang_facs), list(Zhang_hepacam = terms_Zhang_hepacam))
group2 = list(list(groupA = terms_groupA), list(groupB = terms_groupB))
go_terms_fisher= fisher_test(group1,group2, genes=trms, heatmap = TRUE, alpha = .000001)

gA_Bar_GO = intersect(terms_groupA, terms_Barres)
gB_Bar_GO = intersect(terms_groupB, terms_Barres)

gA_Ana_GO = intersect(terms_groupA, terms_Ana)
gB_Ana_GO = intersect(terms_groupB, terms_Ana)

intersectionGoBar = matrix(c(length(gA_Bar_GO),length(gB_Bar_GO)),ncol=2)
colnames(intersectionGoBar)=c("Group A", "Group B")
intersectionGoAna = as.table(intersectionGoBar)
bp = barplot(intersectionGoBar, main="GO terms common with Zhang et al.",ylab="",horiz = TRUE,cex.names = 1,cex.main = 1)
label = c(paste0("p = ",pvalFormat(go_terms_fisher["Barres","groupA"])),paste0("p = ",pvalFormat(go_terms_fisher["Barres","groupB"])))
intersectionGoBar[2] = intersectionGoBar[1]
text(x = c(intersectionGoBar)/2, y = bp, label = label, cex = 2, col = "red")

intersectionGoAna = matrix(c(length(gA_Ana_GO),length(gB_Ana_GO)),ncol=2)
colnames(intersectionGoAna)=c("Group A", "Group B")
intersectionGoAna = as.table(intersectionGoAna)
bp = barplot(intersectionGoAna, main="GO terms common with Llorens-Bobadilla et al.",ylab="",horiz = TRUE,cex.names = 1,cex.main=1)
label = c(paste0("p = ",pvalFormat(go_terms_fisher["Ana","groupA"])),paste0("p = ",pvalFormat(go_terms_fisher["Ana","groupB"])))
intersectionGoAna[2] = intersectionGoAna[1]
text(x = c(intersectionGoAna)/2, y = bp, label = label, cex = 2, col = "red")

#Venn Diagram of jointly occuring GO term in groupA-Barres and groupA-Ana 
grid.newpage()
draw.pairwise.venn(length(gA_Bar_GO), length(gA_Ana_GO), length(intersect(gA_Ana_GO,gA_Bar_GO)), 
                   category = c("groupA & Barres","groupA & Ana"), lty = rep("blank",2), 
                   fill = c("light blue", "pink"), alpha = rep(.5,2), cat.pos = rep(0,2), cat.dist = rep(0.025, 2))

#Comparison with TAPs (Ana)
at_tap_n_df = signature(at[bothA,c(at_TAP,at_n)],at_TAP,sig_thresh = SIG_THRESH); at_tap_n_gene = rownames(at_tap_n_df); 
at_tap_allA_df = signature(at[bothA,c(at_TAP,at_allA)],at_TAP,sig_thresh = SIG_THRESH); at_tap_allA_gene = rownames(at_tap_allA_df); 
at_tap_gene = intersect(at_tap_n_gene,at_tap_allA_gene)

gA_Ana_tap = intersect(groupA_gene,at_tap_gene)
gB_Ana_tap = intersect(groupB_gene,at_tap_gene)

group1 = list(list(at_tap = at_tap_gene))
group2 = list(list(groupA=groupA_gene), list(groupB=groupB_gene))
tap_fisher= fisher_test(group1,group2,genes=bothA, heatmap = TRUE)

#Venn diagram of Ana's TAPs
vals1 = c(A=length(at_tap_gene),B=length(groupA_gene),C=length(groupB_gene),
          "A&B"=length(gA_Ana_tap),
          "A&C"=length(gB_Ana_tap))
names1 = c("Llorens-Bobadilla et al. (TAP)","A","B")
VennPlot(vals1,pvals=c(tap_fisher["at_tap","groupA"],tap_fisher["at_tap","groupB"]),names = names1,cex = 2)

#Comparison with Neural Stem Cells (Ana)
at_n_tap_df <-signature(at[bothA,c(at_n,at_TAP)],at_n,sig_thresh = SIG_THRESH); at_n_tap_gene = rownames(at_n_tap_df); 
at_n_allA_df <-signature(at[bothA,c(at_n,at_allA)],at_n,sig_thresh = SIG_THRESH); at_n_allA_gene = rownames(at_n_allA_df); 
at_n_gene = intersect(at_n_tap_gene,at_n_allA_gene)

gA_Ana_n = intersect(groupA_gene,at_n_gene)
gB_Ana_n = intersect(groupB_gene,at_n_gene)

group1 = list(list(at_n = at_n_gene))
group2 = list(list(groupA=groupA_gene), list(groupB=groupB_gene))
n_fisher= fisher_test(group1,group2,genes=bothA)

#Venn diagram of Ana's TAPs
vals1 = c(A=length(at_n_gene),B=length(groupA_gene),C=length(groupB_gene),
          "A&B"=length(gA_Ana_n),
          "A&C"=length(gB_Ana_n))
names1 = c("Llorens-Bobadilla et al. (NSC)","A","B")
VennPlot(vals1,pvals=c(n_fisher["at_n","groupA"],n_fisher["at_n","groupB"]),names = names1,cex = 2)

#Venn diagram of Barres OPC
barres_opc_fc = names(foldChange(bt[bothB,],c(1:2,4:7),3,fc_thresh = 2)[1:500])

gA_Bar_opc = intersect(groupA_gene,barres_opc_fc)
gB_Bar_opc = intersect(groupB_gene,barres_opc_fc)

group1 = list(list(barres_opc = barres_opc_fc))
group2 = list(list(groupA=groupA_gene), list(groupB=groupB_gene))
opc_fisher= fisher_test(group1,group2,genes=bothB)

#Venn diagram of Ana's TAPs
vals1 = c(A=length(barres_opc_fc),B=length(groupA_gene),C=length(groupB_gene),
          "A&B"=length(gA_Bar_opc),
          "A&C"=length(gB_Bar_opc))
names1 = c("Llorens-Bobadilla et al. (OPC)","A","B")
VennPlot(vals1,pvals=c(opc_fisher["barres_opc","groupA"],opc_fisher["barres_opc","groupB"]),names = names1,cex = 2)

#makes binary tables of significant association between unbiased states and different cell types/states in BARRES' ata
if (FALSE){
  
  par(mfrow = c(1,1))
  #Barres data: Astrocytes
  
  S0 = c("C11","C16","C25","C28","C13")
  
  bt_a = colnames(bt)[1] #astrocyte data in Barres data
  all_b = bt[bothB,] #all cells in Barres data
  
  jt_a = c(S0) #subset of astrocytic cells in young (jaden) dataset
  jt_1 = S1.id[S1.id %notin% jt_a]
  jt_2 = S2.id
  jt_3 = S3.id
  jt_4 = S4.id
  jt_5 = S5.id
  jt_A = SA.id
  
  all_j = jt.all[bothB,] #all cells in Jaden dataset
  
  ##### GOAL 2: Get Genes For Each Group ######
  #significant genes 
  bt_a_gene = as.character(read.table("data/Barres_Enriched.txt",header=TRUE)[1:300,1])#bt_a_gene = genes associated with astrocytes in ana dataset
  bt_n_gene = as.character(read.table("data/Barres_Enriched.txt",header=TRUE)[1:300,2])#bt_a_gene = genes associated with astrocytes in ana dataset
  bt_op_gene = as.character(read.table("data/Barres_Enriched.txt",header=TRUE)[1:300,3])#bt_a_gene = genes associated with astrocytes in ana dataset
  bt_no_gene = as.character(read.table("data/Barres_Enriched.txt",header=TRUE)[1:300,4])#bt_a_gene = genes associated with astrocytes in ana dataset
  bt_mo_gene = as.character(read.table("data/Barres_Enriched.txt",header=TRUE)[1:300,5])#bt_a_gene = genes associated with astrocytes in ana dataset
  bt_mg_gene = as.character(read.table("data/Barres_Enriched.txt",header=TRUE)[1:300,6])#bt_a_gene = genes associated with astrocytes in ana dataset
  bt_e_gene = as.character(read.table("data/Barres_Enriched.txt",header=TRUE)[1:300,7])#bt_a_gene = genes associated with astrocytes in ana dataset
  
  jt_a_df <-signature(all_j,jt_a,sig_thresh = SIG_THRESH); jt_a_gene = rownames(jt_a_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_s1_df <-signature(all_j,jt_1,sig_thresh = SIG_THRESH); jt_s1_gene = rownames(jt_s1_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_s2_df <-signature(all_j,jt_2,sig_thresh = SIG_THRESH); jt_s2_gene = rownames(jt_s2_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_s3_df <-signature(all_j,jt_3,sig_thresh = SIG_THRESH); jt_s3_gene = rownames(jt_s3_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_s4_df <-signature(all_j,jt_4,sig_thresh = SIG_THRESH); jt_s4_gene = rownames(jt_s4_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_s5_df <-signature(all_j,jt_5,sig_thresh = SIG_THRESH); jt_s5_gene = rownames(jt_s5_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_sA_df <-signature(all_j,jt_A,sig_thresh = SIG_THRESH); jt_sA_gene = rownames(jt_sA_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  
  group1 = list(list(barres_a = bt_a_gene),list(barres_n = bt_n_gene),list(barres_op = bt_op_gene),list(barres_no = bt_no_gene),list(barres_mo=bt_mo_gene),list(barres_mg=bt_mg_gene),list(barres_e=bt_e_gene))
  group2 = list(list(s0=jt_a_gene), list(s1=jt_s1_gene),list(s2=jt_s2_gene),list(s3=jt_s3_gene),list(s4=jt_s4_gene),list(s5=jt_s5_gene),list(sA=jt_sA_gene))
  barres_fisher= fisher_test(group1,group2, genes=bothB, heatmap = TRUE)
}

#makes binary tables of significant association between unbiased states and different cell types/states in ANA'S data

if(FALSE){
  
  SIG_THRESH = .01
  
  par(mfrow = c(1,1))
  
  S0 = c("C11","C16","C25","C28","C13")
  
  ##### GOAL 1: Create Groups ######
  bothA = intersect(rownames(jt),rownames(at))
  
  all_a = at[bothA,] #all cells in Ana dataset
  at_Str = colnames(at)[grep("str",colnames(at))]
  at_Ctx = colnames(at)[grep("ctx",colnames(at))]
  at_TAP = colnames(at)[grep("tap",colnames(at))]
  at_allA = c(at_Str,at_Ctx)
  at_n = colnames(at)[grep("N",colnames(at))]
  
  jt_a = c(S0) #subset of astrocytic cells in young (jaden) dataset
  jt_1 = S1.id[S1.id %notin% jt_a]
  jt_2 = S2.id
  jt_3 = S3.id
  jt_4 = S4.id
  jt_5 = S5.id
  jt_A = SA.id
  
  all_j = jt[bothA,]
  all_j_s1 = all_j[,c(jt_a,jt_2,jt_3,jt_4,jt_5)] #all cells in Jaden dataset except s1
  
  ##### GOAL 2: Get Genes For Each Group ######
  #significant genes 
  at_allA_df <-signature(all_a,at_allA,sig_thresh = SIG_THRESH); at_allA_gene = rownames(at_allA_df); 
  at_tap_df <-signature(all_a,at_TAP,sig_thresh = SIG_THRESH); at_tap_gene = rownames(at_tap_df);
  at_n_df <-signature(all_a,at_n,sig_thresh = SIG_THRESH); at_n_gene = rownames(at_n_df);
  
  jt_a_df <-signature(all_j,jt_a,sig_thresh = SIG_THRESH); jt_a_gene = rownames(jt_a_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_s1_df <-signature(all_j,jt_1,sig_thresh = SIG_THRESH); jt_s1_gene = rownames(jt_s1_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_s2_df <-signature(all_j,jt_2,sig_thresh = SIG_THRESH); jt_s2_gene = rownames(jt_s2_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_s3_df <-signature(all_j,jt_3,sig_thresh = SIG_THRESH); jt_s3_gene = rownames(jt_s3_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_s4_df <-signature(all_j,jt_4,sig_thresh = SIG_THRESH); jt_s4_gene = rownames(jt_s4_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset
  jt_s5_df <-signature(all_j,jt_5,sig_thresh = SIG_THRESH); jt_s5_gene = rownames(jt_s5_df); #jt_a_gene = genes associated with astrocytes cells in jaden dataset

  group1 = list(list(at_allA = at_allA_gene),list(at_tap = at_tap_gene),list(at_n = at_n_gene))
  group2 = list(list(s0=jt_a_gene), list(s1=jt_s1_gene),list(s2=jt_s2_gene),list(s3=jt_s3_gene),list(s4=jt_s4_gene),list(s5=jt_s5_gene),list(sA=jt_sA_gene))
  ana_fisher= fisher_test(group1,group2,genes=bothA,heatmap = TRUE)
}

#builds heat map of differentially expressed genes
if(FALSE){
  #Put gene lists together
  jt_a_gene_only = jt_a_gene[jt_a_gene %notin% bt_a_gene] # genes ONLY in jaden atrocytes (not ana cells)
  bt_a_gene_only = bt_a_gene[bt_a_gene %notin% jt_a_gene] #genes ONLY in ana astrocytes (not jaden cells)
  jointlist = jt_a_gene[jt_a_gene %notin% c(jt_a_gene_only,bt_a_gene_only)] #genes that associated with both jaden and ana astrocytes
  
  all_b = all_b[c(jointlist,jt_a_gene_only,bt_a_gene_only),] #only include TPM data for cells that are in either jaden/ana genesets 
  all_j = all_j[c(jointlist,jt_a_gene_only,bt_a_gene_only),] # ^^^
  
  ##### GOAL 3: Compute Statistial Sigfinicance of Expression Difference Between Groups ######
  a_sig = signature_2datasets(all_b,all_j,sig_thresh = .01); a_sig = rownames(a_sig) #compute statistical significance of differential gene expression in two datasets
  
  ##### GOAL 4: Plot Stuff #####
  #get exp of sig genes
  jt_a_exp = all_j[,c(jt_a)];jt_a_exp = apply(jt_a_exp,1,mean)
  bt_a_exp = all_b[,c(bt_a)];bt_a_exp = apply(bt_a_exp,1,mean)
  
  #get exp standard error of sig genes
  jt_a_exp_se = all_j[,c(jt_a)];jt_a_exp_se = apply(jt_a_exp_se,1,se)
  bt_a_exp_se = all_b[,c(bt_a)];bt_a_exp_se = apply(bt_a_exp_se,1, se)
  
  #draw heatmap of significant genes, log10 transformed
  jt_a_exp_log = log10(jt_a_exp); jt_a_exp_log[jt_a_exp_log==-Inf] = 0
  bt_a_exp_log = log10(bt_a_exp); bt_a_exp_log[bt_a_exp_log==-Inf] = 0
  
  #old over young expression log10 transformed expression levels
  a_over_s0 = log10(bt_a_exp/jt_a_exp)
  a_over_s0 = a_over_s0;a_over_s0 = a_over_s0[a_over_s0!=Inf];a_over_s0 = a_over_s0[a_over_s0!=-Inf]
  s0_over_a = -1*a_over_s0
  
  pheatmap(rbind(jt_a_exp_log,bt_a_exp_log),cluster_row=F,cluster_col=T,legend=T,show_rownames=T,show_colnames=F,cellwidth=1,cellheight=60,main = "Sig Conditional")
  pheatmap(t(sort(c(a_over_s0))),cluster_row=F,cluster_col=F,legend=T,show_rownames=T,show_colnames=F,cellwidth=1,cellheight=120,main = paste0("Str,Ctx/S0 Conditional (gene N=",length(a_over_s0),")"))
  pheatmap(t(sort(a_over_s0[a_sig])),cluster_row=F,cluster_col=F,legend=T,show_rownames=T,show_colnames=T,cellwidth=3,cellheight=120,main = paste0("Str,Ctx/S0 Conditional (Alpha = .01, gene N=",length(a_sig),")"))
  
  s0high = s0_over_a[s0_over_a>=1.5]
  ahigh = a_over_s0[a_over_s0>=2]
  
  j_up = realEffects(names(s0high),jt[,S0.id])
  a_up = realEffects(names(ahigh),at[,colnames(ata)])
  
  pheatmap(t(sort(a_over_s0[a_up])),cluster_row=F,cluster_col=F,legend=T,show_rownames=T,show_colnames=T,cellwidth=15,color = brewer.pal(9,"YlOrRd"),cellheight=120,main = "Ana-Astro/Jaden-S0 Factor Score")
  
  #creating pseudotime/hmm plots for genes
  for (GeneName in a_up)
  {
    #PTgeneplot(GeneName,PT=as.numeric(jt["Pseudotime",]),TPM_data=as.numeric(jt),col=jt.cols, main= GeneName)
    pseudotime.foo(GeneName, as.numeric(jt),as.numeric((jt["Pseudotime",])))
  }
  
}











# S3/SA comparison

pdf(file = "~/Desktop/SA_sig.pdf")
par(mfrow = c(3,2),mar =c(1.7,1.7,1.7,1.7))
for (gene in (jt_sA_gene)){
  multiplePTgeneplot(gene, jt, sub1 = c(jt_a,jt_1,jt_2,jt_3,jt_4,jt_5), sub2 = SA.id, col = jt.cols)
}
dev.off()

pdf(file = "~/Desktop/S3_sig.pdf")
par(mfrow = c(3,2),mar =c(1.7,1.7,1.7,1.7))
for (gene in (jt_s3_gene)){
  multiplePTgeneplot(gene, jt, sub1 = c(jt_a,jt_1,jt_2,jt_3,jt_4,jt_5), sub2 = SA.id, col = jt.cols)
}
dev.off()

#Volcano Plots
SIG_THRESH = 1
MEAN_THRESH = 0
COVAR_THRESH = Inf

jt_s3_df <-signature_all(jt[,c(jt_1,jt_5)],jt_1); jt_s3_gene = rownames(jt_s3_df); 
jt_sA_df <-signature_all(jt[,c(jt_3,jt_A)],jt_A); jt_sA_gene = rownames(jt_sA_df);

xpt = as.numeric(jt_s3_df[,3]) #log2FC
ypt = as.numeric(-log10(jt_s3_df[,2])) #-log10 pvals
plot(xpt, ypt , pch=20)

#Divergent PT Trajectories for S3

dset = jt.all[,SA.id]
TPM_data = dset
loglik_thresh = -200
exp_thresh = 50

remove_genes = c()
for (i in 1:dim(TPM_data)[1]){
  if (max(as.numeric(TPM_data[rownames(TPM_data)[i],]))<=exp_thresh){
    remove_genes = append(remove_genes,rownames(TPM_data)[i])
  }
}
TPM_data = TPM_data[-which(rownames(TPM_data) %in% remove_genes),]
bimodal_genes = c()
cluster_data = matrix(0,nrow=nrow(TPM_data),ncol=ncol(TPM_data))
colnames(cluster_data) = colnames(TPM_data); rownames(cluster_data) = rownames(TPM_data)

for (i in 1:nrow(TPM_data)){
  clust = c()
  try({
    gene_exp = as.numeric(TPM_data[i,])
    mixmdl = Mclust(gene_exp, G = 1:2, modelNames = c("E","V"))
    clust = mixmdl$classification
    clust = clust-1
    cluster_data[i,]=clust
  })
}

#Weighted clustering
w_cluster = Waterfall.Cluster(cluster_data, nClusters=2, simplecolors = F,colorchoices = NULL)
wdset.cols = w_cluster[,2]
weighted_dset[is.na(weighted_dset)] = 0

#Plotting clusters
for (i in 1:length(wdset.cols)){
  if (wdset.cols[i] == 1){
    wdset.cols[i] = "#4882C3"
  }
  if (wdset.cols[[i]] == 2){
    wdset.cols[i] = "#F26A6A"
  }
}
other_cols = jt.cols[names(jt.cols) %notin% names(wdset.cols)]
for (i in 1:length(other_cols)){
  other_cols[i] = "#D3D3D3"
  wdset.cols = append(wdset.cols, other_cols[i])
}

source("load/LoadData.R")
jt.PT = Waterfall.Pseudotime(jt.all, angle=180, col = wdset.cols, plot_title = " Divergent Trajectories", nclust = 5, seed = 5, invert_pt = T,scalePCA = F,lines=F,mst=F)




















#Weights

#Normalize loglikelihood
for (i in 1:dim(sM)[1]){
  try({
    if (sM[i,1]>-60){
      sM[i,1]=-60
    }
  })
}
for (i in 1:dim(sM)[1]){
  normalized = (sM[i,1]-as.numeric(min(sM[,1],na.rm = TRUE)))/(as.numeric(max(sM[,1],na.rm = TRUE))-as.numeric(min(sM[,1],na.rm = TRUE)))
  sM[i,1] = normalized                                                                                                                          
}
weight = c()
for (i in 1:dim(sM)[1]){
 # weight = append(weight, (sM[i,1])^3)
  weight = append(weight, (sM[i,1]))
  
}
for (i in 1:dim(sM)[1]){
    sM[i,2] = (weight[i]-as.numeric(min(weight,na.rm = TRUE)))/(as.numeric(max(weight,na.rm = TRUE)-as.numeric(min(weight,na.rm = TRUE))))
}

gene_weights = as.vector(sM[,2])
gene_weights[is.na(gene_weights)] = 0

#Weighted Clustering
#Gene Expression Normalization
dset = dset[-which(rownames(dset) %in% remove_genes),]
for (i in 1:dim(dset)[1]){
  min = as.numeric(min(dset[i,],na.rm=TRUE))
  max = as.numeric(max(dset[i,],na.rm=TRUE))
  for (j in 1:dim(dset)[2]){
    normalized = (dset[i,j]-min)/(max-min)
    dset[i,j] = normalized
  }
}
dset = as.matrix(dset)

nrowweighteddset = 0
for (i in 1:dim(dset)[1]){
  factor = round(gene_weights[i]*100)
  for (j in 1:factor){
    nrowweighteddset = nrowweighteddset + 1
  }
}

weighted_dset = matrix(NA,nrow = nrowweighteddset, ncol = dim(dset)[[2]]); #`colnames<-`(weighted_jt,colnames(jt_astro))
colnames(weighted_dset) = colnames(dset)
place = 0
gene_names = c()

for (i in 1:dim(dset)[1]){
  factor = round(gene_weights[i]*100)
  for (j in 1:factor){
    place = place + 1
    gene_names = c(rownames(dset)[i],gene_names)
    weighted_dset[place,] = dset[i,]; #rownames(weighted_dset)[place]=rownames(dset)[i]
  }
}
rownames(weighted_dset) = gene_names

#Weighted clustering
w_cluster = Waterfall.Cluster(weighted_dset, nClusters=2, simplecolors = F,colorchoices = NULL)
wdset.cols = w_cluster[,2]
weighted_dset[is.na(weighted_dset)] = 0

#Plotting clusters
for (i in 1:length(wdset.cols)){
  if (wdset.cols[i] == 1){
    wdset.cols[i] = "#4882C3"
  }
  if (wdset.cols[[i]] == 2){
    wdset.cols[i] = "#F26A6A"
  }
}
other_cols = jt.cols[names(jt.cols) %notin% names(wdset.cols)]
for (i in 1:length(other_cols)){
  other_cols[i] = "#D3D3D3"
  wdset.cols = append(wdset.cols, other_cols[i])
}

source("load/LoadData.R")
jt.PT = Waterfall.Pseudotime(jt, angle=180, col = wdset.cols, plot_title = " Divergent Trajectories", nclust = 5, seed = 5, invert_pt = T,scalePCA = F,lines=F,mst=F)


#Divergent PT Trajectories for SA

dset_sA = jt.all[,SA.id]
TPM_data = dset_sA
loglik_thresh = -200
exp_thresh = 50

remove_genes = c()
for (i in 1:dim(TPM_data)[1]){
  if (max(as.numeric(TPM_data[rownames(TPM_data)[i],]))<=exp_thresh){
    remove_genes = append(remove_genes,rownames(TPM_data)[i])
  }
}
TPM_data = TPM_data[-which(rownames(TPM_data) %in% remove_genes),]
sM_sA = matrix(0,nrow = dim(TPM_data)[1],ncol = 2)
colnames(sM_sA) = c("Loglikelihood of Bimodality", "Weight"); rownames(sM_sA) = rownames(TPM_data)  
bimodal_genes = c()
for (i in 1:dim(TPM_data)[1]){
  try({
    gene_exp = as.numeric(TPM_data[rownames(sM_sA)[i],])
    mixmdl = Mclust(gene_exp, G = 2, modelNames = c("E","V"))
    loglik = as.numeric(mixmdl$loglik)
    sM_sA[i,1] = loglik
  })
}

#Weights

#Normalize loglikelihood
for (i in 1:dim(sM_sA)[1]){
  try({
    if (sM_sA[i,1]>-60){
      sM_sA[i,1]=-60
    }
  })
}
for (i in 1:dim(sM_sA)[1]){
  normalized = (sM_sA[i,1]-as.numeric(min(sM_sA[,1],na.rm = TRUE)))/(as.numeric(max(sM_sA[,1],na.rm = TRUE))-as.numeric(min(sM_sA[,1],na.rm = TRUE)))
  sM_sA[i,1] = normalized
}
weight = c()
for (i in 1:dim(sM_sA)[1]){
  weight = append(weight, (sM_sA[i,1])^3)
}
for (i in 1:dim(sM_sA)[1]){
  sM_sA[i,2] = (weight[i]-as.numeric(min(weight,na.rm = TRUE)))/(as.numeric(max(weight,na.rm = TRUE)-as.numeric(min(weight,na.rm = TRUE))))
}

gene_weights = as.vector(sM_sA[,2])
gene_weights[is.na(gene_weights)] = 0

#Weighted Clustering
#Gene Expression Normalization
dset_sA = dset_sA[-which(rownames(dset_sA) %in% remove_genes),]
for (i in 1:dim(dset_sA)[1]){
  min = as.numeric(min(dset_sA[i,],na.rm=TRUE))
  max = as.numeric(max(dset_sA[i,],na.rm=TRUE))
  for (j in 1:dim(dset_sA)[2]){
    normalized = (dset_sA[i,j]-min)/(max-min)
    dset_sA[i,j] = normalized
  }
}
dset_sA = as.matrix(dset_sA)

nrowweighteddset_sA = 0
for (i in 1:dim(dset_sA)[1]){
  factor = round(gene_weights[i]*100)
  for (j in 1:factor){
    nrowweighteddset_sA = nrowweighteddset_sA + 1
  }
}

weighted_dset_sA = matrix(NA,nrow = nrowweighteddset_sA, ncol = dim(dset_sA)[[2]]); #`colnames<-`(weighted_jt,colnames(jt_astro))
colnames(weighted_dset_sA) = colnames(dset_sA)
place = 0
gene_names = c()

for (i in 1:dim(dset_sA)[1]){
  factor = round(gene_weights[i]*100)
  for (j in 1:factor){
    place = place + 1
    gene_names = c(rownames(dset_sA)[i],gene_names)
    weighted_dset_sA[place,] = dset_sA[i,]; #rownames(weighted_dset_sA)[place]=rownames(dset_sA)[i]
  }
}
rownames(weighted_dset_sA) = gene_names

#Weighted clustering
w_cluster = Waterfall.Cluster(weighted_dset_sA, nClusters=2, simplecolors = F,colorchoices = NULL)
wdset_sA.cols = w_cluster[,2]
weighted_dset_sA[is.na(weighted_dset_sA)] = 0

#Plotting clusters
for (i in 1:length(wdset_sA.cols)){
  if (wdset_sA.cols[i] == 1){
    wdset_sA.cols[i] = "#4882C3"
  }
  if (wdset_sA.cols[[i]] == 2){
    wdset_sA.cols[i] = "#F26A6A"
  }
}
other_cols = jt.cols[names(jt.cols) %notin% names(wdset_sA.cols)]
for (i in 1:length(other_cols)){
  other_cols[i] = "#D3D3D3"
  wdset_sA.cols = append(wdset_sA.cols, other_cols[i])
}

jt.PT = Waterfall.Pseudotime(jt.all, angle=180, col = wdset_sA.cols, plot_title = " Divergent Trajectories", nclust = 5, seed = 5, invert_pt = T,scalePCA = F,lines=F,mst=F)

#   plot(xpt, ypt , pch=".")
#   abline(h=2,col="red")
#   abline(v=2,col="red")
#   abline(v=-2,col="red")
#   text(xpt,ypt,labels = jt_s3_gene)



