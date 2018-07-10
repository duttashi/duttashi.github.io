---

layout: post
title: Assessing Clustering Tendency in R
date: 2015-05-13 14:51
excerpt: "Determining the possible number of clusters present in data"
categories: blog
tags: [R, clustering, preprocessing]
comments: true
share: true

---
While searching for a R package that applied 'Hopkin statistic' (mentioned in chapter 10, example 10.9 page 484 of the book) that determines if a given non-random or non-uniform dataset has the possibility of cluster's present in it or not, I accidentally discovered this <a href="http://cedric.cnam.fr/fichiers/art_2554.pdf" target="_blank">R package</a> for finding the best number of clusters. The <em>NbClust</em> package provides most of the popular indices for cluster validation. It also proposes to the user the best clustering scheme from the different results obtained by varying all combinations of number of clusters,distance measures, and clustering methods.

Besides the package, I would also recommend to any interested learner to read this paper <a href="http://web.itu.edu.tr/sgunduz/courses/verimaden/paper/validity_survey.pdf" target="_blank">part 1</a> and <a href="http://www.sigmod.org/publications/sigmod-record/0209/a1.partii_clvalidity1.pdf" target="_blank">part II</a> by (Halkidi, Batistakis &amp; Vazirgiannis, 2001) who have provided a comprehensive discussion on cluster validation techniques.

Clustering algorithms impose a classification on a dataset even if there are no clusters present for example k-means. To avoid this, clustering tendency assessment is used. On a given dataset it will determines if the dataset D has a non-random or a non-uniform distribution of data structure that will lead to meaningful clusters. To determine this "cluster tendency" a measure called Hopkins statistic can be used.

Anyway, in clustering one of major problem a researcher/analyst face is how to determine an optimal number of clusters in a dataset and how to validate the clustered results.

So searching for the Hopkin statistic package in R I discovered NBClust package. I provide below an example of how it can be used in R to determine an initial number of clusters that a given dataset can have.
<ol>
	<li>If you do not have the package installed, you can do so by typing the following command in R console as</li>
</ol>

	> install.packages("NbClust")

You can then load it in memory as;
	
	> library("NbClust") 

To see a list of default datasets in R type

	> data()
	# and you will see example datasets
	# For this example, I will work with iris and mtcars dataset [/sourcecode]
To load the dataset in R type at the console
	> data(iris)
	# To see the dataset column headings and datatype
	>str(iris)
	>head(iris) 

Remove the column 'Species' from this dataset because if you dont you will get an error when executing the NbClust method

	>iris$Species=NULL
	# Now apply the NbClust method as given but first set the seed function to any value so that your result is reproducible.
	>set.seed(26)
	clusterNo=NbClust(iris,distance="euclidean",
	min.nc=2,max.nc=10,method="complete",index="all")

	# where distance function is euclidean distance, min.nc is minimum number of clusters, max.nc is the maximum number of clusters, method can be single, complete, ward, average etc and index=all means test for all 30 indices with the given parameters. 

For package documentation see <a href="https://cran.r-project.org/web/packages/NbClust/NbClust.pdf">here</a>

#### You will then get a brief summary of the results as shown below

	*******************************************************
	Among all indices:
	* 2 proposed 2 as the best number of clusters
	* 13 proposed 3 as the best number of clusters
	* 5 proposed 4 as the best number of clusters
	* 1 proposed 6 as the best number of clusters
	* 2 proposed 10 as the best number of clusters
	***** Conclusion *****
	*According to the majority rule,
	the best number of clusters is 3
	*******************************************************

Now, lets take another example in which I will change the dataset to quakes which provides the location of earthquakes in Fiji. Since the above code is the same with only the dataset as a change, I will not provide the comments.

	> data(quakes)
	> str(quakes)
	> clusterNo=NbClust(quakes,distance="euclidean",min.nc=2,max.nc=10,
	method="complete",index="all")
	*******************************************************
	Among all indices:
	* 6 proposed 2 as the best number of clusters
	* 3 proposed 3 as the best number of clusters
	* 3 proposed 4 as the best number of clusters
	* 2 proposed 5 as the best number of clusters
	* 7 proposed 7 as the best number of clusters
	* 3 proposed 8 as the best number of clusters
	***** Conclusion *****
	* According to the majority rule,
	the best number of clusters is 7
	********************************************************


Thus you can see that the best number of clusters for the iris dataset is 3 and that for the quakes dataset is 7. Now that you know this, its time to smile because its is proved now that these two datasets are non-uniformly distributed which is a requirement of clustering.

In a similar fashion you can play with the various arguments in the NbClust function. In my opinion, once you get an idea that your dataset actually has clusters in it then trust me you will feel very happy. Because, as I have already stated in the first paragraph, clustering algorithms will partition/divide your dataset into clusters because that is what they are supposed to do. Its analogous to using a knife. The property of a knife is to cut and it will cut any object that is given to it. In the same way are the clustering algorithms. But the quintessential question that matters is "does the dataset has any inherent clusters in it or not? And if yes, then how do you figure it out?" This question is what I have attempted to answer in this post

Cheers.