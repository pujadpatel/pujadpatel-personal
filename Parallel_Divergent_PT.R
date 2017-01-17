library(lmtest)
library(zoo)
library(mixtools)
library(diptest)
library(WeightedCluster)
source("load/LoadData.R")
source("utils/baseB.R")

#bimodalWindows parameter requires a list of windows where bimodality should occur
distributionestimation = function(genename,dset,bimodalWindows){
  best= c()
  windowsize = c()
  loglik = c()
  bimodal = c()
  testgene = as.numeric(dset[genename,])
  PT = as.numeric(dset["Pseudotime",])
  forwindow = as.numeric(length(testgene)) - 4
  for (i in 1:(forwindow)){
    listpseudo = c(PT[i],PT[i+1],PT[i+2],PT[i+3],PT[i+4])
    difference = as.numeric(listpseudo[5]) - as.numeric(listpseudo[1])
    windowsize = c(difference, windowsize)
    winner = max(windowsize)
    windo = as.numeric(winner)
  }
  gh = 100/windo
  windowloop = floor(gh)
  for(i in 0:(windowloop-1)){
    smallwin = c()
    if (i == (windowloop-2)){
      gg = PT >= (i*windo) & PT <= ((i+2)*windo)
    }
    else{
      gg = PT >= (i*windo) & PT <= ((i+1)*windo)
    }
    for (j in 1:ncol(dset)){
      if (gg[j] == TRUE){
        smallwin = c(testgene[j],smallwin)
      }
      else{
        next
      }
    }
    #Calculates loglikelihood of windows where bimodality is expected
    if (i %in% bimodalWindows){
      bimodal = append(bimodal,smallwin)
    }
    if (all(smallwin==0) == TRUE){
      next
    }
    else{
      mixmdl = Mclust(smallwin, G = 2, modelNames = c("E","V"))
      loglik = append(loglik, as.numeric(mixmdl$loglik))
    }
  }
  if (all(bimodal==0) == TRUE){
    print(genename)
  }
  else{
    mixmdl2 = Mclust(bimodal, G = 2, modelNames = c("E","V"))
    loglik2 = as.numeric(mixmdl2$loglik)
  }
  #Caclulates the spearman coefficient for increasing bimodality
  spearm.test = cor.test(seq(0,length(loglik)-1,1),loglik, method = "spearm")
  vals = c(spearm.test[[3]],spearm.test[[4]],loglik2)
  #`names<-`(vals, c("pval","rho","loglik"))
  return(vals)
}

scoringMatrix = function(TPM_data,rho,loglik_thresh,bimodalWindows,exp_thresh){
  #Removes genes under expression threshold
  remove_genes = c()
  for (i in 1:dim(TPM_data)[1]){
    if (max(as.numeric(TPM_data[rownames(TPM_data)[i],]))<=exp_thresh){
      remove_genes = append(remove_genes,rownames(TPM_data)[i])
    }
  }
  TPM_data = TPM_data[-which(rownames(TPM_data) %in% remove_genes),]
  sM = matrix(0,nrow = dim(TPM_data)[1],ncol = 3)
  colnames(sM) = c("Spearman Coefficient", "Loglikelihood of Bimodality", "Weight"); rownames(sM) = rownames(TPM_data)  
  biomodalWindows = c(0,1)
  bimodal_genes = c()
  for (i in 1:dim(TPM_data)[1]){
    try({
      #Spearman coefficient of loglikelihoods of windows of PT
      sM[i,1] = distributionestimation(rownames(sM)[i],TPM_data,biomodalWindows)[2]
      #loglikelihood of bimodalWindows
      sM[i,2] = distributionestimation(rownames(sM)[i],TPM_data,biomodalWindows)[3]
      if (sM[i,1]>=rho & sM[i,2]>=loglik_thresh){
        bimodal_genes=append(bimodal_genes,rownames(sM)[i])
      }
    })
  }
  for (i in 1:dim(sM)[1]){
   #Weights
    #Normalize Rho Values
    for (i in 1:dim(sM)[1]){
      normalized = (sM[i,1]-as.numeric(min(sM[,1],na.rm = TRUE)))/(as.numeric(max(sM[,1],na.rm = TRUE))-as.numeric(min(sM[,1]),na.rm = TRUE))
      sM[i,1] = normalized
    }
    #Normalize loglikelihood
    for (i in 1:dim(sM)[1]){
      if (sM[i,2]>-60){
        sM[i,2]=-60
      }
    }
    for (i in 1:dim(sM)[1]){
      normalized = (sM[i,2]-as.numeric(min(sM[,2],na.rm = TRUE)))/(as.numeric(max(sM[,2],na.rm = TRUE))-as.numeric(min(sM[,2],na.rm = TRUE)))
      sM[i,2] = normalized
    }
    weight = c()
    for (i in 1:dim(sM)[1]){
      weight = append(weight, sum((0.3*sM[i,1]),(0.7*sM[i,2])))
    }
    for (i in 1:dim(sM)[1]){
      sM[i,3] = (weight[i]-as.numeric(min(weight,na.rm = TRUE)))/(as.numeric(max(weight,na.rm = TRUE)-as.numeric(min(weight,na.rm = TRUE))))
    }
  }
  return (sM)
}

