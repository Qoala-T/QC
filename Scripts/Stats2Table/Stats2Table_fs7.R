##################
# STATS2TABLE.R #
##################
# Written by Olga Veth - s2067579 - University of Leiden
# Created on 30-09-2019
# Edited by Lara M Wierenga on 22-02-21
# Most Recent update: 22-02-21
# Version 4.0

# Edited for FS7

# Two inputs should be provided by the user of this script
#   1. Directory containing all the directories of the study participants with FreeSurfer output
#   2. Name of the study and/or dataset

datasetDir <- "/path/to/subjects/directory/" # Change Directory to your data

setwd(datasetDir) 
dataset_name <- "Dataset_Name" # Provide name of your study and/or dataset



readAseg <- function(){
  # The Aseg file of a subject is read in
  # Volume_mm3 and StructName are selected
  aseg_file <- data.frame(read.table(paste("./stats/aseg.stats", sep=""), row.names=1))[,c(3,4)] 
  asegTable <- t(data.frame(aseg_file[,1], row.names = aseg_file[,2])) # Aseg file - regular
  return (asegTable)
}

readMetaAseg <- function(){
  # The Aseg file of a subject is read in
  # Its metadata containing 'lhCortex' etc. and their volume are saved
  aseg_meta <- readLines("./stats/aseg.stats", n=35)[16:36] #Edited for fs7.0.0 from line 16 iso line 15
  meta1 <- gsub("# ", "", aseg_meta)
  meta <- t(data.frame(strsplit(meta1, ",")))[,c(2,4)]
  metaTable <- t(data.frame(meta[,2]))
  colnames(metaTable) <- meta[,1]
  return(metaTable)
}

editCol <- function(side, string, add){
  # Change measure areas from 'Areaname'--> 'lh_Areaname_area'
  return(paste(side, "_", string, add, sep=""))
}

readAparc <- function(value){
  # Aparc files of lh and rh are read in and the 
  # area and thickness values of both files are retreved as well as 
  # the metadata measurements of both parts
  # Areanames are formatted and eventually the data is saved into
  # a data frame
  sides <- c("lh", "rh")
  ifelse((value == "area"), pos <- 1, pos <- 2)
  
  for (x in 1:length(sides)){
    areaThickness <- as.data.frame(read.table(paste("./stats/", sides[x], ".aparc.stats", sep=""), row.names=1))[, c(2,4)]
    rowValues <- rownames(areaThickness)
    
    meta <- readLines(paste("./stats/", sides[x], ".aparc.stats", sep=""))[c(20, 21)] 
    meta1 <- gsub("# ", "", meta)
    meta2 <- t(data.frame(strsplit(meta1, ",")))[, c(2,4)]
    meta3 <- data.frame(meta2[pos,2])
    value2 <- gsub(" ", "", meta2[pos,1])
    
    colnames(meta3) <- paste(sides[x], "_", value2, "_" , value, sep="")
    extra <- t(matrix(areaThickness[,pos]))
    colnames(extra) <- paste(sides[x], "_", rowValues, "_", value, sep="")
    ifelse(x==1, aparcTable <- cbind(extra, meta3), aparcTable <- cbind(aparcTable, extra, meta3))
  }
  return(aparcTable)
}

readFiles <- function(){
  # Aseg and Aparc files are read in and all the data is merged
  # starting with Aseg data followed with Aparc
  asegTable <- readAseg()
  metaTable <- readMetaAseg()
  
  areaAparc <- readAparc("area")
  thickAparc <- readAparc("thickness")
  
  subjectTable <- cbind(asegTable, metaTable, areaAparc, thickAparc) # aparcMeta --> WhiteSurface
  subjectTable <- data.frame(subjectTable)
  return (subjectTable)
}

preprocTable <- function(subjectTable){
  # Columnames are edited or removed of the table
  removeCols <- c("*.WM-hypointensities$","*.WM.hypointensities$", "*pole*", "*bankssts*", "VentricleChoroidVol", "*CerebralWhiteMatterVol", "\\bSurfaceHoles\\b",
                  "SegVolFile.mri.aseg.mgz.", "*CorticalWhiteMatterVol")
  remove <- grep(paste(removeCols, collapse="|"), colnames(subjectTable))
  subjectTable <- subjectTable[, -remove]
  
  colnames(subjectTable) <- gsub("^X\\.", "", colnames(subjectTable))
  colnames(subjectTable) <- gsub("_\\.", "_", colnames(subjectTable))
  colnames(subjectTable) <- gsub("-", ".", colnames(subjectTable))
  colnames(subjectTable) <- gsub(" ", "", colnames(subjectTable))
  
  colnames(subjectTable)[which(colnames(subjectTable) == "eTIV")] <- "EstimatedTotalIntraCranialVol"
  colnames(subjectTable)[which(colnames(subjectTable) %in% c("rd.Ventricle", "th.Ventricle", 
                                                             "5th.Ventricle"))] <- c("X4th.Ventricle", "X3rd.Ventricle", "X5th.Ventricle") # change to names
  
  return(subjectTable)
}

main <- function(){
  # It loops through all subjects sub-directories in the given directory
  # With every single subject, data is retrieved and written in a row
  # in the final table. 
  # The result is saved into a .CSV file
  subjects <- c()
  first <- T
  subjectDirs <- unique(list.dirs('.', recursive=FALSE)) # Get all sample subject
  for (x in 0:length(subjectDirs)){
    setwd(paste(datasetDir, subjectDirs[x], sep=""))
    statsDirs <- list.dirs('.', recursive=FALSE)
    if (file.exists("./stats/aseg.stats")){
      subjectTable <- readFiles()
      subjectTable <- preprocTable(subjectTable)
      if (first == T){
        stats2Table <- subjectTable
        subjects <- c(subjects, substring(subjectDirs[x], 3))
        first = F
      } 
      else if (ncol(subjectTable) == ncol(stats2Table)&& (first == F)){
        stats2Table <- rbind(stats2Table, subjectTable)
        subjects <- c(subjects, substring(subjectDirs[x], 3))
      } 
      
    }
  }
  
  stats2Table <- data.frame(stats2Table)
  rownames(stats2Table) <- subjects
    
    # edit for fs7.0.0
    # 1: rename Left.Thalamus into Left.Thalamus.Proper (idem Right)
    colnames(stats2Table)[which(names(stats2Table) == "Left.Thalamus")] <- "Left.Thalamus.Proper"
    colnames(stats2Table)[which(names(stats2Table) == "Right.Thalamus")] <- "Right.Thalamus.Proper"

    # 2: In fs 7.0.0 two variables are dropped: 
    # BrainSegVolNotVentSurf and SupraTentorialVolNotVentVox
    # These are almost identical to BrainSegVolNotVent and SupraTentorialVolNotVent respectively, so fill them with these values
    stats2Table$BrainSegVolNotVentSurf <- stats2Table$BrainSegVolNotVent
    stats2Table$SupraTentorialVolNotVentVox <- stats2Table$SupraTentorialVolNotVent

  setwd(datasetDir)
  write.csv(stats2Table, paste("FreeSurfer_Output_", dataset_name,".csv", sep=""))
}
main()
