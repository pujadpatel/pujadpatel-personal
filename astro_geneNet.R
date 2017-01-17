source("src/Waterfall.R")
source("load/LoadData.R")
#source("script/dp2_2016.R")

#Gene Network Analysis
count = 5000
top_var = apply(jt,1,sd)
top_var = top_var[order(top_var,decreasing = TRUE)]
top_var = top_var[1:count]

#build expression trend in parallel
nCores = detectCores()
if (nCores > 1) nCores = nCores - 1
cl = makeCluster(nCores)

clusterExport(cl,c("jt")) #variables 
clusterExport(cl, c("PTgeneplot.trend")) #functions

jtTrend = parApply(cl,jt[names(top_var),],1,function(v) PTgeneplot.trend(v,jt["Pseudotime",]))
jtTrend = t(jtTrend)
stopCluster(cl)

#jt including only top n most variable genes
jtLess = t(jt[names(top_var),])

#try size 30
astroNet = networkAnalysisBlock(jtLess,minModuleSize = 50, softPower = 4,tmp_thresh = NULL,top_var = NULL,module_genes_path = "~/Desktop/dp2Modules.csv", block_save_dir = "~/Desktop/dp2Dat", association_names = TRUE,plotMatrix = FALSE)
#par(mar=c(1,1,1,1))
v = findBestModule(astroNet$moduleMat,t(jtLess),PT,window=c(min(jt.PT[S2.id,1]),max(jt.PT[S3.id,1])),take_top = 10)
dev.off();
v1 = findBestModuleDifferential(astroNet$moduleMat,t(jtLess),PT,take_top = 10,group_1=S2.id, group_2 = S3.id)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        dev.off();


#Module Preservation

#Combined group of S3, S4
sub = jt[,c(S3.id,S4.id)]
top_var_sub = apply(sub,1,sd)
top_var_sub = top_var_sub[order(top_var_sub,decreasing = TRUE)]
top_var_sub = top_var_sub[1:count]
jtLessSub = t(sub[names(top_var_sub),])

setLabels= c("All_jt","S3_S4")
multiExpr = list(All_jt = list(data=jtLess),S3_S4 = list(data = jtLessSub));
multiColor = list(All_jt = astroNet$modColors);

mp = modulePreservation(multiExpr, multiColor, referenceNetworks=1,
                        nPermutations = 100,
                        networkType = "unsigned",
                        randomSeed = 2345,
                        permutedStatisticsFile = "halfPreserved-noReg-permStats.RData",
                        verbose = 4, indent = 0)

save(mp, file="modulePreservation_S3S4.RData")
#load("modulePreservation_S3S4.RData")

#Isolate z scores and observed statistics
ref = 1
test = 2
statsObs = cbind(mp$quality$observed[[ref]][[test]][, -1], mp$preservation$observed[[ref]][[test]][, -1])
statsZ = cbind(mp$quality$Z[[ref]][[test]][, -1], mp$preservation$Z[[ref]][[test]][, -1]);

# Compare preservation to quality:
print( cbind(statsObs[, c("medianRank.pres", "medianRank.qual")],
             signif(statsZ[, c("Zsummary.pres", "Zsummary.qual")], 2)) )

# Module labels and module sizes are also contained in the results
modColors = rownames(mp$preservation$observed[[ref]][[test]])
moduleSizes = mp$preservation$Z[[ref]][[test]][, 1];
names(moduleSizes) = modColors
text = modColors;
# Auxiliary convenience variable
plotData = cbind(mp$preservation$observed[[ref]][[test]][, 2], mp$preservation$Z[[ref]][[test]][, 2])
rownames(plotData) = modColors
mains = c("Preservation Median rank S3,S4", "Preservation Zsummary S3,S4");
sizeGrWindow(10, 5);
par(mfrow = c(1,2))
par(mar = c(4.5,4.5,2.5,1))
for (p in 1:2)
{
  min = min(plotData[, p], na.rm = TRUE);
  max = max(plotData[, p], na.rm = TRUE);
  # Adjust ploting ranges appropriately
  if (p==2)
  {
    if (min > -max/10) min = -max/10
    ylim = c(min - 0.1 * (max-min), max + 0.1 * (max-min))
  } 
  else {
    ylim = c(max + 0.1 * (max-min), min - 0.1 * (max-min))
  }
  plot(moduleSizes[modColors], plotData[modColors, p], col = 1, bg = modColors, pch = 21,
       main = mains[p],
       cex = 2.4,
       ylab = mains[p], xlab = "Module size", log = "x",
       ylim = ylim,
       xlim = c(10, 2000), cex.lab = 1.2, cex.axis = 1.2, cex.main =1.4)
    text(moduleSizes[modColors], plotData[modColors, p], labels=text,cex=0.7,pos=4)
}

