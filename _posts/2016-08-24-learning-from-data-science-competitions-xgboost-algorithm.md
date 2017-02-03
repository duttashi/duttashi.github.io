---

layout: post

title: Learning from data science competitions- baby steps

date: 2016-08-24 08:17

comments: true

categories: [classification techniques, competition, exploratory data analysis]

tags: R

---
Off lately a considerable number of winner machine learning enthusiasts have used <a href="https://github.com/dmlc/xgboost" target="_blank">XGBoost</a> as their predictive analytics solution. This algorithm has taken a preceedence over the traditional tree based algorithms like Random Forests and Neural Networks.

The acronym <strong>Xgboost </strong>stands for e<strong>X</strong>treme G<strong>radient </strong><strong>B</strong>oosting package. The creators of this algorithm presented its <a href="https://www.kaggle.com/tqchen/otto-group-product-classification-challenge/understanding-xgboost-model-on-otto-data" target="_blank">implementation</a> by winning the Kaggle Otto Group competition. Another interesting tutorial is listed <a href="https://www.r-bloggers.com/an-introduction-to-xgboost-r-package/">here</a> and the complete documentation can be seen <a href="http://xgboost.readthedocs.io/en/latest/R-package/xgboostPresentation.html">here</a>. This page lists a comprehensive list of <a href="https://github.com/dmlc/xgboost/tree/master/demo#tutorials" target="_blank">awesome tutorials</a> on it and this one shows <a href="http://fr.slideshare.net/MichaelBENESTY/feature-importance-analysis-with-xgboost-in-tax-audit" target="_blank">feature importance</a>  It is a classification algorithm and the reasons of its superior efficiency are,
<ul>
	<li>It's written in C++</li>
	<li>It can be multithreaded on a single machine</li>
	<li>It preprocesses the data before the training algorithm.</li>
</ul>

Unlike its previous tree based predecessors it takes care of many of the inherent problems associated with tree based classification. For example, "By setting the parameter <code>early_stopping</code>,<code>xgboost</code> will terminate the training process if the performance is getting worse in the iteration." [1]

As with all machine learning algorithms, xgboost works on numerical data. If categorical data is there then use one-hot encoding from the R caret package to transform the categorical data (factors)  to numerical dummy variables that can be used by the algorithm. Here is a good <a href="http://stackoverflow.com/questions/24142576/one-hot-encoding-in-r-categorical-to-dummy-variables">SO discussion</a> on one-hot encoding in R. This <a href="https://www.quora.com/What-is-one-hot-encoding-and-when-is-it-used-in-data-science" target="_blank">Quora thread</a> discusses the question on "<em>when should you be using one-hot encoding in data science?".</em>

Okay, enough of background information. Now let's see some action.

<strong>Problem Description</strong>

The objective is to predict whether a donor has donated blood in March 2007. To this effect, the dataset for this study is derived from <a href="https://www.drivendata.org/competitions/2/page/7/" target="_blank">DrivenData</a> which incidentally is also hosting a practice data science competition on the same.

<strong>Problem Type: Classification</strong>.

And how did I figure this out? Well, one has to read the problem description carefully as well as the submission format. In this case, the submission format categorically states that the response variable to be either 1 or 0 which is proof enough that this is a classification problem.

<strong>Choice of predictive algorithm</strong>

Boy, that really let my head spinning for some time. You see I was torn between the traditionalist approach and the quickie (get it out there) approach. First, I thought let me learn and explore what story is the data trying to tell me (<em>traditionalist approach) </em>but then I gave up on this idea because of my past experiences. Once I venture this path, I get stuck somewhere or keep digging in a quest to perfect my solution and time slips away. So this time, I said to myself, "<em>Enough! let me try the quickie approach that is get it (read the solution) out of the lab as quickly as possible. And I can later continue to improve the solution"</em>.  So following this intuition and a very much required <em>self-morale boost</em> (<em>that is what happens to you when you are out in the laboratory all by yourself</em>) I decided to choose XGBoost as the preliminary predictive classification algorithm. Being neck deep into clustering algorithms (<em>which is my research area) </em>and if truth be told I never really had a penchant for supervised algorithms (<em>once again a gut feeling that they were too easy because you already know the outcome. Dammn! I was so wrong)</em>

