## Qoala-T: Estimations of MRI Qoala-T using 10% of data

# Code to reproduce merge freesrufer output files for Qoala-T Tool

# title: Qoala-T: A supervised-learning tool for quality control of automatic segmented MRI data
#author:
#  - name:   Klapwijk, E.T., van de Kamp, F., Meulen, M., Peters, S. and Wierenga, L.M.
# http://doi.org/10.1101/278358
#
#  If you have any question or suggestion, dont hesitate to get in touch:
#  l.m.wierenga@fsw.leidenuniv.nl


# -----------------------------------------------------------------
# Construct your dataset
# -----------------------------------------------------------------
#Instruction: 
# row.names = MRI_ID
# col.names = colnames(simulated_data_A_model.RData)

# -----------------------------------------------------------------
# Construct your dataset for Qoala_T_A_model_based_github.R
# -----------------------------------------------------------------
# Input directory to your data files inclduing: aseg_stats.txt, aparc_area_lh.txt, aparc_area_rh.txt, aparc_thickness_lh.txt, aparc_thickness_rh.txt
inputFolder <- "~/Desktop/input_datafiles/"
setwd(inputFolder)
yourdatafile <- data.frame(read.table("aseg_stats.txt",sep="\t",header=TRUE))
row.names(yourdatafile) <- yourdatafile[,1]
yourdatafile <- yourdatafile[,-1]

for (j in c("aparc_area_lh.txt","aparc_area_rh.txt","aparc_thickness_lh.txt","aparc_thickness_rh.txt")) {
  data = data.frame(read.table(paste(j,sep=""),sep="\t",header=TRUE))
  row.names(data) <- data[,1]
  data <- data[,-1]
  yourdatafile <- merge(yourdatafile,data,by="row.names",all.x=T)
  row.names(yourdatafile) <- yourdatafile[,1]
  yourdatafile <- yourdatafile[,-1]
}

save(yourdatafile,file=yourdatafile.Rdata)

# -----------------------------------------------------------------
# Add rating for Qoala_T_B_subset_based_github.R (not necessary using when only using model based script A) 
# -----------------------------------------------------------------
# column one = Rating with two factor levels 'Include' and 'Exclude', here we simulated that 10% of data is rated, and for 90% of data there is no rating, indicated by NA's
# Make sure to create a text file named rating.txt that includes a column named MRI_ID and Rating
rating_yourdatafile <- data.frame(read.table("rating.txt",sep="\t",header=TRUE))
dataset <- merge(rating_yourdatafile,yourdatafile,by.x="MRI_ID",by.y="row.names",all.y=T)
row.names(dataset) <- dataset[,1]
dataset <- dataset[,-1]