#Significant modules
sig_modules_S3S4 = plotData[,1][(1/plotData[,1])>0.1]

#S3 Module Preservation
sub = jt[,c(S3.id)]
top_var_sub = apply(sub,1,sd)
top_var_sub = top_var_sub[order(top_var_sub,decreasing = TRUE)]
top_var_sub = top_var_sub[1:count]
jtLessSub = t(sub[names(top_var_sub),])

setLabels= c("All_jt","S3")
multiExpr = list(All_jt = list(data=jtLess),S3 = list(data = jtLessSub));
multiColor = list(All_jt = astroNet$modColors);

mpS3 = modulePreservation(multiExpr, multiColor, referenceNetworks=1,
                        nPermutations = 100,
                        networkType = "unsigned",
                        randomSeed = 2345,
                        permutedStatisticsFile = "halfPreserved-noReg-permStats.RData",
                        verbose = 4, indent = 0)

save(mpS3, file="modulePreservation_S3.RData")

#Isolate z scores and observed statistics
ref = 1
test = 2
statsObs = cbind(mpS3$quality$observed[[ref]][[test]][, -1], mpS3$preservation$observed[[ref]][[test]][, -1])
statsZ = cbind(mpS3$quality$Z[[ref]][[test]][, -1], mpS3$preservation$Z[[ref]][[test]][, -1]);

# Compare preservation to quality:
print( cbind(statsObs[, c("medianRank.pres", "medianRank.qual")],
             signif(statsZ[, c("Zsummary.pres", "Zsummary.qual")], 2)) )

# Module labels and module sizes are also contained in the results
modColors = rownames(mpS3$preservation$observed[[ref]][[test]])
moduleSizes = mpS3$preservation$Z[[ref]][[test]][, 1];
names(moduleSizes) = modColors
text = modColors;
# Auxiliary convenience variable
plotData = cbind(mpS3$preservation$observed[[ref]][[test]][, 2], mpS3$preservation$Z[[ref]][[test]][, 2])
rownames(plotData) = modColors
mains = c("Preservation Median rank S3", "Preservation Zsummary S3");
sizeGrWindow(10, 5);
par(mfrow = c(1,2))
par(mar = c(4.5,4.5,2.5,1))
for (p in 1:2)
{
  min = min(plotData[, p], na.rm = TRUE);
  max = max(plotData[, p], na.rm = TRUE);
  # Adjust ploting ranges appropriately
  if (p==2)
  {
    if (min > -max/10) min = -max/10
    ylim = c(min - 0.1 * (max-min), max + 0.1 * (max-min))
  } 
  else {
    ylim = c(max + 0.1 * (max-min), min - 0.1 * (max-min))
  }
  plot(moduleSizes[modColors], plotData[modColors, p], col = 1, bg = modColors, pch = 21,
       main = mains[p],
       cex = 2.4,
       ylab = mains[p], xlab = "Module size", log = "x",
       ylim = ylim,
       xlim = c(10, 2000), cex.lab = 1.2, cex.axis = 1.2, cex.main =1.4)
  text(moduleSizes[modColors], plotData[modColors, p], labels=text,cex=0.7,pos=4)
}

sig_modules_S3 = plotData[,1][(1/plotData[,1])>0.1]

#S4 Module Preservation
sub = jt[,c(S4.id)]
top_var_sub = apply(sub,1,sd)
top_var_sub = top_var_sub[order(top_var_sub,decreasing = TRUE)]
top_var_sub = top_var_sub[1:count]
jtLessSub = t(sub[names(top_var_sub),])

setLabels= c("All_jt","S4")
multiExpr = list(All_jt = list(data=jtLess),S4 = list(data = jtLessSub));
multiColor = list(All_jt = astroNet$modColors);

mpS4 = modulePreservation(multiExpr, multiColor, referenceNetworks=1,
                          nPermutations = 100,
                          networkType = "unsigned",
                          randomSeed = 2345,
                          permutedStatisticsFile = "halfPreserved-noReg-permStats.RData",
                          verbose = 4, indent = 0)

save(mpS4, file="modulePreservation_S4.RData")

#Isolate z scores and observed statistics
ref = 1
test = 2
statsObs = cbind(mpS4$quality$observed[[ref]][[test]][, -1], mpS4$preservation$observed[[ref]][[test]][, -1])
statsZ = cbind(mpS4$quality$Z[[ref]][[test]][, -1], mpS4$preservation$Z[[ref]][[test]][, -1]);

