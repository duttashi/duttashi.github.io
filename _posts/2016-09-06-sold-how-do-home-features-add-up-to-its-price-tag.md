---

layout: post

title: Sold! How do home features add up to its price tag?

date: 2016-09-06 13:20

comments: true

categories: [Competition, exploratory statistics, pre-processing, R]

---
<span style="color:#000000;">I begin with a new project. It is from the</span> <a href="https://www.kaggle.com/c/house-prices-advanced-regression-techniques" target="_blank">Kaggle</a> <span style="color:#000000;">playground wherein the objective is to build a regression model <em>(as the response variable or the outcome or dependent variable is continuous in nature) </em>from a given set of predictors or independent variables. </span>

<span style="color:#000000;">My motivation to work on this project are the following;</span>
<ul>
	<li><span style="color:#000000;">Help me to learn and improve upon <em>feature engineering</em> and advanced regression algorithms like <em>random forests, gradient boosting with xgboost</em></span></li>
	<li><span style="color:#000000;">Help me in articulating compelling data powered stories </span></li>
	<li><span style="color:#000000;">Help me understand and build a complete end to end data powered solution</span></li>
</ul>
<h4><strong>The Dataset</strong></h4>
<span style="color:#000000;">From the Kaggle page,</span> "<em>The <a class="pdf-link" href="http://www.amstat.org/publications/jse/v19n3/decock.pdf" target="_blank">Ames Housing dataset</a> <span style="color:#000000;">was compiled by Dean De Cock for use in data science education. It's an incredible alternative for data scientists looking for a modernized and expanded version of the often cited Boston Housing dataset."</span></em>
<h4><strong>The Data Dictionary</strong></h4>
<span style="color:#000000;">The data dictionary can be accessed from</span> <a href="http://www.amstat.org/publications/jse/v19n3/decock/DataDocumentation.txt" target="_blank">here</a>.
<h4><strong>Objective</strong></h4>
<span style="color:#000000;">With 79 explanatory variables describing (almost) every aspect of residential homes in Ames, Iowa, this competition challenges you to predict the final price of each home.</span>
<h4 class="page-name"><strong>Model Evaluation</strong></h4>
<span style="color:#000000;">Submissions are evaluated on</span> <a href="https://en.wikipedia.org/wiki/Root-mean-square_deviation" target="_blank">Root-Mean-Squared-Error (RMSE)</a> <span style="color:#000000;">between the logarithm of the predicted value and the logarithm of the observed sales price. (Taking logs means that errors in predicting expensive houses and cheap houses will affect the result equally.)  In simple terms this means that the lower the RMSE value, greater is the accuracy of your prediction model.</span>
<h4><strong>About the dataset</strong></h4>
<span style="color:#000000;">The dataset is split into training and testing files where the training dataset has <em>81</em> variables in <em>1460</em> rows and the testing dataser has <em>80</em> variables in <em>1459</em> rows. These variables focus on the quantity and quality of many physical attributes of the real estate property. <em> </em></span>

<span style="color:#000000;">There are a large number of categorical variables (23 nominal, 23 ordinal) associated with this data set. They range from 2 to 28 classes with the smallest being STREET (gravel or paved) and the largest being NEIGHBORHOOD (areas within the Ames city limits). The nominal variables typically identify various types of dwellings, garages, materials, and environmental conditions while the ordinal variables typically rate various items within the property.</span>

<span style="color:#000000;">The 14 discrete variables typically quantify the number of items occurring within the house. Most are specifically focused on the number of kitchens, bedrooms, and bathrooms (full and half) located in the basement and above grade (ground) living areas of the home.</span>

<span style="color:#000000;">In general the 20 continuous variables relate to various area dimensions for each observation. In addition to the typical lot size and total dwelling square footage found on most common home listings, other more specific variables are quantified in the data set.</span>

<span style="color:#000000;">"<em>A strong analysis should include the interpretation of the various coefficients, statistics, and plots associated with their model and the verification of any necessary assumptions."</em></span>

<span style="color:#000000;"><em><strong>An interesting feature of the dataset</strong></em> is that <span style="text-decoration:underline;">several  of the predictors are labelled as NA when actually they are not missing values and correspond to actual data points</span>. This can be verified from the data dictionary where variable like Alley, Pool etc have NA value that correspond to <em>No Alley Access</em> and <em>No Pool </em>respectively.<em> </em>This <a href="http://stackoverflow.com/questions/19379081/how-to-replace-na-values-in-a-table-for-selected-columns-data-frame-data-tab" target="_blank">SO question</a> that was answered by the user 'flodel' solves this problem of recoding specific columns of a dataset. </span>

