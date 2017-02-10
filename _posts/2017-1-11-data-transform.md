---
layout: post
title: Data Transformations in R
date: 2017-1-11
excerpt: "Types of data transformations"
categories: blog
tags: [R, preprocessing]
comments: true
share: true

---

A number of reasons can be attributed to when a predictive model crumples such as:

* Inadequate data pre-processing

* Inadequate model validation

* Unjustified extrapolation

* Over-fitting

(Kuhn, 2013)

Before we dive into data preprocessing, let me quickly define a few terms that I will be commonly using.

*Predictor/Independent/Attributes/Descriptors* – are the different terms that are used as input for the prediction equation.

*Response/Dependent/Target/Class/Outcome* – are the different terms that are referred to the outcome event that is to be predicted.

In this article, I am going to summarize some common data pre-processing approaches with examples in R

a. **Centering and Scaling**

Variable centering is perhaps the most intuitive approach used in predictive modeling. To center a predictor variable, the average predictor value is subtracted from all the values. as a result of centering, the predictor has zero mean.
To scale the data, each predictor value is divided by its standard deviation (sd). This helps in coercing the predictor value to have a `sd` of one. Needless to mention, centering and scaling will work for continuous data. The drawback of this activity is loss of interpretability of the individual values.
An R example:

	# Load the default datasets
	> library(datasets)
	> data(mtcars)
	> dim(mtcars)
	32 11
	
	> str(mtcars)
	'data.frame':   32 obs. of  11 variables:
	$ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
	$ cyl : num  6 6 4 6 8 6 8 4 4 6 ...
	$ disp: num  160 160 108 258 360 ...
	$ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
	$ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
	$ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
	$ qsec: num  16.5 17 18.6 19.4 17 ...
	$ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
	$ am  : num  1 1 1 0 0 0 0 0 0 0 ...
	$ gear: num  4 4 4 3 3 3 3 4 4 4 ...
	$ carb: num  4 4 1 1 2 1 4 2 2 4 ...
	
	> cov(mtcars$disp, mtcars$cyl) # check for covariance
	[1] 199.6603
	> mtcars$disp.scl<-scale(mtcars$disp, center = TRUE, scale = TRUE)  
	> mtcars$cyl.scl<- scale(mtcars$cyl, center = TRUE, scale = TRUE)  
	> cov(mtcars$disp.scl, mtcars$cyl.scl) # check for covariance in scaled data
	          [,1]
	[1,] 0.9020329

b. **Resolving Skewness**

Skewness is a measure of shape. A common appraoch to check for skewness is to plot the predictor variable. As a rule, negative skewness indicates that the mean of the data values is less than the median, and the data distribution is left-skewed. Positive skewness would indicates that the mean of the data values is larger than the median, and the data distribution is right-skewed.

* If the skewness of the predictor variable is 0, the data is perfectly symmetrical,
* If the skewness of the predictor variable is less than -1 or greater than +1, the data is highly skewed,
* If the skewness of the predictor variable is between -1 and -1/2 or between +1 and +1/2 then the data is moderately skewed,
* If the skewness of the predictor variable is -1/2 and +1/2, the data is approximately symmetric.

I will use the function `skewness` from the `e1071 package` to compute the skewness coefficient

An R example:

	> library(e1071)
	> engine.displ<-skewness(mtcars$disp) > engine.displ
	[1] 0.381657

So the variable displ is moderately positively skewed.

c. **Resolving Outliers**

The outliers package provides a number of useful functions to systematically extract outliers. Some of these are convenient and come handy, especially the `outlier()` and `scores()` functions.

*Outliers*

The function `outliers()` gets the extreme most observation from the mean.
If you set the argument `opposite=TRUE`, it fetches from the other side.

An R example:

	> set.seed(4680) # for code reproducibility
	> y<- rnorm(100) # create some dummy data > library(outliers) # load the library
	> outlier(y)
	[1] 3.581686
	> dim(y)<-c(20,5) # convert it to a matrix > head(y,2)# Look at the first 2 rows of the data
         [,1]       [,2]      [,3]      [,4]       [,5]
	[1,] 0.5850232  1.7782596  2.051887  1.061939 -0.4421871
	[2,] 0.5075315 -0.4786253 -1.885140 -0.582283  0.8159582
	> outlier(y) # Now, check for outliers in the matrix
	[1] -1.902847 -2.373839  3.581686  1.583868  1.877199
	> outlier(y, opposite = TRUE)
	[1]  1.229140  2.213041 -1.885140 -1.998539 -1.571196

There are two aspects the the `scores()` function.
Compute the normalised scores based on `z`, `t`, `chisq` etc.

Find out observations that lie beyond a given percentile based on a given score.

	> set.seed(4680)
	> x = rnorm(10)
	> scores(x)  # z-scores => (x-mean)/sd
	[1]  0.9510577  0.8691908  0.6148924 -0.4336304 -1.6772781...
	> scores(x, type="chisq")  # chi-sq scores => (x - mean(x))^2/var(x)
	[1] 0.90451084 0.75549262 0.37809269 0.18803531 2.81326197 . . .
	> scores(x, type="t")  # t scores
	[1]  0.9454321  0.8562050  0.5923010 -0.4131696 -1.9073009
	> scores(x, type="chisq", prob=0.9)  # beyond 90th %ile based on chi-sq
	[1] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE
	> scores(x, type="chisq", prob=0.95)  # beyond 95th %ile
	[1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
	> scores(x, type="z", prob=0.95)  # beyond 95th %ile based on z-scores
	[1] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE
	> scores(x, type="t", prob=0.95)  # beyond 95th %ile based on t-scores
	[1] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE

d. **Outlier Treatment**

Once the outliers are identified, you may rectify it by using one of the following approaches.

* Imputation

Imputation with mean / median / mode.

* Capping

For missing values that lie outside the `1.5 * IQR limits`, we could cap it by replacing those observations outside the lower limit with the value of `5th%ile` and those that lie above the upper limit, with the value of `95th%ile`. For example, it can be done like this as shown;

	> par(mfrow=c(1, 2)) # for side by side plotting
	> x <- mtcars$mpg > plot(x)
	> qnt <- quantile(x, probs=c(.25, .75), na.rm = T) 
	> caps <- quantile(x, probs=c(.05, .95), na.rm = T) 
	> H <- 1.5 * IQR(x, na.rm = T) 
	> x[x < (qnt[1] - H)] <- caps[1] 
	> x[x > (qnt[2] + H)] <- caps[2] 
	> plot(x)

e. Missing value treatment

* Impute Missing values with median or mode
* Impute Missing values based on K-nearest neighbors

Use the library `DMwR` or `mice` or `rpart`. If using `DMwR`, for every observation to be imputed, it identifies ‘k’ closest observations based on the euclidean distance and computes the weighted average (weighted based on distance) of these ‘k’ obs. The advantage is that you could impute all the missing values in all variables with one call to the function. It takes the whole data frame as the argument and you don’t even have to specify which variabe you want to impute. But be cautious not to include the response variable while imputing.

There are many other types of transformations like treating colinearity, dummy variable encoding, covariance treatment which I will cover in another post.

**Reference**

Kuhn, M., Johnson, K. (2013). Applied predictive modeling (pp. 389-400). New York: Springer.
