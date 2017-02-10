---
layout: post
title: How to read CSV file into R
date: 2014-12-06 17:06
comments: true
share: true
excerpt: "An example on reading csv file in R"
categories: blog
tags: [R, preprocessing]

---
If you are using R much you will likely need to read in data at some point. While R can read excel .xls and .xlsx files these file types often cause problems. Comma separated files (.csv) are much easier to work with. It’s best to save these files as csv before reading them into R. If you need to read in a csv with R the best way to do it is with the command read.csv. 

Here is an example of how to read CSV in R: 

<b>Step 1</b>: Save Excel file as CSV file

<b>Step 2</b>: On R console type the following command <code> fileToOpen&lt;-read.csv(file.choose(), header=TRUE)</code> 

The file.choose() command of R to open the file.

Here header is true because the CSV file has column headings in it

The above reads the file <code>fileName.csv</code> into a data frame that it creates called myData. header=TRUE specifies that this data includes a header row and sep=”,” specifies that the data is separated by commas (though read.csv implies the same I think it’s safer to be explicit) <span style="text-decoration:underline;">Also ensure that in file path you use the forward slash ("/") instead of the usual backslash.</span>

Cheers!