<span style="color:#000000;">A total of <i>357</i> missing values are present in training predictors (<em>LotFrontage-259, MasVnrType-8, MasVnrArea-8, Electrical-1, GarageYrBlt-81</em>) and <i>358</i> missing values in testing dataset predictors (<em>MSZoning-4,</em> <em>LotFrontage-227,  Exterior1st-1, Exterior2nd-1, MasVnrType-16, MasVnArea-15, BsmtFinSF1-1, BsmtFinType2-1, BsmtFinSF2-1, BsmtUnfSF-1, TotalBsmtSF-1, BsmtFullBath-2, BsmtHalfBath-2, KitchenQual-1, Functional-2, GarageYrBlt-78, SaleType-1</em>).</span>
<h4><strong>Data Preprocessing</strong></h4>
<span style="color:#000000;">Some basic problems that need to be solved first namely, <em>data dimensionality reduction, missing value treatment, correlation, dummy coding. </em>A common question that most ask is that how to determine the relevant predictors in a high dimensional dataset as this. The approach that I will use for dimensionality reduction will be two fold, first I will check for zero variance predictors. </span>
<h4>(a) <em>Check for Near Zero Variance Predictors</em></h4>
<span style="color:#000000;">A predictor with zero variability does not contribute anything to the prediction model and can be removed. </span>

<span style="color:#000000;"><em><span style="text-decoration:underline;">Computing</span>: </em>This can easily be accomplished by using the <em>nearZeroVar() </em>method from the <em>caret package. </em>In training dataset, there are 21 near zero variance variables namely (</span><span style="color:#000000;"><em>'Street' 'LandContour' 'Utilities' 'LandSlope' 'Condition2' 'RoofMatl' 'BsmtCond' 'BsmtFinType2' 'BsmtFinSF2' 'Heating' 'LowQualFinSF' 'KitchenAbvGr' 'Functional' 'GarageQual' 'GarageCond' 'EnclosedPorch' 'X3SsnPorch' 'ScreenPorch' 'PoolArea' 'MiscFeature' 'MiscVal'</em>) <em>and in the testing dataset there are 19 near zero variance predictors namely ('Street' 'Utilities' 'LandSlope' 'Condition2' 'RoofMatl' 'BsmtCond' 'BsmtFinType2' 'Heating' 'LowQualFinSF' 'KitchenAbvGr' 'Functional' 'GarageCond' 'EnclosedPorch' 'X3SsnPorch' 'ScreenPorch' 'PoolArea' 'MiscVal'). </em>Post removal of these predictors from both the training and testing dataset, the data dimension is reduced to <em>60 predictors for train data </em>and <em>61 predictors </em>each. </span>

<strong>(b) <em>Missing data treatment</em></strong>

<span style="color:#000000;">There are two types of missing data;</span>

<span style="color:#000000;">(i) MCAR (Missing Completetly At Random) &amp; (ii) MNAR (Missing Not At Random)</span>

<span style="color:#000000;">Usually, MCAR is the desirable scenario in case of missing data. For this analysis I will assume that MCAR is at play. Assuming data is MCAR, too much missing data can be a problem too. Usually a safe maximum threshold is 5% of the total for large datasets. If missing data for a certain feature or sample is more than 5% then you probably should leave that feature or sample out. We therefore check for features (columns) and samples (rows) where more than 5% of the data is missing using a simple function. Some good references are</span> <a href="http://stackoverflow.com/questions/4862178/remove-rows-with-nas-missing-values-in-data-frame" target="_blank">1</a> <span style="color:#000000;">and</span> <a href="http://stackoverflow.com/questions/4605206/drop-data-frame-columns-by-name" target="_blank">2</a>.

<span style="color:#000000;"><span style="text-decoration:underline;"><em>Computing</em></span>: I have used the <em>VIM package </em>in R for missing data visualization. I set the threshold at 0.80, any predictors equal to or above this threshold need no imputation and should be removed. Post removal of the near zero variance predictors, I next check for high missing values and I find that there are no predictors with high missing values in either the train or test data. </span>

<span style="color:#000080;">Important Note:</span> <span style="color:#000000;">As per this <a href="https://www.r-bloggers.com/imputing-missing-data-with-r-mice-package/" target="_blank">r-blogger's post</a>, it is not advisable to use mean imputation for continuous predictors because it can affect the variance in the data. Also, one should avoid using the mode imputation for categorical variables so I use the <em>mice library</em> for missing valueimputation for the continuous variables. </span>

<em><strong>(c) Correlation treatment</strong></em>

