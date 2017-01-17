##### Data from Ben Barres Lab #####

bt = read.table("data/barreslab_rnaseq.txt")
bt = ScaleTPM(bt)

#TODO: See trello for checklist of next steps