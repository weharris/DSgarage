---
title: "Misc 02 R Data files"
author: "Ed Harris"
date: 2020-11-01
weight: 1
categories: ["R Misc"]
tags: ["R Misc", "R"]
---

![ ](/img/misc-02.1-data.jpg)  

&nbsp;

## Reading and working with data files in R


&nbsp;

**Overview**

> **The hardest part of starting to use R, is learning how to read in your data file**  

This page introduces the bare basics of working with data sets with multiple variables of different types. Data frames are the most convenient data objects in R. Others you will run across are matrices and lists, which are also described here.

&nbsp;

**Contents**


[2.1 Data file tips](#anchor-2-1) 

[2.2 Read data from csv file](#anchor-2-2)

[2.3 Write and save data to a file](#anchor-2-3)

[2.4 Manipulate data frames](#anchor-2-4)

[2.5 Combine two data frames](#anchor-2-5)

[2.6 Manipulate matrix objects](#anchor-2-6)

[2.7 Manipulate list objects](#anchor-2-7)


# {#anchor-2-1}

&nbsp;

&nbsp;

### 2.1 Data file tips

In R you may encounter `data frames` (native to base R), or an alternative in the `{tidyverse}` called data `tibbles`.  

Using tibbles requires a few libraries:

```r
# both these
library(readr)
library(dplyr)

# or just this
library(tidyverse) # loads both packages and others including ggplot2
```

&nbsp;

Most `{dplyr}` functions will work on both types of data frames. It is also easy to convert back and forth between the two types of data frame.

```r
# convert data frame to tibble type
mydata <- as_tibble(my_data_frame)                               

# do the reverse
mydata <- as.data.frame(my_data_tibble, stringsAsFactors = FALSE)
```

&nbsp;

**Enter data using a spreadsheet**

Enter your data using a spreadsheet program like Excel. Use columns for variables and rows for individual sampling units. 

&nbsp;

**Long vs wide layouts**

Keep data that you want analyzed together in a single worksheet. A “long” layout is recommended, rather than a “wide” layout. Here is an example of a wide layout of data on the numbers of individuals of 3 species recorded in plots and sites.

```
Plot    Site      species1   species2   species3
 1        A           0          12         4
 2        A          88           2         0
 3        B          12           4         1   
...
```

&nbsp;

The equivalent long layout will typically be easier to analyze...

```
Plot   Site  Species Number
 1      A      1      0
 1      A      2     12
 1      A      3      4
 2      A      1     88
 2      A      2      2
 2      A      3      0
 3      B      1     12
 3      B      2      4
 3      B      3      1
...
```

&nbsp;

**What to put in columns**

These will save you frustration when it comes time to read into R.

- Use brief, informative variable names in plain text. Keep more detailed explanations of variables in a separate text file.

- Avoid spaces in variable names – use a dot or underscore instead (e.g., size.mm or size_mm).

- Leave missing cells blank.

- Avoid non-numeric characters in columns of numeric data. R will assume that the entire column is non-numeric. For example, avoid using a question mark “12.67?” to indicate a number you are not sure about. Put the question mark and other comments into a separate column just for comments.

- Use the international format (YYYY-MM-DD) or use separate columns for year, month and day.

- Keep commas out of your data set entirely, because they are column delimiters in your .csv file.

- R is case-sensitive: “Hi” and “hi” are distinct entries.


&nbsp;

**Save data to a csv file**

Consider saving data to an ordinary text file, such as a .csv (comma separated text) file. A text file is never obsolete and can be read by any computer package now and (most likely) in the future. Data in a proprietary format may not be readable 10 years from now.


# {#anchor-2-2}

&nbsp;

&nbsp;

### 2.2 Read data from csv or Excel file

The commands in the code block below will read a data file named `“filename.csv”` into a data frame `mydata`. 

The `stringsAsFactors = FALSE` argument tells R to keep each character variable as-is rather than converting them to factors, which are a little harder to work with (We will explain factors below if this is a new idea to you).

```r
# Base R way
mydata <- read.csv(file.choose(), stringsAsFactors = FALSE)
mydata <- read.csv("/directoryname/filename.csv", stringsAsFactors = FALSE)
mydata <- read.csv(url("http://www.zoology.ubc.ca/~bio501/data/filename.csv"), 
                   stringsAsFactors = FALSE)

# using readr package
mydata <- read_csv("/directoryname/filename.csv")

# Excel
library(openxlsx)
mydata <- read.xlsx("/directoryname/filename.xlsx")

```
&nbsp;

A few options can save frustration if your data file has imperfections.

```r
# base R method:
mydata <- read.csv("filename.csv", stringsAsFactors = FALSE,
                  strip.white = TRUE, na.strings = c("NA", "") )
# using readr package
mydata <- read_csv("/directoryname/filename.csv", na = c("NA", ""))

```
&nbsp;

`strip.white = TRUE` removes spaces at the start and end of character elements. Spaces are often introduced accidentally during data entry. R treats “word” and " word" differently, which is not usually desired. The arguments `na.strings` and `na` tell R to treat both `NA` and empty strings in columns of character data to missing. This is actually the default, but I show it because you might some day need to alter the value coding for missing values.

&nbsp;

**R automatically calls variable types**

&nbsp;

As it reads your data, R will classify your variables into types.

- Columns with only numbers are made into numeric or integer variables.

- Using read_csv() keeps columns having non-numeric characters as characters by default.

- By default, read.csv() converts character variables into factors, which can be annoying to work with. Circumvent this by specifying stringsAsFactors = FALSE.

- A factor is a categorical variable whose categories represent levels. These levels have names, but they additionally have a numeric interpretation. If a variable A has 3 categories “a”, “b”, and “c”, R will order the levels alphabetically, by default, and give them the corresponding numerical interpretations 1, 2, and 3. This will determine the order that the categories appear in graphs and tables. You can always change the order of the levels. For example, if you want “c” to be first (e.g., because it refers to the control group), set the order as follows:

```r
A <- factor(A, levels = c("c","a","b"))
```

&nbsp;

To check on how R has classified all your variables, enter

```r
str(mydata)            # structure
glimpse(mydata)        # command from dplyr package
```

&nbsp;

To check on R’s classification of just one variable, x,

```
class(mydata$x)        # integer, character, factor, numeric, etc
is.factor(mydata$x)    # result: TRUE or FALSE
is.character(mydata$x) # result: TRUE or FALSE
is.integer(mydata$x)   # result: TRUE or FALSE
```

&nbsp;

**Convert variable to another type**

You can always convert variables between types. The following should work well:

```
mydata$x <- as.factor(mydata$x)     # character to factor 
mydata$x <- as.character(mydata$x)  # factor to character
```

**Top tip:** 

- To convert factors to numeric or integer, first convert to character. Converting factors directly to numeric or integer data can lead to unwanted outcomes.

&nbsp;

![](/img/butler-tiny.png) 

Always check the results to make sure R did what you wanted (R can be kind of like a passive-aggressive little butler).

# {#anchor-2-3}

&nbsp;

&nbsp;


### 2.3 Write and save data to a file

&nbsp;
To write the data frame mydata to a comma delimited text file, use either of the following commands. The first is from the readr package and is slightly easier than the base R method.

```r
# base R
write.csv(mydata, file="/directoryname/filename.csv", rownames = FALSE)

# Using readr package
write_csv(mydata, path = "/directoryname/filename.csv")    

# Excel
write.xlsx(mydata, file="/directoryname/filename.xlsx")

```

# {#anchor-2-4}

&nbsp;

&nbsp;


### 2.4 Manipulate data frames

&nbsp;

**View the data**

The following commands are useful for viewing aspects of a data frame.

```r
mydata             # if a tibble, print first few rows; otherwise prints all
print(mydata, n=5) # print the first 5 rows
head(mydata)       # print the first few rows
tail(mydata)       # print the last few rows
names(mydata)      # see the variable names
rownames(mydata)   # view row names (numbers, if you haven't assigned names)
```

&nbsp;

**Useful data frame functions**

&nbsp;

These functions are applied to the whole data frame.

```r
str(mydata)                     # summary of variables in frame
is.data.frame(mydata)           # TRUE or FALSE
ncol(mydata)                    # number of columns in data
nrow(mydata)                    # number of rows
names(mydata)                   # variable names
names(mydata)[1] <- c("quad")   # change 1st variable name to quad
rownames(mydata)                # row names
```

&nbsp;

Some vector functions can be applied to whole data frames too, but with different outcomes:

```r
length(mydata)                  # number of variables
var(mydata)                     # covariances between all variables
```

&nbsp;

**Access variables in data frame**

&nbsp;

The columns of the data frame are vectors representing variables. They can be accessed several ways.

```r
mydata$site          # the variable named "site"
select(mydata, site) # same, using the dplyr package
mydata[ , 2]         # the second variable (column) of the data frame
mydata[5, 2]         # the 5th element (row) of the second variable
```

&nbsp;

**Transform in a data frame**

&nbsp;

For example, log transform a variable named size.mm and save the result as a new variable named logsize in the data frame. (log yields the natural log, whereas the function log10 yields log base 10.)

```r
mydata$logsize <- log(mydata$size.mm)            # as described
mydata <- mutate(mydata, logsize = log(size.mm)) # using the dplyr package
```

&nbsp;

**Delete variable from data frame**

&nbsp;

For example, to delete the variable site from mydata, use

```r
mydata$site <- NULL             # NULL must be upper case
mydata <- select(mydata, -site) # dplyr method
```

&nbsp;

**Extract a data subset**

&nbsp;

There are several ways. One is to use indicators inside square brackets using the following format: mydata[rows, columns].

```r
newdata <- mydata[ , c(2,3)]   # all rows, columns 2 and 3 only;
newdata <- mydata[ , -1]       # all rows, leave out first column
newdata <- mydata[1:3, 1:2]    # first three rows, first two columns
```

&nbsp;

Logical statements and variable names within the square brackets also work.

```r
newdata <- mydata[mydata$sex == "f" & mydata$size.mm < 25, 
                  c("site","id","weight")]
```

&nbsp;

The subset command in base R is easy to use to extract rows and columns. Use the select argument to select columns (variables). For example, to pull out rows corresponding to females with size < 25, and the three variables, site, id, and weight, use the following.

```r
newdata <- subset(mydata, sex == "f" & size.mm < 25, 
                  select = c(site,id,weight))
```

&nbsp;

You can also use dplyr’s filter and select commands. Use select to extract variables (columns), and use filter to select rows, as in the following examples.

```r
# extract rows
temp <- filter(mydata, sex == "f")

# extract columns
newdata <- select(temp, site, id, weight) 
```

&nbsp;

**Sort and order the rows**

&nbsp;

To re-order the rows of a data frame mydata to correspond to the sorted order of one of its variables, say x, use

```r
mydata.x <- mydata[order(mydata$x), ]  # base R
mydata.x <- arrange(mydata, x)         # dplyr method
```
&nbsp;


![](/img/butler-tiny.png) 

Always check the results to make sure R did what you wanted.


# {#anchor-2-5}

&nbsp;

&nbsp;


### 2.5 Combine two data frames

&nbsp;

Measurements stored in two data frames might relate to one another. For example, one data frame might contain measurements of individuals of a bird species (e.g., weight, age, sex) caught at multiple sites. A second data frame might contain physical measurements made at those sites (e.g., elevation, rainfall). If the site names in both data frames correspond, then it is possible to bring one or all the variables from the second data frame to the first.

For example, to bring the site variable “elevation” from the sites data frame to the birds data frame (NB this is a hypoithetical example):

```r
birds$elevation <- sites$elevation[match(birds$siteno, sites$siteno)]
To bring all the variables from the sites data set to the bird data set, corresponding to the same sites in both data frames, use the dplyr command

birds2 <- left_join(birds, sites, by="siteno")
```

&nbsp;

![](/img/butler-tiny.png) 

Always check the results to make sure R did what you wanted.

# {#anchor-2-6}

&nbsp;

&nbsp;


### 2.6 Manipulate matrix objects

&nbsp;

Some functions will give a matrix as output, which is not as convenient for data as a data frame. For example, all columns of a matrix must be of the same data type. Briefly, here’s how to manipulate matrices and convert them to data frames.

&nbsp;

**Reshape a vector to a matrix**

&nbsp;

Use matrix to reshape a vector into a matrix. For example, if

```r
x <- c(1,2,3,4,5,6)
xmat <- matrix(x,nrow=2)
```

Yields the matrix:

```
      [,1] [,2] [,3]
[1,]    1    3    5
[2,]    2    4    6
```

&nbsp;

and

```r
xmat <- matrix(x,nrow=2, byrow=TRUE)
```

Yields the matrix

```
      [,1] [,2] [,3]
[1,]    1    2    3
[2,]    4    5    6
```

&nbsp;

**Bind vectors to make a matrix**

&nbsp;

Use cbind to bind vectors in columns of equal length, and use rbind to bind them by rows instead. For example,

```r
x <- c(1,2,3)
y <- c(4,5,6)
xmat <- cbind(x,y)
```

Yields the matrix:

```
     x y
[1,] 1 4
[2,] 2 5
[3,] 3 6
```

&nbsp;

**Access subsets of a matrix**

&nbsp;

Use integers in square brackets to access subsets of a matrix. Within square brackets, integers before the comma refer to rows, whereas integers after the comma indicate columns: [rows, columns].

```r
xmat[2,3]       # value in the 2nd row, 3rd column of matrix
xmat[, 2]       # 2nd column of matrix (result is a vector)
xmat[2, ]       # 2nd row of matrix (result is a vector)
xmat[ ,c(2,3)]  # matrix subset containing columns 2 and 3 only
xmat[-1, ]      # matrix subset leaving out first row
xmat[1:3,1:2]   # submatrix containing first 3 rows and first 2 columns only
```

&nbsp;

**Useful matrix functions**

```r
dim(xmat)     # dimensions (rows & columns) of a matrix
ncol(xmat)    # number of columns in matrix
nrow(xmat)    # number of rows
t(xmat)       # transpose a matrix
```

&nbsp;

**Convert a matrix to a data.frame**

```r
mydata <- as.data.frame(xmat, stringsAsFactors = FALSE)
```

The `stringsAsFactors = FALSE` is optional but recommended to preserve character data. Otherwise character variables are converted to factors.

&nbsp;

![](/img/butler-tiny.png) 

Always check the results to make sure R did what you wanted.

# {#anchor-2-7}

&nbsp;

&nbsp;

### 2.7 Manipulate list objects

&nbsp;

Some R functions will output results as a list. A list is a collection of R objects bundled together in a single object. The component objects can be anything at all: vectors, matrices, data frames, and even other lists. The different objects needn’t have the same length or number of rows and columns.

&nbsp;

**Create list**

&nbsp;

Use the list command to create a list of multiple objects. For example, here two vectors are bundled into a list

```r
x <- c(1,2,3,4,5,6,7)
y <- c("a","b","c","d","e")
mylist <- list(x,y)                   # simple version
mylist <- list(name1 = x, name2 = y)  # names each list object
```


Entering `mylist` in the R command window shows the contents of the list, which is

```
[[1]]
[1] 1 2 3 4 5 6 7

[[2]]
[1] "a" "b" "c" "d" "e"
```

&nbsp;

if the components were left unnamed, or

```
$name1
[1] 1 2 3 4 5 6 7

$name2
[1] "a" "b" "c" "d" "e"
```

if you named the list components.

&nbsp;

**Add to an existing list**

&nbsp;

Use the `“$”` symbol to name a new object in the list.

```r
z <- c("A","C","G","T")
mylist$name3 <- z
```
&nbsp;


**Access list components**

Use the `“$”` to grab a named object in a list. Or, use an integer between double square brackets,

```r
mylist$name2        # the 2nd list object
mylist[[2]]         # the 2nd list component, here a vector
mylist[[1]][4]      # the 4th element of the 1st list component, here "4"
```

&nbsp;

**Useful list functions**
&nbsp;


```r
names(mylist)              # NULL if components are unnamed
unlist(mylist)             # collapse list to a single vector
```
&nbsp;

**Convert list to data frame**

&nbsp;

This is advised only if all list objects are vectors of equal length.

```r
x <- c(1,2,3,4,5,6,7)
y <- c("a","b","c","d","e","f","g")
mylist <- list(x = x, y = y)
mydata <- do.call("cbind.data.frame", list(mylist, stringsAsFactors=FALSE))
```

&nbsp;

Notice how the option `stringsAsFactors = FALSE` for the command `cbind.data.frame` is contained inside the `list()` argument of `do.call`.

&nbsp;

![](/img/butler-tiny.png) 

Always check the results to make sure R did what you wanted.

&nbsp;

&nbsp;