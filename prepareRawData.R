# Preparing PTSD raw data for input into NeuroMiner
# Author: A.M. Chekroud. 
# Munich. June, 2015.

### Carpentry and Viz
library("plyr") # Data manipulation
library("dplyr") # Faster Manipulation for dataframes--NB:always load dplyr after plyr
library("reshape2")
library("tidyr")
library("ggplot2") # Viz
# library("ggvis") # Viz
library("RColorBrewer") # Viz

### Statistical packages
# library("caret")
# library("glmnet") # http://web.stanford.edu/~hastie/glmnet/glmnet_alpha.html
# library("gbm")
# library("pROC")
# library("dynamicTreeCut") # stats: hclust
# # library("ape") # stats: phylogenetics
# # library("permute")
# # library("klaR")

### Parallel Processing
library("doMC") # Multicore package
registerDoMC() # initialise multicore

### Directories and seeds
set.seed(124) # Reading from the same sheet
setwd("/Users/adamchekroud/Documents/PhD/Projects/PTSD")
dataDir <- "/Users/adamchekroud/Documents/PhD/Projects/PTSD/data"
workDir <- getwd()
saveDir <- paste0(workDir) 


#### Read in some data ####
rawData <- read.csv(paste(dataDir, "/rawData.csv", sep = ""),
                    header = TRUE, stringsAsFactors = FALSE,
                    sep = ",", quote = "\"'")

caseIDs     <- rawData$Scan
label       <- ifelse(rawData$life_PTSD == 1, "HC", "PTSD")  #old classification label
## names(rawData[,c(grep("*dts*", names(rawData)))]) #grep new labels
## rawLabel       <- rawData$X_dts_total
## label          <- ifelse(rawLabel == 0, 0, 1)
simpleDem      <- rawData[,c("gender", "marital_status", "age_at_first_visit", "age_at_scan")]
brainNames     <- names(rawData)[468:628]
braindata      <- select(rawData, one_of(brainNames))
corr_braindata <- 
  
  
# Combine these simple columns into a single df (as needed by NeuroMiner)
firstPassData <- cbind(caseIDs, label, simpleDem, braindata)

# Drop 2 patients with missing dts total
firstPassData_complete <- firstPassData[complete.cases(firstPassData),]

# Write the data as a csv (but need to manually make it xlsx for neurominer)
write.csv(firstPassData_complete, file=paste(saveDir, "/firstPassData.csv", sep = ""), row.names = FALSE)

