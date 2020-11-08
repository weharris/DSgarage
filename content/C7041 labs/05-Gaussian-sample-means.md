---
title: "Lab 05 The Gaussian distribution"
author: "Ed Harris"
date: 2020-11-01
weight: 1
categories: ["c7041"]
tags: ["c7041", "R"]
---

&nbsp;

![ ](/img/05.1-cow.png)  

&nbsp;

## Goals

- Visualize properties of the Gaussian distribution

- Understand the Central Limit Theorem

- Calculate sampling properties of sample means

- Decide whether a data set likely comes from a Gaussian distribution

&nbsp;

[**Get the data for all labs here**](/data/c7041-lab-data.zip)

&nbsp;

---

## Start a script!

For this and every lab or project, **begin by starting a new script**, **create a good header section and table of contents**,  **save the script file with an informative name**, and **set your working directory**.  Aim to make the script useful as a future reference for doing things in R - this will come in handy for projects and assessments!

&nbsp;

## Learning the tools

&nbsp;

This lab mainly focuses on exploring the nature of the Gaussian distribution. We will also learn a couple of tools that help us decide whether a particular data set is likely to have come from population with an approximately Gaussian distribution.

Many statistical tests assume that the variable being analyzed has a Gaussian distribution. Fortunately, some of these tests are robust to this assumption: that is, they work reasonably well, especially when sample size is large (unless the assumption is grossly violated). Therefore it is often sufficient to be able to assess whether the data come from a distribution whose shape is even approximately Gaussian (e.g., are the data similar *enough* to a bell curve?).

A good way to start is to simply visualize the frequency distribution of the variable in the data set by drawing a histogram. Let’s use the age of passengers on the Titanic for our example.

```r
# Load data
# NB your file path may be different than mine
titanicData <- read.csv("data/titanic.csv" )

```

&nbsp;

Remember we can use `ggplot()` to draw histograms.

```r
ggplot(titanicData, aes(x = age)) +   
  geom_histogram(binwidth = 10)

## Warning: Removed 680 rows containing non-finite values (stat_bin).

```

![](/img/04.2-gghist.png)

&nbsp;

**hist()**

If we are just drawing a histogram for ourselves to explore and better understand the data, it is possibly easier to use a function from base R, `hist()`. Give `hist()` a vector of data as input, and it will print a histogram in the plots window.

```r
hist(titanicData$age)

```

![](/img/04.3-hist.png)

&nbsp;

Looking at this histogram, we see that the frequency distribution of the variable does not exactly resenble Gaussian. It is slightly asymmetric and there seems to be a second mode near 0. On the other hand, like the Gaussian distribution, this frequency distribution has a large mode near the center of the distribution, frequencies mainly fall off to either side, and there are no obvious outliers. This is probably close enough to Gaussian that most methods would work fine.

&nbsp;

**QQ plot**

Another graphical technique that can help us visualize whether a variable is approximately Gaussian is the quantile plot (or a QQ plot). The QQ plot shows the data on the vertical axis ranked in order from smallest to largest (“sample quantiles” in the figure below). On the horizontal axis, it shows the expected value of an individual with the same quantile if the distribution were Gaussian (“theoretical quantiles” in the same figure). The QQ plot should follow more or less along a straight line if the data come from a Gaussian distribution (with some tolerance for sampling variation).

QQ plots can be made in R using a function called `qqnorm()`. Simply give the vector of data as input and it will draw a QQ plot for you. `qqline()` will draw a line through that Q-Q plot to make the linear relationship easier to see.

```r
qqnorm(titanicData$age, 
        pch = 16, cex = .8)  # Mere vanity
qqline(titanicData$age, 
        col = "red", lwd = 4, lty = 2) # Mere vanity

```
![](/img/04.4-qq.png)

&nbsp;

This is what the resulting graph looks like for the Titanic age data. The dots do not land along a perfectly straight line. In particular the graph curves at the upper and lower end. However, this distribution definitely would be close enough to Gaussian to use most standard methods, such as the t-test.

It can be difficult to interpret QQ plots without experience. One of the goals of this lab is to develop some visual experience about what these graphs look like when the data is truly Gaussian. To do that, we will take advantage of a function built into R to generate random numbers drawn from a Gaussian distribution. This function is called `rnorm()`.

&nbsp;

**rnorm()**

The function `rnorm()` will return a vector of numbers, all drawn randomly from a Gaussian distribution. It takes three arguments:


**n**: how many random numbers to generate (the length of the output vector)


**mean**: the mean of the Gaussian distribution to sample from


**sd**: the standard deviation of the Gaussian distribution

For example, the following command will give a vector of 20 random numbers drawn from a Gaussian distribution with mean 13 and standard deviation 4:

