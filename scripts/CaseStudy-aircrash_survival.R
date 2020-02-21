# Datasource # 1: https://www.kaggle.com/saurograndi/airplane-crashes-since-1908
# Datasource # 2: http://www.planecrashinfo.com/database.htm
# Objective-1: Justify whether it is safer to take the aircraft nowadays. Support your decision with data.
# Objective-2: Apply machine learning techniques to predict any interesting topic of this.

# Analysis conducted by Ashish Dutt
# clean the workspace
rm(list = ls())

# Load required libraries

library(readr) # input/output
library(tibble) # data wrangling
library(data.table) # data manipulation
library(lubridate) # date and time
library(dplyr) # data manipulation
library(tidyr) # data manipulation
library(ggplot2) # visualization
library(tidytext) # text manipulation
library(xml2)
library(rvest)
library(magrittr)
library(stringr) # text manipulation
library(caret)
library(corrplot)
library(FactoMineR) # for PCA() and MCA()
library(factoextra) # for fviz_screeplot()
library(gridExtra)
library(grid) # for grid.rect()
library(ggpubr) # for annotate_figure()

# load the data
kaggle_data<- read.csv("Pre-Screen Assessment (PSA)/1- Question/data/Airplane_Crashes_and_fatalities_Since_1908.csv",
                       header=T, na.strings=c("","NA"), stringsAsFactors = FALSE)
# lowercase the column names
for( i in 1:ncol(kaggle_data)){
  colnames(kaggle_data)[i] <- tolower (colnames(kaggle_data)[i])
}

# get external data
# since the kaggle data is only till year 2009. Will get the data from 2010 till 2020
# select from which years to get plane crash data and create URL for each
years <- c("2010","2011","2012","2013", "2014", "2015", "2016","2017","2018","2019","2020")
urlYears <- paste0("http://www.planecrashinfo.com/", years, 
                   "/", years, ".htm") 
# get URL for each plane crash table from each year selected
urls <- mapply(function(urlYear, year) {
  rowNumber <- urlYear %>% 
    read_html %>% 
    html_table(header = TRUE) %>% 
    .[[1]] %>% nrow
  
  urlsSpec <- paste0("http://www.planecrashinfo.com/", year, 
                     "/", year, "-", 1:rowNumber, ".htm")
},
urlYears,
years
) %>% unlist 
# retrieve information 

ext_data <- lapply(urls, function(url) {
  url %>% 
    # read each crash table
    read_html %>% 
    html_table %>% 
    data.frame %>%  
    setNames(c("Vars", "Vals")) %>%
    # header is a colunm and values are in a column -> tidy up
    spread(Vars, Vals) %>% 
    .[-1]
})
# data list to data.frame and set appropriate variable names
ext_data %<>% 
  bind_rows %>% 
  setNames(gsub(":", "", colnames(.)) %>% tolower)

# Data management decsions
# replace values in variables like aboard
ext_data$aboard<- sub("\\s*\\(.*", "", ext_data$aboard)
ext_data<-ext_data %>% 
  mutate(aboard = trimws(str_replace(aboard, "\\(.*?\\)", "")))
ext_data<-ext_data %>% 
  mutate(fatalities = trimws(str_replace(fatalities, "\\(.*?\\)", "")))
# replace ? by NA
ext_data[ext_data == '?']<- NA
ext_data$X<- NULL
# rename the variables
ext_data<-ext_data %>%
  rename(flight = "flight #", fuselage_number = "cn / ln", type = "ac\n        type")
kaggle_data<-kaggle_data %>%
  rename(flight = "flight..", fuselage_number = "cn.in")

# Coerce date in factor format to date format
ext_data$date<- mdy(ext_data$date)
kaggle_data$date<- mdy(kaggle_data$date)

# clean the time variable in both the datasets 
ext_data$time<- parse_date_time(ext_data$time,c("HM"))
ext_data<- ext_data %>%
  separate(time, into = c("date1","time"), sep = " ", fill = "right")
ext_data$date1<- NULL
ext_data<- ext_data %>%
  separate(time, into = c("crash_hour","crash_minute","sec"), sep = ":", fill = "right")
ext_data$sec<- NULL

sum(is.na(kaggle_data$time))
kaggle_data$time[is.na(kaggle_data$time)]<- c("00:00")
kaggle_data<- kaggle_data %>%
  separate(time, into = c("crash_hour","crash_minute"), sep = ":", fill = "right")

