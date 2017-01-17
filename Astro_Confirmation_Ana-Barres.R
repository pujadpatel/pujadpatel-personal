#comparing Anas dataset and Barres dataset using Enriched Genes

#source("src/Waterfall.R")
source("load/LoadData.R")
source("src/HyperGeoTerms.R")
source("load/LoadData_Barres.R")
source("load/LoadData-Ana.R")
source("utils/baseB.R")

library(gplots)
library(RColorBrewer)

SIG_THRESH = .1
par(mfrow = c(1,1))
ag = rownames(at)
bg = rownames(bt)

##### GOAL 1: Create Groups ######
ag_only = ag[ag %notin% bg]; bg_only = bg[bg %notin% ag] 
both = c(ag[ag %notin% c(ag_only,bg_only)])

bt_a = colnames(bt)[1] #astrocyte data in Barres data
all_b = bt[both,] #all cells in Barres data

bt_a_data = data.frame(bt[,1], row.names=rownames(bt))
bt_n_data = data.frame(bt[,2], row.names=rownames(bt))
bt_op_data = data.frame(bt[,3], row.names=rownames(bt))
bt_no_data = data.frame(bt[,4], row.names=rownames(bt))
bt_mo_data = data.frame(bt[,5], row.names=rownames(bt))
bt_mg_data = data.frame(bt[,6], row.names=rownames(bt))
bt_e_data = data.frame(bt[,7], row.names=rownames(bt))

all_a = at[both,] #all cells in Ana dataset
at_Str = Str.id
at_Ctx = Ctx.id
at_TAP = TAP.id
at_allA = All_A.id
at_n = N.id

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

at_ctx_gene = names(enrichment(all_a[at_Ctx],enrich_thresh,num_genes))
at_str_gene = names(enrichment(all_a[at_Str],enrich_thresh,num_genes))
at_allA_gene = names(enrichment(all_a[at_allA],enrich_thresh,num_genes))
at_tap_gene = names(enrichment(all_a[at_TAP],enrich_thresh,num_genes))
at_n_gene = names(enrichment(all_a[at_n],enrich_thresh,num_genes))

a_groups = c("at_ctx","at_str","at_allA","at_tap","at_n")
b_groups = c("bt_a","bt_n","bt_op","bt_no","bt_mo","bt_mg","bt_e")

sig_array = matrix(0,nrow = length(b_groups),ncol = length(a_groups)); rownames(sig_array) = b_groups; colnames(sig_array) = a_groups
group_compare = c()
for (group1_name in a_groups){
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