jt_matrix = scoringMatrix(jt,rho=0.75,loglik_thresh=-200,bimodalWindows=c(0,1),exp_thresh=50)

gene_weights = as.vector(sM[,3])
gene_weights[is.na(gene_weights)] = 0

#Weighted Clustering
#Gene Expression Normalization
jt = jt[-which(rownames(jt) %in% remove_genes),]
for (i in 1:dim(jt)[1]){
  min = as.numeric(min(jt[i,],na.rm=TRUE))
  max = as.numeric(max(jt[i,],na.rm=TRUE))
  for (j in 1:dim(jt)[2]){
    normalized = (jt[i,j]-min)/(max-min)
    jt[i,j] = normalized
  }
}
jt = as.matrix(jt)
jt_astro = jt[,c(jt_s0,jt_s1,jt_s2,jt_s3)]

nrowweightedjt = 0
for (i in 1:dim(jt_astro)[1]){
  factor = round(gene_weights[i]*100)
  for (j in 1:factor){
    nrowweightedjt = nrowweightedjt + 1
  }
}

weighted_jt = matrix(NA,nrow = nrowweightedjt, ncol = dim(jt_astro)[[2]]); #`colnames<-`(weighted_jt,colnames(jt_astro))
colnames(weighted_jt) = colnames(jt_astro)
place = 0
gene_names = c()

for (i in 1:dim(jt_astro)[1]){
  factor = round(gene_weights[i]*100)
  for (j in 1:factor){
    place = place + 1
    gene_names = c(rownames(jt_astro)[i],gene_names)
    weighted_jt[place,] = jt_astro[i,]; #rownames(weighted_jt)[place]=rownames(jt)[i]
  }
}
rownames(weighted_jt) = gene_names

#Weighted clustering
w_cluster = Waterfall.Cluster(weighted_jt, nClusters=2, simplecolors = F,colorchoices = NULL)
wjt.cols = w_cluster[,2]
weighted_jt[is.na(weighted_jt)] = 0

#Plotting clusters
for (i in 1:length(wjt.cols)){
  if (wjt.cols[i] == 1){
    wjt.cols[i] = "#4882C3"
  }
  if (wjt.cols[[i]] == 2){
    wjt.cols[i] = "#F26A6A"
  }
}
other_cols = jt.cols[names(jt.cols) %notin% names(wjt.cols)]
for (i in 1:length(other_cols)){
  other_cols[i] = "#D3D3D3"
  wjt.cols = append(wjt.cols, other_cols[i])
}

source("load/LoadData.R")
jt.PT = Waterfall.Pseudotime(jt, angle=180, col = wjt.cols, plot_title = " Divergent Trajectories", nclust = 5, seed = 5, invert_pt = T,scalePCA = F,lines=F,mst=F)


#Signatures
SIG_THRESH = 0.01

wjt1.id = names(w_cluster[w_cluster[,2]==1,2])
wjt2.id = names(w_cluster[w_cluster[,2]==2,2])

wjt_1_df <-signature(jt[c(wjt1.id,wjt2.id)],wjt1.id,sig_thresh = SIG_THRESH); wjt_1_gene = rownames(wjt_1_df);
wjt_2_df <-signature(jt[c(wjt1.id,wjt2.id)],wjt2.id,sig_thresh = SIG_THRESH); wjt_2_gene = rownames(wjt_2_df);

pdf(file = "~/Desktop/Trajectories_astro.pdf")
par(mfrow = c(3,2),mar =c(1.7,1.7,1.7,1.7))
for (gene in (wjt_1_gene)){
  PTgeneplot(gene,jt,col=wjt.cols)
}
dev.off()

pdf(file = "~/Desktop/Trajectories2_astro.pdf")
par(mfrow = c(3,2),mar =c(1.7,1.7,1.7,1.7))
for (gene in (wjt_2_gene)){
  PTgeneplot(gene,jt,col=wjt.cols)
}
dev.off()

#GO Terms
go_terms_wjt_1 = getIntersectingGenesFromGo(wjt_1_gene); terms_wjt_1 = keys(go_terms_wjt_1)
go_terms_wjt_2 = getIntersectingGenesFromGo(wjt_2_gene); terms_wjt_2 = keys(go_terms_wjt_2)

grid.newpage()
draw.pairwise.venn(length(terms_wjt_1), length(terms_wjt_2), length(intersect(terms_wjt_1,terms_wjt_2)), 
                   category = c("Group Blue","Group Pink"), lty = rep("blank",2), 
                   fill = c("light blue", "pink"), alpha = rep(.5,2), cat.pos = rep(0,2), cat.dist = rep(0.025, 2))

if (FALSE){
  #Expression Threshold
  thresh_bimodal = c()
  for (gene in bimodal_genes){
    if (mean(as.numeric(jt[gene,]))>=50){
      thresh_bimodal= append(thresh_bimodal,gene)
      #PTgeneplot(gene, jt, col=jt.cols)
    }
  }
}
