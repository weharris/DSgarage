---
title: "Lab 10 Planning your sample size"
author: "Ed Harris"
date: 2020-11-01
weight: 1
categories: ["c7041"]
tags: ["c7041", "R"]
---

&nbsp;

![ ](/img/10.1-skellington.png)  

&nbsp;

## Goals

- Evaluate principles to increase sampling precision in experimental design

- Evaluate power of sampling

- Demonstrate power tools in R, like {pwr}

&nbsp;

[**Get the data for all labs here**](/data/c7041-lab-data.zip)

&nbsp;

---

## Start a script!

For this and every lab or project, **begin by starting a new script**, **create a good header section and table of contents**,  **save the script file with an informative name**, and **set your working directory**.  Aim to make the script useful as a future reference for doing things in R - this will come in handy for projects and assessments!

&nbsp;

## Learning the tools

&nbsp;

### Experiment planning tools

&nbsp;

Before carrying out a time- and fund-consuming experiment, it is useful to get an idea of what to expect from the results. How big an effect are you expecting? What are the chances that you would detect it? What sample size would you need to have a reasonable chance of succeeding? How narrow a confidence interval around the estimated effect would you be happy with? In this workshop we will show how R can be used to address some of these questions.

&nbsp;

**Random sampling warm-up**

&nbsp;

To begin, get some practice randomly sampling categorical and Gaussian-distributed data from a population. The intention is to use sample

&nbsp;

1. Randomly sample 20 observations from a population having two groups of individuals, “infected” and “uninfected”, in equal proportions. Summarize the results in a frequency table.

2. Repeat the previous step five times to convince yourself that the outcome varies from sample to sample.

3. Sample 18 individuals from a population having two groups of individuals, “mated” and “unmated”, where the proportion mated in the population is 0.7. Summarize the results in a frequency table.

4. Repeat the previous step five times to convince yourself that the outcome varies from sample to sample.

5. Sample 30 observations from a Gaussianly-distributed population having mean 0 and standard deviation 2. Plot the results in a histogram.

6. Repeat the following 5 times and calculate the mean each time: sample 30 observations from a Gaussianly-distributed population having mean 0 and standard deviation 2. Convince yourself that the sample mean is different each time.


&nbsp;

**Answers**

&nbsp;

All lines below beginning with double hashes are R output

```r
# 1.

sample(c("infected","uninfected"), 
       prob = c(.5,.5),
       size = 20, 
       replace = TRUE)

##  [1] "uninfected" "uninfected" "uninfected" "uninfected" "infected"  
##  [6] "uninfected" "infected"   "uninfected" "infected"   "uninfected"
## [11] "uninfected" "infected"   "uninfected" "infected"   "uninfected"
## [16] "infected"   "infected"   "infected"   "infected"   "uninfected"

# 3. 
z <- sample(c("mated","unmated"), size = 18, replace = TRUE, prob = c(.7,.3))

table(z)

## z
##   mated unmated 
##      16       2

# 5. 

z <- rnorm(30, mean = 0, sd = 2)

hist(z, right = FALSE, col = "goldenrod", las = 1)
```

![](/img/10.2-hist.png)

&nbsp;

```r
# 6. 
z <- rnorm(1000, mean = 0, sd = 2)

hist(z, right = FALSE, col = "goldenrod", las = 1)
```

![](/img/10.3-hist.png)

&nbsp;


### Plan for precision

Consider an experiment to estimate mate preference of females of a species of jumping spiders. Each independent trial involves presenting a female spider with two tethered males. One of the males is from her own species, and the other is from its sister species. To avoid pseudoreplication, females are tested only once and males are replaced between tests. You want to estimate p, the proportion of female spiders that choose males of their own species. Before carrying out the experiment, it is useful to generate data under different scenarios to get a sense of the sample size you would need to estimate preference with sufficient precision.


&nbsp;

**Estimate weak or no preference**

