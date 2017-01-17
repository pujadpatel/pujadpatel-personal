#comparing S0 in Jaden's data & Astrocytes from Barres paper using Enriched Genes
#source("src/Waterfall.R")
source("load/LoadData.R")
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

bt_a_data = data.frame(bt[,1], row.names=rownames(bt))
bt_n_data = data.frame(bt[,2], row.names=rownames(bt))
bt_op_data = data.frame(bt[,3], row.names=rownames(bt))
bt_no_data = data.frame(bt[,4], row.names=rownames(bt))
bt_mo_data = data.frame(bt[,5], row.names=rownames(bt))
bt_mg_data = data.frame(bt[,6], row.names=rownames(bt))
bt_e_data = data.frame(bt[,7], row.names=rownames(bt))

jt_a = c(S0) #subset of astrocytic cells in young (jaden) dataset
jt_1 = S1.id[S1.id %notin% jt_a]
jt_2 = S2.id
jt_3 = S3.id
jt_4 = S4.id
jt_5 = S5.id
jt_A = SA.id

all_j = jt.all[both,] #all cells in Jaden dataset

##### GOAL 2: Get Genes For Each Group ######
#enriched genes 
num_genes = 50;
enrich_thresh = 500;

bt_a_gene = row.names(head(bt_a_data[order(-bt_a_data$bt...1.),,drop=FALSE],num_genes))
bt_n_gene = row.names(head(bt_n_data[order(-bt_n_data$bt...2.),,drop=FALSE],num_genes))
bt_op_gene = row.names(head(bt_op_data[order(-bt_op_data$bt...3.),,drop=FALSE],num_genes))
bt_no_gene = row.names(head(bt_no_data[order(-bt_no_data$bt...4.),,drop=FALSE],num_genes))
bt_mo_gene = row.names(head(bt_mo_data[order(-bt_mo_data$bt...5.),,drop=FALSE],num_genes))
bt_mg_gene = row.names(head(bt_mg_data[order(-bt_mg_data$bt...6.),,drop=FALSE],num_genes))
bt_e_gene = row.names(head(bt_e_data[order(-bt_e_data$bt...7.),,drop=FALSE],num_genes))

jt_a_gene = names(enrichment(all_j[jt_a],enrich_thresh,num_genes)); 
jt_s1_gene = names(enrichment(all_j[jt_1],enrich_thresh,num_genes)); 
jt_s2_gene = names(enrichment(all_j[jt_2],enrich_thresh,num_genes)); 
jt_s3_gene = names(enrichment(all_j[jt_3],enrich_thresh,num_genes)); 
jt_s4_gene = names(enrichment(all_j[jt_4],enrich_thresh,num_genes)); 
jt_s5_gene = names(enrichment(all_j[jt_5],enrich_thresh,num_genes)); 
jt_sA_gene = names(enrichment(all_j[jt_A],enrich_thresh,num_genes));

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


alpha = 10^-25
colfunc <- colorRampPalette(c("black", "gray90"))
c = colfunc(2)
tb = sig_array
tb[tb <= alpha] = 0; tb[tb > alpha] = 1
pheatmap(tb,color = c,cluster_rows = FALSE, cluster_cols = FALSE,legend=FALSE,cellwidth = 20,cellheight = 20)
