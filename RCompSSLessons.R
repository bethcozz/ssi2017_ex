##R lessons from CompSS: 1-2##

#Lesson 1:
#What is my working directory?
getwd()
#Set it to my code folder
setwd("~/Desktop/code")
#What's in that folder?
list.files()

#Lesson 2:

#VECTORS!
my_word_vector<-c("Roy Williams","Is","The Best")

# often, you will want to grab one variable within a
# vector. This command, for example, selects the third
# number in my_word_vector 

my_word_vector[3]
#Returns "The Best"
#this is like .loc / .iloc in Python

# Let's pause to try this out. Here's an excercise:
# 1) create your own vector of numbers;
# 2) create a new variable that is the mean of
# your vector

my_new_vector <-c(100, 18, 24, 27, 30, 2018, 75)
mean(my_new_vector)
avg_new_vector <- mean(my_new_vector)
print(avg_new_vector)

#MATRICES!

# Vectors are a basic building block of matrices,
# another critical type of object in R. To create
# a matrix, we use the "matrix()" function.

my_matrix <- matrix(c(1,2,1,2, 64000,38000,100000,200000,
                      1,5,17,21 ), nrow = 4, ncol = 3)

# the first value required by this function is a 
# vector of numbers or characters. We use nrow and ncol
# to specify the number of rows and columns.

# to look at our matrix, you can run this line:
my_matrix

# or, you can click on "my_matrix" in the upper-right
# pane of RStudio.

# often, we will need to grab one row of a matrix, or
# one column. To do this, we use the "," operator:

#Clearly: [Row, Column]

my_matrix[1,]
#Return first row

# The "," operator specifies whether you are requesting
# the rows or the columns of the matrix. To request
# the first column, we would run

my_matrix[,1]
#Return first column

# To get the value of a cell within a matrix, we need
# to tell R about both the row and the column:

my_matrix[1,2]
#Return specific location in matrix (like .iloc)

#LISTS!

# A third important type of R object
# is a list. Lists are like vectors, but unique
# in that they may contain multiple types of 
# data (e.g. strings, numbers, or even matrices)

# Let's create a list

my_list<-list(9, "Roy Williams", my_matrix)

# Let's take a look
my_list

# Let's say we wanted to grab "Roy Williams" from
# our list. We can just write:

my_list[2]

#DATAFRAMES

# Matrices and lists are also important because they are 
# the building blocks of what may be the most important
# type of object in R: data frames.

# Data frames are very similar to datasets you might load
# into Stata/SPSS/SAS in that they have rows, columns, and
# column names, etc.

# In order to create a data frame, we can use the 
# following command on our matrix:

my_data_frame<-as.data.frame(my_matrix)
my_data_frame

#How to change column names
# lets change "V1" to "Sex"

colnames(my_data_frame)[colnames(my_data_frame)=="V1"]<-"Sex"

#How to recode variables - this case, from 1/2 to m/f
my_data_frame$Sex[my_data_frame$Sex==1]<-"Female"
my_data_frame$Sex[my_data_frame$Sex==2]<-"Male"

#Make a table to summarize the gender breakdown
table(my_data_frame$Sex)

# Ok, let's step back again so that you can try 
# this out on your own:
# 1) Change the name of the Second column in
# my_data_frame to "Income";
# 2) Calculate the median of the Income variable

colnames(my_data_frame)[colnames(my_data_frame)=="V2"]<-"Income"
median(my_data_frame$Income)

# R also treats any strings as factors. This can
# become problematic later if you try to perform
# operations on string variables that are actually
# factor variables

sample_csv_data<-read.csv("Sample_CSV_Data.csv", 
                          stringsAsFactors=FALSE)

# this tells R not to import strings as factors. In many
# cases, you will want to add lots of different options
# to an R command.

#IMPORTING .DTA
install.packages("haven")
library(haven)
#webscrape<-read_stata("my_dataframe_wide.dta")
#Failed to parse \\prc-cs-f9dkb42/ecozzolino$/Desktop/code/my_dataframe_wide.dta: Unable to allocate memory.
sample_stata_data<-read_stata("Sample Stata Data.dta")

#80% of data scientists' time is spent on data cleaning/coding
# This is because many data sets are either unstructured, or semi-
# structured, or because they have large amounts of missing
# data, or because they have to be manipulated in order to
# be analyzed for one reason or another

# First, let's work on subsetting data. This simply means breaking
# up a data frame into chunks. The syntax is similar to that we
# used when we worked with matrices. For example, let's say
# we want to take all respondents from our stata dataset who are
# less than 50. The variable we want is called "age."

respondents_under_50<-sample_stata_data[sample_stata_data$age<50,]

# Once again, this is some tricky syntax. We first need to tell R
# which dataset we want to manipulate. Everything inside the 
# parentheses is our instructions to R about what subset we want.
# REMEMBER THAT THE "," BEFORE THE LAST "]" here is critical. 
# We are are telling R that we want ALL ROWS THAT MEET THE CRITERIA.
# This is also the first time we have used a "logical operator"
# in this case "<" you can also use ">" and "<="

#COMMANDS FOR MISSING DATA

no_missing_data<-sample_csv_data[complete.cases(sample_csv_data),]

# this dropped every single row. This is because of the structure
# of this dataset (certain questions were asked of some respondents
# but not others).

pewdata<-read.csv("Sample_Pew_Data.csv")
#Looking at data in a different dataset now
#NAN is coded as 9
#Recode to NA
pewdata$pew10[pewdata$pew10==9]<-NA