```r
set.seed(1) # For replicability
rnorm(n = 20, mean = 13, sd = 4)

 # [1] 10.494185 13.734573  9.657486 19.381123 14.318031  9.718126 14.949716
 # [8] 15.953299 15.303125 11.778446 19.047125 14.559373 10.515038  4.141200
 # [15] 17.499724 12.820266 12.935239 16.775345 16.284885 15.375605
```

&nbsp;

Let’s look at a QQ plot generated from 100 numbers randomly drawn from a Gaussian distribution:

```r
set.seed(1)
Gaussian_vector <- rnorm(n = 100, mean = 13, sd = 4)

qqnorm(Gaussian_vector)
qqline(Gaussian_vector)

```

![](/img/04.5-qq.png)

&nbsp;

These points fall mainly along a straight line, but there is some wobble around that line even though these points were in fact randomly sampled from a known Gaussian distribution. With a QQ plot, we are looking for an overall pattern that is approximately a straight line, but we do not expect a perfect line. In the exercises, we’ll simulate several samples from a Gaussian distribution to try to build intuition about the kinds of results you might get.

When data are not Gaussian distributed, the dots in the quantile plot will not follow a straight line, even approximately. For example, here is a histogram and a QQ plot for the population size of various counties, from the data in `countries.csv`. These data are very skewed to the right, and do not follow a Gaussian distribution at all.


```r
countries <- read.csv("data/countries.csv", header=T)

hist(countries$total_population_in_thousands_2015, breaks=20)

qqnorm(countries$total_population_in_thousands_2015)
qqline(countries$total_population_in_thousands_2015)


```

![](/img/05.6-hist.png)

![](/img/05.7-qqnormie.png)


&nbsp;

### Transformations

When data are not Gaussian distributed, we can try to use a simple mathematical transformation on each data point to create a list of numbers that still convey the information about the original question but that may be better matched to the assumptions of our statistical tests. We may see more about such transformations later, but for now let’s learn how to do one of the most common data transformations, the log-transformation.

With a transformation, we apply the same mathematical function to each value of a given numerical variable for individual in the data set. With a log-transformation, we take the logarithm of each individual value for a numerical variable.

We can only use the log-transformation if all values are greater than zero. Also, it will only improve the fit of the Gaussian distribution to the data in cases when the frequency distribution of the data is right-skewed.

To take the log transformation for a variable in R is very simple. We simply use the function log(), and apply it to the vector of the numerical variable in question. For example, to calculate the log of age for all passengers on the Titanic, we use the command:

```r
log(titanicData$age)

```

This will return a vector of values, each of which is the log of age of a passenger.


&nbsp;

## R commands summary

![](img\05.8-commands.png)


&nbsp;

## Challenge questions

> Make a script in RStudio that collects all your R code required to answer the following questions. Include answers to the qualitative questions using comments.

&nbsp;

1. We will use R’s random number generator for the Gaussian distribution to build intuition for how to view and interpret histograms and QQ plots. Remember, the lists of values generated by `rnorm()` come from a population that truly have a Gaussian distribution.

a. Generate a list of 10 random numbers from a Gaussian distribution with mean 15 and standard deviation 3, using the following command:

```r
Gaussian_vector <- rnorm(n = 10, mean = 15, sd = 3)

```

&nbsp;

b. Use `hist()` to plot a histogram of these numbers from part a.

c. Plot a QQ plot from the numbers in part a.

d. Repeat a - c several times (at least a dozen times). For each, look at the histograms and QQ plots. Think about the ways in which these look different from the expectation of a Gaussian distribution (but remember that each of these samples comes from a true Gaussian population).


&nbsp;

2. Repeat the procedures of Question 1, except this time have R sample 250 individuals for each sample. (You can use the same command as in Question 1, but now set n = 250.) Do the graphs and QQ plots from these larger samples look more like the Gaussian expectations than the smaller sample you already did? Why do you think that this is?


&nbsp;

3. In 1898, Hermon Bumpus collected house sparrows that had been caught in a severe winter storm in Chicago. He made several measurements on these sparrows, and his data are in the file “bumpus.csv”.

Bumpus used these data to observe differences between the birds that survived and those that died from the storm. This became one of the first direct and quantitative observations of natural selection on morphological traits. Here, let’s use these data to practice looking for fit of the Gaussian distribution. 

a. Use `ggplot()` to plot the distribution of total length (this is the length of the bird from beak to tail). Does the data look as though it comes from distribution that is approximately Gaussian?

b. Use `qqnorm()` to plot a QQ plot for total length. Does the data fall approximately along a straight line in the QQ plot? If so, what does this imply about the fit of these data to a Gaussian distribution?

c. Calculate the mean of total length and a 95% confidence interval for this mean. 

&nbsp;

4. The file “mammals.csv” contains information on the body mass of various mammal species.

Plot the distribution of body mass, and describe its shape. Does this look like it has a Gaussian distribution?

Transform the body mass data with a log-transformation. Plot the distribution of log body mass. Describe the new distribution, and examine it for Gaussianity.

&nbsp;

&nbsp;

