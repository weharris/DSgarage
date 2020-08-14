## HEADER ####
## Who: <YOUR NAME>
## https://dsgarage.netlify.app/
## What: 3.3 Git repo script
## Last edited: <DATE TODAY in yyyy-mm-dd format)
####

## CONTENTS ####
## 01 Setup
## 02 Graph

## 01 Setup ####
# Get the data set up
mydir <- "D:/Dropbox/git/DSgarage/public/data" # << change to yours!
setwd(mydir)

library(openxlsx)
data <- read.xlsx("3.3-cane.xlsx")

## 02 Graph ####
# Make a plot showing the proportion of diseased stems per plot
# (variable "r" / variable "n")
# as a function of cane variety (variable "var")
plot(y = data$r/data$n, 
     x = data$var)



