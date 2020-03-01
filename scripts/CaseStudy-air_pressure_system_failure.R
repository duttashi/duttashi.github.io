# Objective: Determine the cost of misclassifcation in detecting air pressure system failure in heavy vehicles
# Datasource: https://archive.ics.uci.edu/ml/datasets/APS+Failure+at+Scania+Trucks
# @author: https://github.com/duttashi
# clean the workspace
rm(list = ls())


library(caret)
library(FactoMineR)# for PCA() and MCA()
library(mice)
library(Hmisc) # impute()
library(factoextra) # for fviz_screeplot()
library(gridExtra) # grid.arrange
library(grid) # for grid.rect()
library(ggpubr) # for annotate_figure()
library(MASS) # lda
library(ggplot2)
library(magrittr)
library(VIM) # aggr
# READ DATA IN MEMORY
df_train<- read.csv("data/aps_failure_training_set.csv",
                               header=T, na.strings=c("na","NA"), stringsAsFactors = FALSE, strip.white = TRUE)

df_test <- read.csv("data/aps_failure_test_set.csv",
                               header=T, na.strings=c("na","NA"), stringsAsFactors = FALSE, strip.white = TRUE)
# check and count total missing values
sum(is.na(df_train)) # 850015
sum(is.na(df_test)) # 228680
# check data str
str(df_train)
# create a copy
df<- df_train
# Visualize the imbalanced data
df %>%
  dplyr::filter(!is.na(class)) %>%
  ggplot(aes(x=class))+
  geom_bar()+
  ggtitle("Imbalanced class distribution")+
  labs(x="class", y="failure count")+
  theme_bw()+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

####### Data cleaning
# save the class var
x<- df_train$class
y<- df_test$class

# Dimensionality reduction steps for training data
df<- df_train
# check for variables with more than 75% data is missing
miss_cols<- lapply(df, function(col){sum(is.na(col))/length(col)})
df<- df[, !(names(df) %in% names(miss_cols[lapply(miss_cols, function(x) x) > 0.75]))]  # 6 cols with more than 75% missing data
# check for variables with more than 80% values are zero
zero_cols<- lapply(df, function(col){length(which(col==0))/length(col)})
#zero_cols<- as.data.frame(zero_cols)
df<- df[, !(names(df) %in% names(zero_cols[lapply(zero_cols, function(x) x) > 0.8]))]

# as all independent variables are continuous in nature, so check for variables where the standard deviation is zero
# remove columns where the standard derivation is zero
std_zero_col <- lapply(df, function(col){sd(col, na.rm = TRUE)})
df <- df[, !(names(std_zero_col) %in% names(std_zero_col[lapply(std_zero_col, function(x) x) == 0]))] # only 1 variable with std dev is zero

# check for near zero variance cols
badCols<- nearZeroVar(df)
names(df[, badCols]) # 9 cols in aps_train data with near zero variance property. removing them
df<- df[, -badCols]

# Missing data visualization
aggr(df, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, 
                  labels=names(df), cex.axis=.7, gap=3, 
                  ylab=c("Histogram of missing data","Pattern"))

# missing data imputation
imputed<- impute(df,imputation=1, list.class=TRUE, pr=FALSE, check=FALSE)
# convert the list to dataframe
imputed.data <- as.data.frame(do.call(cbind,imputed))
# arrange the columns accordingly
imputed.data <- imputed.data[, colnames(df), drop = FALSE]
# check for missing data
sum(is.na(imputed.data))
names(imputed.data)
# PCA correaltion treatment 
df_pca<-PCA(imputed.data, scale.unit = TRUE, ncp = 5,  graph = FALSE)
#Scree plot to visualize the PCA's
screeplot<-fviz_screeplot(df_pca, addlabels = TRUE,
                          barfill = "gray", barcolor = "black",
                          ylim = c(0, 50), xlab = "Principal Component (PC) for continuous variables", ylab = "Percentage of explained variance",
                          main = "(A) Scree plot: Factors affecting APS ",
                          ggtheme = theme_minimal()
                          )
