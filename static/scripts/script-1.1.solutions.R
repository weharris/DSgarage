## HEADER ####
## Who: <YOUR NAME>
## https://dsgarage.netlify.app/
## What: 1.1 R syntax basics
## Last edited: <DATE TODAY in yyyy-mm-dd format)
####


## CONTENTS ####
## 1.1.1 Example script, help, pseudocode  
## 1.1.2 Math operators  
## 1.1.3 Logical Boolean operators  
## 1.1.4 Regarding base R and the Tidyverse   
## 1.1.5 Practice exercises  

help(mean)
## 1.1.1 Example script, help, pseudocode  ####


## 1.1.2 Math operators ####


## Arithmentic #### 

# Add with "+"
2 + 5

# Subtract with "-"
10 - 15

# Multiply with "*"
6 * 4.2

# Divide by "/"
10 / 4

# raise to the power of x
2^3 
9^(1/2) # same as sqrt()!

# There are a few others, but these are the basics


## Order of operation ####

# An easy way is to use parentheses

# Try this
4 + 2 * 3

# Order control - same
4 + (2 * 3)

# Order control - different...
(4 + 2) * 3

## Use of spaces ####

# Try this
6+10                                  # no spaces
7     -5                              # uneven spaces
1.6             /                2.3  # large spaces
16 * 3                                # exactly 1 space

# exactly 1 space is easiest to read...

## 1.1.3 Logical Boolean operators  ####

# Try this
# simplest example
3 > 5

# 3 is compared to each element
3 < c(1, 2, 3, 4, 5, 6) 

# Logic and math
# & (ampersand) means "and"
# | (pipe) means "or"

# This asks if both phrases are true (true AND true)
# notice "TRUE" has a special meaning in R

TRUE & TRUE # both phrases are true

3 > 1 & 1 < 5 # both phrases are true

# Are both phrases true?

TRUE & FALSE # are both true?

FALSE & FALSE # are both true?

# Booleans can be useful to select data

# Put some data into a variable and then print the variable
x <- c(21, 3, 5, 6, 22)
x

x > 20

# the square brackets act as the index for the data vector
x[x > 20]


## 1.1.4 Regarding base R and the Tidyverse ####   


## 1.1.5 Practice exercises ####

# **1** Name and describe the purpose of the first 2 sections 
# that should be present in every R script

# HEADER - description
# CONTENTS - description

# **2** What is the purpose of "main" argument in the boxplot() 
# function (hint: use help())

help(boxplot) 

# The main argument sets the boxplot title

# **3** Write an expression using good R spacing syntax that takes 
# the sum of 3, 6, and 12 and divides it by 25

(3 + 6 + 12) / 25 # ans = 0.84

# **4** Write pseudocode steps for calculating the volume of a cylinder 
# (hint, if you do not know it by heart, you may need to research the 
#   equation for the volume of a cylinder!). For a cylinder of 
# height = 3.2 cm and end radius of 5.5 cm, report the volume in cm to 
# 2 decimal points of accuracy.  Use at least 3 decimal points of accuracy 
# for *pi*.

# Volume of a cylinder: 
# circle.area = (pi * radius^2) 
pi * 5.5^2
# height = height of cylinder
3.2
# volume of cylinder = circle.area * height
pi * 5.5^2 * 3.2

# 304.11 cm^3!

# pseudocode
# 1 calculate the circle area for the cylinder ends
# 2 multiply the circle area by the cylinder height

# **5** Execute the code and explain the outcome in comments
TRUE & 3 < 5 & 6 > 2 & !FALSE

# All the components are true
# including !FALSE, not false!


