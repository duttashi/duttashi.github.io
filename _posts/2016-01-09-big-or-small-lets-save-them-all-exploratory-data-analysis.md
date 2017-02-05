---
layout: post
title: Big or small-let's save them all: Exploratory Data Analysis
date: 2016-01-09 18:03
excerpt: "Exploratory data analysis of the gapminder dataset"
categories: blog
tags: [python, data analysis]
comments: true
published: true
share: true

---
In my previous post, I had discussed at length on the research question, the dataset, the variables and the various research hypothesis.
For the sake of brevity, I will restate the research question and the variables of study.

Research question: Can alcohol consumption increase the risk of breast cancer in working class women.
Variables to explore are:
<ol>
	<li>‘alcconsumption’- average alcohol consumption, adult (15+) per capita consumption in litres pure alcohol</li>
	<li>‘breastcancerper100TH’- Number of new cases of breast cancer in 100,000 female residents during the certain year</li>
	<li>‘femaleemployrate’- Percentage of female population, age above 15, that has been employed during the given year</li>
</ol>
In this post, I present to the readers an exploratory data analysis of the gapminder dataset.

Although, for this course we are provided with the relevant dataset, however if you are not taking this course and are interested in the source of the data, then you can get it from <a href="http://www.gapminder.org/data/">here</a>. In the List of indicators search box type “breast cancer, new cases per 100,000 women” to download the dataset.

I will be using python for Exploratory Data Analysis (EDA). I begin by importing the libraries pandas and numpy as

	# Importing the libraries
	import pandas as pd
	import numpy as np

I have already downloaded the dataset which is .csv (comma seperated value format) and will now load/read it in a variable called datausing pandas library as given

	# Reading the data where low_memory=False increases the program efficiency
	data = pd.read_csv('data/train.csv', low_memory=False)

To get a quick look at the number of rows and columns and the coulmn headers, you can do the following;

	print (len(data)) # shows the number of rows, here 213 rows
	print (len(data.columns))# shows the number of cols, here 4 columns# Print the column headers/headings
	names=data.columns.values
	print names

You will see the output as

	213
	4
	213
	['country' 'breastcancerper100th' 'femaleemployrate' 'alcconsumption']

Now, to see the frequency distribution of these four variables I use the <strong>value_counts() </strong>function to generate the frequency counts of the breast cancer dependence variables. Note, if you want to see the data with the missing values then choose the flag <strong>dropna=False</strong> as shown. For this dataset, majority of variable values have a frequency of 1.

	print "\nAlcohol Consumption\nFrequency Distribution (in %)"
	c1=data['alcconsumption'].value_counts(sort=False,dropna=False)
	print c1
	print "\nBreast Cancer per 100th"
	c2=data['breastcancerper100th'].value_counts(sort=False)
	print c2
	print "\nFemale Employee Rate"
	c3=data['femaleemployrate'].value_counts(sort=False)
	print c3 

The output will be `Alcohol Consumption 5.25 1 9.75 1 0.50 1 9.50 1 9.60 1`

In the above output, values 5.25,9.75,0.50,5.05 are the alcohol consumption in litres and the value 0.004695 is the percentage count of the value. The flag sort=False means that values will not be sorted according to their frequencies. Similarly, I show the frequency distribution for the other two variables

	Breast Cancer per 100th
	23.5 2
	70.5 1
	31.5 1
	62.5 1
	19.5 6

and

	Female Employee Rate
	45.900002 2
	55.500000 1
	35.500000 1
	40.500000 1
	45.500000 1

I now subset the data to explore my research question in a bid to see if it requires any improvement or not. I want to see which countries are prone to greater risk of breast cancer among female employee where the average alcohol intake is 10L;

	# Creating a subset of the data
	sub1=data[(data['femaleemployrate']>40) & (data['alcconsumption']>=20)& (data['breastcancerper100th']<50)]
	# creating a copy of the subset. This copy will be used for subsequent analysis
	sub2=sub1.copy()

and the result is;

	country breastcancerper100th femaleemployrate alcconsumption
	9      Australia 83.2 54.599998 10.21
	32     Canada 84.3 58.900002 10.20
	50     Denmark 88.7 58.099998 12.02
	63     Finland 84.7 53.400002 13.10
	90     Ireland 74.9 51.000000 14.92
	185    Switzerland 81.7 57.000000 11.41
	202    United Kingdom 87.2 53.099998 13.24

Interestingly, countries with stable economies like Australia, Canada, Denmark, Finland, Ireland, Switzerland &amp; UK top the list of high breast cancer risk among working women class. These countries are liberal to women rights. Now, this can be an interesting question that will be explored later.

How about countries with very low female employee rates- how much is there contribution to alcohol consumption and breast cancer risk? <em>(I set the threshold for high employee rate as greater than 40% and threshold for high alcohol consumption to be greater than 20 liters and breast cancer risk at less than 50%). And the winner is,</em> <strong>Moldova </strong>a landlocked country in Eastern Europe. Here we can see that Moldova contributes to approximately 50% of new breast cancer cases reported per 100,000th female residents with a per capita alcohol consumption of 23%. So with a low female employee rate of 43% (as compared to the threshold of 40%) this country does have a significant amount of new breast cancer cases reported because of high alcohol consumption by the relatively less number of adult female residents. ((on a side note: "Heaven's! Moldavian working class women drink a lot :-) ))

	print "\nContries where Female Employee Rate is greater than 40 &" \
      " Alcohol Consumption is greater than 20L & new breast cancer cases reported are less than 50\n"
	print sub2
	print "\nContries where Female Employee Rate is greater than 50 &" \
      " Alcohol Consumption is greater than 10L & new breast cancer cases reported are greater than 70\n"
	sub3=data[(data['alcconsumption']>10)&(data['breastcancerper100th']>70)&(data['femaleemployrate']>50)]
	print sub3

the result is

	Contries where Female Employee Rate is greater than 40 & Alcohol Consumption is greater than 20L & new breast cancer cases reported are less than 50
	
	     country   incomeperperson  alcconsumption armedforcesrate  \
	126  Moldova  595.874534521728           23.01        .5415062   
	
	     breastcancerper100th      co2emissions  femaleemployrate hivrate  \
	126                  49.6  149904333.333333         43.599998      .4   
	
	     internetuserate lifeexpectancy oilperperson polityscore  \
	126  40.122234699607         69.317                        8   
	
	    relectricperperson suicideper100th        employrate urbanrate  
	126   304.940114846777        15.53849  44.2999992370606     41.76  

The complete python code is listed on my <a href="https://github.com/duttashi/Data-Analysis-Visualization/blob/master/gapminder%20data%20analysis.ipynb" target="_blank">github account</a>

This series will be continued....
