---

layout: post
title: Splitting a data frame into training and testing sets in R
date: 2015-04-06 14:37
excerpt: "Learning to split data"
categories: blog
tags: [R, preprocessing]
comments: true
share: true

---
Step 1: <strong>Loading data in R</strong>

a. Import the iris data set from UCI Machine Learning repository as

	> iris= read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"), header = FALSE)
Step 2: <strong>Inspecting the dataset in R</strong>
b. Inspect the first few rows of the dataset use the head() as,

	> head(iris)
	V1 V2 V3 V4 V5
	1 5.1 3.5 1.4 0.2 Iris-setosa
	2 4.9 3.0 1.4 0.2 Iris-setosa
	3 4.7 3.2 1.3 0.2 Iris-setosa
	4 4.6 3.1 1.5 0.2 Iris-setosa
	5 5.0 3.6 1.4 0.2 Iris-setosa
	6 5.4 3.9 1.7 0.4 Iris-setosa
Step 3: <strong>Getting to know your dataset</strong>

a. Inspect the data type and levels of the attributes of the dataset in R use the str() as

	> str(iris)
	'data.frame': 150 obs. of 5 variables:
	$ V1: num 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
	$ V2: num 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
	$ V3: num 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
	$ V4: num 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
	$ V5: Factor w/ 3 levels "Iris-setosa",..: 1 1 1 1 1 1 1 1 1 1 ...
b. To check the distribution of the data values in a particular attribute use the table() as

	# table(dataframe$attribute)
	> table(iris$V5)
	Iris-setosa Iris-versicolor Iris-virginica
	50 50 50 
c. Use the summary() to obtain a detailed overview of your dataset

	> summary(iris)
This will give you the minimum value, first quantile, median, mean, third quantile and maximum value of the data set Iris for numeric data types. For the class variable, the count of factors will be returned:

	V1 V2 V3 V4 V5
	Min. :4.300 Min. :2.000 Min. :1.000 Min. :0.100 Iris-setosa :50
	1st Qu.:5.100 1st Qu.:2.800 1st Qu.:1.600 1st Qu.:0.300 Iris-versicolor:50
	Median :5.800 Median :3.000 Median :4.350 Median :1.300 Iris-virginica :50
	Mean :5.843 Mean :3.054 Mean :3.759 Mean :1.199
	3rd Qu.:6.400 3rd Qu.:3.300 3rd Qu.:5.100 3rd Qu.:1.800
	Max. :7.900 Max. :4.400 Max. :6.900 Max. :2.500
Step 4: <strong>What to do next?</strong>

After you have attained a good understanding of your data, you have to think about what your data set might teach you or what you think you can learn from your data. From there on, you can think about what kind of algorithms you would be able to apply to your data set in order to get the results that you think you
can obtain. For this tutorial, the Iris data set will be used for classification, which is an example of predictive modeling.

Step 5: <strong>Divide the dataset into training and test dataset</strong>

a. To make your training and test sets, you first set a seed. This is a number of R's random number generator.

The major advantage of setting a seed is that you can get the same sequence of random numbers whenever you supply the same seed in the random number generator.
<span style="text-decoration:underline;">Another major advantage is that it helps others to reproduce your results.</span>

	# To set a seed use the function set.seed()
	> set.seed(123)

Then, you want to make sure that your Iris data set is shuffled and that you have the same ratio between species in your training and test sets. You use the sample() function to take a sample with a size that is set as the number of rows of the Iris data set which is 150.
Also you will create a new vector variable in the Iris dataset that will have the TRUE and FALSE values basis on which you will later split the dataset into training and test. You obtain this as following;

sample.split() is part of caTools package so you need to install it first if you have not done so by using install.packages(caTools). Assuming in this case, its already installed so we will now load it as

	> library(caTools)
	> iris$spl=sample.split(iris,SplitRatio=0.7)
	
By using the sample.split() you are actually creating a vector with two values TRUE and FALSE. By setting the SplitRatio to 0.7, you are splitting the original Iris dataset of 150 rows to 70% training and 30% testing data.

	# iris$spl will create a new column in the Iris dataset.</code>

Now, if you view the Iris dataset again you would notice a new column added at the end, you can use View() or head() for this

	> head(iris)
	V1 V2 V3 V4 V5 spl
	1 5.1 3.5 1.4 0.2 Iris-setosa TRUE
	2 4.9 3.0 1.4 0.2 Iris-setosa TRUE
	3 4.7 3.2 1.3 0.2 Iris-setosa TRUE
	4 4.6 3.1 1.5 0.2 Iris-setosa FALSE
	5 5.0 3.6 1.4 0.2 Iris-setosa FALSE
	6 5.4 3.9 1.7 0.4 Iris-setosa TRUE

b. Now, you can split the dataset to training and testing as given

	> train=subset(iris, iris$spl==TRUE)
where <i>spl== TRUE</i> means to add only those rows that have value true for spl in the training dataframe

	> View(train)
you will see that this dataframe has all values where iris$spl==TRUE

Similarly, to create the testing dataset,

	> test=subset(iris, iris$spl==FALSE) 
where <i>spl== FALSE </i> means to add only those rows that have value true for spl in the training dataframe

	> View(test) 
you will see that this dataframe has all values where iris$spl==FALSE

Another easy method to split the dataset into training and test set is as follows;

	> train= iris [1:100,] 
this will put the first 100 rows into the training set</code>

	> test= iris [101:150] 
this will put the remaining 50 rows into the test set

Numerical data in R is examined by using the summary() whereas the categorical data is examined in R using the table().

The table output lists the categories of the nominal variable and a count of the number of values falling into that category.

To calculate the proportion of each nominal variable in R, use the prop.table() as follows

	> propIris=table(iris$V5)
V5 column contains the three types of Iris flower

	> prop.table(propIris)
This will generate proportion in decimals so to change it in 100s, multiply it by 100 as

	>prop.table(propIris)*100
In the next post we will see how to normalize the dataset in R so that data mining is easier to get better results.

P.S. if you want to know how to split the dataset in Weka, you can follow it on the Weka Wiki <a href="https://weka.wikispaces.com/How+do+I+divide+a+dataset+into+training+and+test+set%3F" target="_blank">here</a>

Cheers!
