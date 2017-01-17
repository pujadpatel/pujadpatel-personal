source("src/Waterfall.R")
source("src/HyperGeoTerms.R")
source("load/LoadData_Barres.R")
source("load/LoadData-Ana.R")
source("load/LoadData_Zhang.R")
source("load/LoadData.R")
source("utils/baseB.R")

#S3->S2->S1 Trajectory

SIG_THRESH = 0.05
#zm_astro_df = signature(zm,colnames(zm)[1:6],sig_thresh = SIG_THRESH); zm_astro_gene = rownames(zm_astro_df) 

zm_astro_fc = names(foldChange(zm,7:21,1:6,fc_thresh = 2)[1:500])
  
both = intersect(rownames(jt),rownames(at))
rmi = which(both=="Pseudotime")
both = both[-rmi]

pt = jt.PT[c(S1.id,S2.id,S3.id),1]
q = quantile(pt)
pt = jt.PT[c(S1.id,S2.id,S3.id),1]

groupA = names(pt[pt<q[3]])
groupB = names(pt[pt>=q[3]])

groupA_df  = signature(jt[1:(nrow(jt)-1),c(S1.id,S2.id,S3.id)],groupA,sig_thresh = SIG_THRESH,mean_thresh = 25); groupA_gene = rownames(groupA_df);
groupB_df  = signature(jt[1:(nrow(jt)-1),c(S1.id,S2.id,S3.id)],groupB,sig_thresh = SIG_THRESH,mean_thresh = 25); groupB_gene = rownames(groupB_df);

bares_astro_fc = names(foldChange(bt[both,],2:7,1,fc_thresh = 2)[1:500])

at_allA_n_df = signature(at[both,c(at_allA,at_n)],at_allA,sig_thresh = SIG_THRESH); at_allA_n_gene = rownames(at_allA_n_df); 
at_allA_tap_df = signature(at[both,c(at_allA,at_TAP)],at_allA,sig_thresh = SIG_THRESH); at_allA_tap_gene = rownames(at_allA_tap_df); 
at_allA_genes = intersect(at_allA_n_gene,at_allA_tap_gene)

barres_gene = bares_astro_fc
ana_gene = at_allA_genes
zhang_mouse_gene = zm_astro_fc

j_groups = c("groupA", "groupB")
b_groups = c("barres","ana","zhang_mouse")

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
  }
}
s3_sigarray = sig_array

alpha = .001
colfunc <- colorRampPalette(c("black", "gray90"))
c = colfunc(2)
tb = sig_array
tb[tb <= alpha] = 0; tb[tb > alpha] = 1
pheatmap(tb,color = c,cluster_rows = FALSE, cluster_cols = FALSE,legend=FALSE,cellwidth = 40,cellheight = 40)

########### SA->S2->S1 Trajectory

par(mfrow=c(1,1))
jt = read.table("data/Jaden_TPM_NSC.txt")
jt = ScaleTPM(jt)
grx = Waterfall.Cluster(jt, nClusters = 7)
S0 = c("C11","C16","C25","C28","C13")
grx[S0,1] = "purple"
jt.cols = grx[,1] #Includes SA
S0 = c("C11","C16","C25","C28","C13")

jt.all = jt 
anno = grx;
anno[anno=="6"] = "A" 
jt.cols.all = grx[,1] 

S1.id = names(grx[grx[,2]==1,2])
S2.id = names(grx[grx[,2]==2,2])
S3.id = names(grx[grx[,2]==3,2])
S4.id = names(grx[grx[,2]==4,2])
S5.id = names(grx[grx[,2]==5,2])
SN.id = names(grx[grx[,2]==6,2])
SA.id = names(grx[grx[,2]==7,2])

jt.PT = Waterfall.Pseudotime(jt, angle=180, col = jt.cols, plot_title = " Adult", nclust = 5, seed = 5, invert_pt = F,scalePCA = F,lines=F,mst=F)

#SortJaden by PT, create a dummy gene called "PT"
jt.cols = jt.cols[rownames(jt.PT)]
jt = jt[,rownames(jt.PT)]
jt["Pseudotime",] = jt.PT[,1]

pt = jt.PT[c(S1.id,S2.id,SA.id),1]
q = quantile(pt)
pt = jt.PT[c(S1.id,S2.id,SA.id),1]

groupA = names(pt[pt<q[3]])
groupB = names(pt[pt>=q[3]])

groupA_df  = signature(jt[1:(nrow(jt)-1),c(S1.id,S2.id,SA.id)],groupA,sig_thresh = SIG_THRESH,mean_thresh = 25); groupA_gene = rownames(groupA_df);
groupB_df  = signature(jt[1:(nrow(jt)-1),c(S1.id,S2.id,SA.id)],groupB,sig_thresh = SIG_THRESH,mean_thresh = 25); groupB_gene = rownames(groupB_df);

barres_gene = bares_astro_fc
ana_gene = at_allA_genes
zhang_mouse_gene = zm_astro_fc

j_groups = c("groupA", "groupB")
b_groups = c("barres","ana","zhang_mouse")

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
  }
}
sA_sigarray = sig_array

alpha = .001
colfunc <- colorRampPalette(c("black", "gray90"))
c = colfunc(2)
tb = sig_array
tb[tb <= alpha] = 0; tb[tb > alpha] = 1
pheatmap(tb,color = c,cluster_rows = FALSE, cluster_cols = FALSE,legend=FALSE,cellwidth = 40,cellheight = 40)



