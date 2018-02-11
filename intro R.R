# Up and running with R: Lynda.com. Early Oct 2017.

2 + 2 # vbasic math
#control-return runs it if you're on that line
# [1] = index number for the vector
1:100 #print numbers 1-100 on several lines
#[21] = index number for vector 
#no command terminator
#for command more than one line, use parentheses

print("Hello World!")
#just like python

x <- 1:5 # puts numbers 1-5 in var x
# <- "gets" x gets numbers 1-5
#in workspace, shows x var
x #display vals in x
# c= concatenate
y <- c(6, 7, 8, 9, 10)
#now have varialbe y, which is numeric (x is int)
y

#can do vector based math - operations w/o loops

x + y #add x vals to y vals
# 1+6, 2+7, etc.

x*2 

#R will also create vars with = but <- is better form, according to R style guides

x <- 0:10
x

y <-c(5, 4, 1, 6, 7, 2, 2, 3, 2, 8)
y

ls() #list objects - same as python
#i have a lot more b/c using stuff from summrstats

#easy to take data from .csv variable 

#social network.csv has missing data! 

#R converts missing data to NA (not available)
# have to specify header 
header = T

#social_network.csv <- read.csv("~/Desktop/R/summerstats2git", header = T, sep = )
#sn.csv <- read.csv("~/Desktop", header = T)
#above ones DO NOT WORK. Below do.

library(readr)
social_network <- read_csv("~/Desktop/R/summerstats2git/social_network.csv")

social_network <- read.csv("~/Desktop/R/summerstats2git/social_network.csv")

social_network <- read.csv("~/Desktop/R/summerstats2git/social_network.csv", header = T)
#str(social_network.csv) doesn't work
#so underscores super just don't work huh

sn.csv <- read.csv("~/Desktop/sn.csv", header = T)
str(sn.csv)

vignette(
  
)
update.packages()
y

#3. charts and statistics for one var

#have to create table w/ frequencies for R to make a bar graph

site.freq <- table(sn.csv$Site)

barplot(site.freq) #shows in "plots" field the bar graph
? barplot #opens a help window for barplots

barplot(site.freq[order(site.freq, decreasing =T)])
#this puts bars in descending order

barplot(site.freq[order(site.freq)], horiz = T)
#this puts the bar chart horizontally

#Below: fbba = facebook blue. concatenate - facebook blue. repeat gray, 5 times

fbba <- c(rep ("gray", 5), 
          rgb(59, 89, 152, maxColorValue = 255))
#how to break code across 2 lines - one single command 

barplot(site.freq[order(site.freq)], 
        horiz = T,
        col = fbba)
#color = use vector fbba

barplot(site.freq[order(site.freq)],
        horiz = T, #horizontal
        col = fbba, #fb color
        border = NA, # no bordres
        xlim = c(0,100), #scale from 0-100
        main = "Preferred Social Netwrking Site \nA Survey of 202 Users",
        xlab = "Number of Users")
#Bottom two give label for graph and for the x-axis

#how to export the chart? Click on the chart and save as PDF it under "export" 

#charts can help you make sure that your variables look right
sn.csv <- read.csv("~/Desktop/sn.csv", header = T)

#histograms:

hist(sn.csv$Age)

hist(sn.csv$Age,
     #border = NA
     col = "beige", #or use: col = colors() [18]
     main = "Ages of Respondents\nSocial Networking Survey of 202 Users",
     xlab = "Age of Respondents")

#box plots: look at distribution and outliers
boxplot(sn.csv$Age)
#median age around 30, low of 10, high of 70

boxplot(sn.csv$Age,
        col = "beige",
        notch = T,
        horizontal = T,
        main = "Ages of Respondents]n Social Networking Survey",
        xlab = "Age of Respondents")

#Calculating Frequencies:

table(sn.csv$Site) #creates frequency table in alpha order
site.freq <- table(sn.csv$Site) #saves table
site.freq #print table

#replace this table w/ a sorted version of itself
site.freq <- site.freq[order(site.freq, decreasing = T)] #decreasing = True
site.freq #print table

prop.table(site.freq) #gives proportions of total
round(prop.table(site.freq), 2) #gives proportions to 2 decimal points 