# merge the kaggle and external data
df<-  data.frame( rbind(kaggle_data, ext_data))
df$crash_hour[is.na(df$crash_hour)]<- 0
df$crash_minute[is.na(df$crash_minute)]<- 0
df$crash_hour<- as.numeric(factor(df$crash_hour))
df$crash_minute<- as.integer(df$crash_minute)

# write data to disk
write.csv(df, file = "Pre-Screen Assessment (PSA)/1- Question/data/external_and_kaggle_data.csv")

# Data structure and content
summary(df)
# observations
# 1. several factor variables. Change data type for date, time
# several operator, flight, route and type. Decompose/Subset to manageable chunk
# clean the location variable to extract the precise area of crash.
# ideas
# 1. find distance between crash site and flight take-off location
# There are crashes with Zero passengers aboard

# missing values
sum(is.na(df)) # 8181 missing values

# replace illegal character
df$registration<- gsub("/","", df$registration)
df$registration<- gsub("-","", df$registration)

# FEATURE ENGINEERING
df<- df %>%
  mutate(crash_reason=ifelse(grepl('\\btakeoff\\b',summary),'technical_failure',
                             ifelse(grepl('\\mountain\\b',summary),'mountain_crash',
                                    ifelse(grepl('\\sea\\b',summary),'sea_crash',
                                           ifelse(grepl('\\Engine failure\\b',summary),'technical_failure',
                                                  ifelse(grepl('\\taking off\\b',summary),'technical_failure',
                                                         ifelse(grepl('\\approach\\b',summary),'technical_failure',
                                                                ifelse(grepl('\\weather\\b',summary),'natural_cause',
                                                                       ifelse(grepl('\\cargo\\b',summary),'technical_failure',
                                                                              ifelse(grepl('\\collision\\b',summary),'technical_failure',
                                                                                     ifelse(grepl('\\pilot\\b',summary),'technical_failure',
                                                                                            ifelse(grepl('\\snow\\b',summary),'natural_cause',
                                                                                                   ifelse(grepl('\\fog\\b',summary),'natural_cause',
                                                                                                          ifelse(grepl('\\fire\\b',summary),'natural_cause',
                                                                                                                 ifelse(grepl('\\emergency\\b',summary),'technical_failure',
                                                                                                                        ifelse(grepl('\\landing\\b',summary),'technical_failure',
                                                                                                                               ifelse(grepl('\\collision\\b',summary),'technical_failure',
                                                                                                                                      ifelse(grepl('\\shot\\b',summary),'military action',
                                                                                                                                             ifelse(grepl('\\military\\b',summary),'military action',
                                                                                                                                                    ifelse(grepl('\\exploded\\b',summary),'technical_failure',
                                                                                                                                                           ifelse(grepl('\\gas\\b',summary),'technical_failure',
                                                                                                                                                                  ifelse(grepl('\\misidentified\\b',summary),'military action by accident',
                                                                                                                                                                         "miscellaneous"))))
                                                                                                                                      )
                                                                                                                               )
                                                                                                                        )
                                                                                                                 )
                                                                                                          )
                                                                                                   )
                                                                                            )
                                                                                     )
                                                                              )
                                                                       )
                                                                )
                                                         )
                                                  )
                                           )
                                    )
                             )
  )
  )

# now split the date into day, month, year cols
df<- df %>%
  separate(date, into = c("crash_year","crash_month","crash_date"))
# change data types
df$crash_year<- as.integer(df$crash_year)
df$crash_month<- as.integer(df$crash_month)
df$crash_date<- as.integer(df$crash_date)

# now split location into crash_area, crash_country cols
df<- df %>%
  separate(location, into = c("crash_area","crash_country"), sep = ",", fill = "right")

# now split route into crash_route_start, crash_route_mid, crash_route_end cols
df<- df %>%
  separate(route, into = c("crash_route_start","crash_route_mid","crash_route_end"), sep = c("-"), fill = "right")

df$aboard[is.na(df$aboard)]<- 0
df$aboard<- as.numeric(factor(df$aboard))

df$fatalities[is.na(df$fatalities)]<- 0
df$fatalities<- as.numeric(factor(df$fatalities))
# create variable Survived based on people on board - people died
df$survived<- ifelse(df$fatalities > df$aboard, "0", df$aboard-df$fatalities)
df$crash_survivor<- ifelse(df$survived>0, "alive","dead")

# Civilian VS Military crash types
df<- df %>%
  mutate(crash_opr_type=ifelse(grepl('\\bMilitary\\b',operator),'Military','Civilian'))
# ratio of alive vs dead
df <- df %>%
  mutate(alive_dead_ratio=fatalities/aboard)

