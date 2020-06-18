## HEADER ####
## Who: <YOUR NAME>
## https://dsgarage.netlify.app/
## What: 1.2 Functions and Packages
## Last edited: <DATE TODAY in yyyy-mm-dd format)
####


## CONTENTS ####
## 1.2.1 Function tour
## 1.2.2 Using functions and getting help
## 1.2.3 R packages
## 1.2.4 Finding, downloading and using packages
## 1.2.5 Practice exercises

help(mean)
## 1.2.1 Function tour ####


## 1.2.2 Using functions and getting help ####

## A workflow for using functions ####

## (make pseudocode of steps)
# Overall task: calculate the mean for a vector of numbers
# Step 1: Code the vector of data - c() function
# Step 2: Calculate the mean - mean() function
# Step 3: Plot the data - boxplot()

# Step 1: Code the vector of data - c() function

help(c) # We use this a lot - it "combines" numbers
c(2, 6, 7, 8.1, 5, 6) 

# Step 2: Calculate the mean - mean() function

help(mean) 
# Notice under Usage, the "x" argument
# Notice under Arguments, x is a numeric vector

mean(x = c(2, 6, 7, 8.1, 5, 6)) # Easy

# Step 3: Plot the data - boxplot()

help(boxplot) # x again!
boxplot(x = c(2, 6, 7, 8.1, 5, 6))

# Challenge 1: Add a title to you boxplot using the argument "main"
# Challenge 2: Add an axis label to the y-axis - can you find the argument?


## 1.2.3 R packages ####



## 1.2.4 Finding, downloading and using packages ####



## 1.2.5 Practice exercises ####



