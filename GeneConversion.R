############################################################
# GeneConversion.R
#
# Suite of functions to convert RNA seq data from FPKM/RPKM 
# to Raw Counts/CPM and determine gene lengths
#
############################################################

library(TxDb.Hsapiens.UCSC.hg19.knownGene) 
library(org.Hs.eg.db)
#library(org.Hs.egSYMBOL2EG)

#scaling factors = sum of reads per sample/1000000
scalingFactors <- function(raw_data){
  sf = matrix(0,nrow = 1,ncol = dim(raw_data)[2])
  colnames(sf) = colnames(raw_data)
  for(i in 1:dim(raw_data)[2]){
    sf[1,i]=sum(raw_data[,i])
  }
  return (sf)
}

#returns gene lengths for various genes using org.HS.egSYMBOL2EG
geneLengths <- function(gene)
{
  exons.db = exonsBy(TxDb.Hsapiens.UCSC.hg19.knownGene, by='gene')    
  egs = unlist(  mget(gene[ gene %in% mappedkeys(org.Hs.egSYMBOL2EG) ],org.Hs.egSYMBOL2EG) )
  sapply(egs,function(eg)
  {
    exons = exons.db[[eg]]
    exons = reduce(exons)
    sum( width(exons) )
  })
}

#converts to entrezid
entrez_gene <-function(gene) {return (AnnotationDbi::select(org.Hs.eg.db, gene, "ENTREZID", "SYMBOL")[,2])}

#converts to cpm from FPKM or RPKM
CPMconversion <- function(raw_data){
  sf = scalingFactors(raw_data)
  lengths = matrix(nrow=dim(raw_data)[1], ncol= 1)
  rownames(lengths) = rownames(raw_data)
  for (i in 1:dim(lengths)[1]){
    try({
      lengths[i,1] = geneLengths(rownames(lengths)[i])
    })
  }
  cpm = matrix(0,nrow=dim(raw_data)[1], ncol= dim(raw_data)[2])
  colnames(cpm)=colnames(raw_data); rownames(cpm)=rownames(raw_data)
  for (i in 1:dim(raw_data)[1]){
    for (j in 1:dim(raw_data)[2]){
      cpm[i,j]=raw_data[i,j]*lengths[i,1]*sf[1,j]
    }
  }
  return (cpm)
}