<strong>Choice of tool</strong>

For sometime now, I had been juggling between the choice of being a pythonist or an R user, <em>"To be or not to be, that is the question". </em> The worldwide web has some great resources on this discussion and you can take your pick. In my case, I decided to chose and stick with R because of two reasons, primarily its a statistical programming language and two predictive analytics or machine learning has its roots in statistics.

<strong>The</strong>  <strong>Strategy</strong>

"Visualize it, <em>Clean it, Smoothe it, Publish it".  </em>

After reading the data in R, my first step was to plot as many meaningful graphs as possible to detect a trend or a relationship. I started with line plots but before I get into that, a brief about the dataset. The dataset was pre-divided into training and testing data. The training data had 576 observations in 6 continuous variables of which the last variable was the response. Similarly, the test data had 200 observations in 5 continuous variables.

	# Read in the data
	train.data<- read.csv("data//blood_donation_train.csv", sep = ",", header=TRUE)
	test.data<-read.csv("data//blood_donation_test.csv", sep = ",", header=TRUE) 
	# Check the data structure 
	> str(train.data)
	'data.frame': 576 obs. of 6 variables:
	$ ID : int 619 664 441 160 358 335 47 164 736 436 ...
	$ Months.since.Last.Donation : int 2 0 1 2 1 4 2 1 5 0 ...
	$ Number.of.Donations : int 50 13 16 20 24 4 7 12 46 3 ...
	$ Total.Volume.Donated..c.c..: int 12500 3250 4000 5000 6000 1000 1750 3000 11500 750 ...
	$ Months.since.First.Donation: int 98 28 35 45 77 4 14 35 98 4 ...
	$ Made.Donation.in.March.2007: int 1 1 1 1 0 0 1 0 1 0 ...

	> str(test.data)
	'data.frame': 200 obs. of 5 variables:
	$ ID : int 659 276 263 303 83 500 530 244 249 728 ...
	$ Months.since.Last.Donation : int 2 21 4 11 4 3 4 14 23 14 ...
	$ Number.of.Donations : int 12 7 1 11 12 21 2 1 2 4 ...
	$ Total.Volume.Donated..c.c..: int 3000 1750 250 2750 3000 5250 500 250 500 1000 ...
	$ Months.since.First.Donation: int 52 38 4 38 34 42 4 14 87 64 ...

<b> a. Data Visualization</b>

I first started with the base R graphics library, you know commands like <em>hist() or plot()</em> but honestly speaking the visualization was draconian, awful. You see it did not appeal to me at all and thus my grey cells slumbered. Then, I chose the ggplot2 library. Now, that was something. The visualizations were very appealing inducing the grey mater to become active.

<em><strong>Learning note</strong>: So far, I have not done any data massaging activity like centering or scaling. Why? The reason is one will find patterns in the raw data and not in a centered or scaled data.</em>

Off the numerous graphs I plotted, I finally settled on the ones that displayed some proof of variablity. I wanted to see if there was a cohort of people who were donating more blood than normal. I was interested in this hypothesis because there are some cool folks out there (pun intended) for whom blood donation is a business. Anyway, if you look at the line plot 1 that explores my perceived hypothesis, you will notice a distinct cluster of people who donated between 100 cc to 5000 cc in approx 35 months range.

