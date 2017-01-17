#Load Ana- NSC are 2 groups

source("src/HyperGeoTerms.R")
source("src/Waterfall.R")
#source("load/LoadData.R")

at = read.table("data/Ana_TPM_NSC.csv")
at = ScaleTPM(at) 

#remove outlier N_GP_15B
removeIndex = which(colnames(at) == "N_GP_15B" )
at = at[, colnames(at)[-removeIndex]]
at = ScaleTPM(at) #normalize in such a way that each gene's TPM is essentially a percentage of the total TPM for a given cell

a.n.cols = Waterfall.Cluster(at[N.id], nClusters = 4)[,1]
at.cols = c() #colors
at.cols[colnames(at)] = "purple" #expect to see no purple if all are labeld well
at.cols[grep("str", colnames(at))] = "black"
at.cols[grep("ctx", colnames(at))] = "black"
at.cols[grep("tap", colnames(at))] = "yellow"

at.cols[names(a.n.cols)] = a.n.cols

at.Pt2 =Waterfall.Pseudotime( at, col = at.cols, angle = 0,  plot_title = " Ana", nclust = 5, seed = 5, scalePCA = T, invert_pt = F)

at.cols = at.cols[rownames(at.Pt2)]
at =at[,rownames(at.Pt2)]
at["Pseudotime",] = at.Pt2[,1]

N1.id = names(at.cols[at.cols=="#13751B"])
jg = rownames(jt.all)
ag = rownames(at)
both = intersect(jg,ag)
all_a = at[both,]

at_n1_df <-signature(all_a,N1.id,sig_thresh = 0.001, mean_thresh = 50)
at_n1_gene = rownames(at_n1_df)

path_to_file = paste0("~/Desktop/astrogenesis-down.pdf")
pdf(file=path_to_file, width=10, height=10)
par(mfrow=c(2,2), mar=c(1.2,1.2,1.2,1.2) + .5)

for (geneName in at_n1_gene)
{
  PTgeneplot(geneName,jt,as.numeric(jt["Pseudotime",]),col=jt.cols,hmm=T)
}

dev.off()

write.csv(t(t(at_n1_gene)),file = "~/Desktop/pre-astro.csv" )

