source("src/Waterfall.R")
source("utils/baseB.R")

#Jaden's Data: Astrogenesis
par(mfrow=c(1,1))
jt = read.table("data/Jaden_TPM_NSC.txt") #the full Dataset is jt
jt = ScaleTPM(jt)
grx = Waterfall.Cluster(jt, nClusters = 6)
jt.cols = grx[,1] #Includes SA
#Color S0: Purple
S0 = c("C11","C16","C25","C28","C13")
grx[S0,1] = "purple"

jt.all = jt 
anno = grx;
anno[anno=="6"] = "A" 
anno = list("V1" = anno[,2])
jt.cols.all = grx[,1] 

#Removes everything but S2, S1, S0
jt = jt[,grx[,2] %notin% c(3,4,5,6)]
jt.cols = grx[,1][grx[,2] %notin% c(3,4,5,6)]
jt = Waterfall.go.CleanData(jt)

jt.PT = Waterfall.Pseudotime( jt, angle=180, col = jt.cols, plot_title = " Astrogenesis", nclust = 5, seed = 5, scalePCA = F, invert_pt = T)

jt.cols = jt.cols[rownames(jt.PT)]
jt = jt[,rownames(jt.PT)]
jt["Pseudotime",] = jt.PT[,1]

Kegg.processes = read.csv("data/KeggProcesses.txt", header = T)

c(mfrow=c(3,3))
fits.all1 = MakeMultipleKeggPlots.Sin(1:50, jt) # for illustrative processes, I used 1:50, for all processes use 1:476 
dim(fits.all1)
colnames(fits.all1) = colnames(jt)
fits.all1 = rbind(fits.all1, jt["Pseudotime",])
write.table(fits.all1, file = "AllKeggProcesses-Jaden.txt")

#DOWN REGULATED PROCESSES
par(mfrow=c(1,1))
JadenKegg = read.table( "data/AllKeggProcesses-Jaden.txt")
#define query
query1 = function(pt, TPM){
  #query function to be performed on a given gene, takes pseudotime in x, TPM of the gene in y, 
  #returns processes where S2 < S1 < S0
  S0_value = mean(TPM[(pt>79) & (pt < 100) ])
  S1_value = mean( TPM[(pt>46) & (pt < 79) ] )
  S2_value = mean( TPM[pt<46] )
  return ((S0_value < S1_value) & (S1_value < S2_value))
}
# ID processes that satisfy the query
q1_output = apply(JadenKegg, 1, function(Row) query1(JadenKegg["Pseudotime",], Row) )
#save plots of processes that satisfy the query
plotQuery(ProcessDataset = JadenKegg, queryOutput = q1_output, outputname = "Astrogenesis_Jaden_S2>S1>S0.pdf") #code in WaterfallRishi.R

#UP REGULATED PROCESSES
par(mfrow=c(1,1))
JadenKegg = read.table( "data/AllKeggProcesses-Jaden.txt")
#define query
query2 = function(pt, TPM){
  #query function to be performed on a given gene, takes pseudotime in x, TPM of the gene in y, 
  #returns processes where S2 > S1 > S0
  S0_value = mean(TPM[(pt>79) & (pt < 100) ])
  S1_value = mean( TPM[(pt>46) & (pt < 79) ])
  S2_value = mean( TPM[pt<46] )
  return ((S0_value > S1_value) & (S1_value > S2_value))
}
#ID processes that satisfy the query
q2_output = apply(JadenKegg, 1, function(Row) query2(JadenKegg["Pseudotime",], Row) )
#save plots of processes that satisfy the query
plotQuery(ProcessDataset = JadenKegg, queryOutput = q2_output, outputname = "Astrogenesis_Jaden_S2<S1<S0.pdf") #code in WaterfallRishi.R