# Determine Variable contributions to the principal axes
# Contributions of variables to PC1
pc1<-fviz_contrib(df_pca, choice = "var", 
                  axes = 1, top = 10, sort.val = c("desc"),
                  ggtheme= theme_minimal())+
  labs(title="(B) PC-1")

# Contributions of variables to PC2
pc2<-fviz_contrib(df_pca, choice = "var", axes = 2, top = 10,
                  sort.val = c("desc"),
                  ggtheme = theme_minimal())+
  labs(title="(C) PC-2")

fig1<- grid.arrange(arrangeGrob(screeplot), 
                    arrangeGrob(pc1,pc2, ncol=1), ncol=2, widths=c(2,1)) 
annotate_figure(fig1
                ,top = text_grob("Principal Component Analysis (PCA): training data", color = "black", face = "bold", size = 14)
                ,bottom = text_grob("Data source: \n APS\n", color = "brown",
                                    hjust = 1, x = 1, face = "italic", size = 10)
)
# Add a black border around the 2x2 grid plot
grid.rect(width = 1.00, height = 0.99, 
          gp = gpar(lwd = 2, col = "black", fill=NA))
grid.newpage()
#### Extract the Principal Components
# select PC1 components only
# get eigen values
eig.val<- get_eigenvalue(df_pca)
# A simple method to extract the results, for variables, from a PCA classput is to use the function get_pca_var() [factoextra package].
imp_vars<-factoextra::fviz_contrib(df_pca, choice = "var", 
                                   axes = c(1), top = 10, sort.val = c("desc"))
#save data from contribution plot
dat<-imp_vars$data
#filter class ID's that are higher than 1
r<-rownames(dat[dat$contrib>1,])
#extract these from your original data frame into a new data frame for further analysis
df_imputed_impvars<-imputed.data[r] # 50 variables showing maximum variance
df_imputed_impvars$class<- x
train_data_clean<- df_imputed_impvars
train_data_clean$class<- as.factor(train_data_clean$class)
str(train_data_clean)
###### PREDICTIVE MODELLING ON IMBALANCED TRAINING DATA
# Run algorithms using 3-fold cross validation
set.seed(2020)
index <- createDataPartition(train_data_clean$class, p = 0.7, list = FALSE, times = 1)
train_data <- train_data_clean[index, ]
test_data  <- train_data_clean[-index, ]
# create caret trainControl object to control the number of cross-validations performed
ctrl <- trainControl(method = "repeatedcv",
                     number = 3,
                     # repeated 3 times
                     repeats = 3, 
                     verboseIter = FALSE, 
                     classProbs=TRUE, 
                     summaryFunction=twoClassSummary
                     )

# Metric is AUPRC which is Area Under Precision Recall Curve (PRC). Its more robust then using ROC. Accuracy and Kappa are used for balanced classes, while PRC is used for imbalanced classes
set.seed(2020)
# turning "warnings" off
options(warn=-1)
metric <- "AUPRC"
# linear discrminant analysis
fit_lda<-train(class ~., data = train_data , 
               method='lda', 
               trControl=ctrl,  
               metric = metric,
               preProc = c("center", "scale"))

fit_logreg<-train(class ~., data = train_data , 
                  method='glm', 
                  trControl=ctrl,  
                  metric = metric,
                  preProc = c("center", "scale")
                  )

# gradient boosting
fit_gbm <- train(class ~., data = train_data ,
                 method='gbm',
                 trControl=ctrl,
                 metric = metric,
                 preProc = c("center", "scale")
)

# Model summary
models <- resamples(list(logreg = fit_logreg, gbm = fit_gbm, lda = fit_lda))
summary(models)
# compare models
dotplot(models)
bwplot(models)
# Make Predictions using the best model
predictions <- predict(fit_logreg, test_data) # log reg has lowest specificity
confusionMatrix(predictions, test_data$class) # 98% accuracy, balanced accuracy # 75%
# Total cost imbalanced training data = 10*55+500*149 = $75,050


