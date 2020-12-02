---
title: "Misc 04 Sample size and power"
author: "Ed Harris"
date: 2020-11-01
weight: 1
categories: ["R Misc"]
tags: ["R Misc", "R"]
---

&nbsp;

![sumo](/img/misc-04.1-sumo.jpg)  
**If power analysis were an athlete, it would be a sumo wrestler**

&nbsp;

## Defending your sample size

&nbsp;

**Overview**

> **Many scientific studies lack sufficient statistical power, failing to defend their sample size**  

&nbsp;

**Contents**

[4.1 Data simulation to explore sample size](#anchor-1) 

[4.2 Power and sample size calculation](#anchor-2)

[4.3 Suggested reading](#anchor-3)


&nbsp;

This page provides a brief overview on two methods to defend your sample size.  First, methods in data and sample size simulation are examined. Then, we will look at tools for calculating power and sample size.

# {#anchor-1}

&nbsp;

&nbsp;

### Data simulation to explore sample size determination

Here, we explore how to simulate data by random sampling from a population with a known (or estimated) mean and variance, or a known proportion. Such data sets can be useful for exploring design and analysis strategies prior to beginning an experiment.

Two vector functions you will use frequently are `c()` to concatenate values and `rep()` to replicate values. For example,

```r
x1 <- c(1, 2, 3, 4, 5)             # Combine numbers in a vector
x2 <- c(x1, c(9, 8, 7))            # Combine two vectors into one
x <- rep(1, 10)                    # Make a vector with ten 1's
x <- rep(c(1, 2), 5)               # Make the vector 1 2 1 2 ... (5 times)
A <- rep(c("a", "b"), c(4, 2))     # Make the vector a a a a a b b

```

&nbsp;

**Gausian-distributed populations**

In the following example we sample 5 random numbers from a Gaussian population having a mean of 2 and a standard deviation of 10. Repeat it several times to convince yourself that the outcomes are different each time. Modify the mean and sd values to see how this affects the results. Change the 5 to another number (e.g. a higer number like, 30) to obtain a different sample size.

```r
myrand <- rnorm(n = 5, mean = 2, sd = 10)

# You can round the data to 2 decimal places using:

myrand <- round(x = myrand, digits = 2)

```

&nbsp;

**Categorical data**

To sample 20 individuals from a population in which 40% of individuals are diseased and 60% are healthy,

```r
sample( c("diseased", "healthy"), size = 20, 
        replace = TRUE, prob = c(.4, .6))

```

&nbsp;

**Two treatments, Gaussian data**

The following commands generate a data frame with data from 20 individuals in two treatment groups (10 in each group). In this first example, the mean response is the same between treatments.

```r
treatment <- rep( c("treat", "control"), c(10, 10))

response <- rnorm(20, mean = 10, sd = 3)

mydat <- data.frame(treatment, response, stringsAsFactors = FALSE)

mydat
```

```
   treatment  response
1      treat 12.316904
2      treat  4.645895
3      treat  7.052028
4      treat 13.003198
5      treat 12.727637
6      treat 11.788675
7      treat  8.790188
8      treat 10.916575
9      treat  5.706918
10     treat  9.572046
11   control  7.700946
12   control  7.935650
13   control  8.032526
14   control  7.726573
15   control 16.505601
16   control 12.831074
17   control  5.933128
18   control  9.521768
19   control  7.688485
20   control  9.102640
```

&nbsp;

The following commands modify the above procedure so that the mean is different between treatment and control groups, but the standard deviation remains the same (the usual assumption of linear models).

```r
treatment <- rep(c("treat", "control"), c(10, 10))
response1 <- rnorm(10, mean = 10, sd = 3)
response2 <- rnorm(10, mean = 8,  sd = 3)

mydat <- data.frame(treatment, response = c(response1, response2), 
                    stringsAsFactors = FALSE)

```

&nbsp;

**Two treatments, categorical data**

The following commands generate a data frame with categorical data from 20 individuals in two treatment groups (10 in each group). The response variable is `“dead”` or `“alive”`. In this first example, the proportion alive is the same, 0.3, between treatments.

```r
treatment <- rep(c("treat", "control"), c(10, 10))
survival <- sample(c("alive", "dead"), size = 20, 
                   replace = TRUE, prob = c(.3, .7))

mydat <- data.frame(treatment, survival, stringsAsFactors = FALSE)

table(mydat) # view the sampling results

```

```
         survival
treatment alive dead
  control     2    8
  treat       4    6

```

&nbsp;

The following commands modify the above procedure so that the probability of survival is different between treatment (0.6) and control (0.3) groups.

```r
treatment <- rep(c("treat", "control"), c(10, 10))

s1 <- sample(c("alive", "dead"), 10, replace = TRUE, prob = c(.6, .4))
s2 <- sample(c("alive", "dead"), 10, replace = TRUE, prob = c(.3, .7))

mydat <- data.frame(treatment, survival = c(s1,s2), stringsAsFactors = FALSE)
table(mydat) # view the sampling results

```

```
         survival
treatment alive dead
  control     3    7
  treat       6    4
```

# {#anchor-2}

&nbsp;

&nbsp;

### Power and sample size calculation

The **statistical power** of a test is its probability of rejecting the null hypothesis when it is fact false. A rule of thumb minimum level of statistical power for experimental design is 80%.  Here we introduce tools in R to calculate the sample size required to achieve a specific level of statistical power, *given* a specified magnitude of difference from the null hypothesis. You can also determine the power for a given sample size.

We’ll use functions in the `{pwr}` package. These functions are built on the methods of **Cohen. 1988. *Statistical power analysis for the behavioral sciences*.**

To begin, load the `{pwr}` package (you’ll need to download and install the package from the CRAN website if you haven’t already done so – it isn’t part of the standard installation).

```r
library(pwr)

```

&nbsp;

The procedures involve two steps. The first step converts your quantities of interest to an **"effect size"**. Effect sizes are standard measures of the magnitude of a *difference* or of the strength of the *relationship between two variables*. Effect size is used to design experiments, but it is also used in meta-analysis to compare results from diverse studies using different methods and types of variables. 

Cohen developed these measures of effect size that are in common use. 

The second step is to calculate power or sample size for the given or estimated effect size. In all the examples below we use a standard significance level of `α = 0.05`.

&nbsp;

**For a single proportion**

The binomial test is used to compare the observed frequency of “success” and “failure”. The `χ2` goodness of fit test is used in the same context when sample size is large. The null and alternative hypotheses for the test are

```
Null hypothesis:
My proportion p IS NOT DIFFERENT to some null proportion p0

HO:p=p0 

Alternative hypothesis:
My proportion p IS DIFFERENT to some null proportion p0

HA:p≠p0
```

&nbsp;

**Effect size for proportion test**

Each different kind of statistical test you may perform will typically have an associated **effect size**.  The effect size is different for different kinds of tests. E.g. a difference in means (relative to variation), a measure of assocation (like the correlation coefficient), etc. 

The `pwr.p.test()` function calculates the statistical power (remember, the probability of rejecting the Null GIVEN it is actually false) of this test for a given sample size, or the sample size needed to achieve a specified power. `pA` refers to the proportion under the alternative hypothesis that you would like to compare.  `p0` is the null proportion to which you compare `pA`.

`Cohen's h` is the effect size here, here quantifying the different between `p0` and `pA`.

```r
# The effect size for comparing proportions is Cohen's "h"
# use the ES.h() to cacluate it
# convert your p's to Cohen's effect size "h"
h <- ES.h(p0, pA)           

# Returns SAMPLE SIZE needed to achieve power of 80%
pwr.p.test(h = h, power = 0.8)  


# Returns POWER of test when n = 50
pwr.p.test(h = , n = 50)   

```

&nbsp;

For example, to determine the sample size needed to achieve 80% power of a test in which the null hypothesis is 0.5, and in which you hope to detect a proportion at least as large as 0.7, use

```r 

myh <- ES.h(0.5, 0.7)

pwr.p.test(h = myh, power = 0.8)

```

```
     proportion power calculation for binomial distribution (arcsine transformation) 

              h = 0.4115168
              n = 46.34804
      sig.level = 0.05
          power = 0.8
    alternative = two.sided
```    

&nbsp;

**For a 2x2 experiment**

The Fisher exact test and `χ2` contingency test are used to detect association between treatment and response in a 2 x 2 experiment. The `{pwr}` package has routines to calculate power and sample size in a 2 x 2 design for the χ2 contingency test. To use them, you need to specify he probability of “success” and “failure” in both treatment and control. The method below assumes that the sample size is the same in both the treatment and controls. For example, to determine the power of


```r

control <- c(0.5, 0.5)                   # control prob. of success, failure
treatment <- c(0.3, 0.7)                 # treatment probs.
probs <- data.frame(treatment, control)  # a 2 x 2 data frame of p's
probs <- cbind(treatment, control)       # this works too: a 2 x 2 matrix of p's

w <- ES.w2(probs/sum(probs))             # Cohen's effect size "w"
w

```
```
[1] 0.2041241
```

&nbsp;

To calculate the power of the test for a given total sample size,

```r
# N is the total sample size
pwr.chisq.test(w, df = 1, N = 60) 

```

&nbsp;

To calculate the total sample size needed to achieve a test with 80% power,

```r
pwr.chisq.test(w, df = 1, power = 0.80)

```

&nbsp;

**For a two-sample t-test or anova**

`Cohen's d` quantifies the effect size here.

If your response variable is normally distributed with equal variance in both groups, you would use a two-sample t-test (or, equivalently, an anova on two groups). The basic stats package in R includes a function to calculate power and sample size for this case, `power.t.test()`.

To calculate power, first calculate delta, the known (i.e., expected, or estimated) difference between means. You will also need to know the standard deviation within each group. Then, to calculate power of an experiment for given sample size n in each group (2n overall, since we are assuming equal sample size...):

```r
# The basic function for power for the t-test

# Calculate SAMPLE SIZE for an assumed 
# delta (DIFFERENCE between means) and
# sd (standard deviation around means, pooled sd of course)
power.t.test(delta = delta, sd = sd, power = 0.80)


# Calculate POWER for a given sample size
power.t.test(n = n, delta = delta, sd = sd)
```

# {#anchor-3}

&nbsp;

&nbsp;

### Suggested reading

&nbsp;

There is a lot more to this subject and it is very important.

&nbsp;

Cohen, J., 1992. A power primer. Psychol Bull 112, 155–159. https://doi.org/10.1037//0033-2909.112.1.155

Colegrave, N., Ruxton, G.D., 2003. Confidence intervals are a more useful complement to nonsignificant tests than are power calculations. Behav Ecol 14, 446–447. https://doi.org/10.1093/beheco/14.3.446

Collaboration, O.S., 2015. Estimating the reproducibility of psychological science. Science 349. https://doi.org/10.1126/science.aac4716

Hoenig, J.M., Heisey, D.M., 2001. The Abuse of Power. The American Statistician 55, 19–24. https://doi.org/10.1198/000313001300339897

Ioannidis, J.P.A., 2005. Why Most Published Research Findings Are False. PLOS Medicine 2, e124. https://doi.org/10.1371/journal.pmed.0020124

Nakagawa, S., 2004. A farewell to Bonferroni: the problems of low statistical power and publication bias. Behav Ecol 15, 1044–1045. https://doi.org/10.1093/beheco/arh107

Verhoeven, K.J.F., Simonsen, K.L., McIntyre, L.M., 2005. Implementing false discovery rate control: increasing your power. Oikos 108, 643–647. https://doi.org/10.1111/j.0030-1299.2005.13727.x


&nbsp;

&nbsp;