## HEADER ####
## Who: Data Science Garage
## https://dsgarage.netlify.app/
## What: 0.1 Bootcamp intro
## Last edited: 2020-06-10
####


## CONTENTS ####
## 00 Look at the "iris" data
## 01 Make a simple graph


## 00 Look at the "iris" data ####
# Here we are "telling R" we want to use a dataset called "iris"
data(iris)

# Print the "head" (first 6 lines) if iris data
head(iris)

# The code on the next line will display the help page for the iris data
?iris


## 01 Make a simple graph ####

# Make a boxplot showing the Sepal.Length for each iris Species
boxplot(formula = Sepal.Length ~ Species,
        data = iris)
