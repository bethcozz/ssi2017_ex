##Trying NOLA code in R##

library(readr)
#Read in data set
nola <- read_csv("~/Desktop/code/nolabblistings.csv")
#Look at data
print(nola)
head(nola)
describe(nola)

#Scatterplot reviews x price
plot(nola$reviews, nola$price,
     main = "number of reviews by price",
     xlab = "number of reviews",
     ylab = "price",
     col = "grey")

#Scatterplot satisfaction x price
plot(nola$overall_satisfaction, nola$price,
    main = "overall satisfaction by price",
    xlab = "overall satisfaction (1-5)",
    ylab = "price",
    col = "grey")
    
plot(nola$overall_satisfaction, nola$reviews,
     main = "number of reviews by satisfaction",
     ylab = "number of reviews",
     xlab = "overall satisfaction (1-5)",
     col = "grey")

plot(nola$bedrooms, nola$price,
     main = "price by bedrooms",
     xlab = "num rooms",
     ylab = "price",
     col = "grey")

plot(nola$bedrooms, nola$accommodates,
     main = "accommodates by rooms",
     xlab = "num rooms",
     ylab = "accommodates",
     col = "grey")

#Create subset of data w/ only focal vars
keyvars <- c("price", "reviews", "overall_satisfaction", "bedrooms", "accommodates", "minstay", "room_type")
nolaTrim <- nola[keyvars]
nolaTrim
head(nolaTrim)
describe(nolaTrim)

??null
?is.null
is.null(nolaTrim)
is.na(nolaTrim)
nomiss <- na.omit(nolaTrim)

head(nomiss)
describe(nomiss)

#here we specify dataset separately instead of nola$ for all
pairs(~price + overall_satisfaction + bedrooms + accommodates + reviews,
      data = nomiss,
      pch = 20,
      main = "simple scatterplot matrix")
#what this means: price x sat, then rooms, then accommodates, and each by each other

#Make correlation matrix
numvars <- c("price", "reviews", "overall_satisfaction", "bedrooms", "accommodates", "minstay")
nolanum <- nomiss[numvars]

#from: http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization
cornola <- round(cor(nolanum),2)
#have to reshape "melt" corr fist (IDK why)
library(reshape2)
melted_cornola <- melt(cornola)
head(melted_cornola)
library(ggplot2)
ggplot(data = melted_cornola, aes(x=Var1, y=Var2, fill=value)) + geom_tile
?geom_tile
#Error: Don't know how to add geom_tile to a plot
ggplot(melted_cornola) + geom_tile()
?ggplot

##NOTE: SKIPPING CORRELATION HEATMAP FOR NOW##
cor(nomiss$reviews, nomiss$price)
#reviews, price
cor(nomiss$accommodates, nomiss$price)
#accommodates, price

library(MASS)
rtsat <- table(nomiss$room_type, nomiss$overall_satisfaction)
rtsat
chisq.test(rtsat)
#room type, satisfaction

rtpri <-table(nomiss$room_type, nomiss$price)
rtpri
chisq.test(rtpri)
#room type, price

print(nomiss$room_type)
#not sure how to see all unique vals,
#but cheated w/ python: entire home/apt
#private room, shared room only options

nomiss$entirehome <- ifelse(nomiss$room_type=="Entire home/apt", 1, 0)
nomiss$pvtroom <- ifelse(nomiss$room_type=="Private room", 1, 0)
nomiss$shared <- ifelse(nomiss$room_type=="Shared room", 1, 0)
#sweet - already bound to our dataset

head(nomiss)

#REGRESSION
#Make sure DV is numeric this way:
#is.factor(nomiss$price)
#nomiss$price<-as.numeric(nomiss$price)

#Equation/command:
pricereg <-lm(price~reviews + overall_satisfaction + bedrooms + accommodates + minstay + pvtroom + shared, data=nomiss)
summary(pricereg)

#Next step would be to redo RF model - should prob have a tutorial for it
