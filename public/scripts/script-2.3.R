## HEADER ####
## Who: <YOUR NAME>
## https://dsgarage.netlify.app/
## What: 2.3 Correlation
## Last edited: <DATE TODAY in yyyy-mm-dd format)
####


## CONTENTS ####
## 2.3.1 The question of correlation
## 2.3.2 Data and assumptions
## 2.3.3 Graphing
## 2.3.4 Test and alternatives
## 2.3.5 Practice exercises



## 2.3.1 The question of correlation ####
# devtools::install_github("debruine/faux")
library(faux) 

set.seed(42)
dat <- rnorm_multi(
  n = 99,
  vars = 2,
  mu = c(100, 1000),
  sd = c(10, 50),
  r = c(1, 0.6,
        0.6, 1),
  varnames = c("veg", "arthropods"),
  empirical = FALSE,
  as.matrix = FALSE
)

plot(x = dat, 
     xlab = "Vegetation biomass",
     ylab = "Arth. abundance",
     main = "A positive correlation",
     pch = 16, col = "blue", cex = .7)

dput(round(dat$veg, 1))
dput(round(dat$arthropods, 0))

## flash challenge ####
# Try this:

# Flash challenge
# Take the data input below and try to exactly recreate the figure above!

veg <- c(101.7, 101.2, 97.1, 92.4, 91, 99.4, 104.2, 115.9, 91.9, 101.4, 
         93.5, 87.2, 89.2, 92.8, 103.1, 116.4, 95.2, 80.9, 94.9, 88.8, 
         108.2, 86.1, 104.1, 101.5, 116.9, 109.6, 103.7, 83.9, 85.9, 88.5, 
         98.9, 98.8, 107.8, 86.5, 92.6, 76, 95.2, 105.3, 103.1, 89.3, 
         100.1, 103.1, 87.7, 92.4, 91.5, 105.4, 105.7, 90.5, 105.6, 101.6, 
         97.4, 93.4, 88.7, 81.1, 100.9, 91.6, 102.4, 92.8, 92, 97.1, 91.1, 
         97.3, 104, 99, 101.5, 112.8, 82.4, 84.9, 116.3, 92.2, 106.2, 
         94.2, 89.6, 108.8, 106.2, 91, 95.5, 99.1, 111.6, 124.1, 100.8, 
         117.6, 118.6, 115.8, 102.2, 107.7, 105, 86.7, 99, 101.8, 106.3, 
         100.3, 86.6, 106.4, 92.6, 108.2, 100.5, 100.9, 116.4)

arth <- c(1002, 1006, 930, 893, 963, 998, 1071, 1052, 997, 1044, 923, 
          988, 1022, 975, 1022, 1050, 929, 928, 1019, 957, 1054, 850, 1084, 
          995, 1065, 1039, 1009, 945, 995, 967, 916, 998, 988, 956, 975, 
          910, 954, 1044, 1063, 948, 966, 1037, 976, 979, 969, 1009, 1076, 
          943, 1024, 1071, 969, 963, 1020, 936, 1004, 961, 1089, 953, 1037, 
          962, 977, 958, 944, 933, 970, 1036, 960, 912, 978, 967, 1035, 
          959, 831, 1016, 901, 1010, 1072, 1019, 996, 1122, 1029, 1047, 
          1132, 996, 979, 994, 970, 976, 997, 950, 1002, 1003, 982, 1071, 
          959, 976, 1011, 1032, 1024)

## 2.3.2 Data and assumptions ####

# Try this:
# use veg and arth from above

# r the "hard way"

# r = ((covariance of x,y) / (std dev x * std dev y) )


# sample covariance (hard way)
(cov_veg_arth <- sum( (veg-mean(veg))*(arth-mean(arth))) / (length(veg) - 1 ))

cov(veg,arth) # easy way

# r the "hard way"
(r_arth_veg <- cov_veg_arth / (sd(veg) * sd(arth)))

# r the easy way
help(cor)
cor(x = veg, y = arth,
    method = "pearson") # NB "pearson" is the default method if unspecified



## 2.3.3 Graphing ####

myr <- c(.99, .8, .5, .1, 0, -.1, -.5, -.8, -.99)

par(mfrow=c(3,3))
for (i in 1:9){
  
  dat <- rnorm_multi(n = 100, vars = 2, r = c(1,myr[i],myr[i],1))
  plot(dat, main = paste("r = ", myr[i])) 

}
par(mfrow=c(1,1))


## Correlation matrices ####
# Try this:

# Use the iris data to look at correlation matrix 
# of flower measures
data(iris)
names(iris)
cor(iris[ , 1:4]) # all rows, just the numeric columns

# fix the decimal output
round(cor(iris[ , 1:4]), 2) # nicer

# pairs plot
pairs(iris[ , 1:4], pch = 16, 
      col = iris$Species) # Set color to species...

## 2.3.4 Test and alternatives ####

## Correlation test ####
# Try this:

# 1 The question: whether Petal length and width are correlated

# 2 Graph
plot(iris$Petal.Width, iris$Petal.Length,
     xlab = "Petal width",
     ylab = "Petal length",
     col = iris$Species, pch = 16)

# 3 Test
cor.test(iris$Petal.Width, iris$Petal.Length)

# 4 Validate
hist(iris$Petal.Length) # Ummm..
hist(iris$Petal.Width) # Yuck

# We violate the assumption of Gaussian

# ... Relatedly, we also violate the assumption of independence 
# due to similarities within and differences between species!

## Spearman rank correlation ####

# Try this:

set.seed(42)
height <- round(runif(30, 1, 20), 1)
height[seq(2, 30, by=2)] <- sort(height[seq(2, 30, by=2)])
dput(height)
dput(vol <- sort(round(rnorm(30, 30, 5), 1)))

plot(height, vol,
     xlab = "Height",
     ylab = "Volume",
     pch = 16, col = "blue", cex = .7)

cor(height, vol, method = "spearman")
cor.test(height, vol, method = "spearman")

## 2.3.5 Practice exercises ####

library(MASS)
data(waders)
help(waders)