<span style="color:#000000;"><span class="Apple-style-span">Correlation refers to a technique used to measure the relationship between two or more variables.</span><span class="Apple-style-span">When two objects are correlated, it means that they vary together.</span><span class="Apple-style-span">Positive correlation means that high scores on one are associated with high scores on the other, and that low scores on one are associated with low scores on the other. Negative correlation, on the other hand, means that high scores on the first thing are associated with low scores on the second. Negative correlation also means that low scores on the first are associated with high scores on the second.</span></span>
<p style="font-weight:300;"><span style="color:#000000;">Pearson <em>r</em> is a statistic that is commonly used to calculate bivariate correlations. Or better said, its checks for linear relations. </span></p>
<p style="font-weight:300;"><span style="color:#000000;">For an Example Pearson <em>r</em> = -0.80, <em>p</em> &lt; .01. What does this mean?</span></p>
<p style="font-weight:300;"><span style="color:#000000;">To interpret correlations, four pieces of information are necessary.</span>
<span style="color:#000000;"><b><strong>1.   <em>The numerical value of the correlation coefficient.</em></strong></b>Correlation coefficients can vary numerically between 0.0 and 1.0. The closer the correlation is to 1.0, the stronger the relationship between the two variables. A correlation of 0.0 indicates the absence of a relationship. If the correlation coefficient is –0.80, which indicates the presence of a strong relationship.</span></p>
<p style="font-weight:300;"><span style="color:#000000;"><b style="line-height:1.7;"><strong><em>2. The sign of the correlation coefficient</em>.</strong></b>A positive correlation coefficient means that as variable 1 increases, variable 2 increases, and conversely, as variable 1 decreases, variable 2 decreases. In other words, the variables move in the same direction when there is a positive correlation. A negative correlation means that as variable 1 increases, variable 2 decreases and vice versa. In other words, the variables move in opposite directions when there is a negative correlation. The negative sign indicates that as class size increases, mean reading scores decrease.</span></p>
<p style="font-weight:300;"><span style="color:#000000;"><b style="line-height:1.7;"><strong><em>3. The statistical significance of the correlation. </em></strong></b><span style="line-height:1.7;">A statistically significant correlation is indicated by a probability value of less than 0.05. This means that the probability of obtaining such a correlation coefficient by chance is less than five times out of 100, so the result indicates the presence of a relationship.</span></span></p>
<span style="color:#000000;">In any data anlysis activity, the analyst should always check for highly correlated variables and remove them from the dataset because correlated predictors do not quantify </span>

<span style="color:#000000;"><strong>4.   <i>The effect size of the correlation.</i></strong>For correlations, the effect size is called the coefficient of determination and is defined as <i>r</i><sup>2</sup>. The coefficient of determination can vary from 0 to 1.00 and indicates that the proportion of variation in the scores can be predicted from the relationship between the two variables.</span>

<span style="color:#000000;">A correlation can only indicate the presence or absence of a relationship, not the nature of the relationship. <i><strong>Correlation is not causation</strong>.</i></span>

<span style="color:#000000;">How Problematic is Multicollinearity?</span>

<span style="color:#000000;">Moderate multicollinearity may not be problematic. However, severe multicollinearity is a problem because it can increase the variance of the coefficient estimates and make the estimates very sensitive to minor changes in the model. The result is that the coefficient estimates are unstable and difficult to interpret. Multicollinearity saps the statistical power of the analysis, can cause the coefficients to switch signs, and makes it more difficult to specify the correct model. According to Tabachnick &amp; Fidell (1996) the independent variables with a bivariate correlation more than .70 should not be included in multiple regression analysis.</span>

<span style="text-decoration:underline;color:#000000;"><em><strong>Computing</strong></em></span>

<span style="color:#000000;">To detect highly correlated predictors in the data, I used the <em>findCorrelation()</em> method of the caret library and I find that there are four predictors in the training dataset with more than 80% correlation and these are "YearRemodAdd","OverallCond","BsmtQual","Foundation" which I then remove from the train data thereby reducing the data dimension to 56. I follow the similar activity for the test data and I find that there are two predictors with more than 80% correlation and these are "Foundation" "LotShape" which I then remove from the test data.
The final data dimensions are 1460 rows in 56 columns in train data and 1460 rows in 59 columns in the test data.
</span>

<span style="color:#000000;">The R code used in this post can be can be accessed on my <a style="color:#000000;" href="https://github.com/duttashi/House-Price-Prediction/blob/master/scripts/data_preproc.R" target="_blank">github</a> account and my Kaggle notebook can be viewed <a href="https://www.kaggle.com/ashishdutt/house-prices-advanced-regression-techniques/ahoy-all-relevant-guests-on-board-let-s-sail" target="_blank">here</a>. </span>

<span style="color:#000000;">In the next post, I will discuss on the issue of outlier detection, skewness resolution and data visualization.</span>

&nbsp;

&nbsp;

&nbsp;

&nbsp;
