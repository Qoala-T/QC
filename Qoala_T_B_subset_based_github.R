## Qoala-T: Estimations of MRI Qoala-T using 10% of data

# Code to reproduce step 4 (B) of our Qoala-T Tool
# Copyright (C) 2017 Lara Wierenga - Leiden University, Brain and Development Research Center

# This package contains data and R code for step 4(B) as part of our Qoala-T tool:
#   
# title: Qoala-T: A supervised-learning tool for quality control of automatic segmented MRI data
#author:
#  - name:   Klapwijk, E.T., van de Kamp, F., Meulen, M., Peters, S. and Wierenga, L.M.
# http://doi.org/10.1101/278358
#
#  If you have any question or suggestion, dont hesitate to get in touch:
#  l.m.wierenga@fsw.leidenuniv.nl
   
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


# EDIT THIS PART
# -----------------------------------------------------------------
# Load your dataset
# -----------------------------------------------------------------
# Instruction: Make sure your data format look like simulated_data_A_model.Rdata (code to read simulated_data_A_model below)
# Make sure your data format looks like simulated_data_B_model.Rdata (code to read simulated_data_B_model below):
# First column should contain outcome manual quality control --> "Rating".
# 10% of data is rated, with two factor levels ('Include' and 'Exclude').
# Other 90% of data has no rating ('NA')
#
# row.names = MRI_ID !!! important step to match change the row.names 
# col.names = colnames(simulated_data_B_subset.RData)

setwd(inputFolder)
load("yourdatafile.RData")
dataset <- yourdatafile
dataset_name <- "your_dataset_name"

# -----------------------------------------------------------------
# Or Load example with simulated data
# -----------------------------------------------------------------
# This is an example file
# dataset_name <- "simulated_data" # edit to your dataset name
# # 
# githubURL <- "https://github.com/Qoala-T/QC/blob/master/simulated_data_B_subset.Rdata?raw=true"
# dataset <- get(load(url(githubURL)))
# # -----------------------------------------------------------------

# -----------------------------------------------------------------
# Next match col.names to Qoala_T_model
# -----------------------------------------------------------------
githubURL <- "https://github.com/Qoala-T/QC/blob/master/Qoala_T_model.Rdata?raw=true"
rf.tune <- get(load(url(githubURL)))

# -----------------------------------------------------------------
# reorder colnames of dataset to match traningset
# -----------------------------------------------------------------
dataset_names <- c("Rating",names(rf.tune$trainingData)[-ncol(rf.tune$trainingData)])
dataset <- dataset[,dataset_names]
dataset <- dataset[complete.cases(dataset[-1]),]


# -----------------------------------------------------------------
# Split into training and testing datasets 
# -----------------------------------------------------------------
# select training data for 10% rated data
training = dataset[!is.na(dataset$Rating),]
training$Rating = as.factor(training$Rating) 

# select testing data for 90% of data that is not rated yet 
testing = dataset[is.na(dataset$Rating),]
testing$Rating = as.factor(testing$Rating)

# -----------------------------------------------------------------
# Setting up computational nuances of the train function for internal cross validation 
# -----------------------------------------------------------------
ctrl = trainControl(method = 'repeatedcv',  
                    number = 2,    
                    repeats = 10,         
                    summaryFunction=twoClassSummary, 
                    classProbs=TRUE,        
                    allowParallel=FALSE,    
                    sampling="rose") # 'rose' is used to oversample the imbalanced data       

# -----------------------------------------------------------------
# Estimate model 
# -----------------------------------------------------------------
rf.tune = train(y=training$Rating,
                  x=subset(training, select=-c(Rating)),
                  method = "rf",
                  metric = "ROC",
                  trControl = ctrl,
                  ntree = 501,
                  tuneGrid=expand.grid(mtry = c(8)),
                  verbose=FALSE)

# -----------------------------------------------------------------
# External cross validation on 90% of unseen data (1 repetition)
# -----------------------------------------------------------------
rf.pred <- predict(rf.tune,subset(testing, select=-c(Rating)))
rf.probs <- predict(rf.tune,subset(testing, select=-c(Rating)),type="prob") 
head(rf.probs)

# -----------------------------------------------------------------
# Saving output
# ----------------------------------------------------------------
# create empty data frame
Qoala_T_predictions_subset_based <- data.frame(matrix(ncol = 4, nrow = nrow(rf.probs)))                   
colnames(Qoala_T_predictions_subset_based) = c('VisitID','Scan_QoalaT', 'Recommendation', 'manual_QC_adviced') 

# fill data frame
  Qoala_T_predictions_subset_based$VisitID <- row.names(rf.probs)
  Qoala_T_predictions_subset_based$Scan_QoalaT <- rf.probs$Include*100 
  Qoala_T_predictions_subset_based$Recommendation <- rf.pred
  Qoala_T_predictions_subset_based$manual_QC_adviced <- ifelse(Qoala_T_predictions_subset_based$Scan_QoalaT<60&Qoala_T_predictions_subset_based$Scan_QoalaT>40,"yes","no")
  Qoala_T_predictions_subset_based <- Qoala_T_predictions_subset_based[order(Qoala_T_predictions_subset_based$Scan_QoalaT, Qoala_T_predictions_subset_based$VisitID),]
  
  
  csv_Qoala_T_predictions_subset_based = paste(outputFolder,'Qoala_T_predictions_subset_based',dataset_name,'.csv', sep = '')
  write.csv(Qoala_T_predictions_subset_based, file = csv_Qoala_T_predictions_subset_based, row.names=F)

# -----------------------------------------------------------------
# PLOT results 
# -----------------------------------------------------------------
  excl_rate <- table(Qoala_T_predictions_subset_based$Recommendation)
  
  fill_colour <- rev(c("#88A825","#CF4A30"))
  font_size <- 12
  text_col <- "Black"
  
  p <- ggplot(Qoala_T_predictions_subset_based, aes(x=Scan_QoalaT,y=1,col=Recommendation)) +  
    annotate("rect", xmin=40, xmax=60, ymin=1.12, ymax=.88, alpha=0.2, fill="#777777") +
    geom_jitter(alpha=.8,height=.1,size=6) +
    ggtitle(paste("Qoala-T estimation using 10% of ",dataset_name,"\nMean Qoala-T Score = ",round(mean(Qoala_T_predictions_subset_based$Scan_QoalaT),1),sep="")) + 
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
  
  
  filename<- paste(outputFolder,"Figure_Rating_",dataset_name,".pdf",sep="")
  dev.copy(pdf,filename,width=30/2.54, height=20/2.54)
  dev.off()
  
