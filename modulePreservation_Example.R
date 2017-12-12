library(WGCNA);
# The following setting is important, do not omit.
options(stringsAsFactors = FALSE);
nSamples = c(100, 100);
nMods = 10;
nSets = length(nSamples);
nAllSamples = sum(nSamples);
# Set random seed for reproducibility
set.seed(1)
# Simulate seed eigengenes
allEigengenes = matrix(rnorm(nAllSamples * nMods), nAllSamples, nMods);
# Module sizes
modSizes = c(1000, 500, 250, 100, 50, 1000, 500, 250, 100, 50, 300);
nGenes = as.integer(sum(modSizes)*1.2);
modProps = modSizes/nGenes;
# Eigengenes for each set:
eigengenes = list();
eigengenes[[1]] = list(data = allEigengenes[1:nSamples[1], ]);
eigengenes[[2]] = list(data = allEigengenes[(nSamples[1]+1):nAllSamples, ]);

leaveOut = matrix(FALSE, nMods, nSets);
leaveOut[c(6,7,8,9,10), 2] = TRUE;
data = simulateMultiExpr(eigengenes, nGenes, modProps, leaveOut = leaveOut,
                         minCor = 0.3, maxCor = 0.9, backgroundNoise = 0.2);
# Generate the multiExpr variable from the simulated data
multiExpr = data$multiExpr;
colnames(multiExpr[[1]]$data) = spaste("Gene", c(1:nGenes));
colnames(multiExpr[[2]]$data) = spaste("Gene", c(1:nGenes));

set.seed(3)
mods = list();
for (set in 1:nSets)
  mods[[set]] = blockwiseModules(multiExpr[[set]]$data, numericLabels = TRUE, verbose = 4)
# Correspondence of identified and simulated colors:
table(mods[[1]]$colors, data$allLabels[, 1])
table(mods[[2]]$colors, data$allLabels[, 2])
# We will use the identified module colors for module preservation calculations.
colorList = list();
colorList[[1]] = mods[[1]]$colors;
colorList[[2]] = mods[[2]]$colors;

system.time( {
  mp = modulePreservation(multiExpr, colorList, referenceNetworks=1,
                          nPermutations = 100,
                          networkType = "unsigned",
                          randomSeed = 2345,
                          permutedStatisticsFile = "halfPreserved-noReg-permStats.RData",
                          verbose = 4, indent = 0)
} );
# Save the results.
#save(mp, file= "simulation-halfPreserved.RData");