# write to disk
write.csv(df, file = "Pre-Screen Assessment (PSA)/1- Question/data/aircrash_partial_clean_data.csv")
# subset data based on Military and Civilian crashes
crash_mil<- df[df$crash_opr_type=='Military',]
crash_civ<- df[df$crash_opr_type=='Civilian',]

write.csv(crash_civ, file = "Pre-Screen Assessment (PSA)/1- Question/data/aircrash_civil_partial_clean_data.csv")
write.csv(crash_mil, file = "Pre-Screen Assessment (PSA)/1- Question/data/aircrash_mil_partial_clean_data.csv")

# subset data for air crashes since 2010
# since 2010, there have been 205 civilian air crashes
crash_civ_2k102k20<- subset(crash_civ, crash_year>2009 & crash_civ$survived>-1)
write.csv(crash_civ_2k102k20, file = "Pre-Screen Assessment (PSA)/1- Question/data/aircrash_civil_2k102k20_cleandata.csv")
names(crash_civ_2k102k20)

##### Data Visualizations

data(stop_words)
df %>%
  filter(!is.na(summary)) %>%
  #unnest_tokens(word, summary, token = "sentences") %>%
  unnest_tokens(word, summary, token = "paragraphs") %>%
  # remove the stop words
  anti_join(get_stopwords()) %>%
  ungroup() %>%
  count(word, sort = TRUE)%>%
  filter(n>4) %>%
  mutate(crash_reason = reorder(word,n)) %>%
  ggplot(aes(crash_reason, n))+
  geom_col()+xlab(NULL)+
  coord_flip()+
  labs(x="crash phrase", y="count")+
  ggtitle("Common air crash descriptions")+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))+
  theme_bw()

# word summaries
df %>%
  filter(!is.na(summary)) %>%
  #unnest_tokens(word, summary, token = "sentences") %>%
  unnest_tokens(word, summary) %>%
  # remove the stop words
  anti_join(get_stopwords()) %>%
  ungroup() %>%
  count(word, sort = TRUE)%>%
  filter(n>450) %>%
  mutate(crash_reason = reorder(word,n)) %>%
  ggplot(aes(crash_reason, n))+
  geom_col()+xlab(NULL)+
  coord_flip()+
  labs(x="crash word", y="count")+
  ggtitle("Common air crash word")+
  theme_bw()+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))


# a majority of crash flight operators are us-military, airforce, aeroflot, air france, luftansa
df %>%
  filter(!is.na(operator)) %>%
  unnest_tokens(word, operator, token = "sentences") %>%
  # remove the stop words
  anti_join(get_stopwords()) %>%
  ungroup() %>%
  count(word, sort = TRUE)%>%
  filter(n>25) %>%
  mutate(crash_reason = reorder(word,n)) %>%
  ggplot(aes(crash_reason, n))+
  geom_col()+xlab(NULL)+
  coord_flip()+
  labs(x="crash flight operators", y="count")+
  theme_bw()+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

# is there a relationship between civil air crash year and crash reason?
p<-ggplot(data = crash_civ, aes(x = crash_reason, y=crash_year))
p + geom_boxplot(outlier.colour = "red", na.rm = TRUE, position = "dodge")+
  ggtitle("(a) Civilian air crash reason by year")+
  labs(x="crash reason", y="crash year")+
  theme_bw()+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))+
  coord_cartesian(ylim=c(1908,2019))

# civil air crash reason by month
p<-ggplot(data = crash_civ, aes(x = crash_reason, y=crash_month))
p + geom_boxplot(outlier.colour = "red", na.rm = TRUE, position = "dodge")+
  ggtitle("(b) Civilian air crash reason by month")+
  labs(x="crash reason", y="crash month")+
  theme_bw()+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))+
  coord_cartesian(ylim=c(1,11))

# civil air crash reason by fatalities
p<-ggplot(data = crash_civ, aes(x = crash_reason, y=fatalities))
p + geom_boxplot(outlier.colour = "red", na.rm = TRUE, position = "dodge")+
  ggtitle("(c) Civilian air crash reason by fatalaties")+
  labs(x="crash reason", y="fatalities count")+
  theme_bw()+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

##### PREDICTIVE MODELLING for Air crashes since year 2010 only
df.1<- crash_civ_2k102k20

# check for near zero variance cols and remove them
badCols<- nearZeroVar(df.1)
dim(df.1[,badCols]) # 2 cols with near zero variance property
names(df.1[,badCols])
df.1_rev<- df.1[,-badCols]
# drop the summary col
df.1_rev$summary<- NULL
df.1_rev$V1<- NULL

