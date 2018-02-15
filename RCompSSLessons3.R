#Lessons - Day 3

#FUNCTIONS
# A function is simply a set of instructions or tasks that one
# may apply to any type of object in R. Let's take a very basic
#function

my_function <- function(x) x+2

# This function takes a number (x) and adds two to the number.
# let's try it:

my_function(2)
my_function(100)
my_function(-50)

# functions can get much, much more complicated.
another_function <- function(x, y, z) {
  x <- mean(x)^2
  y <- cos(y)-5
  z <- log(z)*200
  c(x,y,z)
}

# this function requires three inputs (x, y, and z). The part
# between the brackets tells R what we want to do to each of these
# three inputs. The "c()" tells R that we want to display the results
# if we did not include the c(), the function would still run, but
# we would need to type "x,""y," or "z," to see the results for each
# variable.

another_function(4, 10, 100)
another_function(-6, 7, 10)

#LOOPS

for (i in 1:6){
  print("Jim Moody is bad-a$$")
}
#this means it prints it the first 6 times

for (i in 2:12){
  print("who dat")
}
#prints 11 times (2-12)

for (i in 5:9){
  print("how to do")
}
#prints 5 times (5-9)


# Let's start working with an example to illustrate. Let's say we 
# have a folder full of .csv files that describe different health
# indicators from OECD, but we are really only interested in data
# about Korea. 

# Let's build a for loop that opens each file, grabs the data from
# korea, and then makes another data frame. We need to begin with
# a few steps that may seem strange or unnecessary, but it will
# soon become clear why we need to do them.

# first, we need to tell R where the data are. I've placed it in
# the dropbox in a folder entitled "OECD Health Data. Let's use
# list.files to count the number of files. 

list.files("OECD Health Data")

#The first thing we need to do with a for loop is initialize it, or tell it how
# many times we want it to repeat the action. We therefore need
# to count the number of files "

filenames<-list.files("OECD Health Data")
number_of_files<-length(filenames)
number_of_files

# now, let's create an empty data frame to store our data:
koreadata<-as.data.frame(NULL)

# now, let's loop into each file

#for each i from 1 to N (number_of files)
#repeat the step for every file from 1 to N
for(i in 1:number_of_files){
  
  filepath<-paste("OECD Health Data/", filenames[i], sep="")
  data<-read.csv(filepath, stringsAsFactors = FALSE)
  newdata<-data[data$Location=="Korea",]
  newdata$indicator<-filenames[i]
  koreadata<-rbind(koreadata,newdata)
}

# Everything within the brackets is what we want r to do for each
# file.

#We want to open the files, but can't until we specify filepath
#Define filepath to get to the files: 
#paste working directory "/OECD Health Data/", each filename, separated by nothing
#sep - what we want R to put b/w strings (nothing, so just put "")

#second line reads the csv, with stringsAsFactors = FALSE

#third line only selects data for Korea
#this works b/c all files call the country column "Location" and have the same spelling/capitalization

#fourth line: create new var with name of metric
#this name is the title of the file from which it came 

#final line: take this new dataframe and append to the "koreadata" df that we created earlier
#it's an rbind, meaning each entry gets another row

#FORLOOP
# Write a forloop that goes through each variable in our Pew Dataset   and replaces values of 9 with NA.

#Hint: you may find the `ncol` function useful.

#SOLUTION

number_of_columns<-ncol(pewdata)
for (j in 1: number_of_columns){
  pewdata[,j][pewdata[,j]==9]<-NA
}
#get number of columns from pewdata 
#for each column (1 thru N)
#fill all columns with value of 9 as NA 
#[r,c] --> [,c] = columns 

#VECTORIZED FUNCTIONS

#vectorized commands are faster than those in R

# Vectorized functions within R are known as "apply" functions.
# There are different types of apply commands for different
# types of r objects. We are just going to look briefly at the one
# for data frames, though there are also apply commands for lists 
# and arrays.

# let's try to read our OECD Health files into R using apply. Once
# again, we need a list of the names of the files:

filenames<-list.files("OECD Health Data")

# And now let's paste the file path into them
filenames<-paste("OECD Health Data/", filenames, sep="")

# and now let's apply the read.csv command to each file:
data<-lapply(filenames,read.csv)

# just one line! Note that the data is now in list format
# and we'd have to clean it up to make it comparable to
# the data we created within the for loop.

# The apply
# command is particularly powerful because we can apply 
# whatever function we want to our filenames- either other
# people's r functions or our own.

# the syntax for apply commands can become somewhat opaque
# because they do not spell out the functions. Also, one has 
# to choose the appropriate apply command for the object in
# question. A useful resource on the apply command is this
# blog post: 
# http://www.r-bloggers.com/using-apply-sapply-lapply-in-r/

# One final note: you can speed up plyr and dplyr commands
# by specifying the "parallel processing" options that allow
# r to take advantage of multiple CPUs that you may have on 
# your machine. This can be particularly helpful if you use
# the very powerful Amazon machines- or other cluster computing
# technologies- described in section 4.6 below

#PIPING
#New way of programming in R

# Piping is a way of passing data and functions in code without
# initializing or iterating. Many people find it more intuitive
# because it is a) less complex, and b) can be coded in a less
# cluttered manner. 

# let's take a quick peak at the maggritr package

install.packages("magrittr")
library(magrittr)

# The key contribution of this package is the `%>% operator.
# Whatever is on the left side of this operator gets passed
# to the right side.

# Let's look at some data on baby naming from the Social
# Security administration.

install.packages("babynames")
library(babynames)

# The real power of %>% comes when you combine it with other
# packages. Let's combine it with the dplyr package for data
# reshaping/manipulation:

# first, lets take the babynames data and pass it through the
# "filter" command in dplyr which lets us request only names
#where the first three letters start with "Ste." Then we will
# use the group_by function of the same package to reshape
# the data by year and sex. Finally, we will count the totals,
# and plot it using ggplot

#use filter command in dplyr - can request only names starting
#with "ste"

library(dplyr)
library(ggplot2)

babynames %>%
  filter(name %>% substr(1, 3) %>% equals("Ste")) %>%
  group_by(year, sex) %>%
  summarize(total = sum(n)) %>%
  qplot(year, total, color = sex, data = ., geom = "line")%>%
  add(ggtitle('Names starting with "Ste"')) %>%
  print

# Notice that we never created a variable, a blank data frame
# or any other object. Once again, for some, this is much easier
# to follow. Regardless of whether you find it more intuitive,
# you would probably agree that it is quicker to write.

#OK, this one seems maybe a little too advanced for me - don't get it!

# 6: Debugging your code

# RSTudio also has more sophisticated debugging tools that are
# described in detail here: 
# https://support.rstudio.com/hc/en-us/articles/205612627-Debugging-with-RStudio

# One final note on programming. If you want to get into more 
# advanced programming in R, I highly suggest the following 
# site: http://adv-r.had.co.nz authored by Hadley Wickham