#Show obs missing on this var
missing<-pewdata[is.na(pewdata$pew10),]
missing
#If we want to take all the values where "pew10" is NOT
#missing, we would do this:

#Show obvs nonmissing on this var
no_missing<-pewdata[!is.na(pewdata$pew10),]
no_missing

# Note that is.na() is a logical operator. If we write

is.na(pewdata$pew10)

# we see TRUE/FALSE values for each row of the data frame on this
# variable.

#RECODING VARIABLES

# now lets say we wanted to find all of the men with missing data. 
# First let's find the variable

colnames(pewdata)

# now let's see how the variable is coded
table(pewdata$sex)

# Looks like 1s and 2s. I happen to know that 1=Male in these
# data, so:

missing<-pewdata[is.na(pewdata$pew10)& pewdata$sex==1,]

# Note again that we need the "," because we are telling R
# we want the rows. If we wanted to trim columns from the data
# we would need to put the content we want after the ","-
# we can either use the numbers of the columns or their names. Let's
# say we just want the two variables we've been working with so
# far:

gender_and_mosque<-pewdata[,c("sex","pew10")]


# let's say we wanted everything but the first column in the dataset.
# First we would need to know the number of columns. We can use 
# ncol() for this purpose

ncol(pewdata)

# Then we simply tell R we want rows 2 to until the end of DS using the ":" operator,
# which indicates a sequence.

no_first_column<-pewdata[,2:ncol(pewdata)]

# I'm noting this because it will be helpful to know that this is 
# possible when we discuss programming later in this class.

# You now know the basics of manipulating a data frame in R. Let's
# pause for another exercise:
# 1) Figure out the age of the oldest man in the dataset

max(pewdata$age)

gender_and_age<-pewdata[,c("sex", "age")]
#WRONG - oldest_man<-pewdata[max(pewdata$age)& pewdata$sex==1,]
#WRONG - oldest_man <- max(pewdata$age) & pewdata$sex==1

men<-gender_and_age[gender_and_age$sex==1,]
men
max(men)
#The oldest man is 99 :-)

#RESHAPING DATAFRAMES

# Suppose we wanted to examine partisanship by race. The
# Patyln variable describes the following question within the Pew Data:
# "As of today do you lean more to the Republican Party" or more to The
# Democratic party" The possible answers are 1: Republican, 2: Democrat;
# 9: Missing.

pewdata$partyln[pewdata$partyln==1]<-"Republican"
pewdata$partyln[pewdata$partyln==2]<-"Democrat"
pewdata$partyln[pewdata$partyln==9]<-NA

pewdata$partyln
table(pewdata$partyln)

#Next, recode the race variables
pewdata$race[pewdata$race==1]<-"White"
pewdata$race[pewdata$race==2]<-"African American"
pewdata$race[pewdata$race==3]<-"Asian or Pacific Islander"
pewdata$race[pewdata$race==4]<-"Mixed Race"
pewdata$race[pewdata$race==5]<-"Native American"
pewdata$race[pewdata$race==6]<-"Other"
pewdata$race[pewdata$race==9]<-NA

table(pewdata$race)
#Now that we've made tables of each, we can run a crosstab:
table(pewdata$partyln, pewdata$race)
#Save it for later
save(pewdata, file="Pew Data.Rdata")

#Average age by race
aggregate(pewdata$age, by=list(pewdata$race), FUN=mean)
#Average age by both race and party
aggregate(pewdata$age, by=list(pewdata$race, pewdata$partyln), FUN=mean)
#Save this column as a table
age_by_race<-aggregate(pewdata$age, by=list(pewdata$race), FUN=mean)
age_by_race

# Imagine, for example, that we want to add average income by race
# to our dataset that describes average age. I put a very
# small spreadsheet in the Dropbox that describes average
# income by race.

race_income_data<-read.csv("Income By Race.xlsx")
#Don't do this - file is NOT csv, it is xlsx!

#To figure out how to do this, search on stack overflow. Here's preferred answer:
install.packages("XLConnect")
library(XLConnect)
??XLConnect
#DOESN'T WORK - race_income_data <- readWorksheet(loadWorkbook("Income By Race.xlsx"),sheet=1)
#DOESN'T WORK - race_income_data <- readWorksheetFromFile("Income By Race.xlsx")
#Didn't figure this out.
#race_income_data<-read.csv("Income By Race.csv")

race_income_data<-read.csv("Income By Race.csv", 
                          stringsAsFactors=FALSE)

#MERGING DATA
#can do it in base R, but plyr is better

install.packages("plyr")
library(plyr)

#The command for merging datasets is called "join"
merged_data<-join(age_by_race, race_income_data)
#*just like sql
merged_data
#it didn't work tho (N/As)

colnames(age_by_race)
colnames(race_income_data)
#the problem is that in age_by_race, we don't call it race - called Group.1
colnames(age_by_race)[colnames(age_by_race)=="Group.1"]<-"race"
age_by_race

merged_data<-join(age_by_race, race_income_data)
#Okay, it merged - but only has income value for whites

table(age_by_race$race)
table(race_income_data$race)
#The problem that we can see from these tables is that age_by_race has many more racial categories than race_income_data

#Also Black =/ African American and Asian or Pacific Islander =/ Asian
#So we must recode these too
race_income_data[race_income_data=="Black"]<-"African American"
race_income_data[race_income_data=="Asian"]<-"Asian or Pacific Islander"
#MAKE SURE STRINGSASFACTORS IS FALSE!!!

race_income_data

merged_data<-join(age_by_race, race_income_data)

View(merged_data)