# Compare preservation to quality:
print( cbind(statsObs[, c("medianRank.pres", "medianRank.qual")],
             signif(statsZ[, c("Zsummary.pres", "Zsummary.qual")], 2)) )

# Module labels and module sizes are also contained in the results
modColors = rownames(mpS4$preservation$observed[[ref]][[test]])
moduleSizes = mpS4$preservation$Z[[ref]][[test]][, 1];
names(moduleSizes) = modColors
text = modColors;
# Auxiliary convenience variable
plotData = cbind(mpS4$preservation$observed[[ref]][[test]][, 2], mpS4$preservation$Z[[ref]][[test]][, 2])
rownames(plotData) = modColors
mains = c("Preservation Median rank S4", "Preservation Zsummary S4");
sizeGrWindow(10, 5);
par(mfrow = c(1,2))
par(mar = c(4.5,4.5,2.5,1))
for (p in 1:2)
{
  min = min(plotData[, p], na.rm = TRUE);
  max = max(plotData[, p], na.rm = TRUE);
  # Adjust ploting ranges appropriately
  if (p==2)
  {
    if (min > -max/10) min = -max/10
    ylim = c(min - 0.1 * (max-min), max + 0.1 * (max-min))
  } 
  else {
    ylim = c(max + 0.1 * (max-min), min - 0.1 * (max-min))
  }
  plot(moduleSizes[modColors], plotData[modColors, p], col = 1, bg = modColors, pch = 21,
       main = mains[p],
       cex = 2.4,
       ylab = mains[p], xlab = "Module size", log = "x",
       ylim = ylim,
       xlim = c(10, 2000), cex.lab = 1.2, cex.axis = 1.2, cex.main =1.4)
  text(moduleSizes[modColors], plotData[modColors, p], labels=text,cex=0.7,pos=4)
}

sig_modules_S4 = plotData[,1][(1/plotData[,1])>0.1]

#Find Modules Significant for Transition
sig_modules = sig_modules_S3S4[sig_modules_S3S4 %notin% c(sig_modules_S3,sig_modules_S4)]

for (module in (names(sig_modules_S3S4))){
  if ((module %in% names(sig_modules_S3)) && (sig_modules_S3S4[module]<sig_modules_S3[module])){
    if ((module %in% names(sig_modules_S4)) && (sig_modules_S3S4[module]<sig_modules_S4[module])){
      sig_modules = append(sig_modules, module)
    }
    else if (module %notin% names(sig_modules_S4)){
      sig_modules = append(sig_modules, module)
    }
  }
}

################################
# Module Preservation of S3 & S4 just within the S3/S4 subset


#S3 Module Preservation
sub = jt[,c(S3.id)]
top_var_sub = apply(sub,1,sd)
top_var_sub = top_var_sub[order(top_var_sub,decreasing = TRUE)]
top_var_sub = top_var_sub[1:count]
jtLessSub = t(sub[names(top_var_sub),])

set = jt[,c(S3.id,S4.id)]
top_var_set = apply(set,1,sd)
top_var_set = top_var_set[order(top_var_set,decreasing = TRUE)]
top_var_set = top_var_set[1:count]
jtLessS3S4 = t(set[names(top_var_set),])

setLabels= c("S3_S4","S3")
multiExpr = list(S3_S4 = list(data=jtLessS3S4),S3 = list(data = jtLessSub));
multiColor = list(S3_S4 = astroNet$modColors);

mpsubS3 = modulePreservation(multiExpr, multiColor, referenceNetworks=1,
                          nPermutations = 100,
                          networkType = "unsigned",
                          randomSeed = 2345,
                          permutedStatisticsFile = "halfPreserved-noReg-permStats.RData",
                          verbose = 4, indent = 0)

save(mpsubS3, file="modulePreservation_S3sub.RData")

#Isolate z scores and observed statistics
ref = 1
test = 2
statsObs = cbind(mpsubS3$quality$observed[[ref]][[test]][, -1], mpsubS3$preservation$observed[[ref]][[test]][, -1])
statsZ = cbind(mpsubS3$quality$Z[[ref]][[test]][, -1], mpsubS3$preservation$Z[[ref]][[test]][, -1]);

# Compare preservation to quality:
print( cbind(statsObs[, c("medianRank.pres", "medianRank.qual")],
             signif(statsZ[, c("Zsummary.pres", "Zsummary.qual")], 2)) )

