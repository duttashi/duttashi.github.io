---

layout: post
title: How to split a data frame in R with over a million observations in above 50 variables?
date: 2015-04-17 16:06
excerpt: "Does data size matter in analysis?"
categories: blog
tags: [R, preprocessing]
comments: true
share: true

---
In a previous post dated April 6<sup>th</sup> 2015 I had written on how to split a data frame to training and test dataset. Today, I had to do it again so I was following my own post when I stumbled into the following error,

	“Error in `$&lt;-.data.frame`(`*tmp*`, "spl", value = c(TRUE, FALSE, TRUE,  : replacement has 80 rows, data has 201813”

So what does it mean? Googling did not help much when it occurred to me that the data frame had 80 variables (continuous and categorical) with more than 2 million observations. Hmmm, how do I fix it? How do I get my training and test datasets?

<span style="text-decoration:underline;">Solution</span>
<ol>
	<li>Load caTools package as <code>&gt;library (caTools)</code></li>
	<li>Set seed to 123 so that others can reproduce your results. This can be any arbitrary number. <code>&gt;set.seed(123)</code></li>
	<li>Now, I am borrowing two paragraphs from my previous post as follows “Then, you want to make sure that your Iris data set is shuffled and that you have the same ratio between species in your training and test sets. You use the sample() function to take a sample with a size that is set as the number of rows of the Iris data set which is 150.
Also you will create a new vector variable in the Iris dataset that will have the TRUE and FALSE values basis on which you will later split the dataset into training and test. You obtain this as following;</li>
</ol>
	# sample.split() is part of caTools package so you need to install it first if you have not done so by using 

	> install.packages(caTools)
Assuming in this case, its already installed so we will now load it as <code> > library(caTools)</code>

<ol start="4">
	<li>I create a new logical vector called x that will only have True and False values in it which I will later use to splitting the data frame. This can be done as follows</li>
</ol>
<code> > x=sample.split (dataFrameName, SplitRatio= 0.7)</code>

The SplitRatio=0.7 means split into 70% training data and 30% testing data
Cool, the major part of the problem has been solved.

<ol start="5">
	<li><code>Train= dataFrameName[x, 1:80]</code></li>
</ol>
where 1:80 means index 1 till index 80. It can also be understood as the data frame has 80 variables so that is why 1:80. Also x is the logical vector created in step 4

<ol start="6">
	<li><code>Test= dataFrameName[!x, 1:80]</code></li>
</ol>
Do not forget the <i>!x</i>. This <b>!</b> symbol means to put remaining values of logical vector x in test data frame

Cheers!