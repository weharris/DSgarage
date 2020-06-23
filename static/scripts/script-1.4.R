## HEADER ####
## Who: <YOUR NAME>
## https://dsgarage.netlify.app/
## What: 1.4 Data Frames
## Last edited: <DATE TODAY in yyyy-mm-dd format)
####


## CONTENTS ####
## 1.4.1 Tidy data concept  
## 1.4.2 Common data file types  
## 1.4.3 Excel, data setup, and the Data Dictionary  
## 1.4.4 Getting data into R
## 1.4.5 Manipulating variables in the Data Frame
## 1.4.6 Practice exercises  

## 1.4.4 Getting data into R ####
## Working directory ####

# Try this

getwd() # Prints working directory in Console

setwd("D:/Dropbox/git/DSgarage/static/scripts") 
# NB the quotes
# NB the use of "/"
# NB this is MY directory - change the string to YOUR directory :)

getwd() # Check that change worked

## Read in Excel data file


install.packages(openxlsx, dep = T) # Run if needed
library(openxlsx) # Load package needed to read Excel files

# Make sure the data file "1.4-tidy.xlsx" is in your working directory
my_data <- read.xlsx("1.4-tidy.xlsx")

## 1.4.5 Manipulating variables in the Data Frame

# Try this

class(my_data) # data.frame, a generic class for holding data

## The ```names()``` function ####

# The names() function returns the name of attributes in R objects
# When used on a data frame it returns the names of the variables
names(my_data)

# Note the conc.ind variable is classed numeric
# Note the treatment variable is classed as character (not a factor)


## The use of the ```$``` operator for data frames ####

# The $ operator allows us to access variable names inside R objects
# Use it like: data_object$variable_name
my_data$conc.ind

# Try this
conc.ind # Gives an error because the variable conc.ind is INSIDE my_data


## The use of the ```str()``` function for data frames ####
# The str() function returns the STRUCTURE of a data frame
# This includes variable names, classes, and the first few values

str(my_data) # This is similar to the graphical Global Environment view in RStudio

## The use of the index operator ```[ , ]``` ####
# The index operator allows us to access specified rows and colums in data frames
# (this works exactly the same in matrices and otehr indexed objects)

my_data$conc.tot # The conc.tot variable with $
my_data$conc.tot[1:6] # each variable is a vector - 1st 6 values

help(dim)
dim(my_data) # my_data has 18 rows, 6 columns

my_data[ , ] # Leaving the entries blank means return all rows and columns
names(my_data) # Note conc.tot is the 6th variable
names(my_data)[6] # Returns the name of the 6th variable

my_data[ , 6] # Returns all rows of the 6th variable in my_data

# We can explicitly specify all rows (there are 18 remember)
my_data[1:18 , 6] # ALSO returns all rows of the 6th variable in my_data

# We can specify the variable names with a character
my_data[ , "conc.tot"]
my_data[ , "conc.ind"]

# Specify more than 1 by name with c() in the column slot of [ , ]
my_data[ , c("conc.tot", "conc.ind")] 


## The use of the ```attach()``` function ####
# The attach() function makes variable names available 
# for a data object in R space

conc.ind # Error; the Passive-Aggressive Butler doesn't understand...

attach(my_data)
conc.ind # Now that my_data is "attached", the Butler can find variables inside

help(detach) # Undo attach()
detach(my_data)
conc.ind # Is Sir feeling well, Sir?

## 1.4.6 Practice exercises  


