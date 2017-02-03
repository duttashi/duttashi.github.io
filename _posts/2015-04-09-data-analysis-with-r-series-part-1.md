---

layout: post

title: Data Analysis with R Series- Part 1

date: 2015-04-09 17:29

comments: true

categories: [data analysis]

tags: R

---
In this post we will see the preliminary information that can be derived from the data using R. I have used the <a href="http://apps.who.int/gho/data/node.main.271?lang=en" target="_blank">tobacco consumption</a> (Male and Female) data from the World Health Organization Global Health Observatory Data Repository.

Step 1: Go to the above webpage and click on the download dataset button. Under Quick downloads menu, choose CSV format. Download the csv file into your R working directory

Step 2: Open the dataset in a spreadsheet software like MS Excel and remove the heading “Prevalence of current cigarette smoking”.

Step 3: Use the read.csv function to load the dataset and save it to a data frame called WHO like

	> WHO= read.csv (“C:/My Documents/R project/data.csv”)
Next step is to quickly have a quick peek at the dataset so use the following commands like;

a. To see the first few rows of the data use the head() like; The output should be like

	> head (WHO)
	Country      Year   Male Female
	1 Albania    2008   42.5    4.2
	2 Armenia    2005   60.6    1.7
	3 Armenia    2000   64.7     NA
	4 Azerbaijan 2006   49.7     NA
	5 Bangladesh 2007   60.0     NA
	6 Bangladesh 2004   27.8     NA
b. Now let us look at the structure of the data frame. So use the str () like str (WHO). You will see

	> str (WHO)
	'data.frame':   77 obs. of  4 variables:
	$ Country: Factor w/ 49 levels "Albania","Armenia",..: 1 2 2 3 4 4 5 5 6 7 ...
	$ Year   : int  2008 2005 2000 2006 2007 2004 2006 2001 2008 2003 ...
	$ Male   : num  42.5 60.6 64.7 49.7 60 27.8 NA NA NA NA ...
	$ Female : num  4.2 1.7 NA NA NA NA 0.1 0 8.7 0.1 ...

This tells us that there are 77 observations in 4 variables namely Country, Year, Male and Female. We also see that there are many NA in this data frame. To check how many NA are there in the data frame use the is.na() like

	> sum(is.na(WHO))
	[1] 29 
c. Okay, so we have 29 rows in the WHO data frame that have missing values. Now let’s check which variables have missing values. Since there are four variables so either you can apply the is.na() on each of the four variables like <code> >is.na (WHO$Country) </code> or you can use the summary() like <code> > summary (WHO) </code> and this will specifically tell you which variables have missing values like

	> summary(WHO)
	Country        Year           Male           Female
	Cambodia: 3   Min.   :1999   Min.   : 5.40   Min.   : 0.000
	Jordan  : 3   1st Qu.:2003   1st Qu.:14.72   1st Qu.: 0.400
	Malawi  : 3   Median :2005   Median :20.95   Median : 1.200
	Nepal   : 3   Mean   :2005   Mean   :27.42   Mean   : 3.445
	Rwanda  : 3   3rd Qu.:2008   3rd Qu.:35.02   3rd Qu.: 5.100
	Armenia : 2   Max.   :2011   Max.   :68.60   Max.   :27.700
	(Other) :60                  NA's   :25      NA's   :4
To remove the missing values you can use the na.omit() like

	> WHO=na.omit(WHO)
After you have cleaned the dataset, you can write it back to a csv file format as

	> write.table(dataframeName, filePath, sep=",")
So here we see that variable Male has 25 missing values out of 77 observations and variable Female has 4 missing values.
Also from this summary we can see that we have the data from year 1999 till year 2011. Besides this, we also see that the minimum tobacco consumption amongst Male is 5.40% and the maximum is 69%. Similarly, in females the maximum tobacco consumption is 28%

d. Now, lets check which country has the minimum tobacco consumption amongst Male and Female. This can be achieved by using the which.min () like

	> which.min(WHO$Male)
	[1] 63
Here 63 is the row number. So now to check which country has the minimum tobacco consumption amongst Male you do the following;

	> WHO$Country[63]
	[1] Sao Tome and Principe
Similarly, we can check the same for females like

	> which.min(WHO$Female)
	[1] 8
	> WHO$Country[8]
	[1] Benin
So we see that the country Sao Tome and Principe in Africa has the smallest percentage of Male consuming tobacco products and country Benin in West Africa has the smallest percentage of Female consuming tobacco products.

e. Now, let s check which country has the maximum percentage of tobacco consumption for male and female.  We use the which.max() for this like;

	> which.max(WHO$Male)
	[1] 29
	> WHO$Country[29]
	[1] Indonesia
	> which.max(WHO$Female)
	[1] 68
	> WHO$Country[68]
	[1] Turkey

So we now know that country Indonesia has the maximum number of Male’s consuming tobacco products and country Turkey has the maximum number of Female’s consuming tobacco products.

Thus we see that with a few basic commands taming the data gets so easy. However, what is required is a careful study of the data at hand based on which you derive interesting questions and then seek to answer them using the data.

In the next post we shall look at some more interesting functions in R that can help us derive meaning out of the data. Till then stay tuned.