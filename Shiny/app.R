# dependencies: the following packages are used in this code
library("caret")
library("corrplot")
library("gbm")
library("plyr")
library("randomForest")
library("e1071")
library("pROC")
library("DMwR")
library("dplyr")
library("pbkrtest")
library("car")
library("pbkrtest")
library("doParallel")
library("ROSE")
library("repmis")
library("shiny")
library("shinythemes")
library("ggplot2")

# raise max file upload size
options(shiny.maxRequestSize = 25*1024^2)

# Define UI for data upload app ----
ui <- fluidPage(theme = shinytheme("simplex"),
                
                # App title ----
                titlePanel(
                  title =  div(img(src = "https://github.com/Qoala-T/QC/blob/master/Figures/QoalaT-Logo.png?raw=true", height = "100px"), 
                               HTML('&nbsp;'), strong("Qoala-T: quality control of FreeSurfer segmented MRI data")), windowTitle = "Qoala-T App"),
                
                hr(),
                h4(strong("To run Qoala-T on your data, follow these steps:")),
                h5("1. Process T1-weighted MRI images in",a(href="https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall", 
                                                            target="_blank", "FreeSurfer v.6.0")),
                h5("2. Next extract the following output txt files  using",  a(href="https://surfer.nmr.mgh.harvard.edu/fswiki/freesurferstats2table",
                                                                               target="_blank", "fswiki"),
                   ":", em("aseg_stats.txt, aparc_area_lh.txt, aparc_area_rh.txt,  aparc_thickness_lh.txt, aparc_thickness_rh.txt"), br(),
                   "You can also use the following script to extract only the output files necessary for Qoala-T:" 
                   ,a(href="https://github.com/Qoala-T/QC/blob/master/stats2table_bash_qoala_t.sh", target="_blank",
                      "stats2table_bash_qoala_t.sh,"), 
                   "an adapted version from", 
                   a(href="https://surfer.nmr.mgh.harvard.edu/fswiki/freesurferstats2table", target="_blank", "fswiki")),
                h5("3. Upload txt files below.", strong("Be sure to put the right files in the designated fields."), 
                   "Note that data is only used to calculate Qoala-T scores and is not stored anywhere"),
                h5("4. Hit 'Execute Qoala-T predictions' and Qoala-T scores for a dataset are estimated using the 
                   supervised-learning model"),
                h5("Qoala-T scores (ranging from 0 to 100) are computed for every individual scan. This
                   score is based on class probability, where higher numbers indicate a higher chance of
                   being a high quality scan, and thus that scan is more likely to be included. To reduce
                   misclassification we would recommend to manually check scans rated with a scan
                   quality between 30 and 70 (see Manual_QC_advised), since most misclassified scans will fall within these
                   boundaries. A graph is shown in the Graph tab and scores for participants are shown in the 
                   Table tab. Scores are also available for download as csv file."),
                h5("The supervised-learning model is based on 784 T1-weighted imaging scans of subjects aged between 8 and 25 years old (53% 
                   females), see the", a(href="https://doi.org/10.1016/j.neuroimage.2019.01.014", target="_blank", "Klapwijk, van de Kamp, 
                                         van der Meulen, Peters & Wierenga (2019) NeuroImage paper"), "for details and 
                   also the", a(href ="https://github.com/Qoala-T/QC", "Qoala-T Github"), "for the code that is used. This app uses 
                   Qoala-T version 1.2 (released January 2019)."),
                (h5(div(p("When using Qoala-T scores, please cite", a(href="https://doi.org/10.1016/j.neuroimage.2019.01.014", target="_blank",
                                                                      "Klapwijk et al."), "We are also happy to hear about performance of this tool in 
                          your dataset. Please send this information to us at", 
                          a(href="mailto:e.t.klapwijk@fsw.leidenuniv.nl", "e.t.klapwijk@fsw.leidenuniv.nl"), 
                          "or", a(href="mailto:l.m.wierenga@fsw.leidenuniv.nl", "l.m.wierenga@fsw.leidenuniv.nl"), 
                (h5("In the case of any issues with the tool,
                          feel free to leave a message at the ", a(href="https://github.com/Qoala-T/QC/issues", target="_blank", "Github Issues page"), 
                          "so that all users benefit from answers to your questions.")))))),
                br(),
                
                # Sidebar layout with input and output definitions ----
                sidebarLayout(
                  
                  # Sidebar panel for inputs ----
                  sidebarPanel(
                    
                    # Input: Select a file ----
                    fileInput("aseg", h6(strong("Upload aseg_stats.txt")),
                              accept = c("text/plain",
                                         "aseg_stats.txt")),
                    
                    fileInput("aparc_area_lh", h6(strong("Upload aparc_area_lh.txt")),
                              multiple = TRUE,
                              accept = c("text/plain",
                                         ".txt")),
                    
                    fileInput("aparc_area_rh", h6(strong("Upload aparc_area_rh.txt")),
                              multiple = TRUE,
                              accept = c("text/plain",
                                         ".txt")),
                    
                    fileInput("aparc_thick_lh", h6(strong("Upload aparc_thickness_lh.txt")),
                              multiple = TRUE,
                              accept = c("text/plain",
                                         ".txt")),
                    
                    fileInput("aparc_thick_rh", h6(strong("Upload aparc_thickness_rh.txt")),
                              multiple = TRUE,
                              accept = c("text/plain",
                                         ".txt")),
                    
                    # Execute: Press button to display merged data ----
                    actionButton("exec", strong("Execute Qoala-T predictions")),
                    
                    # Built with Shiny by RStudio
                    br(),
                    br(), # Two line breaks for visual separation
                    h5("Built with",
                       img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
                       "by",
                       img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
                       "."),
                    width = 3
                    
                  ),
                  
                  # Main panel for displaying outputs ----
                  mainPanel(
                    tabsetPanel(type = "tabs",
                                # Output: Plot         
                                tabPanel("Graph",
                                         plotOutput("plotmodel")),
                                
                                # Output: Data file ----
                                tabPanel("Table",
                                         HTML("Once the Qoala-T scores are displayed here, hit 'Download csv' to download a csv file of this table."),
                                         br(), br(), # line break and some visual separation
                                         downloadButton(outputId = "download_data", label = "Download csv"),
                                         
                                         tableOutput("contents"))),
                    width = 9
                  )
                )
                )

# Define server logic to read selected file ----
server <- function(input, output) {
  
  # Create a merged file to use for Qoala-T
  Qoala_T_prediction_table <- eventReactive(input$exec, {
    
    Aseg_txt <- input$aseg
    Area_lh_txt <- input$aparc_area_lh
    Area_rh_txt <- input$aparc_area_rh
    Thick_lh_txt <- input$aparc_thick_lh
    Thick_rh_txt <- input$aparc_thick_rh
    
    if (is.null(c(Aseg_txt,Area_lh_txt,Area_rh_txt,Thick_lh_txt,Thick_rh_txt)))
      return(NULL)
    
    yourdatafile <- data.frame(read.table(Aseg_txt$datapath,sep="\t",header=TRUE))
    row.names(yourdatafile) <- yourdatafile[,1]
    yourdatafile <- yourdatafile[,-1]
    
    for (j in c(Area_lh_txt$datapath,Area_rh_txt$datapath,Thick_lh_txt$datapath,Thick_rh_txt$datapath)) {
      data = data.frame(read.table(paste(j,sep=""),sep="\t",header=TRUE))
      row.names(data) <- data[,1]
      data <- data[,-1]
      yourdatafile <- merge(yourdatafile,data,by="row.names",all.x=T)
      ifelse(grep("\\.y$", colnames(yourdatafile)),(yourdatafile <- yourdatafile[, -grep("\\.y$", colnames(yourdatafile))]) , yourdatafile)
      names(yourdatafile) <- gsub("\\.x$", "", names(yourdatafile))
      row.names(yourdatafile) <- yourdatafile[,1]
      yourdatafile <- yourdatafile[,-1]
    }
    
    # use merged_data to calculate Qoala-T scores
    test_data <- yourdatafile
    dataset_name <- "Freesurfer_dataset"
    row.names(test_data) <- gsub("/","",row.names(test_data))
    
    # -----------------------------------------------------------------
    # Load model Qoala-T model based on BrainTime data 
    # -----------------------------------------------------------------
    githubURL <- "https://github.com/Qoala-T/QC/blob/master/Qoala_T_model.Rdata?raw=true"
    rf.tune <- get(load(url(githubURL)))
    
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
    colnames(Qoala_T_predictions) = c('Scan_ID','Qoala_T_score', 'Recommendation', 'Manual_QC_advised') 
    
    # fill data frame
    Qoala_T_predictions$Scan_ID <- row.names(rf.probs)
    Qoala_T_predictions$Qoala_T_score <- rf.probs$Include*100 
    Qoala_T_predictions$Recommendation <- rf.pred
    Qoala_T_predictions$Manual_QC_advised <- ifelse(Qoala_T_predictions$Qoala_T_score<70&Qoala_T_predictions$Qoala_T_score>30,"yes","no")
    Qoala_T_predictions <- Qoala_T_predictions[order(Qoala_T_predictions$Qoala_T_score, Qoala_T_predictions$Scan_ID),]
    
    Qoala_T_prediction_table <- Qoala_T_predictions
    return(Qoala_T_prediction_table)
    
  })
  # assign csv file to download button  
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("Qoala_T_predictions.csv")
    },
    content = function(file) {
      write.csv(Qoala_T_prediction_table(), file, row.names=F)
      
    }
  )
  
  # show output in table  
  output$contents <- renderTable(
    
    Qoala_T_prediction_table())
  
  # -----------------------------------------------------------------
  # PLOT results 
  # -----------------------------------------------------------------
  
  output$plotmodel <- renderPlot({
    
    excl_rate <- table(Qoala_T_prediction_table()$Recommendation)
    
    fill_colour <- rev(c("#88A825","#CF4A30"))
    font_size <- 12
    text_col <- "Black"
    
    ggplot(Qoala_T_prediction_table(), aes(x=Qoala_T_score,y=1,col=Recommendation)) +  
      annotate("rect", xmin=30, xmax=70, ymin=1.12, ymax=.88, alpha=0.2, fill="#777777") +
      geom_jitter(alpha=.8,height=.1,size=6) +
      ggtitle(paste("Qoala-T estimation model based \nMean Qoala-T Score = ",round(mean(Qoala_T_prediction_table()$Qoala_T_score),1),sep="")) + 
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
  }
  )    
}

# Create Shiny app ----
shinyApp(ui, server)