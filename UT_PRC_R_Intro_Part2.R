##UT PRC
##Rob's group
##11.17.15

##############################
#Working with data
##############################

rm(list=ls())  ##Clear R

#I have put together a practice dataset that has only 10 cases ("females") and 4 variables.  We will work with some real data next.

#Reading in a csv file from your computer:

# First let's set a working directory
# This should be the directory where your data is stored
setwd("/Users/elizabethcozzolino/Desktop/R")
#this is the cd/your working directory

#The following code will read in the data.

#We are calling our data "data"
data<-read.csv("females.csv", header=TRUE, sep=",")
#header = true = names of vars listed on the first line, separated by commas

help (read.csv) #tells you how to do data separated by blank space, e.g.

data

is.data.frame(data)  #Check to make sure it is a data frame.

# if we want to see the names of variables in our dataset
names(data)

#The read.table command will accomplish the same thing:
data2<-read.table("females.csv", header=TRUE, sep=",")

is.data.frame(data2)

names(data2)

#See these websites for reading in other types of data:
#http://www.statmethods.net/input/importingdata.html
#http://www.r-tutor.com/r-introduction/data-frame/data-import

#For reading in data from Stata, you would need the "foreign" package.
#Example:
library(foreign)
library(tile)
#to get tile, you have to download it from package installer

data3<-read.dta("R_females.dta")

#library command calls up the package

#In most cases, the foreign package is already installed in R
#To check on which packages are in the library:
library()
#To see which packages you've already loaded (during your R session)
search()

#We will talk about loading packages at the end of the session.

#Let's do some more work with the dataset that we have loaded ("females")

#Note:  Instead of specifying the dataset, it is possible to "attach" the dataset to R.  If you do this, you will not have to keep referring to the dataset name.

#attach(data) #attaching means you don't have to keep calling up the dataset

#It is good practice, however, to not attach the dataset.  One advantage of R is that you can call up multiple data objects at once, and this is more difficult if you attach the data.

#can have multiple datasets at once! attach makes it more like stata

#Let's look at the whole dataset:
data

#Summarize the variables
#This is the equivalent of running "sum() or tab() in Stata for each variable" 
summary(data)

#To refer to a specific variable in a dataset, use the $ prefix
#The basic set-up:  dataname$variable
data$age
#this is like tab age

#Look at a summary of just one variable
summary(data$age)

#We can check on the attributes of variables
is.numeric(data$age)  #Is age a numeric variable?
is.factor(data$age)   #Is age a factor variable?
is.character(data$age) #Is age a string/character variable?

#We can use as.factor() or factor() to change a variable to a factor, as.numeric() to change a variable to a numeric variable, etc.

is.factor(data$gender)

data$gender<-as.factor(data$gender) #we are writing over the original gender variable here, making it a factor variable
is.factor(data$gender)

summary(data$gender)
#do these commands whne you first load a dataset to check and make sure everything is ok

#How many rows are in our data?
nrow(data)

#How many columns?
ncol(data)

# To take a look at the first few cases
data[1,] # this will give us all the columns for the first row
data[1:3,] # this will give us all the columns for the first three rows
head(data)  #This also shows the first few rows
#heads gives first 6 cases

#missing = n/a. dots and spaces recognized as missing

####################################
###### Basic data summaries #########

#Min, max, mean, sd, variance, median:
min(data$age)
max(data$age)
mean(data$age)
sd(data$age)
var(data$age)
sqrt(var(data$age)) # same as the sd
median(data$age)

#mean (x, trim = 0, na.rm = FALSE) #how to deal w/ missing when calculating means
#na.rm = TRUE #is what you will want to use 

#packages = suites of commands
#lattice = pretty graphs

#Values at quantile cut-off points:
quantile(data$age,0.5)
quantile(data$age,0.25)
quantile(data$age,0.75)
quantile(data$age,c(0.25,0.5,0.75))

#if you attached it, you don't need to say data$age, you could just say $age

#############################################
##Recoding variables/ creating a new variable

##Helpful website: http://www.statmethods.net/management/variables.html

# Recode height in feet instead of inches
#The command below tells R to create a new variable "ht_ft" that is put into the dataset "data".
data$ht_ft<-data$ht/12
#name dataset w/ $, <- ht_ft = create new object, divide by 12 = divide the inches by feet

# Is it there?
names(data)

#List all values
data$ht_ft

#Create a dummy variable to identify "tall" cases-- cases over 5.9 feet
#Use the "ifelse" statement
data$tall<-ifelse(data$ht_ft>=5.9, 1, 0)
#if you are greater than or equal to five nine, 1=tall, 0=not tall --> gives value 1 if true, 0 if else

#Check to see if this worked
ht_tall<-cbind(data$ht_ft, data$tall)
ht_tall

