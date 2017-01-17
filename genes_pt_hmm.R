source("src/Waterfall.R")
source("load/LoadData.R")
source("script/Astrogenesis_AnaData.R")
source("utils/baseB.R")
Kegg.processes = read.csv("data/KeggProcesses.txt", header = T)

#Genes for Jaden's Data
PTgeneplot("Mapt",PT=t(jneuro["Pseudotime",]),TPM_data=jneuro,col=jneuro.cols, main= "Mapt-Jaden")
PTgeneplot("3110043O21Rik",PT=t(jneuro["Pseudotime",]),TPM_data=jneuro,col=jneuro.cols, main= "3110043O21Rik-Jaden")

pseudotime.foo("Mapt", TPM_data=jt,PT=t(jt["Pseudotime",]))
pseudotime.foo("3110043O21Rik", TPM_data=jt,PT=t(jt["Pseudotime",]))

#Genes for Ana's Data
aneuro = at[, at["Pseudotime",] > 15] #exluding S0
aneuro.cols = at.cols[at["Pseudotime",] > 15] 
grx = Waterfall.Cluster(aneuro, nClusters = 6)
aneuro.cols = grx[,1] 

pseudotime.foo("Mapt", TPM_data=at,PT=t(at["Pseudotime",]))
pseudotime.foo("3110043O21Rik", TPM_data=at,PT=t(at["Pseudotime",]))

#Correlations
gene1_jt = jt["3110043O21Rik",]
gene2_jt = jt["Mapt",]

correlated_genes <-data.frame()
for (i in 1:109)
{
  if ((gene1_jt[i] > 0) & (gene2_jt[i] > 0))
  {
    #correlated_genes <- rbind(correlated_genes,c((colnames(gene1_jt[i])),gene1_jt[,i]))
    print(colnames(gene1_jt[i]))
    print((gene1_jt[1,i]))
  }
}

gene1_at = at["3110043O21Rik",]
gene2_at = at["Mapt",]
for (i in 1:112)
{
  if ((gene1_at[i] > 0) & (gene2_at[i] > 0))
  {
    print(colnames(gene1_at[i]))
    print((gene1_at[,i]))
  }
}

#"Hgf", "Aqp4", "Itih3", "Bmpr1b", "Itga7", "Plcd4", "Grm3", "Slc14a1","Phkg1","Pla2g3","Cbs","Paqr6","Aldh1l1","Cth","Ccdc80","Fmo1","Slc30a10","Slc6a11","Fgfr3","Slc4a4","Gdpd2","Ppp1r3c","Grhl1","Entpd2","Egfr","Otx1"
for (PDcomponent in c("Nwd1","Atp13a4","Kcnn3","Ptx3","Tnc","Sox9","Abcd2","Fzd10","Lrig1","Mlc1","Chrdl1","Aifm3" ))
{
  PTgeneplot(PDcomponent,PT=t(jneuro["Pseudotime",]),TPM_data=jneuro,col=jneuro.cols, main= PDcomponent)
  pseudotime.foo(PDcomponent, TPM_data=jt,PT=t(jt["Pseudotime",]))
}