# Module labels and module sizes are also contained in the results
modColors = rownames(mpsubS3$preservation$observed[[ref]][[test]])
moduleSizes = mpsubS3$preservation$Z[[ref]][[test]][, 1];
names(moduleSizes) = modColors
text = modColors;
# Auxiliary convenience variable
plotData = cbind(mpsubS3$preservation$observed[[ref]][[test]][, 2], mpsubS3$preservation$Z[[ref]][[test]][, 2])
rownames(plotData) = modColors
mains = c("Preservation Median rank S3", "Preservation Zsummary S3");
sizeGrWindow(10, 5);
par(mfrow = c(1,2))
par(mar = c(4.5,4.5,2.5,1))
for (p in 1:2)
{
  min = min(plotData[, p], na.rm = TRUE);
  max = max(plotData[, p], na.rm = TRUE);
  # Adjust ploting ranges appropriately
  if (p==2)
  {
    if (min > -max/10) min = -max/10
    ylim = c(min - 0.1 * (max-min), max + 0.1 * (max-min))
  } 
  else {
    ylim = c(max + 0.1 * (max-min), min - 0.1 * (max-min))
  }
  plot(moduleSizes[modColors], plotData[modColors, p], col = 1, bg = modColors, pch = 21,
       main = mains[p],
       cex = 2.4,
       ylab = mains[p], xlab = "Module size", log = "x",
       ylim = ylim,
       xlim = c(10, 2000), cex.lab = 1.2, cex.axis = 1.2, cex.main =1.4)
  text(moduleSizes[modColors], plotData[modColors, p], labels=text,cex=0.7,pos=4)
}

sig_modules_S3 = names(plotData[,1][(1/plotData[,1])>0.15])

#S4 Module Preservation
sub = jt[,c(S4.id)]
top_var_sub = apply(sub,1,sd)
top_var_sub = top_var_sub[order(top_var_sub,decreasing = TRUE)]
top_var_sub = top_var_sub[1:count]
jtLessSub = t(sub[names(top_var_sub),])

setLabels= c("S3_S4","S4")
multiExpr = list(S3_S4 = list(data=jtLessS3S4),S4 = list(data = jtLessSub));
multiColor = list(S3_S4 = astroNet$modColors);

mpsubS4 = modulePreservation(multiExpr, multiColor, referenceNetworks=1,
                          nPermutations = 100,
                          networkType = "unsigned",
                          randomSeed = 2345,
                          permutedStatisticsFile = "halfPreserved-noReg-permStats.RData",
                          verbose = 4, indent = 0)

save(mpsubS4, file="modulePreservation_S4sub.RData")

#Isolate z scores and observed statistics
ref = 1
test = 2
statsObs = cbind(mpsubS4$quality$observed[[ref]][[test]][, -1], mpsubS4$preservation$observed[[ref]][[test]][, -1])
statsZ = cbind(mpsubS4$quality$Z[[ref]][[test]][, -1], mpsubS4$preservation$Z[[ref]][[test]][, -1]);

# Compare preservation to quality:
print( cbind(statsObs[, c("medianRank.pres", "medianRank.qual")],
             signif(statsZ[, c("Zsummary.pres", "Zsummary.qual")], 2)) )

# Module labels and module sizes are also contained in the results
modColors = rownames(mpsubS4$preservation$observed[[ref]][[test]])
moduleSizes = mpsubS4$preservation$Z[[ref]][[test]][, 1];
names(moduleSizes) = modColors
text = modColors;
# Auxiliary convenience variable
plotData = cbind(mpsubS4$preservation$observed[[ref]][[test]][, 2], mpsubS4$preservation$Z[[ref]][[test]][, 2])
rownames(plotData) = modColors
mains = c("Preservation Median rank S4", "Preservation Zsummary S4");
sizeGrWindow(10, 5);
par(mfrow = c(1,2))
par(mar = c(4.5,4.5,2.5,1))
for (p in 1:2)
{
  min = min(plotData[, p], na.rm = TRUE);
  max = max(plotData[, p], na.rm = TRUE);
  # Adjust ploting ranges appropriately
  if (p==2)
  {
    if (min > -max/10) min = -max/10
    ylim = c(min - 0.1 * (max-min), max + 0.1 * (max-min))
  } 
  else {
    ylim = c(max + 0.1 * (max-min), min - 0.1 * (max-min))
  }
  plot(moduleSizes[modColors], plotData[modColors, p], col = 1, bg = modColors, pch = 21,
       main = mains[p],
       cex = 2.4,
       ylab = mains[p], xlab = "Module size", log = "x",
       ylim = ylim,
       xlim = c(10, 2000), cex.lab = 1.2, cex.axis = 1.2, cex.main =1.4)
  text(moduleSizes[modColors], plotData[modColors, p], labels=text,cex=0.7,pos=4)
}

sig_modules_S4 = names(plotData[,1][(1/plotData[,1])>0.15])

