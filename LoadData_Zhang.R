source("src/Waterfall.R")

#Human and Mouse Data from Zhang-Barres paper

zm = read.table("data/zhang_mouse_data.txt",header = TRUE)
zm = ScaleTPM(zm)

zh = read.table("data/zhang_human_data.txt",header = TRUE, row.names = NULL)
rownames(zh) = make.names(zh[,1], unique=TRUE)
zh = zh[,-1]
zh = ScaleTPM(zh)

SIG_THRESH = 0.05
zm_astro_df = signature(zm,colnames(zm)[1:6],sig_thresh = SIG_THRESH); zm_astro_gene = rownames(zm_astro_df) 


