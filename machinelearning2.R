#Preprocessing the data, first
#add country to mtcars data set
country <- c("Japan","Japan","Japan", "US", "US","US","US","Germany",
             "Germany","Germany","Germany", "Germany","Germany","Germany",
             "US","US","US","Italy", "Japan","Japan","Japan","US", "US","US","US",
             "Italy","Germany","UK","US", "Italy","Italy","Sweden")
mtcars_plus <- cbind(mtcars, country)

# remove first column - our response variable
mtcars_preds <- mtcars_plus[,-1]

# make sure all categorical variables are stored as factors
# am and vs are actually categorical binary variables dummy coded {0,1}
mtcars_preds$am <- factor(mtcars_preds$am)
mtcars_preds$country <- factor(mtcars_preds$country)
mtcars_preds$vs <- factor(mtcars_preds$vs)

# remove collinearity
# find out which columns are numeric
col_num <- sapply(mtcars_preds,function(x) {class(x) == 'numeric'})
# create a data.frame of just numeric variables
mtcars_preds_num <- mtcars_preds[,col_num]
to_remove <- findCorrelation(cor(mtcars_preds_num), 0.8, names = T)
mtcars_preds <- mtcars_preds[,! names(mtcars_preds) %in% to_remove]

# preprocess data
trans_numeric <- preProcess(mtcars_preds, c("nzv","BoxCox","center","scale"))
trans_categor <- dummyVars(~country+vs+am, mtcars_preds, fullRank = T)

numerics_processed <- predict(trans_numeric, mtcars_preds)
dummies_processed<- predict(trans_categor, mtcars_preds)
mtcars_processed <- cbind(
  numerics_processed[c('hp','drat', 'wt','qsec','gear','carb')] ,
  dummies_processed
)

#set up data partitioning - 10 fold
train_ctrl <- trainControl(method = 'cv', number = 10)

# y argument is response variable
# x argument is the processed data
# method indicates the model to use
# trControl should be the results of trainControl function
lm_fit <- train(y=mtcars$mpg, x=mtcars_processed,
                method = 'lm', trControl = train_ctrl)
#train: (y)outcome=carsmpg, based on (x)predictors=processedCarsData
#lm=linear model

lm_fit
summary(lm_fit) #only relevant for lm - outputs lm() typical output
lm_fit$metric #what metric was used to decide on optimal model
lm_fit$results #no tuning paramater so just 1 set of metrics
lm_fit$finalModel #best-fit model, an lm model
class(lm_fit$finalModel)

#lasso = extension that does rigorization, designed to weigh balance of how 
  #many variables to include, can reduce the # of variables, e.g.
  #tuneGrid = tuning parameter is "fraction"
lasso_fit <- train(y=mtcars$mpg, x=mtcars_processed, method='lasso',
                   tuneGrid = data.frame("fraction" = seq(0.05,1,length.out = 10)) ,
                   trControl = train_ctrl
)
lasso_fit
lasso_fit$metric
lasso_fit$results #for every row in tuneGrid, show metrics
lasso_fit$finalModel
class(lasso_fit$finalModel)

#tuneGrid argument not supplied so use default grid
earth_fit <- train(y=mtcars$mpg, x=mtcars_processed,
                   method='earth',trControl = train_ctrl)
earth_fit
earth_fit$results #for every row in tuneGrid, show metrics
earth_fit$finalModel
class(earth_fit$finalModel)

#random forest - more complex, better track record
rf_fit <- train(y=mtcars$mpg, x=mtcars_processed,
                tuneGrid = data.frame("mtry" = c(2:10,12,14,16,20)),
                method='rf',trControl = train_ctrl)
rf_fit

#change optimized metric from RMSE to Rsquared
rf_fit <- train(y=mtcars$mpg, x=mtcars_processed,
                tuneGrid = data.frame("mtry" = c(2:10,12,14,16,20)),
                method='rf',trControl = train_ctrl, metric="Rsquared")
rf_fit
rf_fit$finalModel

#Another popular model
#scale=F will get passed to underlying argument
svm_fit <- train(y=scale(mtcars$mpg)[,1], x=mtcars_processed,
                 method='svmRadial',trControl = train_ctrl, scale=F)
#svmradial function is trying to scale things, I say false b/c I don't want ot scale again

svm_fit

#without scale, the underlying model tries to scale again
#will produce warnings

train(y=scale(mtcars$mpg)[,1], x=mtcars_processed,
      method='svmRadial',trControl = train_ctrl)

#very popular
xgb_fit <- train(y=mtcars$mpg, x=mtcars_processed,
                 method='xgbLinear',trControl = train_ctrl)
xgb_fit