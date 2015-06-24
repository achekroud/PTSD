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
simpleDem             <- rawData[,c("gender", "marital_status", "age_at_first_visit", "age_at_scan")]
brainNames            <- names(rawData)[468:628]
braindata             <- select(rawData, one_of(brainNames))
corr_braindata        <- braindata/braindata$ICV
corr_braindata$ICV    <- NULL
names(corr_braindata) <- paste0("corr_",names(braindata)[1:dim(corr_braindata)[2]])

## Code to generate all pairwise interactions b/w brain features
## Easy to get 3rd order interactions (change 2nd line to ^3)
# tempY          <- matrix(1, nrow = length(caseIDs), ncol = 1)
# interactMe     <- tempY ~ .^2
# interactions   <- model.matrix(interactMe, data = corr_braindata)

  
# Combine these simple columns into a single df (as needed by NeuroMiner)
secondPassData <- cbind(caseIDs, label, simpleDem, braindata, corr_braindata)

# Drop 2 patients with missing dts total
secondPassData_complete <- secondPassData[complete.cases(secondPassData),]

# Write the data as a csv (but need to manually make it xlsx for neurominer)
write.csv(secondPassData_complete, file=paste(saveDir, "/secondPassData.csv", sep = ""), row.names = FALSE)

