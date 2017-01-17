#comparing S0 in Jaden's data & Astrocytes from Barres paper using Signature Genes
#source("src/Waterfall.R")
#source("load/LoadData.R")
source("src/HyperGeoTerms.R")
source("load/LoadData_Barres.R")
source("utils/baseB.R")
library(gplots)
library(RColorBrewer)

SIG_THRESH = .1

par(mfrow = c(1,1))
#Barres data: Astrocytes

S0 = c("C11","C16","C25","C28","C13")

jg = rownames(jt)
bg = rownames(bt)


##### GOAL 1: Create Groups ######
jg_only = jg[jg %notin% bg]; bg_only = bg[bg %notin% jg] 
both = c(jg[jg %notin% c(jg_only,bg_only)])

bt_a = colnames(bt)[1] #astrocyte data in Barres data
all_b = bt[both,] #all cells in Barres data

jt_a = c(S0) #subset of astrocytic cells in young (jaden) dataset
jt_1 = S1.id[S1.id %notin% jt_a]
jt_2 = S2.id
jt_3 = S3.id
jt_4 = S4.id
jt_5 = S5.id
jt_A = SA.id

all_j = jt.all[both,] #all cells in Jaden dataset

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

j_groups = c("jt_a","jt_s1","jt_s2","jt_s3","jt_s4","jt_s5","jt_sA")
b_groups = c("bt_a","bt_n","bt_op","bt_no","bt_mo","bt_mg","bt_e")

sig_array = matrix(0,nrow = length(b_groups),ncol = length(j_groups)); rownames(sig_array) = b_groups; colnames(sig_array) = j_groups
group_compare = c()
for (group1_name in j_groups){
  group1 = get(paste0(group1_name,"_gene"))
  for (group2_name in b_groups){ 
    group2 = get(paste0(group2_name,"_gene"))
    
    group_compare_i = paste0(group1_name,"_vs","_",group2_name)
    group_compare = c(group_compare,group_compare_i)
    x = length(which(group1 %in% group2))# white ball from drawn
    m = length(group2)# white balls in urn
    n = length(both)-m # black balls in urn
    k = length(group1)# number of balls drawn
    significance_i = phyper(x,m,n,k,lower.tail=F,log=F)
    sig_array[group2_name,group1_name] = significance_i
    #write.table(group1[group1 %in% group2],file=paste0(group1_name,"_overlapwith_",group2_name,".txt"),sep="\t",quote=F)
  }
  #print(data.frame(Overlapping_pair=group_compare, Fisher_exact_test=significance))
  write.table(cbind(group_compare,significance),file=paste0("Hypergeometric_Distribution.txt"),row.names=F,col.names=c("Overlapping Pair","Fisher_exact_test"))

}
  

alpha = .000001
colfunc <- colorRampPalette(c("black", "gray90"))
c = colfunc(2)
tb = sig_array
tb[tb <= alpha] = 0; tb[tb > alpha] = 1
pheatmap(tb,color = c,cluster_rows = FALSE, cluster_cols = FALSE,legend=FALSE,cellwidth = 20,cellheight = 20)


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