#Calculating Descriptives:

summary(sn.csv$Age) #summary for one variable - gives min/max/quartiles/mean/missing = NA
summary(sn.csv)

#Tukey's five number summary: min/quart/mean/3rdquart/max
fivenum(sn.csv$Age)

#alt descriptive statistics - sd, kurtosis, skew, range = like sum, d in Stat
install.packages("psych")
library("psych")
describe(sn.csv)
#gender and site are categorical= have *'s to denote that
#gender, b/c of one missing - gives values 1, 2, 3 (with 1=missing?)

#Recoding Variables:

#looking at variable: Times
hist(sn.csv$Times)
#very skewed histogram - most people in earliest categories

times.z <- scale(sn.csv$Times) #standardizes the distribution
hist(times.z)
describe(times.z)
#skewness and kurtosis are both still bad for this variable. 
#Kurtosis - affected a lot by outliers

#log
times.ln0 <- log(sn.csv$Times)
hist(times.ln0)
describe(times.ln0) #see some weird stuff in this description, b/c of the 0s in dataset

times.ln1 <-log(sn.csv$Times +1) #wow, should have done this for Cynthia paper!
hist(times.ln1)
describe(times.ln1)

#Ranking
times.rank <- rank(sn.csv$Times)
hist(times.rank)
describe(times.rank)
#ties.method : what to do when vals are tied?= c( "average", "first", "random", "max", "min")
times.rankr <- rank(sn.csv$Times, ties.method = "random") #this flattens the dist
hist(times.rankr)
describe(times.rankr)

#Dichotomizing
#use wisely and purposefully! - we are losing information
#if else function: create new var. if time =>1, give val 1, if not, give 0)
time.gt1 <- ifelse(sn.csv$Times > 1, 1, 0)
time.gt1 #this is the whole dataset, with binary values

#Computing New Variables:

#create variable n1 with 1 million random normal values
n1 <- rnorm(1000000) #give random values from normal dist
hist(n1)

#do it again
n2 <- rnorm(1000000)
hist(n2)

#Average scores cross two variables
n.add <- n1 + n2 #new var= n1+n2 (adds 1st item of n1 to 1st in n2, etc.)
hist(n.add) #also gives normal looking bell curve

#Multiple scores across two variables
n.mult <- n1 * n2
hist(n.mult) #hist is much slimmer now. multiplying vals gives huge # of outliers

kurtosi(n1)
kurtosi(n2)
kurtosi(n.add)
kurtosi(n.mult)

#kurtosis is largest diff b/w our mult and add new n vars
#Vector based options in R are very simple and easy to do

#Now, time for bivariate associations.

#Bar charts for group means
google <- read.csv("~/Desktop/R/summerstats2git/google_correlate.csv", header = T)
names(google) #gives names of vars in dataset
str(google) #gives more info about these vars

#does interest in data viz vary by region?
#split data by region, create new data frame
viz.reg.dist <- split(google$data_viz, google$region) #split: from google, take dataviz, split by region
boxplot(viz.reg.dist, col = "lavender")
#shows relative interest in data viz by region - West has widest variation, less in NE
#outliers in NE and in South, South has highest var 

#Barplot w/ means
viz.reg.mean <- sapply(viz.reg.dist, mean) 
barplot(viz.reg.mean,
        col = "beige", #below, 2nd backslash means print the quotation marks
        main = "Average Google Search Shape of\n\"Data Visualization\" by Region of US")
abline(h = 0) #gives reference line of zero

describeBy(google$data_viz, google$region)
#gives descriptives stats for each group 

#Scatterplots
names(google)

#is there assn b/w coldeg and dataviz search?
plot(google$degree, google$data_viz) #x, y
#strong positive assn 
plot(google$degree, google$data_viz,
     main = "interest in data viz searches\nby %with col deg",
     xlab = "pop with col deg",
     ylab = "searches for \"data viz\"",
     pch = 20,
     col = "grey")
#want to add regression line
abline(lm(google$data_viz ~ google$degree), col="red")
#this means: add line, linear model, predicting data viz by degree (red color)
#lowess smoother line (x,y) #this line matches the shape of the data
lines(lowess(google$degree, google$data_viz), col="blue")
#order of vars is different = here x and then y