We’ll start with the case of weak or no preference: Imagine that females choose males essentially randomly (p = 0.5), with half choosing the male from her own species and the other half picking the male of the other species. How much data would you need to demonstrate this (and convince your skeptical supervisory committee)? One idea is to collect data and use it to test the null hypothesis of no preference. If the null hypothesis is true, you should fail to reject it. However, this won’t be very convincing to your committee. Failing to reject a null hypothesis is inconclusive by itself. Maybe your test won’t have much power.

A second idea is to plan your sample size so as to obtain a narrow confidence interval (high precision) for the strength of preference. If, at the end of your experiment, you end up with an estimate of p close to 0.5 AND your 95% confidence interval for p is relatively narrow, you’ll be in a strong position to say that the true preference really is weak, even if you can’t say it is exactly 0.5. What sample size is necessary to achieve a reasonably narrow confidence interval in this case? Investigate this question by simulating data.

&nbsp;

1. Randomly sample n = 10 females from a population having equal numbers of “successes” (females who choose males of her own species) and “failures” (females who choose males of the other species). What was the proportion of successes in your sample?

2. Using the data from step 1, calculate an approximate 95% confidence interval for the population proportion of successes. Use the Agresti-Coull method in the binom package in R, which you will need to install if you haven’t already done so.

&nbsp;

```r
library(binom) # load before using

```

&nbsp;

To obtain the 95% confidence interval, use the binom.confint function explained below. The argument x is the number of “successes” in your generated sample (number of females who chose males of her own species) and n is the sample size (number of females tested).

&nbsp;

```r
# gets the confidence interval
myCI <- binom.confint(x, n, method = "ac")  

print(myCI)                                 # shows the results

myCI$lower                                  # lower limit of confidence interval

myCI$upper                                  # upper limit

```
&nbsp;

Obtain the 95% confidence interval for the proportion using your data from step 1. What was the span of your confidence interval (upper limit minus lower limit)? Can you be confident that the true population proportion is 0.5 or very close to it?

&nbsp;

3. Repeat steps 1 and 2 five times and keep a record of the confidence intervals you obtained. What was the lowest value for the span of the confidence interval from the 5 samples?

&nbsp;

4. You can speed up the effort if you create a for loop in R that automatically repeats steps 1 and 2 as many times as you decide. See the “Loop, Repeat” tab on the R tips page. A loop that repeats ten times would look something like the following. The “i” in this loop is a counter, starting at 1 and increasing by 1 each time the commands in the loop are executed. Don’t forget to include a command inside the loop to print each result.

&nbsp;

```r
for(i in 1:10){
         [paste in your R commands for steps 1 and 2 here]
         }
```

&nbsp;

5. Increase the sample size to n = 20 and run the loop from step 4 again. How much narrower are the confidence interval spans? Are the spans adequate?

&nbsp;

6. By modifying the sample size and re-running the loop a bunch of times, find a sample size (ballpark, no need to be exact at this point) that usually produces a confidence interval having a span no greater than 0.2. This would be the span of a confidence interval that had, e.g., a lower limit of 0.4 and an upper limit of 0.6. Surely this would be convincing evidence that the mate preference really was weak.

By this point you might wish to speed things up by saving the results of each iteration to a vector or data frame rather than print the results to the screen. This will make it possible to increase the number of iterations (say, to 100 times instead of just 10) for a given value of n. 

&nbsp;

7. Given the results of step 6, you would now have some design options before you. Is the sample size n that your simulation indicated was needed to generate a confidence interval of span 0.2 realistic? In other words, would an experiment with so many female spiders (and so many males) be feasible? If the answer is yes, great, get started on your experiment! If the answer is no, the sample size required is unrealistically large, then you have some decisions to make:

- Forget all about doing the experiment. (Consider a thesis based on theory instead.)

- Revise your concept of what represents a “narrow” confidence interval. Maybe a confidence interval for p spanning, say, 0.3 to 0.7 (a span of 0.4) would be good enough to allow you to conclude that the preference was “not strong”. This would not require as big a sample size as a narrower interval.

&nbsp;

8. Repeat the above procedures to find a sample size that usually gives a confidence interval having a span of 0.4 or less.


&nbsp;

**Answers**

&nbsp;

All lines below beginning with double hashes are R output

