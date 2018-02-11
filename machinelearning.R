country <- c("Japan","Japan","Japan", "US", "US","US","US","Germany",
             "Germany","Germany","Germany", "Germany","Germany","Germany",
             "US","US","US","Italy", "Japan","Japan","Japan","US", "US","US","US",
             "Italy","Germany","UK","US", "Italy","Italy","Sweden")
mtcars_plus <- cbind(mtcars, country)
#For this example, we'll assume we want to predict mpg based on the other variables. It will help to have a data.frame without the response variable. Also, we need to make sure that all categorical variables are set to factor objects.

# remove first column - our response variable
mtcars_preds <- mtcars_plus[,-1]
#(take out the y var)

# make sure all categorical variables are stored as factors
# am and vs are actually categorical binary variables dummy coded {0,1}
mtcars_preds$am <- factor(mtcars_preds$am)
mtcars_preds$country <- factor(mtcars_preds$country)
mtcars_preds$vs <- factor(mtcars_preds$vs)
#A good first step is to remove variables that cause multicollinearity. In some models, multicollinearity will cause instability during model training. Outside multiple linear regression, there's not much mathematical-based tests for this. Caret package has the findCorrelation function that can heuristically determine which columns to remove.
View(mtcars_preds)
# find out which columns are numeric
# create a data.frame of just numeric variables
mtcars_preds_num <- mtcars_preds[,col_num]
col_num

# findCorrelation() will determine which variables to remove
# the first input is a correlation matrix.
# the 2nd input is the cutoff value - represents the abs pairwise cor value
# names = T means I want the result to be the column names rather than the index value
cor(mtcars_preds_num)
#subset of predictors for numerical vars
to_remove <- findCorrelation(cor(mtcars_preds_num), 0.8, names = T)
to_remove

# remove those columns
names(mtcars_preds) #names of cols of data.frame
names(mtcars_preds) %in% to_remove #is col name in to_remove?
! names(mtcars_preds) %in% to_remove #flip T/F
mtcars_preds <- mtcars_preds[,! names(mtcars_preds) %in% to_remove]

# the 2nd parameter is a vector listing all the transformations you want
# the order doesn't matter - that's determined by the function
trans <- preProcess(mtcars_preds, c("nzv","BoxCox","center","scale"))
# transformations are actually not done
# the parameters for each transformation are stored instead
trans

# when you want to perform the transformations, use predict
# first argument is the result of preProcess
# 2nd arg is the data.frame i want to process
predict(trans, mtcars_preds)

# Box-Cox will not be performed on variables with non-postive values
dummy <- mtcars_preds
dummy$hp <- -1 * dummy$hp
preProcess(dummy, c("nzv","BoxCox","center","scale"))
preProcess(dummy, c("nzv","YeoJohnson","center","scale"))
#Lastly, some models will need to dummy code categorical variables. By default, dummyVars will create a full set. This is good for tree models but not models like linear regression.

#Just as with preProcess, the result of dummyVars stores how to do the transformation. To do the actual transformation, you use predict again.

# dummy code (0 for false, 1 for true) country, vs, and am variables
y_all <- dummyVars(~country+vs+am, mtcars_preds)
y_all # does not do transformation but stores how to do them
predict(y_all, mtcars_preds) #use predict to do transformation

# what is it doing?
levels(mtcars_preds$country)
colnames(predict(y_all, mtcars_preds))

# fullRank = T if model needs one level to be set as intercept
y_intercept <- dummyVars(~country+vs+am, mtcars_preds, fullRank = T)
levels(mtcars_preds$country)
colnames(predict(y_intercept, mtcars_preds))