#Scatterplot matrices
#when you have several scatterplots arranged in rows & cols

#here we specify dataset separately instead of google$ for all
pairs(~data_viz + degree + facebook + nba,
      data = google,
      pch = 20,
      main = "simple scatterplot matrix")

#what this means: data viz x degree, then fb, then nba, and each by each other

pairs.panels(google[c(3, 7, 4, 5)], gap = 0)
#here, specifying which vars we want to use by order in which appear in dataset
#no gap b/w columns 
#have hist for each 4 vars, on top we have overlaid kernal density estimation
#scatterplots on bottom left side of matrix, dot for means, lowess line,
#ellipse for correlation coefficient - rounder = less associated, longer = more
#upper corner, correlation coeffs
#this matrix gives us a lot of information

google <- read.csv("~/Desktop/R/summerstats2git/google_correlate.csv", header = T)

install.packages("rgl")
library("rgl")
plot3d(google$data_viz, #x var
       google$degree, #y var
       google$facebook, #z var
       xlab = "data_viz",
       ylab = "degree",
       zlab = "facebook",
       col = "red",
       size = 3)
#meh, not sure how helpful this is. But can move it around
       
#Correlations.
g.quant <- google[c (3, 7, 4, 5)]
#create new dataset w/ only quantiative vars

cor(g.quant)
#gives correlation all vars in dataset. dataviz$degree strong, dataviz$facebook strong/neg

#can test one pair of vars at a time as hypothesis test
cor.test(g.quant$data_viz, g.quant$degree)
#passes test of stat sig

install.packages("Hmisc")
library("Hmisc")

rcorr(as.matrix(g.quant))
#turn from dataframe into matrix 
#only 2 decimals, and n size, and probabilities
#sig probabilities: dataviz$fb, fb$nba

#Regressions.
#outcome ~ (is a function of: vars, vars come from google dataset)
reg1 <- lm(data_viz ~
          degree + stats_ed + facebook + nba + has_nba + region,
          data = google)

#stats_ed currently enetered as text, region as categorical w/ 4 levels
#R is smart, so we don't need to transform these vars 

summary(reg1)
#residuals - how well model fits the data
#stats_edyes = made into dummy var w/ 1=yes
#has nba_yes also turned into dummy
#regions = one region is omitted 
#degree and fb are both sig
#R2, adj = good prediction model (~60% of variance explained by model)

#Crosstabs.

#create a contingency table
sn <- read.csv("~/Desktop/R/summerstats2git/sn.csv", header = T)
sn.tab <- table(sn$Gender, sn$Site)
sn.tab

#can also get marginal frequences
margin.table(sn.tab, 1) #row marginal freqs
margin.table(sn.tab, 2) #col marginal freqs
#each of these give a tab of each var, gender and then female

round(prop.table(sn.tab), 2) #cell %
round(prop.table(sn.tab, 1), 2) #row % #add to 100 going across
round(prop.table(sn.tab, 2), 2)#col % add to 100 going down

#Chi-squared test
chisq.test(sn.tab)
#yes, statistically significant. 
#warning message = this is b/c of small sample, sparse cells
#for reliable x2, want expected frequencies of at least 5-10 per cell

#T-tests.
google <- read.csv("~/Desktop/R/summerstats2git/google_correlate.csv", header = T)

t.test(google$nba ~ google$has_nba)
#do more ppl search for nba if they have their own bball group?
#outcome var ~ predictor, t test
#yes, it is significant 
#groups w/o nba team, have -0.5 mean, 0.6 if have a team (standardized)

#Analysis Of Variance.
anova1 <- aov(data_viz ~ region, data = google)
summary(anova1)

#no statistically significant difference b/w these groups - 38% chance to get diffs by random

#Two-way factorial design
anova2a <- aov(data_viz ~
              region + stats_ed + region:stats_ed,
              data=google)
summary(anova2a)
#have stats ed, also interaction b/w stats ed and region
#is there a diff by stats ed, is there a dif by region, does region vary by stats ed
#not significant

anova2b <- aov(data_viz ~
              region*stats_ed,
              data = google)
summary(anova2b)
#if you put the interaction, it will give you the main effects too