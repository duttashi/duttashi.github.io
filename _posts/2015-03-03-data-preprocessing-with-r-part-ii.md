---

layout: post

title: Data preprocessing with R- part II

date: 2015-03-03 13:18

comments: true

categories: [pre-processing]

tags: R

---
This post is a sequel to my earlier post dated December 9th, 2014

General background in R

1. R datatypes are;

a. numeric Numeric data (approximations of the real numbers, R)
b. integer Integer data (whole numbers, Z)
c. factor Categorical data (simple classifications, like gender)
d. ordered Ordinal data (ordered classifications, like educational level)
e. character Character data (strings)
f. raw Binary data

Variable types and indexing techniques

2.a. Vector:

The most basic variable in R is a vector. An R vector is a sequence of values of the same type.
Elements of a vector can be selected or replaced using the square bracket operator [ ] . The square brackets accept either a vector of names, index numbers, or a logical.

<strong>I.B. List:</strong>

A list is a generalization of a vector in that it can contain objects of different types, including other lists. There are two ways to index a list. 
The single bracket operator always returns a sub-list of the indexed list. That is, the resulting type is again a list. The double bracket operator ([[ ]] ) may only result in a single item, and it returns the object in the list itself. Besides indexing, the dollar operator $ can be used to retrieve a single element. To understand the above, check the results of the following statements. <code>
AL AL[[2]]
AL$y
AL[c(1, 3)]
AL[c("x", "y")]
AL[["z"]]
</code>

<strong>2.b. Data Frame</strong>

A data.frame is not much more than a list of vectors, possibly of different types, but with every vector (now columns) of the same length. Since data.frames are a type of list, indexing them with a single index returns a sub-data.frame; that is, a data.frame with less columns.

Likewise, the dollar operator returns a vector, not a sub-data.frame. Rows can be indexed using two indices in the bracket operator, separated by a comma. The first index indicates rows, the second indicates columns. If one of the indices is left out, no selection is made (so everything is returned). 

It is important to realize that the result of a two-index selection is
simplified by R as much as possible. Hence, selecting a single column using a two-index results in a vector. 

This behaviour may be switched off using <i>drop=FALSE</i> as an extra parameter. Here are some short examples demonstrating the above.

We now create 10 obs in 3 variables

	> d[, "x", drop = FALSE]
	# x
	1 1
	2 2
	3 3
	4 4
	5 5
	6 6
	7 7
	8 8
	9 9
	10 10

	> d[c("x", "z")]
	# x z
	1 1 A
	2 2 B
	3 3 C
	4 4 D
	5 5 E
	6 6 F
	7 7 G
	8 8 H
	9 9 I
	10 10 J

	> d[d$x > 3, "y", drop = FALSE]
	# y
	4 d
	5 e
	6 f
	7 g
	8 h
	9 i
	10 j

	> d[2, ]
	Error: unexpected '&gt;' in "&gt;"

<strong>Special values</strong>

R has a number of Special values that are exceptions to the
normal values of a type. These are <strong>NA, NULL, ±Inf and NaN</strong>.

i. NA Stands for not available. NA is a placeholder for a missing value.
The function is.na can be used to detect NA's.

	> NA+1
	[1] NA

	> sum(c(NA, 1, 2))
	[1] NA

ii. NULL You may think of NULL as the empty set from mathematics. NULL is special since it has no class (its class is NULL) and has length 0 so it does not take up any space in a vector. The function is.null can be used to detect NULL variables.

iii. Inf Stands for infinity and only applies to vectors of class numeric. A vector of class integer can never be Inf.

iv. NaN Stands for not a number. This is generally the result of a calculation of which the result is unknown, but it is surely not a number. In particular operations like 0/0, Inf-Inf and Inf/Inf result in NaN. Technically, NaN is of class numeric, which may seem odd since it is used to indicate that something is not numeric. Computations involving numbers and NaN always result in NaN
The function is.nan can be used to detect NaN's.

<strong>3. What is technically correct data in R?</strong>

In the case of R, we define technically correct data as a data set that
– is stored in a data.frame with suitable columns names, and
– each column of the data.frame is of the R type that adequately represents the value domain of the variable in the column.

Numeric data should be stored as numeric or integer, textual
data should be stored as character and categorical data should be stored as a factor or ordered vector, with the appropriate levels

Best practice. A freshly read data.frame should always be inspected with functions like head, str, and summary.

<strong>4. Data preprocessing with R</strong>

A: Consider the following example. Create a .csv file with the following data in it. Save it as datafile.csv

	> X10 X6.0
	42 5.6
	18 2.3*
	21

Now when you read the file using <code>&gt;read.csv command like
person </code><code> , col.names = c("age","height") )</code>
The command when executed creates a data.frame but the problem comes because of a malformed numerical value in the data like 2.3*. , causing R to interpret the whole column as a text variable. Moreover, by default text variables are converted to factor, so we are now stuck with a height variable expressed as levels in a categorical variable:

	> str(person)
	# 'data.frame': 4 obs. of 2 variables:
	# $ age : int 21 42 18 21
	# $ height: Factor w/ 3 levels "5.7*","5.9","6.0": 3 2 1 NA

<strong>Solution 1:</strong>

Using colClasses, we can force R to either interpret the columns in the way we want or throw an error when this is not possible.
	> read.csv("files/datafile.csv", header=FALSE, colClasses=c ('numeric','numeric'))
	# Error: scan() expected 'a real', got '2.3*'

<strong>Solution 2:</strong>
As an alternative, columns can be read in as character by setting stringsAsFactors=FALSE. Example:<code>
dat dat$height ## Warning: NAs introduced by coercion
</code>

<strong>B. Cleaning a text file</strong>

Assume you have a text file with the following contents;

	> %% Data on the Amigo Brothers
	Gratt,1861,1892
	Bob,1892
	1871,Emmet,1937
	% Names, birth and death dates

To remove %% sign use the grepl command as
	> grepl("%%", " ") 

<strong>C. Factors in R</strong>

In R, the value of categorical variables is stored in factor variables. A factor is an integer vector endowed with a table specifying what integer value corresponds to what level. The values in this translation table can be requested with the levels function.<code>

	> f levels(f)
	# [1] "a" "b" "c"

For example, suppose we read in a vector where 1 stands for male, 2 stands for female and 0 stands for unknown. Conversion to a factor variable can be done as in the example below 

	# [1] "a" "b" "c"
	# example:
	> recode (gender) 
	[1] female male male female male male
	#Levels: male female

Note that we do not explicitly need to set NA as a label. Every integer value that is encountered in the first argument, but not in the levels argument will be regarded missing. Levels in a factor variable have no natural ordering.

Reference

de Jonge, E., &amp; van der Loo, M. (2013). An introduction to data cleaning with R: Technical Report 201313, Statistics Netherlands, 2013. 
