---
layout: post
title: Data preprocessing with R
date: 2014-12-09 15:58
share: true
excerpt: "Concepts in data cleaning"
categories: blog
tags: [R, preprocessing]
comments: true

---
In my previous post, I have detailed how to load data into R. Continuing further from there, after the data has been loaded the next step is to clean it and apply some clustering algorithm to it so as to reveal some patterns. 

A data variable is of two types, quantitative and qualitative (also known as categorical). I am not taking into account picture or sound or any other type of data variable. 

<span style="text-decoration:underline;">Quantitative variables take on numerical values</span> Examples include a person’s age, height, or income, the value of a house, and the price of a stock. 

In contrast, qualitative variables take on values in one of K different classes, or categories. Examples of qualitative variables include a person’s gender (male or female), the brand of product purchased (brand A, B, or C), whether a person defaults on a debt (yes or no), or a cancer diagnosis (Acute Myelogenous Leukemia). 

<span style="text-decoration:underline;">We tend to refer to problems with a quantitative response as regression problems, while those involving a qualitative response are often termed as classification problems</span>. However, the distinction is not always that crisp. 

Least squares linear regression is used with a quantitative response, whereas logistic regression is typically used with a qualitative (two-class, or binary) response. As such it is often used as a classification method. 

But since it estimates class probabilities, it can be thought of as a regression method as well. Some statistical methods, such as K-nearest neighbors and boosting, can be used in the case of either quantitative or qualitative responses. 

We tend to select statistical learning methods on the basis of whether the response is quantitative or qualitative; i.e. we might use linear regression when quantitative and logistic regression when qualitative. 

<span style="text-decoration:underline;">However, whether the predictors are qualitative or quantitative is generally considered less important.</span>

I chose to discuss briefly about variables because you got to understand your data that needs to be analysed. 

Therefore a proper understanding of your data variables can help save you a lot of tears later. 

Why I emphasize this is because today I wasted more than 3 hours trying to clean my data when actually the data was already cleaned. I cannot post here the type of data that I’m dealing with but I will tell the problem and the solution to it that I was facing with.

Assume you have a dataset as following;

<strong><span style="text-decoration:underline;">Table Account</span></strong>
<table>
<tbody>
<tr>
<td width="156">Account number</td>
<td width="156">Account name</td>
<td width="156">Account balance</td>
<td width="156">Account type</td>
</tr>
<tr>
<td width="156">111223334</td>
<td width="156">Xyz</td>
<td width="156">$89078</td>
<td width="156">Current</td>
</tr>
<tr>
<td width="156">234534578</td>
<td width="156">Abc</td>
<td width="156">$2345</td>
<td width="156">Savings</td>
</tr>
</tbody>
</table>
Off course real life dataset does not have only 2 rows but this is a mere example. Now, you are tasked with searching for patterns in it. You take into consideration all the four variables as given in table Account. You import the data into R using the command 
	
	> mydata read.csv("C:\Users\Example\Book1.csv")
Next you view the data using the command

	> View(mydata)
and R will show you a tabulated format of your data.

<strong>Problem</strong>

Now, you try to plot it or apply kmeans or any other clustering algorithm to it and you will get the following error
	
	Error in do_one(nmeth) : NA/NaN/Inf in foreign function call (arg 1) In addition: Warning message: In kmeans(mydata, 10) : NAs introduced by coercion

<strong>Solution</strong>

So you might think, lets use the as.numeric function of R to convert all the data to numeric format using the command

	> mydata=as.numeric(mydata)

and you will get another error as

	Error: (list) object cannot be coerced to type 'double'

Q. So what is the problem here when you know that you are data is in the correct format?

Problem my dear friend is the choice of your data variables that you want to compare or make clusters. What I mean is in this example, I have used Kmeans to cluster the data and kmeans understands only continuous data so if you try to cluster the variable "Account number" it will not accept it and will give you the above errors. Therefore a judicious choice of variables is imperative for analysis. So the solution is if you remove the Account number variable from the dataset you will be able to cluster the data and plot it.

<span style="text-decoration"><strong>Q. What if you dont want to loose the variable Account number and use it in the clustering too?</strong></span>

Solution: You do not have to convert the whole data frame to numeric because if you do so R will give you error Error: (list) object cannot be coerced to type 'double' here R is saying to you that it cannot convert the data,frame object into numeric format because its an object data type so you have to coerce it to a matrix. But before that how to check the data type of a variable in R? Use the <strong>str()</strong> as <code>&gt;str(yourdatavariablename)</code> in my case its <code>&gt; str (mydata)</code> and R gives me the attributes along with there data types;

<strong>Answer: </strong>Use the <strong>as.matrix()</strong> <span>function to coerce the data.frame object to a matrix</span> as shown

	> mydata <- as.matrix(mydata)
This command will convert your data.frame object into a matrix and now you are ready to apply any sort of clustering or plotting to your dataset.

<strong>How to apply kmeans</strong>

Note: before you apply kmeans or any other algorithm ensure that you scale or standardise your dataset. for this use the following command as <code> > mydata<- scale(mydata) </code>

After this you will store the k-means result into another variable so the command is <code>> fit=kmeans(mydata) </code>now you are ready to plot it. Install the package cluster if you don't have it as <code>> install.packages("cluster")</code> Now you load it as <code>> library(cluster) </code>to see the cluster results use the command <code>> plotcluster(mydata,fit$cluster)</code> here the $sign is used to refer to the cluster variable

I found a <a href="http://www-bcf.usc.edu/~gareth/ISL/getbook.html" target="_blank">good book</a> on learning R with statistics. The language is easy to understand and in short its a great book.

Cheers!