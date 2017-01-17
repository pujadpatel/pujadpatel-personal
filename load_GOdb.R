library(GO.db)
library(org.Mm.eg.db)

hasGenes = function(trms){
  has_genes = c()
  for (i in 1:length(trms)){ 
    genes = c()
    try(expr = (genes = (get(term_ids[i], org.Mm.egGO2ALLEGS))),silent=TRUE)
    print(length(genes))
    if (length(genes)>0) has_genes = c(has_genes,i)
    
  }
  
  return(has_genes)
}


trms = Term(GOTERM)
term_ids = names(trms); names(term_ids) = trms
ontg = Ontology(GOTERM)

#trms_wg = hasGenes(trms)
