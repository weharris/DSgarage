## HEADER ####
## Who: <YOUR NAME>
## https://dsgarage.netlify.app/
## What: 2.1 Question, explore, analyze
## Last edited: <DATE TODAY in yyyy-mm-dd format)
####


## CONTENTS ####
# 2.1.1 Question formulation and hypothesis testing
# 2.1.2 Summarize: Weighing the Pig
# 2.1.3 Variables and graphing
# 2.1.4 "Analysis" versus "EDA"
# 2.1.5 Statistical Analysis Plan: the concept
# 2.1.6 problems

# 2.1.2 Summarize: Weighing the Pig ####

# Try this:

# Download the 2.1-chickwts.xlsx file, read it into a data 
# object in R called "chicks", 
# and convert the "feed" variable to a factor if necessary.

# Load necessary libraries
library(openxlsx)

# Read file
# This should be YOUR file path...
setwd("D:/Dropbox/git/DSgarage/public/data") 
chicks <- read.xlsx("2.1-chickwts.xlsx")

# Convert feed to factor if needed
class(chicks$feed) # Character
chicks$feed <- factor(chicks$feed)
class(chicks$feed) # Factor

# Try this:

# Summarize the whole dataset
# summary() provides summary statistics for numeric variables and counts
summary(chicks)

# we might want to look at summary for different levels of feed
?summary
summary(object = chicks$weight[which(chicks$feed == "casein")])
summary(object = chicks$weight[which(chicks$feed == "horsebean")])
# etc. - this method is easy but inelegant?

# aggregate()
?aggregate

# mean
aggregate(x = chicks$weight, by = list(chicks$feed), FUN = mean)

# standard deviation
aggregate(x = chicks$weight, by = list(chicks$feed), FUN = sd)

# You can make your own function for the FUN argument
# stadard error of mean, SEM = standard deviation / square root of sample size
aggregate(x = chicks$weight, by = list(chicks$feed), 
          FUN = function(x){ sd(x)/sqrt(length(x)) })

# You can apply several functions and name them!
aggregate(x = chicks$weight, by = list(feed = chicks$feed), 
          FUN = function(x){ c(mean = mean(x), 
                               sd = sd(x),  
                               SEM = sd(x)/sqrt(length(x)))})

# 2.1.3 Variables and graphing ####

# The least you can do
help(hist)
hist(x = chicks$weight)

# Argument main
hist(x = chicks$weight,
     main = "Distribution of chick weights (all feeds)")

# x axis title
hist(x = chicks$weight,
     main = "Distribution of chick weights (all feeds)",
     xlab = "Chick weight (grams)")

# Add vertical line for mean weight
hist(x = chicks$weight,
     main = "Distribution of chick weights (all feeds)",
     xlab = "Chick weight (grams)")

help(abline)
abline(v = mean(chicks$weight), col = "red", lty = 2, lwd = 3)

# Try a boxplot
help(boxplot)
boxplot(x = chicks$weight)
# I have seen worse graphs, but I can't remember when.
# Fix. It.

# weight as a function of feed
boxplot(formula = weight ~ feed,
        data = chicks)
# This is probably a good representation of our hypothesis
# Fix the graph...

# 2.1.6 problems ####
# 1 Show code to set up an R analysis file with a header, 
# table of contents, and a setup section that sets your working 
# directory, loads any required libraries and reads in the data. 
# Call the data.frame object you create seed.

setwd(r"(D:\Dropbox\git-hads\ha-data-science.github.io\pages\harug-files\2021-10-06 bootcamp 2.1)")
library(openxlsx)
seed <- read.xlsx("data/field-trial.xlsx") 

# 2 pct, wet and dry should be numeric; block and trial should 
# be factors, and treatment should be a factor with the level 
# "Control" set as the reference. Show the code to do this.



# 3 Use aggregate() to calculate the mean, standard deviation, 
# standard error, and the count (e.g. length()) of pct for each 
# level of treatment. Show the code.



# 4 Make a fully labelled boxplot of the pct as a function of 
# treatment. Add a horizontal line (red and dashed) for the 
# overall mean of pct, and 2 horizontal lines (gray, dotted) 
# for the overall mean of pct +/- 1 standard deviation.
seed$block <- factor(seed$block)
seed$trial <- factor(seed$trial)


boxplot(pct ~ treatment,
        data = seed,
        xlab = 'Treatment',
        ylab = 'Seed pct %',
        main = 'My title')
abline(h = mean(seed$pct),
       col = "red",
       lty = 2)
abline(h = mean(seed$pct) + sd(seed$pct),
       col = "gray",
       lty = 3)
abline(h = mean(seed$pct) - sd(seed$pct),
       col = "gray",
       lty = 3)


# 5 (hard: may require tinkering and problem solving) 
# Experiment making a boxplot showing pct ~ treatment 
# separated for each ```trial

par(mfrow=c(1,1))

seed_Control <- seed[which(seed$treatment == "Control"),]
boxplot(
  pct ~ trial,
  data = seed_Control,
  xlab = 'Treatment',
  ylab = 'Seed pct %',
  main = 'Treatment Control'
)

seed_A <- seed[which(seed$treatment == "A"),]
boxplot(
  pct ~ trial,
  data = seed_A,
  xlab = 'Treatment',
  ylab = 'Seed pct %',
  main = 'Treatment A'
)
seed_B <- seed[which(seed$treatment == "B"),]
boxplot(
  pct ~ trial,
  data = seed_B,
  xlab = 'Treatment',
  ylab = 'Seed pct %',
  main = 'Treatment B'
)

# 6 Write a plausible practice question involving aggregate() 
# and boxplot() in-built R dataset iris.
