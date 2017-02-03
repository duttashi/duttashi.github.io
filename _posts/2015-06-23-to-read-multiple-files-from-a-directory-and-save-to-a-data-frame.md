---

layout: post
title: To read multiple files from a directory and save to a data frame
date: 2015-06-23 16:16
excerpt: "Basic data manipulation techniques in R"
categories: blog
tags: [R, preprocessing]
comments: true
share: true

---
There are various solution to this questions like these but I will attempt to answer the problems that I encountered with there working solution that either I found or created by my own.

Question 1: My initial problem was how to read multiple .CSV files and store them into a single data frame.

Solution: Use a lapply() function and rbind(). One of the working R code I found <a href="http://stackoverflow.com/questions/23190280/issue-in-loading-multiple-csv-files-into-single-dataframe-in-r-using-rbind">here</a> provided by Hadley. 

The code is;

	# The following code reads multiple csv files into a single data frame
	load_data <- function(path) 
	{ 
 		files <- dir(path, pattern = '\\*.csv', full.names = TRUE)
 		tables <- lapply(files, read.csv)
 		do.call(rbind, tables)
	}

And then use the function like

	> load_data("D://User//Temp")