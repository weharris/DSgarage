## HEADER ####
## Who: <YOUR NAME>
## https://dsgarage.netlify.app/
## What: 2.6 1-way ANOVA
## Last edited: <DATE TODAY in yyyy-mm-dd format)
####

## CONTENTS ####
## 01 The question of 1-way ANOVA
## 02 Data and assumptions
## 03 Graphing
## 04 Test and alternatives
## 05 Practice exercises

## 01 The question of 1-way ANOVA ####



## 02 Data and assumptions ####

# Try this
# Data in "wide format"  ####
A <- c(687, 691, 793, 675, 700, 753, 704, 717)
B <- c(618, 680, 592, 683, 631, 691, 694, 732)
C <- c(618, 687, 763, 747, 687, 737, 731, 603)
D <- c(600, 657, 669, 606, 718, 693, 669, 648)
E <- c(717, 658, 674, 611, 678, 788, 650, 690)

head(chicken.wide <- data.frame(A, B, C, D, E))

# Data in "long format"  ####
# The hard way
weight <- c(A,B,C,D,E)

sire <- c(rep("A", 8),
          rep("B", 8),
          rep("C", 8),
          rep("D", 8),
          rep("E", 8) )

head(data.frame(weight, sire))
tail(data.frame(weight, sire))

# The "programm-ey" way
weight1 <- c(A,B,C,D,E)

sire1 <- vector(mode = "character", length = 40)
for(i in 1:5) { sire1[(8*i-8)+c(1:8)] <- rep(LETTERS[i], 8) }

head(data.frame(weight1, sire1))
tail(data.frame(weight1, sire1))

# With function from {tidyr}
head(chicken.wide) # From above

library(reshape2) # For melt()
?melt
new.long <- melt(chicken.wide)

head(new.long) # Not bad but note the variable names

# Flash challenge: change the variable names in new.long

# NB, you should probably just use long format for your data in the first place!

## **Assumptions** ####

## - Gaussian residuals ####
# Make the model object with aov()
?aov
m1 <- aov(formula = Weight ~ Sire, 
         data = new.long)

# Graph to examine Gaussian assumption of residuals
# NB we use rstandard()
par(mfrow = c(1,2))
hist(rstandard(m1),
     main = "Gaussian?")

# Look at residuals with qqPlot()
library(MASS) # For qqPlot()
qqPlot(x = m1,
       main = "Gaussian?")
par(mfrow=c(1,1))

# NHST to examine Gaussian assumption of residuals
shapiro.test(rstandard(m1))


# Plot for homoscedasticity check
plot(formula = rstandard(m1) ~ fitted(m1),
     ylab = "m1: residuals",
     xlab = "m1: fitted values",
     main = "Spread similar across x?")
abline(h = 0,
       lty = 2, lwd = 2, col = "red")

# Make the mean residual y points
y1 <- aggregate(rstandard(m1), by = list(new.long$Sire), FUN = mean)[,2]
# Make the x unique fitted values
x1 <- unique(round(fitted(m1), 6))

points(x = x1, y = y1, 
       pch = 16, cex = 1.2, col = "blue")

# NHST to examine  assumption of homoscedasticity
# (homoscedasticiyy good, heteroscedasticity bad)

bartlett.test(formula = weight~sire, data = new.long)



## 03 Graphing ####

## basic boxplot ####

# It always pays to make a nice plot

# If you neglected the Flash Challenge above
names(new.long) <- c("Sire", "Weight")

# Do you think sire affects offspring weight?
boxplot(weight ~ sire, data = new.long) 

## **Make a better graph** ####

boxplot(weight ~ sire, data = new.long,
        ylab = "Weight (g)",
        xlab = "Sire",
        main = "Effect of Sire on 8-wk weight",
        cex = 0) # Get rid of the outlier dot (we will draw it back)

# Make horizontal line for grand mean
abline(h = mean(new.long$Weight), 
       lty = 2, lwd = 2, col = "red") # Mere vanity

# Draw on raw data
set.seed(42)
points(x = jitter(rep(1:5, each = 8), amount = .1),
       y = new.long$Weight,
       pch = 16, cex = .8, col = "blue") # Mere vanity

## 04 Test and alternatives ####

## Perform 1-way ANOVA ####
# Try this