# Missing data treatment
# check for missing data distribution
sum(is.na(df.1_rev))
pMiss <- function(x){sum(is.na(x))/length(x)*100}
apply(df.1_rev,2,pMiss) 

# replace missing values with zero because sample size is very small
df.1_rev[is.na(df.1_rev)]<- 0
sum(is.na(df.1_rev))
# rearrange the cols such that all numeric are first followed by char
df.1_rev<- data.frame(df.1_rev[,c(1:5,16:17,6:15,18:19)])

# write to disk
write.csv(df.1_rev, file = "Pre-Screen Assessment (PSA)/1- Question/data/crash_civ_2k10_2k20_cmplt_data.csv")

# Check for multicollinearity
cor1<- cor(df.1_rev[,c(1:7)])
corrplot(cor1, number.cex = .7) # # Observation: aboard, fatalities, survived have high correlations

# Correlation Detection & Treatment
# UNSUPERVISED FEATURE SELECTION FOR BOTH CONTINUOUS AND CATEGORICAL VARIABLES
# PCA and MCA for correaltion treatment 
df.1_rev_pca<-PCA(df.1_rev[,c(1:7)], graph = FALSE)
#Scree plot to visualize the PCA's
screeplot<-fviz_screeplot(df.1_rev_pca, addlabels = TRUE,
                          barfill = "gray", barcolor = "black",
                          ylim = c(0, 50), xlab = "Principal Component (PC) for continuous variables", ylab = "Percentage of explained variance",
                          main = "(A) Scree plot: Factors affecting air crash survival ",
                          ggtheme = theme_minimal()
)
# Determine Variable contributions to the principal axes
# Contributions of variables to PC1
pc1<-fviz_contrib(df.1_rev_pca, choice = "var", 
                  axes = 1, top = 10, sort.val = c("desc"),
                  ggtheme= theme_minimal())+
  labs(title="(B) PC-1")

# Contributions of variables to PC2
pc2<-fviz_contrib(df.1_rev_pca, choice = "var", axes = 2, top = 10,
                  sort.val = c("desc"),
                  ggtheme = theme_minimal())+
  labs(title="(C) PC-2")

fig1<- grid.arrange(arrangeGrob(screeplot), 
                    arrangeGrob(pc1,pc2, ncol=1), ncol=2, widths=c(2,1)) 
annotate_figure(fig1
                ,top = text_grob("Principal Component Analysis (PCA)", color = "black", face = "bold", size = 14)
                ,bottom = text_grob("Data source: \n Kaggle and planecrashinfo.com\n", color = "brown",
                                    hjust = 1, x = 1, face = "italic", size = 10)
)
# Add a black border around the 2x2 grid plot
grid.rect(width = 1.00, height = 0.99, 
          gp = gpar(lwd = 2, col = "black", fill=NA))

# clear the graphic device
grid.newpage()

# MULTIPLE CORRESPONDENCE ANALYSIS (MCA) FOR CATEGORICAL DATA
df.1_rev_mca<-MCA(df.1_rev[,c(8:19)], graph = FALSE)
#Scree plot to visualize the PCA's
screeplot<-fviz_screeplot(df.1_rev_mca, addlabels = TRUE,
                          barfill = "gray", barcolor = "black",
                          ylim = c(0, 50), xlab = "Principal Component (PC) for categorical variables", ylab = "Percentage of explained variance",
                          main = "(A) Scree plot: Factors affecting air crash survival ",
                          ggtheme = theme_minimal()
)
# Determine Variable contributions to the principal axes
# Contributions of variables to PC1
pc1<-fviz_contrib(df.1_rev_mca, choice = "var", 
                  axes = 1, top = 10, sort.val = c("desc"),
                  ggtheme= theme_minimal())+
  labs(title="(B) PC-1")

# Contributions of variables to PC2
pc2<-fviz_contrib(df.1_rev_mca, choice = "var", axes = 2, top = 10,
                  sort.val = c("desc"),
                  ggtheme = theme_minimal())+
  labs(title="(C) PC-2")

fig2<- grid.arrange(arrangeGrob(screeplot), 
                    arrangeGrob(pc1,pc2, ncol=1), ncol=2, widths=c(2,1)) 
annotate_figure(fig2
                ,top = text_grob("Multiple Correspondence Analysis (MCA)", color = "black", face = "bold", size = 14)
                ,bottom = text_grob("Data source: \n Kaggle and planecrashinfo.com\n", color = "brown",
                                    hjust = 1, x = 1, face = "italic", size = 10)
)
# Add a black border around the 2x2 grid plot
grid.rect(width = 1.00, height = 0.99, 
          gp = gpar(lwd = 2, col = "black", fill=NA))
