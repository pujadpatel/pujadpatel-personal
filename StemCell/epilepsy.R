source("src/Waterfall.R")
source("src/HyperGeoTerms.R")
source("utils/baseB.R")
#load FPKM data
ep = read.table("data/epData.txt",header=TRUE,row.names = 1)
gene_nms = as.vector(ep[,1])
row_nms = rownames(ep)
start = ep[,"Start"]
stop = ep[,"Stop"]
epTPM = raw2TPM(ep[,6:ncol(ep)],start,stop)
epTPM = as.data.frame(cbind(gene_nms,epTPM))
epTPM = rmDupGenes(epTPM,blend_function = "sum")
ep = ep[,6:ncol(ep)]

#load names, make new colnames
tmp = c(read.csv("data/epNames.csv"),header = FALSE)
pID = as.character(tmp[[2]]); names(pID) = as.character(tmp[[1]])
colnames(ep) = paste0(pID[colnames(ep)],"_",colnames(ep))
colnames(epTPM) = paste0(pID[colnames(epTPM)],"_",colnames(epTPM))

if (F){
  #QC: sum reads distribution
  sumFPKM = apply(ep,2,sum); sumFPKM = sumFPKM[order(sumFPKM)]
  histogram(sumFPKM,breaks=50,xlab = "Σfragments/cell",main= "fragment count distribution",ylab="% of Total Cells")
  
  #QC reads vs detectability 
  dtb = apply(ep,2,function(col){return(length(col)-length(which(col == 0)))})
  plot(sumFPKM,dtb[names(sumFPKM)],main = "total reads vs total detected genes", pch=19)
  
  #QC reads vs counts & relative expression 
  mcnd = apply(ep,2,function(col){return(mean(col[col>0]))})
  mcndTPM = apply(epTPM,2,function(col){return(mean(col[col>0]))})
  plot(sumFPKM,mcnd)
  plot(sumFPKM,mcndTPM)
  
  #QC overlap in detected genes against Jaden
  
  exp_min = 5
  dtct = list()
  for (sample in colnames(epTPM)){
    dtct[[sample]] = rownames(epTPM)[which(epTPM[,sample]>exp_min)]
  }
  
  dtctJADEN = list() #jaden
  for (sampleJADEN in colnames(jt)){
    dtctJADEN[[sampleJADEN]] = rownames(jt)[which(jt[,sampleJADEN]>exp_min)]
  }
  
  
  ovlpAll = ovlpMat(dtct); diag(ovlpAll) = min(ovlpAll)
  ovlpAllJADEN = ovlpMat(dtctJADEN); diag(ovlpAllJADEN) = min(ovlpAllJADEN)
  
  pheatmap(ovlpAll,cluster_rows = FALSE,cluster_cols = FALSE,main = paste("Gene Correspondence Ratio - Epilepsy | Avg =",round(mean(ovlpAll[row(ovlpAll) != col(ovlpAll)]),2)))
  pheatmap(ovlpAllJADEN,cluster_rows = FALSE,cluster_cols = FALSE, main = paste("Gene Correspondence Ratio - Shin 2015 | Avg =",round(mean(ovlpAllJADEN[row(ovlpAllJADEN) != col(ovlpAllJADEN)]),2)))
  
  
  plot(sumFPKM,mcnd[names(sumFPKM)],xlab = "total reads",ylab = "mean raw read | > 0 ", main = "total reads vs mean read count (Raw)", pch = 19)
  per = round(cor(sumFPKM,mcnd[names(sumFPKM)]),3)
  legend('topleft', paste("pearson ~",per), bty='n', cex=1.2) 
  plot(sumFPKM,mcndTPM[names(sumFPKM)],xlab = "total reads",ylab = "mean TPM | > 0", main = "total reads vs mean read count (TPM)", pch = 19)
  per = round(cor(sumFPKM,mcndTPM[names(sumFPKM)]),3)
  legend('topleft', paste("pearson ~",per), bty='n', cex=1.2) 
  
  
  #QC: mean vs. sd
  u = apply(epTPM,1,mean)
  s = apply(epTPM,1,sd)
  plot(u,s,xlab = "mean",ylab = "stdev",main = "Mean vs Stdev - Raw",pch=".",cex=2)
  
  epTPM_Log = log10(epTPM); epTPM_Log[epTPM_Log==-Inf] = min(epTPM_Log[epTPM_Log>-Inf])
  uLog = apply(epTPM_Log,1,mean)
  sLog = apply(epTPM_Log,1,sd)
  plot(uLog,sLog,xlab = "mean",ylab = "stdev",main = "Mean vs Stdev - Log",pch=".",cex=2)
  
  #QC: dissimilarity 
  type.cols = rep("black",ncol(epTPM))
  type.cols[grep("NI",colnames(epTPM))] = "darkgreen"
  type.cols[grep("INT",colnames(epTPM))] = "red"
  type.cols[grep("X",colnames(epTPM))] = "grey"
  epClust = Waterfall.Cluster(epTPM,cell.cols = type.cols, nClusters = 2)
  
  type.cols = rep("black",ncol(epTPM))
  type.cols[which(colnames(epTPM) %in% names(sumFPKM[sumFPKM < median(sumFPKM)]))] = "blue"
  type.cols[which(colnames(epTPM) %in% names(sumFPKM[sumFPKM >= median(sumFPKM)]))] = "red"
  epClust = Waterfall.Cluster(epTPM,cell.cols = type.cols,nClusters = 2)

  rmIDX = which(colnames(epTPM) %in% c("SUB_NI_T541")) #"SUB_X_T473","CA1_INT_T517",
  type.cols = rep("black",ncol(epTPM))
  type.cols[rmIDX] = "darkgreen"
  epClust = Waterfall.Cluster(epTPM,cell.cols = type.cols, nClusters = 2)  
  
  epClust = Waterfall.Cluster(epTPM,nClusters = 2)
  epNum = epClust[,2]
  
  #colors
  ep.cols = epClust[colnames(epTPM),1]
  
  #remove Idx
  #rmIdx = which(colnames(epTPM) %in% names(epNum[epNum ==2]))
  ep = ep[,-rmIDX]
  epTPM = epTPM[,-rmIDX]
  ep.cols = ep.cols[-rmIDX]
  sumFPKM = sumFPKM[colnames(epTPM)]
  
  #Pseudotime
  ep.PT = Waterfall.Pseudotime(epTPM, angle=0, col = ep.cols, plot_title = "EP",label = TRUE,nclust = 3, seed = 5, invert_pt = T,scalePCA = F,lines=F,mst=F)
  
  epTPM = epTPM[,rownames(ep.PT)]
  ep.cols = ep.cols[colnames(epTPM)]
  type.cols
  epTPM["Pseudotime",] = ep.PT[,1]
  epTPM["Reads",] = sumFPKM[colnames(epTPM)]
  
  #QC reads vs. specific gene expression
  #plot(as.numeric(epTPM["Reads",]),as.numeric(epTPM[refnm(ens2name,"ACTB"),]),xlab = "Σ Raw Reads",main="Actin (TPM)",col=ep.cols, pch=19)
  #plot(as.numeric(epTPM["Reads",]),as.numeric(epTPM[refnm(ens2name,"PROX1"),]),xlab = "Σ Raw Reads",main="Prox1 (TPM)",col=ep.cols, pch=19)
  #plot(as.numeric(epTPM["Reads",]),as.numeric(epTPM[refnm(ens2name,"DCX"),]),xlab = "Σ Raw Reads",main="Dcx (TPM)",col=ep.cols,pch=19)
  
}


