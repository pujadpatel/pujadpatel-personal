#comparing S1 (without s0) in Jaden's data & Astrocytes in Ana's data

source("src/Waterfall.R")
source("load/LoadData.R")
source("src/HyperGeoTerms.R")
source("load/LoadData_4mo.R")
library(gplots)
library(RColorBrewer)

ebars <- function(x, y, upper, lower=upper, length=0.1,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}

se = function(X) return(sd(X)/sqrt(length(X)))

at = read.table("data/Ana_TPM_NSC.csv")
at = ScaleTPM(at) 

#remove outlier N_GP_15B
removeIndex = which(colnames(at) == "N_GP_15B" )
at = at[, colnames(at)[-removeIndex]]

#removes TAP
ata = at[, -grep("tap", colnames(at))]
ata = ata[, -grep("N", colnames(ata))]

ata.cols = c() #colors
ata.cols[colnames(ata)] = "yellow" 
ata.cols[grep("str", colnames(ata))] = "blue"
ata.cols[grep("ctx", colnames(ata))] = "green"

par(mfrow = c(1,1))

#Jaden's data: S1
jt = read.table("data/Jaden_TPM_NSC.txt") #the full Dataset is jt
jt = ScaleTPM(jt)
S1.id = S1.id[S1.id %notin% S0.id] #removing S0 from 
jt.cols = grx[,1] #Includes SA
jg = rownames(jt)
ag = rownames(at)

SIG_THRESH = .01

##### GOAL 1: Create Groups ######
jg_only = jg[jg %notin% ag]; ag_only = ag[ag %notin% jg] 
both = c(jg[jg %notin% c(jg_only,ag_only)])

ana_a = names(ata) #subset of astrocytes (ctx & str) in Anas dataset
all_a = at[both,] #all cells in Ana dataset

jt_S1 = c(S1.id) #subset of S1 in jaden dataset
all_j = jt[both,] #all cells in young dataset

##### GOAL 2: Get Genes For Each Group ######
#significant genes 
ana_a_df <-signature(all_a,ana_a,sig_thresh = SIG_THRESH); ana_a_gene = rownames(ana_a_df) #ana_a_gene = genes associated with astrocytes in ana dataset
jt_S1_df <-signature(all_j,jt_S1,sig_thresh = SIG_THRESH); jt_S1_gene = rownames(jt_S1_df) #jt_S1_gene = genes associated with S1 cells in jaden dataset

#Put gene lists together

jt_S1_gene_only = jt_S1_gene[jt_S1_gene %notin% ana_a_gene] # genes ONLY in jaden atrocytes (not ana cells)
ana_a_gene_only = ana_a_gene[ana_a_gene %notin% jt_S1_gene] #genes ONLY in ana astrocytes (not jaden cells)
jointlist = jt_S1_gene[jt_S1_gene %notin% c(jt_S1_gene_only,ana_a_gene_only)] #genes that associated with both jaden and ana astrocytes

all_a = all_a[c(jointlist,jt_S1_gene_only,ana_a_gene_only),] #only include TPM data for cells that are in either jaden/ana genesets 
all_j = all_j[c(jointlist,jt_S1_gene_only,ana_a_gene_only),] # ^^^

##### GOAL 3: Compute Statistial Sigfinicance of Expression Difference Between Groups ######
a_sig = signature_2datasets(all_a,all_j,sig_thresh = .01); a_sig = rownames(a_sig) #compute statistical significance of differential gene expression in two datasets


##### GOAL 4: Plot Stuff #####
#get exp of sig genes
jt_S1_exp = all_j[,c(jt_S1)];jt_S1_exp = apply(jt_S1_exp,1,mean)
ana_a_exp = all_a[,c(ana_a)];ana_a_exp = apply(ana_a_exp,1,mean)

#get exp standard error of sig genes
jt_S1_exp_se = all_j[,c(jt_S1)];jt_S1_exp_se = apply(jt_S1_exp_se,1,se)
ana_a_exp_se = all_a[,c(ana_a)];ana_a_exp_se = apply(ana_a_exp_se,1, se)

#draw heatmap of significant genes, log10 transformed
jt_S1_exp_log = log10(jt_S1_exp); jt_S1_exp_log[jt_S1_exp_log==-Inf] = 0
ana_a_exp_log = log10(ana_a_exp); ana_a_exp_log[ana_a_exp_log==-Inf] = 0

#old over young expression log10 transformed expression levels

a_over_s1 = log10(ana_a_exp/jt_S1_exp)
a_over_s1 = a_over_s1;a_over_s1 = a_over_s1[a_over_s1!=Inf];a_over_s1 = a_over_s1[a_over_s1!=-Inf]
s1_over_a = -1*a_over_s1

pheatmap(rbind(jt_S1_exp_log,ana_a_exp_log),cluster_row=F,cluster_col=T,legend=T,show_rownames=T,show_colnames=F,cellwidth=1,cellheight=60,main = "Sig Conditional")
pheatmap(t(sort(c(a_over_s1))),cluster_row=F,cluster_col=F,legend=T,show_rownames=T,show_colnames=F,cellwidth=1,cellheight=120,main = paste0("Str,Ctx/s1 Conditional (gene N=",length(a_over_s1),")"))
pheatmap(t(sort(a_over_s1[a_sig])),cluster_row=F,cluster_col=F,legend=T,show_rownames=T,show_colnames=T,cellwidth=3,cellheight=120,main = paste0("Str,Ctx/s1 Conditional (Alpha = .01, gene N=",length(a_sig),")"))


s1high = s1_over_a[s1_over_a>=1.5]
ahigh = a_over_s1[a_over_s1>=2]


realEffects = function(GOI,tpm_data){
  gene_lst = c()
  for (gene in GOI){
    exp = as.numeric(tpm_data[gene,])
    mean_exp = mean(exp)
    N_meets_condition = length(exp[exp>=mean_exp])
    if ((N_meets_condition >= length(exp)*.5 ) & mean_exp > 100) gene_lst = c(gene_lst,gene)
  }
  
  return(gene_lst)
}

j_up = realEffects(names(s1high),jt[,s1.id])
a_up = realEffects(names(ahigh),at[,colnames(ata)])

pheatmap(t(sort(a_over_s1[a_up])),cluster_row=F,cluster_col=F,legend=T,show_rownames=T,show_colnames=T,cellwidth=15,color = brewer.pal(9,"YlOrRd"),cellheight=120,main = "Ana-Astro/Jaden-s1 Factor Score")

#creating pseudotime/hmm plots for genes
for (GeneName in a_up)
{
  #PTgeneplot(GeneName,PT=as.numeric(jt["Pseudotime",]),TPM_data=as.numeric(jt),col=jt.cols, main= GeneName)
  pseudotime.foo(GeneName, as.numeric(jt),as.numeric((jt["Pseudotime",])))
}