#We could have also coded it in this way:
data$tall2[data$ht_ft>=5.9]<-1
data$tall2[data$ht_ft<5.9]<-0
#data$tall2[data$ht_ft=.]<-. #we think this is how you would do missing


#this does the same thing

data$tall2

#Check both newly coded variables against the original:
ht_tall_tall2<-cbind(data$ht_ft, data$tall, data$tall2)
ht_tall_tall2

#What is the mean of height in feet?
mean(data$ht_ft)

##Recode age as a string (character) variable 
min(data$age)  #Check the minimum value (optional)
max(data$age)  #Check the maximum value (optional)

##Categories: 11-20, 21-30, 31-40, 41-50
data$age_cat<-""
data$age_cat
#might not have needed these two above commands...

data$age_cat[data$age>=11 & data$age<=20]<-"11-20"
data$age_cat

data$age_cat[data$age>=21 & data$age<=30]<-"21-30"
data$age_cat[data$age>=31 & data$age<=40]<-"31-40"
data$age_cat[data$age>=41 & data$age<=50]<-"41-50"

data$age_cat

#Is this a factor variable?
is.factor(data$age_cat)
is.character(data$age_cat)

#Recode age_cat as a factor variable
data$age_cat_factor<-factor(data$age_cat, labels=c("11-20", "21-30", "31-40", "41-50"))

data$age_cat_factor
is.factor(data$age_cat_factor)

#Use table to see how many cases are in each age category
table(data$age_cat_factor)
summary(data$age_cat_factor)

#See proportions of cases that fall into each category:
age_table<-table(data$age_cat_factor)  #Save totals as a table
prop.table(age_table)				   #prop.table divides totals in  the table by the number or cases in the table --> gives us proportions 

#####################################
#Create a subset of the data and save

#Only keep the tall cases

tall_cases<-data$tall==1  
tall_cases          ##Identifies tall cases using "TRUE" or "FALSE"

data_tall_cases<-data[tall_cases,] 
data_tall_cases  #Keeps only the tall cases (and all variables)

#What if we wanted to save this data subset?
write.csv(data_tall_cases,"data_tall_cases.csv",row.names=F)

######################################
#More practice with real data
#####################################

##Practice data- Integrated Health Interview Series data subset from IPUMS (NHIS data)
##https://www.ihis.us/ihis/

ihis<-read.csv("IHIS_practice_data.csv", header=TRUE, sep=",")

names(ihis)

#Show first 5 rows
ihis[1:5, ]
#Show first 6 rows
head(ihis)

#Variables summary:
summary(ihis)
 
#Can check on types of variables:
#Looks like weight might be a factor
is.factor(ihis$weight)

#incfam07on- Family income
is.character(ihis$incfam07on)
is.factor(ihis$incfam07on)

#dentint- Dental interval (last time went to dentist)
is.character(ihis$dentint)
is.factor(ihis$dentint)

#Race/Ethnicity 
is.factor(ihis$race_ethnic)

#Code race/ethnicity as a factor variable with labels
ihis$race_ethnic<-factor(ihis$race_ethnic, labels=c("White", "Black", "Asian", "Latina/o"))
is.factor(ihis$race_ethnic)

#no codebook variable - go to IPUMS and use their codebook
# we think that NIU = not applicable

#############################
#Summary statistics-- A look at BMI and race/ethnicity
#find mean BMI
bmi_mean<-mean(ihis$bmi)
bmi_mean

bmi_sd<-sd(ihis$bmi)
bmi_sd

bmi_mean_sd<-cbind(bmi_mean, bmi_sd)
bmi_mean_sd

#Find number and proportion for each racial/ethnic group
race_ethnic_totals<-table(ihis$race_ethnic)
race_ethnic_totals

race_ethnic_props<-prop.table(race_ethnic_totals)
race_ethnic_props

race_ethnic_tot_prop<-cbind(race_ethnic_totals, race_ethnic_props)
race_ethnic_tot_prop

##Race/Ethnicity and Poverty
##Create table with race/ethnicity and poverty totals
race_ethnic_pov_table<-table(ihis$race_ethnic, ihis$pooryn)
race_ethnic_pov_table

#What is the distribution of the whole sample across race/ethnicity and poverty groups?
prop.table(race_ethnic_pov_table)

#What proportion of each racial/ethnic group is in poverty?
prop.table(race_ethnic_pov_table, 1)  #1 refers to row proportions

#What proportion of those in poverty are members of each racial/ethnic group?
prop.table(race_ethnic_pov_table, 2) #2 refers to column proportions

#help(proptable)

#Calculate mean BMI for each group, using tapply
#Using tapply, calculate BMI for each racial/ethnic group
tapply(ihis$bmi, ihis$race_ethnic, mean)
tapply(ihis$bmi, ihis$race_ethnic, sd)
#is like egen in STATA -- gives you group means and SDs