# PREDICTIVE MODELLING On BALANCED TRAINING DATA

# Method 1: Under Sampling
# turning "warnings" off
options(warn=-1)
ctrl <- trainControl(method = "repeatedcv",
                     number = 3, repeats = 3,
                     verboseIter = FALSE,
                     classProbs=TRUE, 
                     summaryFunction=twoClassSummary,
                     sampling = "down")
# Logistic Regression on under sampled data
set.seed(2020)
fit_logreg_under<-train(class ~., data = train_data , 
                        method='glm', 
                        trControl=ctrl,  
                        metric = metric,
                        preProc = c("center", "scale")
                        )
# Logistic Regression on over sampled data
ctrl <- trainControl(method = "repeatedcv",
                     number = 3, repeats = 3,
                     verboseIter = FALSE,
                     classProbs=TRUE, 
                     summaryFunction=twoClassSummary,
                     sampling = "up"
                     )
set.seed(2020)
fit_logreg_up<-train(class ~., data = train_data , 
                     method='glm', 
                     trControl=ctrl,  
                     metric = metric,
                     preProc = c("center", "scale")
                     )

# Logistic Regression on random over sampled data
set.seed(2020)
ctrl <- trainControl(method = "repeatedcv",
                     number = 3, repeats = 3,
                     verboseIter = FALSE,
                     classProbs=TRUE, 
                     summaryFunction=twoClassSummary,
                     sampling = "rose"
                     )
fit_logreg_rose<-train(class ~., data = train_data , 
                       method='glm', 
                       trControl=ctrl,  
                       metric = metric,
                       preProc = c("center", "scale")
                       )

# summarize models built on balanced data
models <- resamples(list(glm_under=fit_logreg_under, glm_over=fit_logreg_up, glm_rose=fit_logreg_rose))
summary(models)
# compare accuracy of models
dotplot(models)
bwplot(models)

# Make Predictions using the best model
predictions <- predict(fit_logreg_up, test_data)
# Using over-sampling as a method for balancing the data
confusionMatrix(predictions, test_data$class) # Total cost balanced training data (log reg over sampl)= 10*540+500*33 = $21,900

########## Data cleaning for the testing dataset

# Dimensionality reduction steps
df<- df_test
# check for variables with more than 75% data is missing
miss_cols<- lapply(df, function(col){sum(is.na(col))/length(col)})
df<- df[, !(names(df) %in% names(miss_cols[lapply(miss_cols, function(x) x) > 0.75]))]  # 6 cols with more than 75% missing data
# check for variables with more than 80% values are zero
zero_cols<- lapply(df, function(col){length(which(col==0))/length(col)})
#zero_cols<- as.data.frame(zero_cols)
df<- df[, !(names(df) %in% names(zero_cols[lapply(zero_cols, function(x) x) > 0.8]))]

# as all independent variables are continuous in nature, so check for variables where the standard deviation is zero
# remove columns where the standard derivation is zero
std_zero_col <- lapply(df, function(col){sd(col, na.rm = TRUE)})
df <- df[, !(names(std_zero_col) %in% names(std_zero_col[lapply(std_zero_col, function(x) x) == 0]))] # only 1 variable with std dev is zero

# check for near zero variance cols
badCols<- nearZeroVar(df)
names(df[, badCols]) # 8 cols in aps_train data with near zero variance property. removing them
df<- df[, -badCols]

# Missing data visualization
aggr(df, col=c('navyblue','red'), numbers=TRUE, sortVars=TRUE, 
     labels=names(df), cex.axis=.7, gap=3, 
     ylab=c("Histogram of missing data","Pattern"))


