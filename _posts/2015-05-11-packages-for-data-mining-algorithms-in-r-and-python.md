---

layout: post
title: Packages for data mining algorithms in R and Python
date: 2015-05-11 17:47
share: true
excerpt: "Packages for data mining in R"
categories: blog
tags: [R, Python]
comments: true

---
Although there is abundance of such data both in print and electronic format but it is mostly either buried deep in voluminous books or in a long threaded conversation?
I think it will be appropriate to "cluster" all such useful packages as used in two popular data mining languages R and Python in a single thread.
<ol>
	<li>Hierarchical Clustering Methods</li>
	<li>For hierarchical clustering methods use the cluster package in R. An example implementation is posted on this<a href="https://class.coursera.org/clusteranalysis-001/forum/thread?thread_id=481">thread</a> In the same package you can find methods for <a href="http://cran.r-project.org/web/packages/clues/index.html">clues</a>, clara, clarans, Diana, ClustOfVar algorithms</li>
	<li>BIRCH methods- The<a href="http://cran.r-project.org/web/packages/birch/index.html">R package has been removed</a> from the CRAN repository. You can either use the <a href="http://cran.r-project.org/src/contrib/Archive/birch">earlier versions</a> found here or else you can modify the code. For Python, you can use <a href="http://scikit-learn.org/dev/modules/generated/sklearn.cluster.Birch.html">sckit-learn</a></li>
	<li>Agglomerative Clustering- the r function is agnes found in the cluster package</li>
	<li>Expectation-Maximization algorithm- the r package is<a href="http://cran.r-project.org/web/packages/EMCluster/index.html">EMCluster</a></li>
	<li><a href="http://cran.r-project.org/web/packages/kmodR/index.html">K-modesR</a>for classical k-means, <a href="http://cran.r-project.org/web/packages/kernlab/index.html">kernlab</a>, <a href="http://cran.r-project.org/web/packages/flexclust/index.html">Flexclust</a></li>
	<li><a href="http://cran.r-project.org/web/packages/clValid/vignettes/clValid.pdf">Clustering and Cluster validation in R</a>Package - <a href="http://cran.r-project.org/web/packages/fpc/">fpc</a>, <a href="http://cran.r-project.org/web/packages/RANN/index.html">RANN for k-nearest neighbors</a></li>
	<li>For clustering mixed-type dataset, the R package is<a href="http://cran.r-project.org/web/packages/clue/index.html">Cluster Ensembles</a></li>
	<li>In Python- Text processing tasks can be handled by<a href="http://www.nltk.org/">Natural Language Toolkit (NLP)</a> is a mature, well-documented package for NLP, <a href="http://textblob.readthedocs.org/en/dev/">TextBlob</a> is a simpler alternative, <a href="http://honnibal.github.io/spaCy/">spaCy</a> is a brand new alternative focused on performance. The R package for text processing is <a href="http://cran.r-project.org/web/packages/tm/index.html">tm</a> package</li>
	<li><a href="http://cran.r-project.org/web/views/">CRAN Task View</a>- contains a list of packages that can be used for finding groups in data and modeling unobserved cross-sectional heterogeneity. This is one place where you can find both the function name and its description.
Is data cleaning your objective? So if your focus is on data cleaning also known as data munging then python is more powerful in my experience because its backed by <a href="https://docs.python.org/2/library/re.html">regular expression</a></li>
</ol>
Is data exploration your objective? The <a href="http://pandas.pydata.org/">pandas</a> package in Python is very powerful and extremely flexible but its equally challenging to learn too. Similarly, the <a href="http://cran.r-project.org/web/packages/dplyr/index.html">dplyr</a> package in R can be used for the same.

Is data visualization your objective? If so then in R, <a href="http://ggplot2.org/">ggplot2</a> is an excellent package for data visualization. Similarly, you can use <a href="http://ggplot.yhathq.com/">ggplot for python</a> for graphics

And finally, like the CRAN-R project is a single repository for R packages the <a href="https://store.continuum.io/cshop/anaconda/">Anaconda distribution for Python</a> has a similar package management system
