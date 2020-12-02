---
title: "Misc 01 R Basics"
author: "Ed Harris"
date: 2020-11-01
weight: 1
categories: ["R Misc"]
tags: ["R Misc", "R"]
---

![ ](/img/misc-01.1-ladybird.jpg)  

&nbsp;

## R Tips and tricks on a variety of topics


&nbsp;

**Overview**

> **The great thing about data analysis, statistics, programming, and R, is that there is always something new to learn.**  

Tools for creating evidence from data are constantly evolving and changing.  These days, the advancement is faster than ever.  This page presents some tips and tricks on a variety of topics to make the journey easier.

&nbsp;

**Contents**


[1.1 Get the latest versions of R and RStudio](#anchor-1-1)

[1.2 Use a script file](#anchor-1-2)

[1.3 Get add-on packages](#anchor-1-3)

[1.4 Get R help](#anchor-1-4)

[1.5 Working with Vectors](#anchor-1-5)

[1.6 Useful vector functions](#anchor-1-6)

[1.7 Combine vectors into a data frame](#anchor-1-7)

[1.8 Missing values](#anchor-1-8)

[1.9 Write your own function](#anchor-1-9)

[1.10 Paste clipboard to a vector](#anchor-1-10)

&nbsp;


## R Basics

# {#anchor-1-1}

&nbsp;

&nbsp;

### 1.1 Get the latest versions of R and RStudio

[Download R for your operating system from the CRAN website](https://cran.r-project.org/)

Mac users: Some packages may require that you have installed [the latest version of the XQuartz package](http://xquartz.macosforge.org/)

Most people will want to [use R within the Rstudio environment](https://rstudio.com/products/rstudio/download/)

&nbsp;

# {#anchor-1-2}

&nbsp;

&nbsp;

### 1.2 Use a script file

Use a text file to write and edit your R commands. This keeps a record of your analyses for later use, and makes it easier to rerun and modify analyses as data collection continues.

RStudio has a built-in editor that makes it easy to submit commands selected in a script file to the command line. Go to “File” on the menu and select “New File” and then select "R Script" (or **Ctrl + Shift + N**). Save to a file with the `.R` extension. To open a preexisting file, choose “Open Document” or “Open script” from the “File” menu (or **Ctrl + O**).

Execute a line of code by placing the cursor anywhere on the line and pressing the keys **Ctrl + Enter** (Windows) or **Command + Enter** (Mac)

&nbsp;

**Very basic script tips**

- Use a new script file for each project.

- Write lots of notes in the script file to record how and why you did that particular analysis. This is essential when reviewing it weeks (years) later. Annotate as though someone else will be reading your script later and attempt to duplicate your effort and make sense of it.

- Write generic code that can easily be extended to other situations with a minimum of editing. For example, write code to read values of x and y from a data file rather than "hard coding" the points in an R script file explicitly.

- R will start up if you double click a script file. If this happens, R might not load the workspace. Enter load(“.RData”) in R’s command window and all will be well.

&nbsp;

# {#anchor-1-3}

&nbsp;

&nbsp;

### 1.3 Get add-on packages

R has a core set of command libraries (base, graphics, stats, etc), but there is a wealth of add-on packages available (the full list is available at the CRAN web site).

&nbsp;

**Standard Packages**

The following are a few of the add-on packages already included with your standard R installation:

`boot` – bootstrap resampling

`foreign` – read data from files in the format of other stats programs

`ggplot2` – graphics

`lme4` – linear mixed-effects models; general least squares

`MASS` – package for the book by Venables and Ripley, Modern Applied Statistics with S-PLUS

`mgcv` – generalized additive models

&nbsp;

To use the tools in a package, you need to load it!

`library(packagename)`

You’ll have to do this again every time you run R.

To see all the libraries available on your computer enter

`library()`

&nbsp;

**Non-standard packages (examples)**

The vast majority of R packages are not included with the standard installation, and you need to download and install ones you want to use before you can use them. Here are a few add-on packages that might be useful in ecology and applied biology. [The full list of available packages is here](https://cran.r-project.org/web/packages/available_packages_by_name.html)

&nbsp;

`car` – linear model tools (e.g., alternative sums of squares), from the book Fox & Weisberg *An R Companion to Applied Regression*

`leaps` – all subsets regression

`emmeans` – group means for ANOVA and other linear models

`meta` – meta-analysis

`pwr` – power analysis

`qtl` – QTL analysis

`shapes` – geometric morphometrics

`vegan` – ordination and biodiversity methods for community ecology

`visreg` – visualize linear model fits

&nbsp;

**Install an R package**

&nbsp;

To install packages use the packages tab > Install button in RStudio or the `install.packages()` function. 

`install.packages("packagename", dependencies = TRUE)`

To use a package once it is installed, load it by entering

`library(packagename)`

R is under constant revision, and periodically it is a good idea to install the latest version. Once you have accomplished this, you should also download and install the latest version of all the add-on packages too.

# {#anchor-1-4}

&nbsp;

&nbsp;

### 1.4 Get R help

&nbsp;

**Built-in help**

Use the `help()` function or `?` in the R command window to get documentation of specific function name. For example, to get help on the `mean()` function (used to calculate a sample mean), enter

`help(mean)` or `?mean`

&nbsp;

You can also search the help documentation on a more general topic using ?? or help.search. For example, use the following commands to find out what’s available on anova and linear models.

`??anova`

`??"linear models"  # same as help.search("linear models")`

&nbsp;

A window will pop up that lists commands available and the packages that include them. To use a command indicated you might have to load the corresponding library. (See “Add-on packages” for help on how to load libraries.) Note the ?? command will only search documentation in the R packages installed on your computer.

&nbsp;

**Interpret a help page**

As an example, here’s how to interpret the help page for the sample mean, obtained by

?mean
In the pop-up help window, look under the title **“Usage”** and you will see something like this:

`mean(x, trim = 0, na.rm = FALSE, ...)`

The items between the brackets “()” are called **arguments**.

Any argument shown without an “=” sign means **it is required for you to provide it for the command to work**. Any argument with an “=” sign represents an option, with the default value indicated. (Ignore the "…" part for now.)

In this example, the argument x represents the data object you supply to the function. Look under **“Arguments”** on the help page to see what kind of object R needs. In the case of the mean almost any data object will do, but you will usually apply the function to a vector (representing a single variable).

If you are happy with the default settings, then you can use the command in its simplest form. If you want the mean of the elements in the variable myvariable, enter:

`mean(myvariable)`

&nbsp;

If the default values for the options don’t meet your needs you can alter the values. The following example changes the na.rm option to TRUE. This instruct R to remove missing values from the data object before calculating the mean. (If you fail to do this and have missing values, R will return NA.)

`mean(myvariable, na.rm = TRUE)`

&nbsp;

The following example changes the trim option to calculate a "trimmed mean":

`mean(myvariable, trim = 0.1)`

&nbsp;

**Online help**

You are spoiled for choice on the internet - here are a few cherry-picked useful ones.

You might wish to look at a reference cheat sheet for R, like **[Tom Short’s R reference card](https://cran.r-project.org/doc/contrib/Short-refcard.pdf)**

Venables and Smith’s Introduction to R **[HTML](https://cran.r-project.org/doc/manuals/R-intro.html)** , **[PDF to download](https://cran.r-project.org/doc/manuals/R-intro.pdf)**

**[Daily news and tutorials about R](https://www.r-bloggers.com/)**

&nbsp;

**Someone has solved your problem and shared it on the internet**

The judicious use of Google might (!) help solve your problem, e.g. google your error message or shearch for a phrase to find methods for some task you are trying to do.


&nbsp;

# {#anchor-1-5}

&nbsp;

&nbsp;

### 1.5 Working with vectors

A **vector** is a simple array of numbers or characters, such as the measurements of a single variable on a sample of individuals. R makes it easy to carry out mathematical operations and functions to all the values in a vector at once.

&nbsp;

**Enter measurements**

Use the left arrow syntax “<-” (“less than” sign followed by a dash) and the c function (for concatenate) to create a vector containing a set of measurements.  

```r
x <- c(11,42,-3,14,5)              # store these 5 numbers in vector x
x <- c(1:10)                       # store integers 1 to 10
x <- c("Watson","Crick","Wilkins") # use quotes for character data
```

&nbsp;

Use the seq function to generate a sequence of numbers and store in a vector,

```r
x <- seq(0, 10, by=0.1)            # 0, 0.1, 0.2, ... 9.9, 10
```

(note: seq results that include decimals may not be exact – the result “0.2” may not be exactly equal to the number 0.2 unless rounded using the “round” command)

&nbsp;

Use rep to repeat values a specified number of times and store to a vector,

```r
x <- rep(c(1,2,3), c(2,1,4))       # 1 1 2 3 3 3 3
```

&nbsp;

To view contents of any object, including a vector, type its name and enter, or use the print command,

```r
x                  # print "x" to the screen
print(x)           # do the same
```

&nbsp;

**Delete a vector**

The following command removes the vector x (or any other R object you name) from the local R environment. This is sometimes useful.

`rm(x)`

&nbsp;

**Access elements of a vector**

Use integers in square brackets to indicate specific elements of a vector. For example,

```r
x[5]           # 5th value of the vector x
x[2:6]         # 2nd through 6th elements of x
x[2:length(x)] # everything but the first element
x[-1]          # everything but the first element
x[5] <- 4.2    # change the value of the 5th element to 4.2
```

&nbsp;

**Math with vectors**

These operations are carried out on every element of the vector

```r
x + 1          # add 1 to each element of x
x^2            # square each element of x
x/2            # divide each element of x by 2
10 * x         # multiply each element of x by 10
```

&nbsp;

Operations on two vectors x and y work best when both are the same length (have the same number of elements). For example

```r
x * y        # yields a new vector whose 
             # elements are x[1]*y[1], x[2]*y[2], ... x[n]*y[n]
```

&nbsp;

If x and y are not the same length, then the shorter vector is elongated by starting again at the beginning.

&nbsp;

# {#anchor-1-6}

&nbsp;

&nbsp;

### 1.6 Useful vector functions

Here is a selection of useful functions for data vectors. Many of the functions will also work on other data objects such as data frames, possibly with different effects.

&nbsp;

**Transform numerical data**

The most common data transformations, illustrated using the single variable x.

```r
sqrt(x)          # square root
sqrt(x + 0.5)    # modified square root transformation
log(x)           # the natural log of x
log10(x)         # log base 10 of x
exp(x)           # exponential ("antilog") of x
abs(x)           # absolute value of x
asin(sqrt(x))    # arcsine square root (used for proportions)
```

&nbsp;

**Statistics**

Here are a few basic statistical functions on a numeric vector named x. Most of them will require the na.rm=TRUE option if the vector includes one or more missing values.

```r
sum(x)                 # the sum of values in x
length(x)              # number of elements (including missing)
mean(x)                # sample mean
var(x)                 # sample variance
sd(x)                  # sample standard deviation
min(x)                 # smallest element in x
max(x)                 # largest element in x
range(x)               # smallest and largest elements in x
median(x)              # median of elements in x
quantile(x)            # quantiles of x
unique(x)              # extracts only the unique values of x
sort(x)                # sort, smallest to largest
weighted.mean(x, w)    # weighted mean
```

&nbsp;

**Functions for character data**

```r
casefold(x)              # convert to lower case
casefold(x, upper=TRUE)  # convert to upper case
substr(x, 2, 4)          # extract 2nd to 4th characters of each element of x
paste(x, "ly", sep="")   # paste "ly" to the end of each element in x
nchar(x)                 # no. of characters in each element of x
grep("a", x)             # which elements of x contain letter "a" ?
grep("a|b", x)           # which elements of x contain letter "a" or letter "b"?
strsplit(x, "a")         # split x into pieces wherever the letter "a" occurs
```

&nbsp;

**Functions for factors**

A factor is like a character variable except that its unique values represent “levels” that have names but also have a numerical interpretation. The following commands are useful if x is a factor variable (a vector).

```r
levels(x)                   # show the unique values of a factor variable
droplevels(x)               # delete unused levels of a factor variable
as.character(x)             # convert values of a factor to character strings instead
as.numeric(as.character(x)) # convert numbers in "x" from factors to numeric type
```

&nbsp;

**TRUE and FALSE data**

Vectors can be assigned logical measurements, directly or as the result of a logical operation. Here’s an example of direct assignment.

```r
z <- c(TRUE, TRUE, FALSE)  # put 3 logical values to a vector z
```

&nbsp;

Logical operations can identify and select those vector elements for which a condition is TRUE. The comparison operations include

```r
 ==  (equal to)
 !=  (not equal to)
 <   (less than)
 <=  (less than or equal to)
 %in% (is an element of)
```
 
and so on.

&nbsp;

**Try this**

```r
# put the following numbers into a vector z,

z <- c(2, -1, 3, 99, 8 )

# Try the following logical operations and functions 

z <= 3             # TRUE TRUE TRUE FALSE FALSE (for each element of z)
!(z < 3)           # FALSE FALSE TRUE TRUE TRUE
z[z != 3]          # 2 -1 99  8, the elements of z for which the condition is TRUE
which(z <= 4)      # 4 5, the indices for elements of z satisfying the condition
is.na(z)           # FALSE FALSE FALSE FALSE FALSE
any(z < 0)         # TRUE
all(z < 0)         # FALSE
99 %in% z          # TRUE
100 %in% z         # FALSE
```

&nbsp;

The logical operators “&” and “|” refer to AND and OR. For example, put the following numbers into a vector z,

```r
z <- c(-10, -5, -1, 0, 3, 92)
```

&nbsp;

The following operations yield the results shown on the right

```r
z < 0 & abs(z) < 5     # TRUE FALSE FALSE FALSE FALSE FALSE

z[z < 0 | abs(z) < 5]  # -10  -5  -1  92
```

**What am I?**

These functions return TRUE or FALSE depending on the structure of x and its data type.

```r
is.vector(x)
is.character(x)
is.numeric(x)
is.integer(x)
is.factor(x)
```

&nbsp;

# {#anchor-1-7}

&nbsp;

&nbsp;

### 1.7 Combine vectors into a data frame

Vectors representing different variables measured made on the same unit can be made into columns of a data frame. A data frame is a spreadsheet-like object containing a data set. See the “Data” tab for tips on working with data frames. Here we show how to make a data frame by combining vectors of the same length. The vectors need not be of the same data type.

&nbsp;

First, obtain some vectors:

```r
quadrat <- c(1:7)
site <- c(1,1,2,3,3,4,5)
species <- c("a","b","b","a","c","b","a")
```

&nbsp;

Now combine them into a data frame named mydata.

&nbsp;

```r
mydata <- data.frame(quadrat = quadrat, site = site, species = species, 
                    stringsAsFactors = FALSE)
```

&nbsp;

The argument `stringsAsFactors = FALSE` is optional but recommended to preserve character data (otherwise character variables are converted to factors).

You can accomplish the same job using the tibble command in the `{dplyr}` package (you’ll need to install the package if you have not already done so using `install.packages()`).

```r
library(dplyr)                                                       # load package
mydata <- tibble(quadrat = quadrat, site = site, species = species)  # dplyr method
```

&nbsp;

# {#anchor-1-8}

&nbsp;

&nbsp;

### 1.8 Deal with missing values

Missing values in R are indicated with `NA`.

```r
x[5] <- NA        # assign "missing" to the 5th element of x
x[x == -99] <- NA # change all instances of -99 in x to missing
which(is.na(x))   # identify which element(s) is missing
```

&nbsp;

Some functions will treat NA as valid entries. For example, the length of a vector (number of elements) includes missing values in the count.

&nbsp;

**length(x)**

Some functions won’t work on variables that include missing values unless default options are modified. For example, if you try to calculate the mean of a vector that contains missing values you will get NA as your result. Most functions have an option “na.rm” that ignores the missing values when calculating.

```r
x <- c(1,2,3,4,5,NA)  # a vector with one missing value
mean(x)               # result is NA
mean(x, na.rm = TRUE) # result is the mean of non-missing values of x
```

&nbsp;

As usual, there’s more than one way to solve the problem. For example, you can create a new variable that contains only the non-missing values, but this requires an extra step so it not preferred:

```r
x1 <- na.omit(x)           # put the non-missing values of x into new vector x1
x1 <- x[complete.cases(x)] # same
x1 <- x[!is.na(x)])        # same
length(x1)                 # count the number of non-missing values
```

# {#anchor-1-9}

&nbsp;

&nbsp;

### 1.9 Write your own function

&nbsp;

If R is missing a needed function write your own. Here’s an example of a function named sep() that calculates the standard error of an estimate of a proportion. The argument n refers to sample size, and X is the number of “successes” (e.g., the number of females in the sample, the number of infected individuals, etc.).

```r
sep <- function(X, n){
  p.hat <- X / n                  # The proportion of "successes"
  sep <- sqrt(p.hat*(1-p.hat)/n)  # The standard error of p.hat
  return(sep)                     # Return the standard error as the result
  }
```

&nbsp;

To use the function, copy it to your clipboard. Then paste it into your command window and hit the enter key. (On a Mac, you may need to use the R Edit menu to “Paste as Plain Text” to avoid formatting problems.) The function sep() will be stored in your R workspace so you only need to paste it once. If you save your workspace when you exit R it will remain there when you start up again – otherwise you’ll need to paste it in again.

&nbsp;

To use the function on some data, for example n=20 and X=10, enter:

```r
sep(X = 10, n = 20) # yields the standard error
sep(10,20)          # shorthand ok if X and n are given in correct order
```

&nbsp;


# {#anchor-1-10}

&nbsp;

&nbsp;

### 1.10 Paste clipboard to a vector

&nbsp;

To demonstrate, select the following 10 numbers with your mouse and copy to your clipboard: 76 75 -52 -70 52 8 -50 -6 57 5 (choose Edit -< Copy on your browser menu to copy to clipboard) Then execute the following command in your R command window:

```r
z <- scan("clipboard", what=numeric())             # on a PC
z <- scan(pipe("pbpaste"), what=numeric())         # on a Mac
```

&nbsp;


To paste characters instead of numbers, use the following,

```r
z <- scan("clipboard", what=character())           # PC
z <- scan(pipe("pbpaste"), what=character())       # Mac
```

&nbsp;

If characters or numbers of interest are separated by commas, use

```r
z <- scan("clipboard", what=character(), sep=",")      # PC
z <- scan(pipe("pbpaste"), what=character(), sep=",")  # Mac
```

&nbsp;

&nbsp;
