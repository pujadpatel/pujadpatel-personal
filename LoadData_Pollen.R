##### Data from Pollen #####

source("src/Waterfall.R")
source("src/GeneConversion.R")
library(TxDb.Hsapiens.UCSC.hg19.knownGene) 
library(org.Hs.eg.db)
library(org.Hs.egSYMBOL2EG)

po = read.table("data/pollen_cpm.txt")
po_cells = read.table("data/pollen_cells.txt", header = TRUE)
cpm = CPMconversion(po)

#Genes above 1 CPM in at least 2 cells
po_genes=c()
for (i in 1:length(rownames(cpm))){
  if (is.finite(cpm[i,1])){
    if (max(cpm[i,])>=1){
      if (sort(cpm[i,],decreasing = TRUE)[[2]]>1){
        po_genes = append(po_genes, rownames(cpm)[i])
      }
    }
  }
}

po = po[po_genes,]
po = ScaleTPM(po)

gw16.5 = po[po_cells[,3]=="GW16.5"]
gw18 = po[po_cells[,3]=="GW18"]
gw16 = po[po_cells[,3]=="GW16"]

grx = Waterfall.Cluster(po, nClusters = 5)
po.cols = grx[,1] 

po.PT = Waterfall.Pseudotime(po, angle=180, cols = po.cols, plot_title = " Pollen", nclust = 5, seed = 5, invert_pt = F,scalePCA = F,lines=F,mst=F)

po = po[,rownames(po.PT)]
po["Pseudotime",] = po.PT[,1]

gw16.5.cols = Waterfall.Cluster(gw16.5, nClusters = 5)[,1]
gw16.5.PT = Waterfall.Pseudotime(gw16.5, angle=180, cols = gw16.5.cols, plot_title = " Pollen GW16.5", nclust = 5, seed = 5, invert_pt = F,scalePCA = F,lines=F,mst=F)

#Heatmap
identity_genes = c("RBFOX1","NEUROD2","STMN2","SLA","NEUROD6","HES6","ELAVL4","NEUROD1","SSTR2","PENK","EOMES","PPP1R17","NPR3","NEUROG1","PAX6","SOX2","SLC1A3","NOTCH3","HES1","VIM","GFAP")

avg_exp_genes = log2(po[identity_genes,])
avg_exp_genes[avg_exp_genes==-Inf] = min(avg_exp_genes[avg_exp_genes !=-Inf])

pheatmap(avg_exp_genes,cluster_row=F,cluster_col=T,legend=T,show_rownames=T,show_colnames=F,cellwidth=1,cellheight=10,main = "Expression of Identity Genes-Pollen")

#Radial Glia
pheatmap(avg_exp_genes[275:393],cluster_row=F,cluster_col=F,legend=T,show_rownames=T,show_colnames=F,cellwidth=1,cellheight=10,main = "Expression of Identity Genes-Pollen")

rgl=intersect(colnames(po[po.cols=="#E2CF00"]),colnames(po[,280:393]))
rgl=colnames(po[po.cols=="#E2CF00"])

#Radial Glial Markers
po.SLC1A3 = sort(po["SLC1A3",],decreasing = TRUE)[1:100]
po.PAX6 = sort(po["PAX6",],decreasing = TRUE)[1:100]
po.SOX2 = sort(po["SOX2",],decreasing=TRUE)[1:100]
po.PDGFD = sort(po["PDGFD",],decreasing=TRUE)[1:100]
po.GLI3 = sort(po["GLI3",],decreasing=TRUE)[1:100]
#rgl = unique(c(names(po.SLC1A3), names(po.PAX6),names(po.SOX2),names(po.PDGFD),names(po.GLI3)))

po.rgl= po[rgl]
pca = prcomp(t(po.rgl), center = TRUE, scale = FALSE)
PC3_loadings = pca$rotation[,3]
top_genes = c(names(sort(PC3_loadings, decreasing = TRUE)[1:82]),names(sort(PC3_loadings)[1:82]))
rgl_clusters = Waterfall.Cluster(po.rgl[top_genes,], nClusters=2)
rgl.PT = Waterfall.Pseudotime(po.rgl, col = rgl_clusters[,1],mst=FALSE)

#VZ markers
PTgeneplot("CRYAB",po.rgl,col=rgl_clusters[,1])
PTgeneplot("PDGFD",po.rgl,col=rgl_clusters[,1])
PTgeneplot("TAGLN2",po.rgl,col=rgl_clusters[,1])
PTgeneplot("FBXO32",po.rgl,col=rgl_clusters[,1])
PTgeneplot("PALLD",po.rgl,col=rgl_clusters[,1])
#OSVZ markers
PTgeneplot("HOPX",po.rgl,col=rgl_clusters[,1])
PTgeneplot("PTPRZ1",po.rgl,col=rgl_clusters[,1])
PTgeneplot("TNC",po.rgl,col=rgl_clusters[,1])
PTgeneplot("FAM107A",po.rgl,col=rgl_clusters[,1])
PTgeneplot("MOXD1",po.rgl,col=rgl_clusters[,1])


#Top Covariance among Genes
if (FALSE){
  covar_po = cov(t(po))
  po_mean = rowMeans(covar_po)
  po_mean = sort(po_mean, decreasing = TRUE)
  po_max = po[names(po_mean[1:5000]),]
  
  grx = Waterfall.Cluster(po_max, nClusters = 5)
  po_max.cols = grx[,1] 
  po_max.PT = Waterfall.Pseudotime(po_max, angle=180, cols = po_max.cols, plot_title = " Pollen", nclust = 5, seed = 5, invert_pt = F,scalePCA = T,lines=F,mst=F)
  
  po_max = po_max[,rownames(po_max.PT)]
  po_max["Pseudotime",] = po_max.PT[,1]
}