#analysis
INTcells = colnames(epTPM)[grep("INT",colnames(epTPM))]
NIcells = colnames(epTPM)[grep("NI",colnames(epTPM))]

INTsig = signatureAll(epTPM[,c(INTcells,NIcells)],INTcells)
genes = rownames(INTsig)
p = INTsig$pval 
fc = INTsig$log2FC
candidates = pvolcanoPlot(fc, p, genenames = genes, fcthresh = 4, alpha = .05)
toAffy(candidates$upGenes, candidates$dnGenes)

drug_priority = priorityCmap("data/permutedResults144947.xls",weightMat = c(5,2,5),betaMat = c(1/4,3,6),reordered_parent = "/Users/maxwellbay/Desktop")

upGO = getIntersectingGenesFromGo(stdFmt(candidates$upGenes), pval_thresh = .01,write_csv = TRUE,csv_path = "~/Desktop/UPgo.csv")
upGOp = NULL
for (i in 1:length(names(upGO))){
  upGOp = c(upGOp,upGO[[names(upGO)[i]]][1])
  
}
upGOp = -log10(as.numeric(upGOp))
names(upGOp) = names(upGO); upGOp = upGOp[order(upGOp)]


dnGO = getIntersectingGenesFromGo(stdFmt(candidates$dnGenes), pval_thresh = .01,write_csv = TRUE,csv_path = "~/Desktop/DNgo.csv")
dnGOp = NULL
for (i in 1:length(names(dnGO))){
  dnGOp = c(dnGOp,dnGO[[names(dnGO)[i]]][1])
  
}
dnGOp = -log10(as.numeric(dnGOp))
names(dnGOp) = names(dnGO); dnGOp = dnGOp[order(dnGOp)]

par(mai=c(1,3,1,1))
barplot(upGOp,horiz = TRUE,las=1,cex.names=.75,col="lightblue",main = "Upregulated GO Terms",xlab = "-log10p")
par(mai=c(3,4.5,1,1))
barplot(dnGOp,horiz = TRUE,las=1,cex.names=.75,col="red",main = "Downregulated GO Terms", xlab = "-log10p")

gene_list = c("VDAC3","EGR1","ESD","MBNL2","MTMR2","FMR1")
candidates$upGenes[toupper(candidates$upGenes) %in% gene_list]
candidates$dnGenes[toupper(candidates$dnGenes) %in% gene_list]

gene_list = c("VDAC3","EGR1","ESD","MBNL2","MTMR2","FMR1")
sigGenes[sigGenes %in% gene_list]

ord = order(apply(epTPM,1,var),decreasing = TRUE)
epTPMLess = t(epTPM[ord[1:5000],])

epNet = networkAnalysisBlock(epTPMLess,minModuleSize = 35, softPower = 10,tmp_thresh = NULL,top_var = NULL,module_genes_path = "~/Desktop/epModules.csv", block_save_dir = "~/Desktop/epDat", association_names = TRUE,plotMatrix = FALSE)
asMod = findBestModule(epNet$moduleMat,t(epTPMLess),PT,window=c(45,80),take_top = 20)


