source("src/Waterfall.R")
library(data.table)
library(plyr)
library(reshape2)
library(rgl)
#for 3d plot download: http://xquartz.macosforge.org/trac/wiki

#Epilepsy Project
#Postnatal Neurogenesis Data
#Gao et al.

#gao
nt = read.table("data/bhw040supp_table2.txt",comment.char = "!")
nt = nt[-which(nt[,1] == "#N/A"),]
nt = rmDupGenes(nt,blend_function = "sum")
nt = ScaleTPM(nt)

#shin
ejt = jt
ejt = ScaleTPM(ejt)

#epilepsy
et = epTPM
rownames(et) = capitalize(tolower(rownames(et)))
et = ScaleTPM(et)

both_genes = Reduce(intersect, list(rownames(nt),rownames(ejt),rownames(et)))

nt.sub = nt[both_genes,]
ejt.sub = ejt[both_genes,]
et.sub = et[both_genes,]
njt = cbind(ejt.sub,nt.sub,et.sub)

#2 clusters
grx_njt = Waterfall.Cluster(njt,nClusters = 2)
njt.cols = grx_njt[,1]
njt.PT =  Waterfall.Pseudotime(njt, angle=180, col = njt.cols, plot_title = " Nes + Dcx", nclust = 8, seed = 5, invert_pt = T,scalePCA = F,lines=F,mst=F,rndY = T)

#null clusters
grx_njt = Waterfall.Cluster(njt,nClusters = NULL)
njt.cols = grx_njt[,1]
njt.PT =  Waterfall.Pseudotime(njt, angle=180, col = njt.cols, plot_title = " Adult", nclust = 8, seed = 5, invert_pt = T,scalePCA = F,lines=F,mst=F)

#old colorations
njt.cols = rep("black",ncol(njt));names(njt.cols) = colnames(njt)
njt.cols[names(jt.cols[names(jt.cols)%in%names(njt.cols)])] = jt.cols[names(jt.cols)%in%names(njt.cols)]
njt.cols[names(njt.cols) %in% names(ep)[grep("INT",names(ep))]] = "grey"
njt.cols[names(njt.cols) %in% names(ep)[grep("NI",names(ep))]] = "cyan"
njt.cols[names(njt.cols) %in% names(ep)[grep("X",names(ep))]] = "green"
color_vect = njt.cols

Waterfall.Cluster(njt,nClusters = 2,cell.cols = color_vect)
njt.PT =  Waterfall.Pseudotime(njt, angle=180, col = njt.cols, plot_title = " CFP+DCX", nclust = 8, seed = 5, invert_pt = T,scalePCA = F,lines=F,mst=F,threeD_plot=TRUE)
njt = njt[,rownames(njt.PT)]
njt["Pseudotime",] = njt.PT[,1]