#Put these in a table
#Mean
race_ethnic_bmi_means<-tapply(ihis$bmi, ihis$race_ethnic, mean)
#SD
race_ethnic_bmi_sd<-tapply(ihis$bmi, ihis$race_ethnic, sd)
#Table:
race_ethnic_bmi_table<-rbind(race_ethnic_bmi_means, race_ethnic_bmi_sd)
#bound them together by row

race_ethnic_bmi_table

##To assign group means to each case, use the "ave" command
ihis$bmi_race_mean<-ave(ihis$bmi, ihis$race_ethnic)  #Creates average BMI for racial/ethnic groups

#Check this value for each group
race_ethnic_bmi_table

#Creating subsets of data for each group:
whites<-data.frame(subset(ihis, race_ethnic=="White", select=bmi_race_mean))
head(whites) #Check value for Whites

blacks<-data.frame(subset(ihis, race_ethnic=="Black", select=bmi_race_mean))
head(blacks) #Check value for Blacks

latinos<-data.frame(subset(ihis, race_ethnic=="Latina/o", select=bmi_race_mean))
head(latinos) #Check value for Latinas/os

######################################
##Statistics

##T-test-- Are BMIs between whites and non-whites?

##Create a dummy for white vs. non-white
ihis$white<-factor(ifelse(ihis$race_ethnic=="White", 1, 0))

is.factor(ihis$white)

#Check mean values 
mean(ihis$bmi[ihis$white==1])
mean(ihis$bmi[ihis$white==0])

#T-test
t.test(ihis$bmi~ihis$white)
#also, we're comparing big groups and the scale of variation is low, hence significance

##Chi-square test
##Inequalities in poverty status by race/ethnicity?

race_pov_table<-table(ihis$race_ethnic, ihis$pooryn)
race_pov_table
#x2 test is run on the table, not on the vars

race_pov_prop<-prop.table(race_pov_table)
race_pov_prop

chisq.test(race_pov_table) #yes this is significant

##Regression analysis

##Linear Regression
##basic structure:  lm(outcome~predictor + predictor + predictor…, data=data_name)

##Predict BMI based on age, sex, race/ethnicity, and poverty
##(Age is a factor variable; change to numeric)
is.factor(ihis$age)
ihis$age<-as.numeric(ihis$age)
is.numeric(ihis$age)

#Equation/command:
bmi_M1<-lm(bmi~age + sex + race_ethnic + pooryn, data=ihis)
#save as BMI MODEL 1

#Get the output:
summary(bmi_M1)

lm(bmi~age + sex + race_ethnic + pooryn, data=ihis) #this also displays results, but summary looks better and gives significance

#You can pull out coefficients and other information from the model:
betas_M1<-coef(bmi_M1)
betas_M1 #save betas

se_M1<-sqrt(diag(vcov(bmi_M1)))
se_M1 #save std errors

#You could then use this to create confidence intervals
upper_ci_M1<-betas_M1 + (se_M1*1.96)
upper_ci_M1

lower_ci_M1<-betas_M1 - (se_M1*1.96)
lower_ci_M1

##Display the coefficient and confidence intervals:
bmi_model_results<-cbind(betas_M1, lower_ci_M1, upper_ci_M1)
bmi_model_results

#there are packages to export this 

##Logistic regression models using glm
##Basic structure:  glm(outcome_binary ~ predictor, family=binomial(link="logit"), data=data_name)

##Predict "ever smoked"; use same predictors as before
##Make sure ever smoked is binary predictor

is.factor(ihis$smokev)
table(ihis$smokev)

ihis$smokev_yes<-ifelse(ihis$smokev=="Yes", 1, 0)
ihis$smokev_yes<-as.factor(ihis$smokev_yes)

summary(ihis$smokev_yes)

#Equation/command
smokev_M1<-glm(smokev_yes ~ age + sex + race_ethnic + pooryn, data=ihis, family=binomial(link="logit")) #have to specify that it's a logit model

#glm = outcome ~ vars, family (binomial), link=logit --> can change link to mlogit too we think 

#Output
summary(smokev_M1)

#mi package in R is amelia, or amelia2 --> uses maximum likelihood

#Odds Ratios
smokev_odds_ratios<-exp(coef(smokev_M1))
smokev_odds_ratios


##########################################
##Package for Sequence Analysis: TraMineR
##You will also need to load the RColorBrewer and boot packages to use TraMineR

library(TraMineR)

#Info on TraMineR:
#http://traminer.unige.ch/
#https://cran.r-project.org/web/packages/TraMineR/index.html

#pretty graphics: lattice, ropeladder, tile 

library()

