---
layout: post
title: Big or small-let’s save them all: Making Data Management Decisions
date: 2016-01-15 
excerpt: "Making data powered decisions for the gapminder dataset"
categories: blog
tags: [python, data analysis]
comments: true
published: true
share: true

---
So far I have discussed the data-set, the research question, introduced the variables to analyze and performed some exploratory data analysis in which I showed how to get a brief overview of the data using python. Continuing further, I have now reached a stage wherein I must ‘dive into’ the data-set and make some strategic data management decisions. This stage cannot be taken lightly because it lays the foundation of the entire project. A misjudgment here can spell doom to the entire data analysis cycle. 

The first step is to see, if the data is complete or not? By completeness, I mean to check the rows and the columns of the data-set for any missing values or junk values. (<em>Do note, here I have asked two questions. In this post I will answer the first question only. In another post i will answer the second question</em>); a) How to deal with missing values and b) How to deal with junk values.

To answer the first question, I use the following code to get the sum of missing values by rows thereafter I use the is.null().sum() as given to display the column count of the missing values.

	# Create a copy of the original dataset as sub4
	sub4=data

	print "Missing data rows count: &amp;quot;,sum([True for idx,row in data.iterrows() if any(row.isnull())])
I would see that there are 48 rows of missing data as shown

	Missing data rows count: 48
Now how about I want to see the columns that have missing data. For that I use the isnull().sum() function as given

	print sub4.isnull().sum()
This line of code will give me the column-vise missing data count as shown

	country 0
	breastcancerper100th 40
	femaleemployrate 35
	alcconsumption 26
	dtype: int64

So now, how to deal with this missing data? There are some excellent papers written that have addressed this issue. For interested reader, I refer to two such examples <a href="http://www.unt.edu/rss/class/mike/6810/articles/roth.pdf">here</a> and <a href="http://myweb.brooklyn.liu.edu/cortiz/PDF%20Files/Best%20practices%20for%20missing%20data%20management.pdf">here</a>.
<span style="text-decoration:underline;"><strong>Dealing with Missing Values</strong></span>
So what do I do with a data set that has 3 continuous variables which off-course as always is dirty (<em><strong>brief melodrama now: </strong>hands high in air and I shout "Don't you have any mercy on me! When will you give me that perfect data set. God laughs and tells his accountant pointing at 'me'.."look at that earthly fool..while all fellows at his age ask for wine, women and fun he wants me to give him "clean data" which even I don't have"</em>). So how do I mop it clean? Do i remove the missing values? "Nah" that would be apocalyptic in data science ..hmmm..so what do I do? How about I code all the missing values as Zero. <strong>NO! Not to underestimate the Zero. </strong>So what do I do?

One solution is to impute the missing continuous variables with the mean of the neighboring values in the variable. Note: to impute the missing categorical values, one can try imputing the mode (highest occurring frequency value). Yeah..that should do the trick. So I code it as given;

	sub4.fillna(sub4['breastcancerper100th'].mean(), inplace=True)
	sub4.fillna(sub4['femaleemployrate'].mean(), inplace=True)
	sub4.fillna(sub4['alcconsumption'].mean(), inplace=True)

So here, I have used the fillna() method of pandas library. You can see here the <a href="http://pandas.pydata.org/pandas-docs/stable/missing_data.html">documentation</a> . Now I show the output before missing value imputation as

	Missing data rows count: 48
	country 0
	breastcancerper100th 40
	femaleemployrate 35
	alcconsumption 26
	dtype: int64 

and the output after the missing values were imputed using the fillna() function as

	country 0 breastcancerper100th 0 femaleemployrate 0 alcconsumption 0 dtype: int64

Continuing further, I now categorize the quantitative variables based on customized splits using the cut function and why I am doing this because it will help me later to view a nice elegant frequency distribution.

	# categorize quantitative variable based on customized splits using the cut function
	sub4['alco']=pd.qcut(sub4.alcconsumption,6,labels=["0","1-4","5-9","10-14","15-19","20-24"])
	sub4['brst']=pd.qcut(sub4.breastcancerper100th,5,labels=["1-20","21-40","41-60","61-80","81-90"])
	sub4['emply']=pd.qcut(sub4.femaleemployrate,4,labels=["30-39","40-59","60-79","80-90"])

<span style="font-family:Consolas, Monaco, monospace;line-height:1.7;"><span style="font-family:Consolas, Monaco, monospace;line-height:1.7;">Now, that I that I have split the continuous variables, I will now show there frequency distributions so as to understand my data better.


	fd1=sub4['alco'].value_counts(sort=False,dropna=False)
	fd2=sub4['brst'].value_counts(sort=False,dropna=False)
	fd3=sub4['emply'].value_counts(sort=False,dropna=False)

<span style="font-family:Consolas, Monaco, monospace;line-height:1.7;"><span style="font-family:Consolas, Monaco, monospace;line-height:1.7;">I will now print the frequency distribution for alcohol consumption as given

	Alcohol Consumption
	0 36
	1-4 35
	5-9 36
	10-14 35
	15-19 35
	20-24 36
	dtype: int64

<span style="font-family:Consolas, Monaco, monospace;line-height:1.7;"><span style="font-family:Consolas, Monaco, monospace;line-height:1.7;">then, the frequency distribution for breast cancer per 100th women as 

	Breast Cancer per 100th
	1-20 43
	21-40 43
	41-60 65
	61-80 19
	81-90 43
	dtype: int64 

<span style="font-family:Consolas, Monaco, monospace;line-height:1.7;"><span style="font-family:Consolas, Monaco, monospace;line-height:1.7;"><span style="font-family:Consolas, Monaco, monospace;line-height:1.7;">and finally the female employee rate as </span>

	Female Employee Rate
	30-39 73
	40-59 34
	60-79 53
	80-90 53
	dtype: int64 
<span style="font-family:Consolas, Monaco, monospace;line-height:1.7;"><span style="font-family:Consolas, Monaco, monospace;line-height:1.7;"><span style="font-family:Consolas, Monaco, monospace;line-height:1.7;">Now, this looks better. So if I have to summarize it the frequency distribution for alcohol consumption per liters among adults (age 15+). I will say that there are 36 women who drink no alcohol at all (and still they are breast cancer victims...hmmm ..nice find..will explore it further later). The count of women who drink between 5-9 liters and 20-24 liters of pure alcohol is similar! Then there are about 73% of women who have been employed in a certain year and roughly about 43 new breast cancer cases are reported per 100th female residents. </span>

Stay tuned, next time I will provide a visual interpretation of these findings and more.

Cheers!