```r
library(binom)

# 1. 10 females from a population having equal numbers 
# of successes (1) and failures (0)

x <- sample(c(1, 0), size = 10, c(0.5, 0.5), replace = TRUE)
x

##  [1] 1 1 0 0 0 1 1 1 1 0

sum(x)/10

## [1] 0.6

# 2. 

myCI <- binom.confint(sum(x), length(x), method = "ac")
myCI

##          method x  n mean     lower     upper
## 1 agresti-coull 6 10  0.6 0.3116041 0.8328894

mySpan <- myCI$upper - myCI$lower
mySpan

## [1] 0.5212853

# 3 & 4. 

# initialize empty vector "span"
span <- vector()

for(i in 1:5){
    x <- sample(c(1,0), size = 10, c(0.5,0.5), replace = TRUE)
    myCI <- binom.confint(sum(x), 10, method = "ac")
    span[i] <- myCI$upper - myCI$lower
    }

min(span)

## [1] 0.4747451

# 5.

n <- 20       # sample size each time
nruns <- 100  # number of runs

span <- vector()

for(i in 1:nruns){
    x <- sample(c(1,0), size = n, c(0.5,0.5), replace = TRUE)
    myCI <- binom.confint(sum(x), n, method = "ac")
    span[i] <- myCI$upper - myCI$lower
    }

hist(span, right = FALSE, col = "goldenrod", las = 1)
```
![](/img/10.4-hist.png)

&nbsp;

```r
# 6.

n <- 93       # sample size each time
nruns <- 100  # number of runs

span <- vector()

for(i in 1:nruns){
    x <- sample(c(1,0), size = n, c(0.5,0.5), replace = TRUE)
    myCI <- binom.confint(sum(x), n, method = "ac")
    span[i] <- myCI$upper - myCI$lower
    }

hist(span, right = FALSE, col = "goldenrod", las = 1)

```
![](/img/10.5-hist.png)

&nbsp;

```r
# 8.

n <- 21       # sample size each time
nruns <- 100  # number of runs

span <- vector()

for(i in 1:nruns){
    x <- sample(c(1,0), size = n, c(0.5,0.5), replace = TRUE)
    myCI <- binom.confint(sum(x), n, method = "ac")
    span[i] <- myCI$upper - myCI$lower
    }

hist(span, right = FALSE, col = "goldenrod", las = 1)

```
![](/img/10.6-hist.png)

&nbsp;

###Plan for power

&nbsp;

Assume that the preference p really is different from 0.5, and use null hypothesis significance testing to detect it. What strength of preference would we like to be able to detect in our experiment? To pick an extreme case, if the true proportion of females in the population choosing a male from her own species is 0.51 rather than 0.50, you would need an enormous sample size to detect it. But we don’t really care about such a small effect. Let’s start instead with the more realistic proportion p = 0.7. What sample size would be needed to detect it with reasonably high probability?

&nbsp;

1. Sample 20 females from a population in which the true fraction of “successes” is 0.7

&nbsp;

2. Apply the binomial test to your sample, to test the null hypothesis that the population proportion is 0.5. The binomial test calculates the exact 2-tailed probability of a result as extreme or more extreme as that observed if the null hypothesis is true. The method is implemented in R in the following command,

```r
z <- binom.test(x, n, p = 0.5)

```

&nbsp;

where x is the observed number of successes in your sample from step 1, and n is the sample size. z here is an object that stores the result. To see the results of the test enter print(z) or just z in the command line. If you just want to see the resulting P-value of the test, enter this instead:

```r
z$p.value

```

&nbsp;

Did you reject the null hypothesis?

&nbsp;

3. Create a loop to repeat steps 1 and 2 ten times. In what fraction of iterations was the null hypothesis rejected?

&nbsp;

4. By modifying the sample size and re-running the loop multiple times, find a sample size (ballpark, no need to be exact at this point) that usually results in the null hypothesis being rejected. Compare your results to those from the confidence interval simulation above.

&nbsp;

