---

layout: post

title: How to solve the missing data problem?

date: 2015-05-04 18:47

comments: true

categories: [missing data treatment, preprocessing]

tags: R

---
There are several solution to it.
1. Delete the missing observations- but then you could end up throwing away more than half of your data (depending upon the frequency distribution of missing data)
2. Delete the missing variable -- this approach is okay if that variable is not required for analysis but is non-feasible if that variable is required
3. Impute the missing values in the variable by the taking the average of the other value's in that variable

The above three approaches are termed as "Simple approaches for handling missing data"

Besides the aforementioned you can also use the "Multiple Imputation" method in which you fill the missing values in the variable with the non-missing values. This method is easy to implement using R packages a common one is mice (Multiple Imputations By Chained Equations).

Let us now see an example using R on how to do this.

Download the <a href="https://archive.ics.uci.edu/ml/machine-learning-databases/horse-colic/horse-colic.data" target="_blank">horse colic data set</a> from the UCI Machine Learning repository.

You can look at the data description <a href="https://archive.ics.uci.edu/ml/machine-learning-databases/horse-colic/horse-colic.names" target="_blank">here</a>

The data has 30% missing values.

Now install the mice package in R (if you dont have it installed) as
	
	> install.packages("mice")
and then load it as 

	> library("mice") 
You might notice that the missing data is coded as ? symbol while R understands NA for missing data so how to change the ? to NA in R and load the dataset in a data frame you can do like this.

	> horseData<- summary(horseData)
you will see several variables like 

	> easy= horseData[c("V1","V4","V5","V6")] 
etc have varied levels of missing values in them.

Now assume you want the variables V1, V4, V5 and V6 only for data analysis so you can limit your data frame to these four as 

	> easy= horseData[c("V1","V4","V5","V6")] 
Once again you can take a look at the summary statistics of this data frame as 

	>summary(easy)
	V1 V4 V5 V6
	Min. :1.000 Min. :35.40 Min. : 30.00 Min. : 8.00
	1st Qu.:1.000 1st Qu.:37.80 1st Qu.: 48.00 1st Qu.:18.50
	Median :1.000 Median :38.20 Median : 64.00 Median :24.50
	Mean :1.398 Mean :38.17 Mean : 71.91 Mean :30.42
	3rd Qu.:2.000 3rd Qu.:38.50 3rd Qu.: 88.00 3rd Qu.:36.00
	Max. :2.000 Max. :40.80 Max. :184.00 Max. :96.00
	NA's :1 NA's :60 NA's :24 NA's :58
All that has changed is that we now have a smaller number of variables. Please note that I reduced the number of variables only for explanation purpose
Again, please note that multiple imputation if executed several times will give different results so if you want others to get the same result as yours then you should define the seed function as

	> set.seed(26)
This number is an arbitrary number.
Now the final step to fill in the missing values. Its just one line of code where in you use the complete function on mice which is called on data frame easy.

	>imputedData= complete(mice(easy))
As the results will show that 5 rounds of imputation had been run and now if you look at the data frame all the missing values have been filled

	>summary(imputedData)
	V1 V4 V5 V6
	Min. :1.000 Min. :35.40 Min. : 30.00 Min. : 8.00
	1st Qu.:1.000 1st Qu.:37.80 1st Qu.: 48.00 1st Qu.:20.00
	Median :1.000 Median :38.20 Median : 64.00 Median :28.00
	Mean :1.397 Mean :38.17 Mean : 72.08 Mean :30.69
	3rd Qu.:2.000 3rd Qu.:38.50 3rd Qu.: 88.00 3rd Qu.:36.00
	Max. :2.000 Max. :40.80 Max. :184.00 Max. :96.00 

Cheers!