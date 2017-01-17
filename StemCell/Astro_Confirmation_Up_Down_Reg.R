#Upregulated & Downregulated Gene Comparisons (s2->s1 in JT to Ana's and Barres')

source("load/LoadData.R")
source("load/LoadData_Barres.R")
source("load/LoadData-Ana.R")

#Pseudotime in Astrogenic direction 
jt.PT = Waterfall.Pseudotime( jt, angle=0, col = jt.cols, plot_title = " Adult", nclust = 5, seed = 5, scalePCA = F,lines=T, invert_pt = T)
jta.PT = jt.PT[c(S1.id,S2.id),]

pt.rescale = function(X){
  return(100/(max(jta.PT[,1])-min(jta.PT[,1]))*(X-100)+100)}
jta.PT[,1] <- sapply(jta.PT[,1],pt.rescale)
jta.PT = jta.PT[order(jta.PT[,1]),]

jta.cols=jt.cols[rownames(jta.PT)]
plot(jta.PT, col = jta.cols, cex=2, pch=20, main = paste0("Pseudotime Astrogenesis Jaden"),xlab = "Pseudotime" )
jta=jt[,rownames(jta.PT)]
jta["Pseudotime",rownames(jta.PT)] = jta.PT[,1]

#Spearman Correlation on All Genes in Jt- Matrix
jg = rownames(jt.all)
ag = rownames(at)
all_both = intersect(jg,ag)
j.spearman <- matrix(nrow = length(all_both), ncol = 2)
rownames(j.spearman) = all_both
colnames(j.spearman) = c("Rho", "P-value")

for (geneName in all_both)
{
  j.spearm.test = cor.test(seq(0,100,1),PTgeneplot.trend(geneName,jta,jta["Pseudotime",]), method = "spearm")
  j.spearman[geneName,1] = j.spearm.test[[4]]
  j.spearman[geneName,2] = j.spearm.test[[3]]
}

j.spearman = j.spearman[order(j.spearman[,2]),]

#All genes, specific rho/p values
j.spearm.allgenesUP = c()
j.spearm.allgenesDOWN = c()
rho = 0.75
p = 0.001
for (geneName in all_both)
{
  #if max tpm at least 50
  if (max(jta[geneName,])>=50 & (mean(as.numeric(jta[geneName,S1.id])))>=100){
   if (is.na(j.spearman[geneName,2])) {
      next();
    }
    if (j.spearman[geneName,2]<=p & j.spearman[geneName,1]>=rho) 
    {
      #PTgeneplot(geneName,jta,jta["Pseudotime",],col=jta.cols)
      j.spearm.allgenesUP = append(j.spearm.allgenesUP,geneName)
    }
    if (j.spearman[geneName,2]<=p & j.spearman[geneName,1]<=-rho) 
    {
      #PTgeneplot(geneName,jta,jta["Pseudotime",],col=jta.cols)
      j.spearm.allgenesDOWN = append(j.spearm.allgenesDOWN,geneName)
    }
  }
}

#Barres Astro
barres_astro_fc_up = names(foldChange(bt[both,],2:7,1,thresh = 2)[1:500])
barres_astro_fc_down = names(foldChange(bt[both,],2:7,1,thresh = 0,decreasing=F)[1:500])

#Ana's Astro UP
at_allA_n_df = signature(at[both,c(at_allA,at_n)],at_allA,sig_thresh = SIG_THRESH); at_allA_n_gene = rownames(at_allA_n_df); 
at_allA_tap_df = signature(at[both,c(at_allA,at_TAP)],at_allA,sig_thresh = SIG_THRESH); at_allA_tap_gene = rownames(at_allA_tap_df); 
at_allA_genes_up = intersect(at_allA_n_gene,at_allA_tap_gene)

#Ana's Astro DOWN
at_n_allA_df = signature(at[both,c(at_allA,at_n)],at_n,sig_thresh = SIG_THRESH); at_n_allA_gene = rownames(at_n_allA_df); 
at_tap_allA_df = signature(at[both,c(at_allA,at_TAP)],at_TAP,sig_thresh = SIG_THRESH); at_tap_allA_gene = rownames(at_tap_allA_df); 
at_allA_genes_down = intersect(at_n_allA_gene,at_tap_allA_gene)

up_genes = Reduce(intersect, list(j.spearm.allgenesUP, barres_astro_fc_up, at_allA_genes_up))
#down_genes = Reduce(intersect, list(j.spearm.allgenesDOWN, barres_astro_fc_down, at_n_allA_gene))     
down_genes= intersect(j.spearm.allgenesDOWN, at_n_allA_gene)