5. Is the sample size you determined feasible in an experiment? If the answer is yes, great! If the answer is no, because the sample size required is too large, then you have some decisions to make. You could decide not to run the experiment after all. Or, you could revise your aims. Perhaps your committee would be happy if you if you could detect a preference of 0.8 instead of 0.7.

&nbsp;

### Answers

&nbsp;

All lines below beginning with double hashes are R output

```r
# 1. Sample 20 females from a population in which the true fraction of "successes" is 0.7

x <- sample(c("success","failure"), size = 20, c(0.7,0.3), replace = TRUE)
nsuccess <- length(which(x == "success"))


# 2. Apply the binomial test

z <- binom.test(nsuccess, 20, 0.5)
z$p.value

## [1] 0.002576828


# 3. Repeat 10 times

result <- vector()

for(i in 1:10){
    x <- sample(c("success","failure"), size = 20, c(0.7,0.3), replace = TRUE)
    nsuccess <- length(which(x == "success"))
    z <- binom.test(nsuccess, 20, 0.5)
    result[i] <- z$p.value
    }

which(result <= 0.05)

## [1] 1 2 7 8


# 4. Repeating 100 times shows that a sample size of n = 50 females 
#   seems to reject Ho roughly 80% of the time

n <- 50 

result <- vector()

for(i in 1:100){
    x <- sample(c("success","failure"), size = n, c(0.7,0.3), replace = TRUE)
    nsuccess <- length(which(x == "success"))
    z <- binom.test(nsuccess, n, 0.5)
    result[i] <- z$p.value
    }

length(which(result <= 0.05))/100

## [1] 0.84

```
&nbsp;


### Power tools in R

Simulating random samples on the computer, as we did above, is a great way to investigate power and sample size requirements. It works in any situation and can mimic, even complicated study designs. However, a number of quantitative tools have been developed for mainly simple designs that do the work for you.


**Try the pwr package**

&nbsp;

Load the pwr library and use it to do some of the calculations for you. See the “Power and sample size” section of the “Planning tools” page on the R tips web pages for advice.

&nbsp;

1. Use the pwr package to calculate the approximate minimum sample size needed to detect a preference of 0.6 with a power of 0.80 (i.e., the null hypothesis would be rejected in 80% of experiments). The null hypothesis is that the population proportion p of females who would choose the male from her own population is 0.5. The goal is to design an experiment that has a high probability of rejecting the null hypothesis when p is 0.6.

&nbsp;

2. Repeat the above procedure for a preference of 0.7, 0.8, and 0.9.

&nbsp;

**Answers**

&nbsp;

All lines below beginning with double hashes are R output

```r
# You might need to install {pwr}
library(pwr)

# 1.

h <- ES.h(0.5, 0.6)

z <- pwr.p.test(h, power = 0.8)
z$n

## [1] 193.5839


# 2.

# Repeat for range values of pref

pref <- c(0.6, 0.7, 0.8, 0.9)

for(i in 1:length(pref)){
  h <- ES.h(0.5, pref[i])
  z <- pwr.p.test(h, power = 0.8)
  print(z$n)
}

## [1] 193.5839
## [1] 46.34804
## [1] 18.95431
## [1] 9.127904

```

&nbsp;

**Plan a 2 x 2 experiment**

&nbsp;

In an experiment on the great tit, two eggs were removed from 30 nests, which caused the attending females to lay one more egg. 35 un-manipulated nests served as controls. The response variable was incidence of malaria in female great tits at the end of the experiment. The results of the experiment are tabulated below.

&nbsp;

![](/img/10-malaria-table.png)


&nbsp;

Imagine that you are considering repeating this experiment on a different species of songbird. What are the chances of detecting an effect? What sample sizes should you plan?

&nbsp;

1. Randomly sample 30 females from a control population in which the fraction of infected birds is 0.2 (the fraction in the tit data). Sample also 30 females from an experimental population in which the fraction of infected birds is 0.5 (the fraction in the tit data). Combined the samples into a data frame. Include a variable indicating treatment.

&nbsp;

2. Display the 2 x 2 frequency table from your random sample. Is there an association?

&nbsp;

3. Repeat steps 1-3 three times to convince yourself that the answer is different each time.