# none of the categorical vars are contributors
# clear the graphic device
grid.newpage() 

# extract the important variables from PCA and MCA tests
names(df.1_rev)
df.1_rev_impvars<- data.frame(df.1_rev[,c(1:3,5:7,19)])

# PREDICTIVE MODELLING On UNBALANCED DATA
df.1<- df.1_rev_impvars # create a copy
table(df.1$survived)
df.1$crash_survivor<- ifelse(df.1$survived>0, "alive", "dead")
# drop the survived variable
df.1$survived<- NULL
# convert crash_survivor to factor
df.1$crash_survivor<- as.factor(df.1$crash_survivor)
prop.table(table(df.1$crash_survivor)) # where 0 is dead and 1 is alive

# Run algorithms using 10-fold cross validation
set.seed(2020)
index <- createDataPartition(df.1$crash_survivor, p = 0.7, list = FALSE)
train_data <- df.1[index, ]
test_data  <- df.1[-index, ]
ctrl <- trainControl(method = "repeatedcv"
                     , number = 10, repeats = 10
                     , verboseIter = FALSE
                     , classProbs=TRUE, 
                     summaryFunction=twoClassSummary
)
# Build models
# CART
set.seed(2020)

fit_cart<-caret::train(crash_survivor ~ .,data = train_data,
                       method = "rpart",
                       preProcess = c("scale", "center"),
                       trControl = ctrl 
                       ,metric= "ROC"
)
# kNN
set.seed(2020)

fit_knn<-caret::train(crash_survivor ~ .,data = train_data,
                      method = "knn",
                      preProcess = c("scale", "center"),
                      trControl = ctrl 
                      , metric= "ROC"
)

# Logistic Regression
set.seed(2020)
fit_glm<-caret::train(crash_survivor ~ .,data = train_data
                      , method = "glm", family = "binomial"
                      , preProcess = c("scale", "center")
                      , trControl = ctrl
                      , metric= "ROC"
)
# summarize accuracy of models
models <- resamples(list(cart=fit_cart, knn=fit_knn, glm=fit_glm))
summary(models)
# compare accuracy of models
dotplot(models)
bwplot(models)

# Make Predictions using the best model
predictions <- predict(fit_glm, test_data)
confusionMatrix(predictions, test_data$crash_survivor) # 58% accuracy with kappa at 0.17


# PREDICTIVE MODELLING On BALANCED DATA
# Method 1: Under Sampling
set.seed(2020)
ctrl <- trainControl(method = "repeatedcv"
                     , number = 10, repeats = 10
                     , verboseIter = FALSE
                     , classProbs=TRUE, 
                     summaryFunction=twoClassSummary,
                     sampling = "down"
)

fit_under<-caret::train(crash_survivor ~ .,data = train_data,
                        method = "glm",family = "binomial"
                        ,preProcess = c("scale", "center"),
                        trControl = ctrl,metric= "ROC")

# Method 2: Over Sampling
set.seed(2020)
ctrl <- trainControl(method = "repeatedcv"
                     , number = 10, repeats = 10
                     , verboseIter = FALSE
                     , classProbs=TRUE, 
                     summaryFunction=twoClassSummary,
                     sampling = "up"
)

fit_over<-caret::train(crash_survivor ~ .,data = train_data,
                       method = "glm",family = "binomial"
                       ,preProcess = c("scale", "center"),
                       trControl = ctrl, 
                       metric= "ROC"
)
# Method 3: Hybrid Sampling (ROSE)
set.seed(2020)
ctrl <- trainControl(method = "repeatedcv"
                     , number = 10, repeats = 10
                     , verboseIter = FALSE
                     , classProbs=TRUE
                     , summaryFunction=twoClassSummary
                     , sampling = "rose"
)

fit_rose<-caret::train(crash_survivor ~ .,data = train_data
                       , method = "glm",family = "binomial"
                       , preProcess = c("scale", "center")
                       , trControl = ctrl 
                       , metric= "ROC"
)

# summarize accuracy of models
models <- resamples(list(glm_under=fit_under, glm_over=fit_over, glm_rose=fit_rose))
summary(models)
# compare accuracy of models
dotplot(models)
bwplot(models)

# Make Predictions using the best model
predictions <- predict(fit_under, test_data)
# Using under-balancing as a method for balancing the data
confusionMatrix(predictions, test_data$crash_survivor) # 98% accuracy on balanced under sampled logistic regression model

