---
  title: "Misc 11 Modeling Zero Inflated data"
author: "Ed Harris"
date: 2020-11-01
weight: 1
categories: ["R Misc"]
tags: ["R Misc", "R"]
---
  
  &nbsp;

![Dolphin](/img/misc-11.01-dolphin.jpg)  

> **Data with lots of zeros is very common, occurring especially frequently with count data and behavioural events data.  Is your Poisson distributed data zero inflated...?
  
  &nbsp;

**Overview**
  
  This page provides a very brief introduction to modeling data with a lot of zeros, making modeling with Poisson GLM or Negative Binomial GLM a poor fit. We will cover a few topics:
  
- Basics of count data modeling with GLM

- First Zero Inflated model - Zero Inflated Poisson

- Examining model output and model selection

- Mixed effects Zero Inflated models
  
  
&nbsp;

**Contents**
  
[11.1 Basics of count data modeling with GLM](#anchor-1) 
    
[11.2 First Zero Inflated model ZIP](#anchor-2)
      
[11.3 Examining model output and model selection](#anchor-3)
        
[11.4 Mixed effects Zero Inflated models](#anchor-4)
          
[11.5 Resources](#anchor-5)
            
            
&nbsp;
            
This page provides a brief overview on two methods to defend your sample size.  First, methods in data and sample size simulation are examined. Then, we will look at tools for calculating power and sample size.
            
{#anchor-1}
            
&nbsp;
            
&nbsp;
            
## 11.1 Basics of count data modeling with GLM
            
[Fish data](data/11.1-fish.csv)

count - the number of fish caught by park visitors
livebait - did they use it?
camper - did they camp?
persons - count of people
child - count of children


```r
# you may need to install some or all of these
require(ggplot2)
require(pscl) ## for ZI models
require(boot)
require(glmmTMB) ## for mixed effect ZI models
require(bbmle) ## for AICtab
require(lmtest)

# you will need to download the fish.csv data
fish <- read.csv("fish.csv")

# convert to factors
fish <- within(fish, {
  nofish <- factor(nofish)
  livebait <- factor(livebait)
  camper <- factor(camper)
})

# look at the data - lots of zeros...
table(fish$count)
hist(log10(fish$count+1))

# first zero inflated model
?zeroinfl
summary(m1 <- zeroinfl(count ~ child + camper | persons, data = fish))
# notice the sections
# the pipe symbol denotes the zero inflation corrected factor
# here persons

fish[1:10, c("nofish", "count", "livebait")]
head(fish)
plot(count~persons, data = fish)

# back it up
# what does plain GLM look like for these data?
m0 <- glm(count ~ child + camper,
          data = fish,
          family = 'gaussian')
summary(m0)
plot(m0, which=3) # yuck!

# dispersion parameter - should be one
## Check for over/underdispersion in the model
E2 <- resid(m0, type = "pearson")
N  <- nrow(fish)
p  <- length(coef(m0))   
sum(E2^2) / (N - p) # should be near 1!


# a simple model with Poisson
m2 <- zeroinfl(count ~ child | camper, 
               data = fish,
               dist = 'poisson')
summary(m1)

E2 <- resid(m2, type = "pearson")
N  <- nrow(fish)
p  <- length(coef(m2))   
sum(E2^2) / (N - p)

# a simple model with negative binomial
m3 <- zeroinfl(count ~ child | camper, 
               data = fish,
               dist = 'negbin')
summary(m3)


E2 <- resid(m3, type = "pearson")
N  <- nrow(fish)
p  <- length(coef(m3))   
sum(E2^2) / (N - p)

# Which is better, Poisson or neg bin?
lrtest(m2,m3) # the models are different
AICtab(m2,m3) # model 3 is better (lower AIC)


# fancy model
m.pred <- zeroinfl(count ~ child + camper | persons,
                   data = fish)
summary(m1)

# make grid of factor values against which to PREDICT
# fish caught with our fancy model
newdata1 <- expand.grid(0:3,           # children 0 1 2 3
                        factor(0:1),   # camper 0 1
                        1:4)           # n persons 1 2 3 4

colnames(newdata1) <- c("child", "camper", "persons")
newdata1 <- subset(newdata1, subset=(child<=persons))
newdata1$phat <- predict(m.pred, newdata1)

ggplot(newdata1, aes(x = child, y = phat, colour = factor(persons))) +
  geom_point() +
  geom_line() +
  facet_wrap(~camper) +
  labs(x = "Number of Children", y = "Predicted Fish Caught") +
  theme_classic()



## mixed effects ####
# https://drizopoulos.github.io/GLMMadaptive/articles/ZeroInflated_and_TwoPart_Models.html

# https://cran.r-project.org/web/packages/glmmTMB/vignettes/glmmTMB.pdf

# Bolker, B. M. (2015). Linear and generalized linear mixed models. In
# G. A. Fox, S. Negrete-Yankelevich, and V. J. Sosa (Eds.), Ecological Statistics: Contemporary theory and application, Chapter 13. Oxford University
# Press.
# 
# Zuur, A. F., E. N. Ieno, N. J. Walker, A. A. Saveliev, and G. M. Smith (2009,
# March). Mixed Effects Models and Extensions in Ecology with R (1 ed.).
# Springer

# try a mixed effect model
# different package
Owls <- transform(Owls,
                  Nest=reorder(Nest,NegPerChick),
                  NCalls=SiblingNegotiation,
                  FT=FoodTreatment)

# The basic glmmTMB fit — a zero-inflated Poisson model with a single zero inflation 
# parameter applying to all observations (ziformula~1). (Excluding zero-inflation 
# is glmmTMB’s default: to exclude it explicitly, use ziformula~0.)

# zero inflated negative binomial mixed effects
fit_zipoisson <- glmmTMB(NCalls~log(BroodSize)  + SexParent + (1|Nest),
                         data=Owls,
                         ziformula=~1,
                         family=poisson)
summary(fit_zipoisson)

# zero inflated negative binomial mixed effects
fit_fishinom <- glmmTMB(NCalls~log(BroodSize)  + SexParent + (1|Nest),
                        data=Owls,
                        ziformula=~1,
                        family=nbinom1)
summary(fit_fishinom)

# zero inflated Poisson "hurdle" model
fit_hnbinom1 <- glmmTMB(NCalls~log(BroodSize)  + SexParent + (1|Nest),
                        data=Owls,
                        ziformula=~.,
                        family=list(family="truncated_nbinom1",link="log"))

summary(fit_hnbinom1)


AICtab(fit_zipoisson, fit_fishinom, fit_hnbinom1)

# try on fishing

fish_nbinom1 <- glmmTMB(count~child + camper,
                        data=fish,
                        ziformula=~persons,
                        family=list(family="truncated_nbinom1",link="log"))

summary(fish_nbinom1)

```



&nbsp;

**Under construction**

{#anchor-2}
            
&nbsp;
            
&nbsp;
            
## 11.2 First Zero Inflated model ZIP
            
&nbsp;
          
{#anchor-3}
            
&nbsp;
            
&nbsp;
            
## 11.3 Examining model output and model selection
            
&nbsp;
          
{#anchor-4}
            
&nbsp;
            
&nbsp;
            
## 11.4 Mixed effects Zero Inflated models
            
&nbsp;
          
{#anchor-1}
            
&nbsp;
            
&nbsp;
            
## 11.1 Basics of count data modeling with GLM
            
&nbsp;
          
{#anchor-5}
            
&nbsp;
            
&nbsp;
            
## 11.5 Resources
            
&nbsp;
          
&nbsp;