&nbsp;

4. Using the tools in pwr calculate the sample size needed to achieve 80% power in this design.

&nbsp;

**Answers**

&nbsp;

All lines below beginning with double hashes are R output

```r
library(pwr)


# 1. 

x <- sample(c("malaria", "no"), size = 30, replace = TRUE, prob = c(0.2,0.8))
y <- sample(c("malaria", "no"), size = 30, replace = TRUE, prob = c(0.5,0.5))
z <- rep(c("control","treat"), c(30,30))

mydata <- cbind.data.frame(response = c(x,y), 
                          treatment = z, 
                          stringsAsFactors = FALSE)

# 2.

table(mydata)

##          treatment
## response  control treat
##   malaria       7    16
##   no           23    14


# 3. Repeat above

# 4. 

control <- c(0.2,0.8)
treatment <- c(0.5,0.5)

probs <- cbind.data.frame(treatment = treatment, control = control, 
            stringsAsFactors = FALSE)
            
w <- ES.w2(probs/sum(probs))           # Cohen's effect size "w"

z <- pwr.chisq.test(w, df = 1, power = 0.80)
z$N

## [1] 79.36072

```

&nbsp;

**Plan a 2-treatment experiment**

&nbsp;

Imagine that you are considering a two-treatment experiment for a numeric response variable. The treatments consist of two grazing regimes and the response variable is the number of plant species in plots at the end of the experiment. How many replicate plots should you set up? As usual, we will investigate only the case of equal sample sizes in the two groups.

&nbsp;

We’ll assume that the number of plant species in plots has a Gaussian distribution in both treatment and control. We’ll round the numbers so that they are integers.

&nbsp;

1. Randomly sample 20 measurements from a Gaussian distribution having a mean of 10 and a variance of 10 (so the standard deviation is the square root of 10). Call this the “control” group. Let’s round the numbers so that they are integers.

```r
control <- round(control, 0)

```

&nbsp;

2. Repeat step 1 for a second sample, this time from a Gaussian distribution having a mean of 15 but the same sample variance, 10. (This is a bit unrealistic, as we would expect the variance in numbers of species to be higher as the mean increases, but never mind for now). Call this the “treatment” group. In other words, we will investigate the power of this experiment to detect a 1.5-fold change in the mean number of species from control to treatment.

&nbsp;

3. Assemble the samples into a data frame in “long” format, with a second variable indicating which measurements are from the control group and which are from the treatment group. Create a histogram for each of the two samples and compare the distributions by eye.

&nbsp;

4. Using the power.t.test command in the basic R stats package, determine the power of the above design – probability that the experiment will detect a significant difference between the treatment and control means based on random samples.

&nbsp;

5. Using the same command, determine the sample size that would be necessary to achieve a power of 0.80.

&nbsp;

**Answers**

&nbsp;

All lines below beginning with double hashes are R output

```r

library(pwr)
library(ggplot2)


# 1.

x1 <- rnorm(20, mean = 10, sd = sqrt(10))
x1 <- round(x1,0)


# 2.

x2 <- rnorm(20, mean = 15, sd = sqrt(10))
x2 <- round(x2,0)


# 3.

nspecies <- c(x1, x2)

treatment <- rep(c("control", "treatment"), c(20,20))

mydata <- cbind.data.frame(nspecies, treatment, stringsAsFactors = FALSE)

ggplot(mydata, aes(x = nspecies)) + 
        geom_histogram(fill = "goldenrod", col = "black", 
        boundary = 0, closed = "left", binwidth = 2) +
    labs(x = "Number of species", y = "Frequency") + 
    theme(aspect.ratio = 0.5) + 
    facet_wrap( ~ treatment, ncol = 1, scales = "free_y")+
    theme_classic()

```
![](/img/10.7-hist.png)

&nbsp;

```r
# 4.

z <- power.t.test(n = 20, delta = 5, sd = 10)
z$power

## [1] 0.3377084


# 5.

z <- power.t.test(delta = 5, sd = 10, power = 0.80)
z$n

## [1] 63.76576

``` 

&nbsp;


&nbsp;

