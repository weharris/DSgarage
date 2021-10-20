## HEADER ####
## Who: <YOUR NAME>
## https://dsgarage.netlify.app/
## What: 2.2 Distributions
## Last edited: <DATE TODAY in yyyy-mm-dd format)
####


## CONTENTS ####
# 2.2.1 Use of the histogram
# 2.2.2 Gaussian: that ain't normal
# 2.2.3 Poisson
# 2.2.4 Binomial
# 2.2.5 Diagnosing the distribution

# 2.2.1 Use of the histogram ####

# Try this:

# Adult domestic cats weight approximately 4 Kg on average
# with a standard deviation of approximately +/1 0.5 Kg

# Let's simulate some fake weight data for 1000 cats
help(rnorm) # A very useful function
help(set.seed) # If we use this, we can replicate "random data"
set.seed(42)
cats <- rnorm(n = 10000,
              mean = 4,
              sd = 0.5)
cats[1:10] # The first 10 cats

help(hist)
hist(x = cats,
     xlab = "Cat weight (Kg)")

# Try this:
# simulation of samples

help(sample) # randomly sample the cats vector
help(vector) # Initialize a variable to hold our sample means

# We will do a "for loop" with for()

mymeans <- vector(mode = "numeric",
                  length = 100)
mymeans # Empty

for(i in 1:100){
  mysample <- sample(x = cats, # Takes a random sample
                    size = 30)
  
  mymean[i] <- mean(mysample) # stores sample mean in ith vector address

  }
mymean # Our samples

hist(x = mymean,
     xlab = "Mean of samples",
     main = "100 cat weight samples (n = 30/sample)")
abline(v = mean(mymean), col = "red", lty = 2, lwd = 2)

# 2.2.2 Gaussian: that ain't normal ####

# Data
(myvar <- c(1,4,8,3,5,3,8,4,5,6))

# Mean the "hard" way
(myvar.mean <- sum(myvar)/length(myvar))

# Mean the easy way
mean(myvar)

# Variance the "hard" way 
# (NB this is the sample variance with [n-1])
(sum((myvar-myvar.mean)^2 / (length(myvar)-1)))

# Variance the easy way 
var(myvar)

# Std dev the easy way
sqrt(var(myvar))

## Gaussian variations ####
# Try this:

# 4 means
(meanvec <- c(10, 7, 10, 10))

# 4 standard deviations
(sdvec <- c(2, 2, 1, 3))

# Make a baseline plot
x <- seq(0,20, by = .1)

# Probabilities for our first mean and sd
y1 <- dnorm(x = x, 
            mean = meanvec[1],
            sd = sdvec[1])

# Baseline plot of 1st mean and sd
plot(x = x, y = y1, ylim = c(0, .4),
     col = "goldenrod",
     lwd = 2, type = "l",
     main = "Gaussian fun 
     \n mean -> curve position; sd -> shape",
     ylab = "Density",
     xlab = "(Arbitrary) Measure")

# Make distribution lines
mycol <- c("red", "blue", "green")
for(i in 1:3){
  y <- dnorm(x = x, 
                mean = meanvec[i+1],
                sd = sdvec[i+1])
  lines(x = x, y = y, 
        col = mycol[i],
        lwd = 2, type = "l")
}

# Add a legend
legend(title = "mean (sd)",
       legend = c("10 (1)", "10 (2)", 
                  "10 (3)", "  7 (2)"),
       lty = c(1,1,1,1), lwd = 2,
       col = c("blue", "goldenrod", "green", "red"),
       x = 15, y = .35)

## q-q- Gaussian ####

# Try This:

library(car) # Might need to install {car}

# Set graph output to 2 x 2 grid
# (we will set it back to 1 x 1 later)
par(mfrow = c(2,2)) 

# Small Gaussian sample
set.seed(42)
sm.samp <- rnorm(n = 10, 
                 mean = 10, sd = 2)

qqPlot(x = sm.samp, 
       dist = "norm", # C'mon guys, Gaussian ain't normal!
       main = "Small sample Gaussian")

# Large Gaussian sample
set.seed(42)
lg.samp <- rnorm(n = 1000, 
                 mean = 10, sd = 2)

qqPlot(x = lg.samp, 
       dist = "norm", 
       main = "Large sample Gaussian")

# Non- Gaussian sample
set.seed(42)
uni <- runif(n = 50, 
                 min = 3, max = 17)

qqPlot(x = uni, 
       dist = "norm", 
       main = "Big deviation at top")

par(mfrow = c(1,1))



# 2.2.3 Poisson ####

# Try this:

# E.g. (simulated) Number of ewes giving birth to triplets
# The counts were made in one year 1n 100 similar flocks (<20 ewes)
set.seed(42)
mypois <- rpois(n = 100, lambda = 3)
hist(mypois,
     main = "Ewes with triplets",
     xlab = "Count of triplets")

# Try this:
# 3 lambdas
(lambda <- c(1, 3, 5))

