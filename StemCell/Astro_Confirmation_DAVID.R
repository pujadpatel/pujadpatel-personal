library("RDAVIDWebService")
source("load/load_GOdb.R")
source("utils/baseB.R")

david = DAVIDWebService(email="pujadpat@usc.edu", url="https://david.ncifcrf.gov/webservice/services/DAVIDWebService.DAVIDWebServiceHttpSoap12Endpoint/")
Idt = getIdTypes(david)
genes = at_allA_genes

data("demoList1")
#result<-addList(david, demoList1, idType="AFFYMETRIX_3PRIME_IVT_ID", listName="demoList1", listType="Gene")
ent = AnnotationDbi::select(org.Mm.eg.db, genes, "ENTREZID", "SYMBOL")[,2]
result = addList(david, ent, idType="ENTREZ_GENE_ID", listName="ent", listType="Gene")


termCluster = getClusterReport(david, type="Term")
getClusterReportFile(david, type="Term", fileName="termClusterReport_at_n1.tab")

#pid = as.character(names(trms[50]))
#fileName = system.file("files/termClusterReport_at_n1.tab.tar.gz", package="RDAVIDWebService")
#untar(fileName)
#termCluster = DAVIDTermCluster(untar(fileName, list=TRUE))
termCluster

#head(summary(termCluster))
summary(termCluster)
plot2D(termCluster, 2)

higherEnrichment = which.max(RDAVIDWebService::enrichment(termCluster))
clusterGenes = members(termCluster)[[higherEnrichment]]
#wholeCluster<-cluster(termCluster)[[higherEnrichment]]

ids(termCluster)
ids(termCluster)[[higherEnrichment]]

plot2D(termCluster, number=higherEnrichment)

#Functional Annotation Chart
genesA = groupA_gene
entA = AnnotationDbi::select(org.Mm.eg.db, genesA, "ENTREZID", "SYMBOL")[,2]
result = addList(david, entA, idType="ENTREZ_GENE_ID", listName="entA", listType="Gene")

AnnotationChartA = getFunctionalAnnotationChart(david)
categories(AnnotationChartA)
ids(AnnotationChartA) #ids of genes present in each term

PVAL_THRESH = 0.01
go_terms_groupA=c()
for (i in 1:dim(AnnotationChartA)[1])
{
  if (AnnotationChartA[i,5] <= PVAL_THRESH & (length(grep("GOTERM", AnnotationChartA[i,1])) == 1)){
    go_terms_groupA <- append(go_terms_groupA, AnnotationChartA[i,2])
  }
}
#Group B
genesB = groupB_gene
entB = AnnotationDbi::select(org.Mm.eg.db, genesB, "ENTREZID", "SYMBOL")[,2]
result = addList(david, entB, idType="ENTREZ_GENE_ID", listName="entB", listType="Gene")

AnnotationChartB = getFunctionalAnnotationChart(david)
go_terms_groupB=c()
for (i in 1:dim(AnnotationChartB)[1])
{
  if (AnnotationChartB[i,5] <= PVAL_THRESH & (length(grep("GOTERM", AnnotationChartB[i,1])) == 1)){
    go_terms_groupB <- append(go_terms_groupB, AnnotationChartB[i,2])
  }
}-
#Barres Astrocytes
genesBar = bares_astro_fc
entBar = AnnotationDbi::select(org.Mm.eg.db, genesBar, "ENTREZID", "SYMBOL")[,2]
result = addList(david, entBar, idType="ENTREZ_GENE_ID", listName="entBar", listType="Gene")

AnnotationChartBar = getFunctionalAnnotationChart(david)
go_terms_barres=c()
for (i in 1:dim(AnnotationChartBar)[1])
{
  if (AnnotationChartBar[i,5] <= PVAL_THRESH & (length(grep("GOTERM", AnnotationChartBar[i,1])) == 1)){
    go_terms_barres <- append(go_terms_barres, AnnotationChartBar[i,2])
  }
}
#Ana Astrocytes
genesAna = at_allA_genes
entAna = AnnotationDbi::select(org.Mm.eg.db, genesAna, "ENTREZID", "SYMBOL")[,2]
result = addList(david, entAna, idType="ENTREZ_GENE_ID", listName="entAna", listType="Gene")

