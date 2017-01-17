source("src/Waterfall.R")
source("src/HyperGeoTerms.R")
source("src/GeneConversion.R")

library("xlsx")

library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(org.Hs.eg.db)
library(reshape)

hg19GeneLengths = function(symbols){
  require(TxDb.Hsapiens.UCSC.hg19.knownGene) 
  exons.db = exonsBy(TxDb.Hsapiens.UCSC.hg19.knownGene, by='gene')    
  egs    = unlist(  mget(symbols[ symbols %in% keys(org.Hs.egSYMBOL2EG) ],org.Hs.egSYMBOL2EG) )
  sapply(egs,function(eg)
  {
    exons = exons.db[[eg]]
    exons = reduce(exons)
    sum( width(exons) )
  })
}

splitRows = function(str,spltr,idx){
    return(strsplit(str,spltr)[[1]][idx])
}

EXPRESSION_PATH = "data/exonic_raw_data_types.csv"
LABELS_PATH = "data/U01_cell_log_10_25_2016.csv"

dat = read.csv(EXPRESSION_PATH )
dat = as.data.frame(dat[-grep("@AMBIG",dat[,1]),])
dat = as.data.frame(dat[-grep("/",dat[,1]),])

ensID = as.vector(sapply(as.character(dat[,1]),function(str){
  str = strsplit(str,"/")[[1]][1]
  str = strsplit(str,",")[[1]][1]
  return(str)
}))

gNms= as.vector(sapply(as.character(dat[,1]),function(str){
  str = strsplit(str,"/")[[1]][1]
  str = strsplit(str,",")[[1]][2]
  str = strsplit(str,"@")[[1]][1]
  return(str)
}))

names(gNms) = ensID
rownames(dat) = ensID
dat = dat[,2:256]

#Convert raw data in TPM
end = c()
for (gene in gNms){
  try({
    end = append(end,(geneLengths(gene)))
  })
}
end_stack = stack(end)
end_unique = aggregate(end_stack['values'], by=end_stack["ind"],sum)
chow_lengths = end_unique$values
names(chow_lengths) = end_unique$ind
remove = c(names(gNms[gNms %notin% names(chow_lengths)]))
dat = dat[-which(rownames(dat) %in% remove),]
dat = aggregate(dat,by=list(names(end)),sum)
rownames(dat) = dat$Group.1
dat = dat[,2:256]

start = rep(0,length(chow_lengths))
datTPM = raw2TPM(dat,start,chow_lengths)
rownames(datTPM) = capitalize(tolower(rownames(datTPM)))
save(datTPM, file="chow_datTPM.RData")
#load("chow_datTPM.RData")

#Clustering/Waterfall

chow_clust = Waterfall.Cluster(datTPM)
chow_cols = chow_clust[,1]

chow.PT = Waterfall.Pseudotime(datTPM, angle=180, col = chow_cols, plot_title = " Chow", nclust = 5, seed = 5, invert_pt = F,scalePCA = F,lines=F,mst=F)

#Sort by PT, create a dummy gene called "PT"
chow_cols = chow_cols[rownames(chow.PT)]
datTPM = datTPM[,rownames(chow.PT)]
datTPM["Pseudotime",] = chow.PT[,1]


