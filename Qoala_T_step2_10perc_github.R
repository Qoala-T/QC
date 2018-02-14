## Qoala-T Step 2B: Estimations of MRI Qoala-T using 10% of data

# Code to reproduce step 2B of our Qoala-T Tool
# Copyright (C) 2017 Lara Wierenga - Leiden University, Brain and Development Research Center

# This reproducibility package contains data and R code for the steps as part of our Qoala-T tool:
#   
# title: Qoala-T: A supervised-learning tool to assess accuracy of manual quality control of automated neuroanatomical labeling in developmental MRI data
#author:
#  - name:   Klapwijk, E.T., van de Kamp, F., Meulen, M., Peters, S. and Wierenga, L.M.
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

## ============================
# Create output directory if it doesnt exist  
outputFolder <- "~/Desktop/Output_Qoala_T/" 
ifelse(dir.exists(outputFolder),FASLE,dir.create(outputFolder))
## ============================

# -----------------------------------------------------------------
# Load your dataset - edit this part 
# -----------------------------------------------------------------
#Instruction: Make sure your data format looks like simulated_data. 
# row.names = VisitID
# column one = Rating with two factor levels 'Include' and 'Exclude', here we simulated that 10% of data is rated, and for 90% of data there is no rating, indicated by NA's
dataset_name <- "simulated_data" # edit to your dataset name

download.file("https://github.com/larawierenga/Qoala-T-under-construction/blob/master/simulated_data_step2B.Rdata?raw=true","simulated_data_step2B") # include path to your datafile 
load("simulated_data_step2B")

dataset <- simulated_data_step2B
# -----------------------------------------------------------------

# -----------------------------------------------------------------
# Split into traning and testing datasets 
# -----------------------------------------------------------------
# select traning data for 10% rated data see setp 2B #ETK: wat bedoel je met setp 2B?
training = dataset[!is.na(dataset$Rating),]
training$Rating = as.factor(training$Rating) # needs factors, can be set back afterwards..if required by algorithm

# select testing data for 90% of data that is nog rated yet #ETK: nog must be not
testing = dataset[is.na(dataset$Rating),]
testing$Rating = as.factor(testing$Rating)

# -----------------------------------------------------------------
## Setting up computational nuances of the train function for internal cross validation - step 2C
# -----------------------------------------------------------------
ctrl = trainControl(method = 'repeatedcv',  
                    number = 2,    #number of folds         
                    repeats = 10,  # number of repeats         
                    summaryFunction=twoClassSummary, 
                    classProbs=TRUE,        
                    allowParallel=FALSE,    
                    sampling="rose") # 'rose' is used to oversample the imbalanced data       

# -----------------------------------------------------------------
# Estimate model - step 2C 
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
## External cross validation on 90% of unseen data - step 2B (1 repetition)
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
  Qoala_T_predictions_subset_based$manual_QC_adviced <- ifelse(Qoala_T_predictions_subset_based$Scan_QoalaT<60&Qoala_T_predictions_subset_based$Scan_QoalaT>40,1,0)
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
  
