## HEADER ####
## Who: <YOUR NAME>
## https://dsgarage.netlify.app/
## What: 2.5 T-test
## Last edited: <DATE TODAY in yyyy-mm-dd format)
####


## CONTENTS ####
## 01 The question of the t-test
## 02 Data and assumptions
## 03 Graphing
## 04 Test and alternatives
## 05 Practice exercises


## 01 The question of the t-test ####

## 2 independent samples ####

density <- c("high","high","high","high","high","high","high",
            "low","low","low","low","low","low","low")

height <- c(2,3,4,3,4,3,2, 
            6,8,6,9,7,8,7)

## 2 sample t-test long format data
(long.data <- data.frame(density,height))

## 2 sample t-test wide format data
(wide.data <- data.frame(high.ht = c(2,3,4,3,4,3,2),
                        low.ht = c(6,8,6,9,7,8,7)))

# Boxplot
boxplot(height ~ density, data = long.data,
        main = "2 independent samples")
# Optional: add raw data points
# jitter() nudges the x-axis placement so that the points do not overlap
set.seed(42)
points(x = jitter(c(1,1,1,1,1,1,1,
                    2,2,2,2,2,2,2), 
                  amount = .2),
       y = long.data$height,
       col = "red", pch = 16, cex = .8) # Mere vanity

## fake 1-sample data
set.seed(42)
mysam <- round(rnorm(15, 1.85,0.15),2)

## Compare 1 sample to a known mean ####

# Example: fertilizer particle size
# (kind of boring but practical example)
# Your fertilizer product SHOULD have a mean particle size of
# mean = 2.00 mm and standard deviation of 0.15 mm
# Is your sample the same?

dput(mysam)

boxplot(mysam, 
        main = "Sample population the same?")

points(x = jitter(rep(1,15), amount = .1),
       y = mysam,
       col = "red", pch = 16, cex = .8) # Mere vanity
abline(h = 2.0,
       col = "blue", lty = 2, lwd = 2)  # Mere vanity


## Compare 1 sample to a known mean ####

# fake paired data
set.seed(42)
N.first <- sort(round(rnorm(15, 19, 4 ),1))
N.second <- sort(round(rnorm(15, 24, 3 ),1))
plot <- LETTERS[1:15]

biochar <- data.frame(plot,N.first,N.second)

## 02 Data and assumptions ####

# Biochar application, measure N before and after
biochar

# Data (the code are kind of ugly, but run it to "make" biochar)
biochar <- structure(list(
  plot = c("A", "B", "C", "D", "E", "F", "G", "H", "I", 
           "J", "K", "L", "M", "N", "O"), 
  N.first = c(13.4, 16.7, 17.9, 18.5, 18.6, 18.6, 18.7, 
              20.5, 20.6, 21.5, 24.2, 24.5, 25, 27.1, 28.1), 
  N.second = c(16, 16.7, 18.7, 18.7, 22.1, 22.7, 23.1, 
               23.1, 23.2, 23.5, 25.4, 25.9, 27.6, 28, 29.7)), 
  class = "data.frame", 
  row.names = c(NA, -15L))

# boxplot would work, but hides pairwise relationship
# Try this:

plot(x = jitter(c(rep(1,15), rep(2,15)),amount = .02),
     y = c(biochar$N.first, biochar$N.second),
     xaxt = "n", xlim = c(0.5, 2.5),
     cex = .8, col = "blue", pch = 16,  # Mere vanity
     xlab = "Biochar treatment",
     ylab = "Soil N",
     main = "Do the lines tend to increase?")

mtext(side = 1, at = 1:2, text = c("before", "after"), line = 1)

# Get crazy: add horizontal lines to visualize the plot pairs
for(i in 1:15){
lines(x = c(1.05,1.95),
      y = c(biochar$N.first[i], biochar$N.second[i]),
      lty = 2, lwd = 1, col = "red") # Mere vanity
}        


## 03 Graphing ####




## 04 Test and alternatives ####

## **2-sample t-test** ####
# Try this
# data
density <- c("high","high","high","high","high","high","high",
             "low","low","low","low","low","low","low")
height <- c(2.1,3.5,4.3,3.2,4.5,3.7,2.7, 
            6.1,8,6.9,9.1,7.5,8,7.4)
(treegrowth <- data.frame(density,height))

# There is not much data to compare to the Gaussian distribution
library(MASS) # for qqPlot()
hist(treegrowth$height[treegrowth$density == "low"])
qqPlot(treegrowth$height[treegrowth$density == "low"])

hist(treegrowth$height[treegrowth$density == "high"])
qqPlot(treegrowth$height[treegrowth$density == "high"])



# The histograms are a little "wooly", but there are no huge 
# deviations from the expectation of Gaussian and the 
# q-q plots look ok: proceed

?t.test
# NB 1 - the x argument can be a formula
# x = height ~ density
# or we can set our samples to x and y respectively
# x = height[low], y = height[high]

t.test(x = height ~ density, 
       data = treegrowth)

## **1 sample t-test** ####
set.seed(42)
ewl <- round(rnorm(20, 18, 3), 1)

# Example earwig length
dput(ewl)

# Try this:

# Data
earwigs <- c(22.1, 16.3, 19.1, 19.9, 19.2, 17.7, 22.5, 17.7, 24.1, 17.8, 
            21.9, 24.9, 13.8, 17.2, 17.6, 19.9, 17.1, 10, 10.7, 22)

mymu <- 17.0 # Our mu

?t.test #notice the mu argument
t.test(x = earwigs,
       mu = mymu)

## **2 paired samples** ####

# Try this:
# Data
cort.t0 <- c(0.59, 0.68, 0.74, 0.86, 0.54, 0.85, 0.7, 0.81, 0.79, 0.76, 
             0.49, 0.64, 0.74, 0.51, 0.57, 0.74, 0.77, 0.72, 0.52, 0.49)

cort.t1 <- c(1.13, 0.81, 0.77, 0.72, 0.45, 0.9, 0.7, 0.7, 0.98, 0.96, 1.1, 
             0.63, 0.91, 1.1, 0.99, 0.72, 1.11, 1.2, 0.77, 0.91)

?t.test # NB the "paired" argument
t.test(x = cort.t0,
       y = cort.t1,
       paired = TRUE)

# Flash Challenge:
# 1) Make a great graph that represents these data
# 2) Was your hypothesis upheld...?
# 3) format and report the results in the technical style!


## **Mann-Whitney U-test** ####
set.seed(42)
diet <- round(runif(15, 0,3), 0)
diet.bone <- round(rpois(15,2.5), 0)

dput(diet)
dput(diet.bone)

# Gaussian assumption
library(MASS)
hist(diet)
hist(diet.bone) # Dist not similar to diet

par(mfrow = c(1,2))
qqPlot(diet, 
       main = "Not Gaussian") # Divergence
qqPlot(diet.bone,
       main = "Diff. to diet?") 
par(mfrow = c(1,1))

?wilcox.test
wilcox.test(x = diet, y = diet.bone)

## 05 Practice exercises ####