![image](https://duttashi.github.io/images/rplot-2-1.png)

Line plot 1: Distribution of total blood volume donated in year 2007-2010

	highDonation2<- subset(train.data, Total.Volume.Donated..c.c..>=100 & Total.Volume.Donated..c.c..<=5000 & Months.since.Last.Donation<=35)
	
	p5<- ggplot() +geom_line(aes(x=Total.Volume.Donated..c.c.., y=Months.since.Last.Donation, colour=Total.Volume.Donated..c.c..),size=1 ,data=highDonation2, stat = "identity")
	
	p5 # Visualize it
	
	highDonation2.3<- subset(train.data, Total.Volume.Donated..c.c..>800 & Total.Volume.Donated..c.c..<=5000 & Months.since.Last.Donation<=35)

	str(highDonation2.3)

	p6.3<- ggplot() +geom_line(aes(x=Total.Volume.Donated..c.c.., y=Months.since.Last.Donation, colour=Total.Volume.Donated..c.c..),size=1 ,data=highDonation2.3, stat = "identity")

	p6.3 # Visualize it
	
	highDonation2.4<- subset(train.data, Total.Volume.Donated..c.c..>2000 & Total.Volume.Donated..c.c..<=5000 & Months.since.Last.Donation<=6)
	
	p6.2<- ggplot() +geom_line(aes(x=Total.Volume.Donated..c.c.., y=Months.since.Last.Donation, colour=Total.Volume.Donated..c.c..),size=1 ,data=highDonation2.4, stat = "identity")
	
	p6.2 # Visualize it

I then took a subset of these people and I noticed that total observations was 562 which is just 14 observations less than the original dataset. Hmm.. maybe I should narrow my range down a bit more.  so then I narrowed the range between 1000 cc to 5000 cc  of blood donated in the 1 year and I find there are 76 people and when I further narrow it down to between 2000-5000 cc of blood donation in 6 months, there are 55 people out of 576 as shown in line plot 2.

![image](https://duttashi.github.io/images/rplot-2-2.png)

Line plot 2: Distribution of total blood volume (in cc) donated in 06 months of 2007

If you look closely at the line plot 2, you will notice a distinct spike between 4 and 6 months. (<em>Ohh baby, things are getting soo hot and spicy now, I can feel the mounting tension). </em>Let's plot it. And lo behold there are 37 good folks who have donated approx 2000 cc to 5000 cc in the months of May and June, 2007.

![image](https://duttashi.github.io/images/rplot-2-3.png)

Line plot 3: Distribution of total blood volume (in cc) donated in May &amp; June of 2007

I finally take this exploration one step further wherein I search for a pattern or a group of people who had made more than 20 blood donations in six months of year 2007. And they are 08 such good guys who were hyperactive in blood donation. This I show in line plot 4.

![image](https://duttashi.github.io/images/rplot2-4.png)

Line plot 4: Distribution of high blood donors in six months of year 2007

This post is getting too long now. I thin it will not be easier to read and digest it. So I will stop here and continue it in another post.

<strong>Key Takeaway Learning Points</strong>

A few important points that have helped me a lot.
<ol>
	<li>A picture is worth a thousand words. Believe in the power of visualizations</li>
	<li>Always, begin the data exploration with a hypothesis or question and then dive into the data to prove it. You will find something if not anything.</li>
	<li>Read and regurgiate on the research question, read material related to it to ensure that the data at hand is enough to answer your questions.</li>
	<li>If you are a novice, don't you dare make assumptions or develop any preconceived notions about knowledge nuggets (<em>for example, my initial aversion towards supervised learning as noted above) </em>that you have not explored.</li>
	<li>Get your fundamentals strong in statistics, linear algebra and probability for these are the base of data science.</li>
	<li>Practice programming your learnings and it will be best if create an end to end project. Needless to mention, the more you read, the more you write and the more you code, you will get better in your craft.And stick to one programming tool.</li>
	<li>Subscribe to data science blogs like R-bloggers, kaggle, driven data etc. Create a blog which will serve as your live portfolio.</li>
	<li>I think to master the art of story telling with data takes time and a hell lot of reading and analysis.</li>
</ol>

In the next part of this post, I will elaborate and discuss on my strategy that i undertook to submit my initial entry for predicting blood donor, competition hosted at driven data.

References

"An Introduction To Xgboost R Package". R-bloggers.com. N.p., 2016. Web. 23 Aug. 2016.