# missing data imputation
imputed<- impute(df,imputation=1, list.class=TRUE, pr=FALSE, check=FALSE)
# convert the list to dataframe
imputed.data <- as.data.frame(do.call(cbind,imputed))
# arrange the columns accordingly
imputed.data <- imputed.data[, colnames(df), drop = FALSE]
# check for missing data
sum(is.na(imputed.data))
# PCA correaltion treatment 
df_pca<-PCA(imputed.data, scale.unit = TRUE, ncp = 5,  graph = FALSE)
#Scree plot to visualize the PCA's
screeplot<-fviz_screeplot(df_pca, addlabels = TRUE,
                          barfill = "gray", barcolor = "black",
                          ylim = c(0, 50), xlab = "Principal Component (PC) for continuous variables", ylab = "Percentage of explained variance",
                          main = "(A) Scree plot: Factors affecting APS ",
                          ggtheme = theme_minimal()
                          )
# Determine Variable contributions to the principal axes
# Contributions of variables to PC1
pc1<-fviz_contrib(df_pca, choice = "var", 
                  axes = 1, top = 10, sort.val = c("desc"),
                  ggtheme= theme_minimal())+
  labs(title="(B) PC-1")

# Contributions of variables to PC2
pc2<-fviz_contrib(df_pca, choice = "var", axes = 2, top = 10,
                  sort.val = c("desc"),
                  ggtheme = theme_minimal())+
  labs(title="(C) PC-2")

fig2<- grid.arrange(arrangeGrob(screeplot), 
                    arrangeGrob(pc1,pc2, ncol=1), ncol=2, widths=c(2,1)) 
annotate_figure(fig2
                ,top = text_grob("Principal Component Analysis (PCA): test data", color = "black", face = "bold", size = 14)
                ,bottom = text_grob("Data source: \n APS\n", color = "brown",
                                    hjust = 1, x = 1, face = "italic", size = 10)
)
# Add a black border around the 2x2 grid plot
grid.rect(width = 1.00, height = 0.99, 
          gp = gpar(lwd = 2, col = "black", fill=NA))
grid.newpage()
#### Extract the Principal Components
# select PC1 components only
# get eigen values
eig.val<- get_eigenvalue(df_pca)
# A simple method to extract the results, for variables, from a PCA classput is to use the function get_pca_var() [factoextra package].
imp_vars<-factoextra::fviz_contrib(df_pca, choice = "var", 
                                   axes = c(1), top = 10, sort.val = c("desc"))
#save data from contribution plot
dat<-imp_vars$data
#filter class ID's that are higher than 1
r<-rownames(dat[dat$contrib>1,])
#extract these from your original data frame into a new data frame for further analysis
df_imputed_impvars_test<-imputed.data[r] # 49 variables showing maximum variance
df_imputed_impvars_test$class<- y
df_imputed_impvars_test$class<- as.factor(df_imputed_impvars_test$class)
test_data_clean<-df_imputed_impvars_test 
dim(test_data_clean)
# PREDICTIVE MODELLING using Logistic Regression On BALANCED Over sampled DATA 
set.seed(2020)
index <- createDataPartition(test_data$class, p = 0.7, list = FALSE, times = 1)
train_data <- test_data[index, ]
test_data  <- test_data[-index, ]
# turning "warnings" off
options(warn=-1)
metric <- "AUPRC"
# Logistic Regression on over sampled data
set.seed(2020)
ctrl <- trainControl(method = "repeatedcv",
                     number = 3, repeats = 3,
                     verboseIter = FALSE,
                     classProbs=TRUE, 
                     summaryFunction=twoClassSummary,
                     sampling = "up"
                     )
fit_logreg_up<-train(class ~., data = train_data , 
                     method='glm', 
                     trControl=ctrl,  
                     metric = metric,
                     preProc = c("center", "scale")
                     )
# Make Predictions using the best model
predictions <- predict(fit_logreg_up, test_data)
# Using over-sampling as a method for balancing the data
confusionMatrix(predictions, test_data$class) # Total cost balanced testing data (log reg over sampl)= 10*129+500*12 = $7,290
