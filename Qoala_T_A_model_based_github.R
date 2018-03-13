## Qoala-T: Estimations of MRI Qoala-T using BrainTime model

# Code to reproduce step 4 (A) of our Qoala-T Tool
# Copyright (C) 2017 Lara Wierenga - Leiden University, Brain and Development Research Center
# 
# This package contains data and R code for step 4 (A) as part of our Qoala-T tool:
#   
#   title: Qoala-T: A supervised-learning tool for quality control of automatic segmented MRI data
# author:
#  - name:   Klapwijk, E.T., van de Kamp, F., Meulen, M., Peters, S. and Wierenga, L.M.
# 
# If you have any question or suggestion, dont hesitate to get in touch:
# l.m.wierenga@fsw.leidenuniv.nl

## ============================
# dependencies: the following packages are used in this code
packages <- c("caret", "corrplot", "gbm", "plyr", "randomForest", "e1071",
              "pROC", "DMwR","dplyr","pbkrtest","car","pbkrtest","doParallel","ROSE","repmis")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
lapply(packages, library, character.only = TRUE)
## ============================

# EDIT THIS PART
# -----------------------------------------------------------------
# set inputFolder and outputFolder
# -----------------------------------------------------------------
# Input directory to your data file
inputFolder <- "~/Desktop/input_datafiles/"
# Create output directory if it doesnt exist  
outputFolder <- "~/Desktop/Output_Qoala_T/" 
ifelse(dir.exists(outputFolder),FALSE,dir.create(outputFolder))
# -----------------------------------------------------------------

# EDIT THIS PART
# -----------------------------------------------------------------
# Load your dataset
# -----------------------------------------------------------------
#Instruction: Make sure your data format look like simulated_data_A_model.Rdata (code to read simulated_data_A_model below)
# row.names = MRI_ID !!! important step to match change the row.names 
# col.names = colnames(simulated_data_A_model)
setwd(inputFolder)
load("yourdatafile.RData")
test_data <- yourdatafile
dataset_name <- "your_dataset_name"

# -----------------------------------------------------------------
# Or Load example with simulated data
# -----------------------------------------------------------------
# This is an example file
# download.file("https://github.com/larawierenga/Qoala-T-under-construction/blob/master/simulated_data_A_model.Rdata?raw=true","simulated_data_A_model") 
# dataset_name <- "simulated_data_A_model" 
# load("simulated_data_A_model") 
# test_data <- get(dataset_name) 

# -----------------------------------------------------------------
# Load model Qoala-T model based on BrainTime data 
# -----------------------------------------------------------------
download.file("https://github.com/larawierenga/Qoala-T-under-construction/blob/master/Qoala_T_model.Rdata?raw=true","Qoala_T_model")
rf.tune <- get(load("Qoala_T_model"))

# -----------------------------------------------------------------
#reorder colnames of dataset to match traningset
# -----------------------------------------------------------------
dataset_colnames <- names(rf.tune$trainingData)[-ncol(rf.tune$trainingData)]
testing <- test_data[,dataset_colnames]
testing <- testing[complete.cases(testing),]

# -----------------------------------------------------------------
## External validation of unseen data on Qoala-T model 
# -----------------------------------------------------------------
rf.pred <-  predict(rf.tune,testing)
rf.probs <- predict(rf.tune,testing,type="prob") # probability of belonging in either category (certainty..)
head(rf.probs)

# -----------------------------------------------------------------
# Saving output
# ----------------------------------------------------------------
# create empty data frame
Qoala_T_predictions <- data.frame(matrix(ncol = 4, nrow = nrow(rf.probs)))                             
colnames(Qoala_T_predictions) = c('VisitID','Scan_QoalaT', 'Recommendation', 'manual_QC_adviced') 

# fill data frame
Qoala_T_predictions$VisitID <- row.names(rf.probs)
Qoala_T_predictions$Scan_QoalaT <- rf.probs$Include*100 
Qoala_T_predictions$Recommendation <- rf.pred
Qoala_T_predictions$manual_QC_adviced <- ifelse(Qoala_T_predictions$Scan_QoalaT<60&Qoala_T_predictions$Scan_QoalaT>40,1,0)
Qoala_T_predictions <- Qoala_T_predictions[order(Qoala_T_predictions$Scan_QoalaT, Qoala_T_predictions$VisitID),]


csv_Qoala_T_predictions = paste(outputFolder,'Qoala_T_predictions_model_based_',dataset_name,'.csv', sep = '')
write.csv(Qoala_T_predictions, file = csv_Qoala_T_predictions, row.names=F)

# -----------------------------------------------------------------
# PLOT results 
# -----------------------------------------------------------------
excl_rate <- table(Qoala_T_predictions$Recommendation)

fill_colour <- rev(c("#88A825","#CF4A30"))
font_size <- 12
text_col <- "Black"

p <- ggplot(Qoala_T_predictions, aes(x=Scan_QoalaT,y=1,col=Recommendation)) +  
  annotate("rect", xmin=40, xmax=60, ymin=1.12, ymax=.88, alpha=0.2, fill="#777777") +
  geom_jitter(alpha=.8,height=.1,size=6) +
  ggtitle(paste("Qoala-T estimation model based ",dataset_name,"\nMean Qoala-T Score = ",round(mean(Qoala_T_predictions$Scan_QoalaT),1),sep="")) + 
  annotate("text", x=20, y=1.15, label=paste("Excluded = ",as.character(round(excl_rate[1]))," scans",sep="")) + 
  annotate("text", x=80, y=1.15, label=paste("Included = ",as.character(round(excl_rate[2]))," scans",sep="")) + 
  
  scale_colour_manual(values=fill_colour) +
  theme_bw() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        panel.border = element_blank(),
        axis.text.x = element_text (size = font_size,color=text_col),
        axis.text.y = element_blank(),
        axis.title.x = element_text (size = font_size,color=text_col), 
        axis.title.y = element_blank(), 
        axis.ticks=element_blank(),
        plot.title=element_text (size =16,color=text_col,hjust=.5)
  )
print(p) 


filename<- paste(outputFolder,"Figure_Rating_model_based_",dataset_name,".pdf",sep="")
dev.copy(pdf,filename,width=30/2.54, height=20/2.54)
dev.off()