AnnotationChartAna = getFunctionalAnnotationChart(david)
go_terms_ana=c()
for (i in 1:dim(AnnotationChartAna)[1])
{
  if (AnnotationChartAna[i,5] <= PVAL_THRESH & (length(grep("GOTERM", AnnotationChartAna[i,1])) == 1)){
    go_terms_ana <- append(go_terms_ana, AnnotationChartAna[i,2])
  }
}

gA_Bar_GO = intersect(go_terms_groupA, go_terms_barres)
gB_Bar_GO = intersect(go_terms_groupB, go_terms_barres)

gA_Ana_GO = intersect(go_terms_groupA, go_terms_ana)
gB_Ana_GO = intersect(go_terms_groupB, go_terms_ana)

intersect(go_terms_ana, go_terms_barres)

#Venn Diagram of jointly occuring GO term in groupA-Barres and groupA-Ana 
grid.newpage()
draw.pairwise.venn(length(gA_Bar_GO), length(gA_Ana_GO), length(intersect(gA_Ana_GO,gA_Bar_GO)), 
                   category = c("groupA & Barres","groupA & Ana"), lty = rep("blank",2), 
                   fill = c("light blue", "pink"), alpha = rep(.5,2), cat.pos = rep(0,2), cat.dist = rep(0.025, 2))


#Fisher's Exact Test
j_groups = c("groupA", "groupB")
b_groups = c("barres","ana")

sig_array = matrix(0,nrow = length(b_groups),ncol = length(j_groups)); rownames(sig_array) = b_groups; colnames(sig_array) = j_groups
group_compare = c()
for (group1_name in j_groups){
  group1 = get(paste0("go_terms_", group1_name))
  for (group2_name in b_groups){ 
    group2 = get(paste0("go_terms_", group2_name))
    
    group_compare_i = paste0(group1_name,"_vs","_",group2_name)
    group_compare = c(group_compare,group_compare_i)
    x = length(which(group1 %in% group2))# white ball from drawn
    m = length(group2)# white balls in urn
    n = length(trms)-m # black balls in urn
    k = length(group1)# number of balls drawn
    significance_i = phyper(x,m,n,k,lower.tail=F,log=F)
    sig_array[group2_name,group1_name] = significance_i
    #write.table(group1[group1 %in% group2],file=paste0(group1_name,"_overlapwith_",group2_name,".txt"),sep="\t",quote=F)
  }
  #print(data.frame(Overlapping_pair=group_compare, Fisher_exact_test=significance))
  #write.table(cbind(group_compare,significance),file=paste0("Hypergeometric_Distribution.txt"),row.names=F,col.names=c("Overlapping Pair","Fisher_exact_test"))
  
}

alpha = .000001
colfunc <- colorRampPalette(c("black", "gray90"))
c = colfunc(2)
tb = sig_array
tb[tb <= alpha] = 0; tb[tb > alpha] = 1
pheatmap(tb,color = c,cluster_rows = FALSE, cluster_cols = FALSE,legend=FALSE,cellwidth = 20,cellheight = 20)

intersectionGoBar = matrix(c(length(gA_Bar_GO),length(gB_Bar_GO)),ncol=2)
colnames(intersectionGoBar)=c("Group A", "Group B")
intersectionGoAna = as.table(intersectionGoBar)
bp = barplot(intersectionGoBar, main="GO terms common with Zhang et al.",ylab="",horiz = TRUE,cex.names = 1,cex.main = 1)
label = c(paste0("p = ",pvalFormat(sig_array["barres","groupA"])),paste0("p = ",pvalFormat(sig_array["barres","groupB"])))
intersectionGoBar[2] = intersectionGoBar[1]
text(x = c(intersectionGoBar)/2, y = bp, label = label, cex = 2, col = "red")

intersectionGoAna = matrix(c(length(gA_Ana_GO),length(gB_Ana_GO)),ncol=2)
colnames(intersectionGoAna)=c("Group A", "Group B")
intersectionGoAna = as.table(intersectionGoAna)
bp = barplot(intersectionGoAna, main="GO terms common with Llorens-Bobadilla et al.",ylab="",horiz = TRUE,cex.names = 1,cex.main=1)
label = c(paste0("p = ",pvalFormat(sig_array["ana","groupA"])),paste0("p = ",pvalFormat(sig_array["ana","groupB"])))
intersectionGoAna[2] = intersectionGoAna[1]
text(x = c(intersectionGoAna)/2, y = bp, label = label, cex = 2, col = "red")
