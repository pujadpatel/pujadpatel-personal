#comparing S0 in Jaden's data & Astrocytes from Ana's data using Enriched Genes
#source("src/Waterfall.R")
source("load/LoadData.R")
source("src/HyperGeoTerms.R")
source("load/LoadData-Ana.R")
source("utils/baseB.R")

library(gplots)
library(RColorBrewer)

SIG_THRESH = .01

par(mfrow = c(1,1))

S0 = c("C11","C16","C25","C28","C13")

jg = rownames(jt.all)
ag = rownames(at)


##### GOAL 1: Create Groups ######
jg_only = jg[jg %notin% ag]; ag_only = ag[ag %notin% jg] 
both = c(jg[jg %notin% c(jg_only,ag_only)])

all_a = at[both,] #all cells in Ana dataset
at_Str = Str.id
at_Ctx = Ctx.id
at_TAP = TAP.id
at_allA = All_A.id
at_n = N.id

jt_a = c(S0) #subset of astrocytic cells in young (jaden) dataset
jt_1 = S1.id[S1.id %notin% jt_a]
jt_2 = S2.id
jt_3 = S3.id
jt_4 = S4.id
jt_5 = S5.id
jt_A = SA.id

all_j = jt.all[both,] #all cells in Jaden dataset
all_j_s1 = all_j[,c(jt_a,jt_2,jt_3,jt_4,jt_5,jt_A)] #all cells in Jaden dataset except s1

##### GOAL 2: Get Genes For Each Group ######
num_genes = 50;
enrich_thresh = 500;

#Gene lists based on enrichment
at_ctx_gene = names(enrichment(all_a[at_Ctx],enrich_thresh,num_genes))
at_str_gene = names(enrichment(all_a[at_Str],enrich_thresh,num_genes))
at_allA_gene = names(enrichment(all_a[at_allA],enrich_thresh,num_genes))
at_tap_gene = names(enrichment(all_a[at_TAP],enrich_thresh,num_genes))
at_n_gene = names(enrichment(all_a[at_n],enrich_thresh,num_genes))

jt_a_gene = names(enrichment(all_j[jt_a],enrich_thresh,num_genes)); 
jt_s1_gene = names(enrichment(all_j[jt_1],enrich_thresh,num_genes)); 
jt_s2_gene = names(enrichment(all_j[jt_2],enrich_thresh,num_genes)); 
jt_s3_gene = names(enrichment(all_j[jt_3],enrich_thresh,num_genes)); 
jt_s4_gene = names(enrichment(all_j[jt_4],enrich_thresh,num_genes)); 
jt_s5_gene = names(enrichment(all_j[jt_5],enrich_thresh,num_genes)); 
jt_sA_gene = names(enrichment(all_j[jt_A],enrich_thresh,num_genes));

j_groups = c("jt_a","jt_s1","jt_s2","jt_s3","jt_s4","jt_s5","jt_sA")
a_groups = c("at_ctx","at_str","at_allA","at_tap","at_n")

sig_array = matrix(0,nrow = length(a_groups),ncol = length(j_groups)); rownames(sig_array) = a_groups; colnames(sig_array) = j_groups
group_compare = c()
for (group1_name in j_groups){
  group1 = get(paste0(group1_name,"_gene"))
  for (group2_name in a_groups){ 
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
}

alpha = 10^-30
colfunc <- colorRampPalette(c("black", "gray90"))
c = colfunc(2)
tb = sig_array
tb[tb <= alpha] = 0; tb[tb > alpha] = 1
pheatmap(tb,color = c,cluster_rows = FALSE, cluster_cols = FALSE,legend=FALSE,cellwidth = 20,cellheight = 20)