# NB if the factor is a character, it "should" be coerced to a factor
# by R, "the passive aggressive butler"
# If in doubt, explicitly make the vector class == factor()
m1 <- aov(formula = weight ~ factor(sire), 
          data = new.long)

summary(m1)

## Contrasts, post hoc tests ####

# Use lm() and summary() to generate contrasts
# Use relevel() to set sire C to the reference factor level
new.long$Sire <- relevel(new.long$Sire, ref="C")
m2 <= lm(function = Weight ~ Sire, 
         data = new.long)
summary(m2)
plot(Weight ~ Sire, 
     data = new.long,
     main = "Sire C as reference")

## Bonferroni ####

?pairwise.t.test

# there are a few p.adjust.methods
# c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY",
#   "fdr", "none")
# we will use "bonferroni"
pairwise.t.test(x = new.long$Weight, 
                g = new.long$Sire,
                p.adjust.method = "bonferroni")


## Tukey Honestly Significant Differences ####
?TukeyHSD
TukeyHSD(m1) # NB m1 - this function requires an "aov" object
plot(TukeyHSD(m1))

## **Kruskal-Wallis non-parametric alternative to the 1-way ANOVA**
 ####

# Try this:
?kruskal.test
kruskal.test(formula = Weight ~ Sire,
             data = new.long)

## ANOVA details ####

# Try this:
# For the code below, try to follow what is going on in the code
# It is okay if not every detail is clear yet
# Do we get the same answer as aov()?

n.groups <- ncol(chicken)
n.per.group <- vector(mode = "integer", length = ncol(chicken))

for(i in 1:ncol(chicken)) {n.per.group[i] <- length(chicken[,i])}

n.individuals <- ncol(chicken)*nrow(chicken)
df.between <- n.groups - 1
df.within <- n.individuals - n.groups
mean.total <- mean(as.matrix(chicken))
mean.per.group <- colMeans(chicken)

ss.between <- sum(n.per.group*(mean.per.group-mean.total)^2)

ss.within <- sum(sum((chicken[,1] - mean.per.group[1])^2),
                 sum((chicken[,2] - mean.per.group[2])^2),
                 sum((chicken[,3] - mean.per.group[3])^2),
                 sum((chicken[,4] - mean.per.group[4])^2),
                 sum((chicken[,5] - mean.per.group[5])^2)
                 )
ms.between <- ss.between/df.between
ms.within <- ss.within/df.within

# Manual F
(myF <- ms.between/ms.within)

# Anova table
anova(m1)$"F value"[1] # Store-bought F


## 05 Practice exercises ####

## Pest damage data

treatment <- c(rep("control", 10),
               rep("x.half", 10),
               rep("x.full", 10),
               rep("organic", 10))
set.seed(42)
damage <- round(c(rnorm(10, 100, 10),
            rnorm(10, 75, 10),
            rnorm(10, 50, 10),
            rnorm(10, 100, 10)), 1)

pest <- data.frame(damage, treatment)
dput(pest)
pest <- structure(list(damage = c(113.7, 94.4, 103.6, 
                                  106.3, 104, 98.9, 
                          115.1, 99.1, 120.2, 99.4, 
                          88, 97.9, 61.1, 72.2, 73.7, 
                          81.4, 72.2, 48.4, 50.6, 88.2, 
                          46.9, 32.2, 48.3, 62.1, 69, 
                          45.7, 47.4, 32.4, 54.6, 43.6, 
                          104.6, 107, 110.4, 93.9, 105, 
                          82.8, 92.2, 91.5, 75.9, 100.4), 
                       treatment = c("control", "control", 
                                     "control", "control",
                                     "control", "control", 
                                     "control", "control", 
                                     "control", "control",
                                     "x.half", "x.half", 
                                     "x.half", "x.half", 
                                     "x.half", "x.half", 
                                     "x.half", "x.half", 
                                     "x.half", "x.half", 
                                     "x.full", "x.full", 
                                     "x.full", "x.full",
                                     "x.full", "x.full", 
                                     "x.full", "x.full", 
                                     "x.full", "x.full", 
                                     "organic", "organic", 
                                     "organic", "organic", 
                                     "organic", "organic", 
                                     "organic", "organic", 
                                     "organic", "organic")), 
                  class = "data.frame", 
                  row.names = c(NA, -40L))
