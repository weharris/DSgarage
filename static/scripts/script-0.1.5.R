## HEADER ####
## Who: Data Science Garage
## What: Example script
## Last edited: 2020-06-10
####

## CONTENTS ####
## 00 Look at Iris data
## 01 Make a simple graph

## 00 Look at Iris data ####

# Here we are "telling R" we want to use a dataset called "iris"
data(iris)

# Print the "head" (first 6 lines) if iris data
head(iris)

## 01 Make a simple graph ####

# Make a boxplot showing the Sepal.Length for each iris Species
boxplot(formula = Sepal.Length ~ Species,
        data = iris)