# Make a baseline plot
x <- seq(0, 15, by = 1)

# Probabilities for our first lambda
y1 <- dpois(x = x, 
            lambda = lambda[1])

# Baseline plot Pois
plot(x = x, y = y1, ylim = c(0, .4),
     col = "goldenrod",
     lwd = 2, type = "b",
     main = "Poisson fun",
     ylab = "Density",
     xlab = "(Arbitrary) Count")

# Make distribution lines
mycol <- c("red", "blue")
for(i in 1:2){
  y <- dpois(x = x, 
             lambda = lambda[i+1])
  lines(x = x, y = y, 
        col = mycol[i],
        lwd = 2, type = "b")
}

# Add a legend
legend(title = "lambda",
       legend = c("1", "3", "5"),
       lty = c(1,1,1,1), lwd = 2,
       col = c("goldenrod", "red", "blue"),
       x = 12, y = .35)


# 2.2.4 Binomial ####

# Try this:
# dormouse presence:
set.seed(42)
rbinom(n = 50, # Number of "experiments", here nestboxes checked
       size = 1, # Number of checks, one check per nestbox
       prob = .3) # Probability of presence

# Try this:
# Flip a fair coin:
set.seed(42)
rbinom(n = 20, # Number of "experiments", 20 people flipping a coin
       size = 10, # Number of coin flips landing on "heads" out of 10 flips per person
       prob = .5) # Probability of "heads"


# Try this:

# Binomial parameters
# 3 n of trial values
(n <- c(10, 10, 20))

# 3 probability values
(p <- c(.5, .8, .5))

# Make a baseline plot
x <- seq(0, 20, by = 1)

# Probabilities for our first set of parameters
y1 <- dbinom(x = x, 
            size = n[1],
            prob = p[1])

# Baseline plot Binom
plot(x = x, y = y1, ylim = c(0, .4),
     col = "goldenrod",
     lwd = 2, type = "b",
     main = "Binomial fun",
     ylab = "Density",
     xlab = "(Arbitrary) # \"Successes\"")

# Make distribution lines
mycol <- c("red", "blue")
for(i in 1:2){
  y <- dbinom(x = x, 
             size = n[i+1],
             prob = p[i+1])
  lines(x = x, y = y, 
        col = mycol[i],
        lwd = 2, type = "b")
}

# Add a legend
legend(title = "Parameters",
       legend = c("n = 10, p = 0.50", 
                  "n = 10, p = 0.80",
                  "n = 20, p = 0.50"),
       lty = c(1,1,1,1), lwd = 2,
       col = c("goldenrod", "red", "blue"),
       x = 13, y = .35)



# 2.2.5 Diagnosing the distribution ####


## 2.2.6 Practice exercises ####

# Data to use:

set.seed(42)
(A <- round(rnorm(20, 40, 3),1))
(B <- rpois(20, 10))
(C <- round(runif(20, 0, 1), 2))
(D <- round(rbeta(20, 1, 1), 1)*15+5)

# The code below loads and prints the data frame "dat"
# Data dictionary for "dat", a dataset with different measures of 20 sheep
# weight - weight in Kg
# ked - count of wingless flies
# trough - 2 feed troughs, proportion of times "Trough A" fed from
# shear - minutes taken to "hand shear" each sheep
(dat <- data.frame(
  weight = c(44.1, 38.3, 41.1, 41.9, 41.2, 39.7, 44.5, 39.7, 46.1, 39.8, 
    43.9, 46.9, 35.8, 39.2, 39.6, 41.9, 39.1, 32.0, 32.7, 44.0),
  
  ked = c(9, 4, 15, 11, 10, 8, 12, 12, 6, 11,
             12, 13, 8, 11, 19, 19, 12, 7, 8, 14),
  
  trough = c(0.52, 0.74, 0.62, 0.63, 0.22, 0.22, 0.39, 0.94, 0.96, 0.74,
              0.73, 0.54, 0.00, 0.61, 0.84, 0.75, 0.45, 0.54, 0.54, 0.00),
  
  shear = c(14.0, 8.0, 14.0, 11.0, 14.0, 5.0, 9.5, 11.0, 6.5, 11.0, 
            18.5, 11.0, 18.5, 8.0, 8.0, 6.5, 18.5, 15.5, 14.0, 8.0)
  ))


# 1 Do you expect "weight" to be Gaussian distributed? How about "ked"? 
#   Explain your answer for each.



# 2 Show the code to graphically diagnose and decide whether "weight" 
# is Gaussian and explain your conclusion.



# 3 Show the code to graphically diagnose and decide whether "ked" 
# is Gaussian and explain your conclusion. If you choose another 
# likely distribution, test it as well and similarly diagnose.



# 4 Explore whether "trough" is Gaussian, and explain whether you 
# expect it to be so. If not, does transforming the data "persuade 
# it" to conform to Gaussian? Discuss.



# 5 Write a plausible practice question involving any aspect of 
# graphical diagnosis of data distribution.

