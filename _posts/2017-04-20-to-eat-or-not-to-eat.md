---

layout: post
title: To eat or not to eat! That's the question?
date: 2017-04-20
share: true
excerpt: "Will write the summary post the data analysis"
categories: blog
tags: [R, data analysis]
comments: true
published: false

---

### 1. Introduction
The data is sourced from UCI Machine Learning [repository](http://archive.ics.uci.edu/ml/machine-learning-databases/mushroom/agaricus-lepiota.data). As it states in the `data information` section, "This data set includes descriptions of hypothetical samples corresponding to 23 species of gilled mushrooms in the Agaricus and Lepiota Family (pp. 500-525). Each species is identified as definitely edible, definitely poisonous, or of unknown edibility and not recommended. This latter class was combined with the poisonous one. The guide clearly states that there is no simple rule for determining the edibility of a mushroom; 

Furthermore, the possible research questions, I want to explore are;
	
* Which features are most indicative of a poisonous mushroom?
* Visualizing categorical data
* What types of machine learning models perform best on this dataset?


#### 2. Making data management decisions
As a first step, I have read the data in the R environment as 

	# Import data from UCI ML repo
	> theURL<- "http://archive.ics.uci.edu/ml/machine-learning-databases/mushroom/agaricus-lepiota.data"
	# Explicitly adding the column headers from the data dictionary
	> mushroom.data<- read.csv(file = theURL, header = FALSE, sep = ",",strip.white = TRUE,
                         stringsAsFactors = TRUE, 
                         col.names = c("class","cap-shape","cap-surface","cap-color","bruises",
                                       "odor","gill-attachment","gill-spacing","gill-size",
                                       "gill-color","stalk-shape","stalk-root","stalk-surface-above-ring",
                                       "stalk-surface-below-ring","stalk-color-above-ring","stalk-color-below-ring",
                                       "veil-type","veil-color","ring-number","ring-type","spore-print-color",
                                       "population","habitat"))

Next, I quickly summarise the dataset to get a brief glimpse. The reader's should note that the data has no missing values.

	# Calculate number of levels for each variable
	> mushroom.data.levels<-cbind.data.frame(Variable=names(mushroom.data), Total_Levels=sapply(mushroom.data,function(x){as.numeric(length(levels(x)))}))
	> print(mushroom.data.levels)
	                                         Variable Total_Levels
	class                                       class            2
	cap.shape                               cap.shape            5
	cap.surface                           cap.surface            3
	cap.color                               cap.color           10
	bruises                                   bruises            2
	odor                                         odor            8
	gill.attachment                   gill.attachment            1
	gill.spacing                         gill.spacing            2
	gill.size                               gill.size            3
	gill.color                             gill.color           10
	stalk.shape                           stalk.shape            3
	stalk.root                             stalk.root            6
	stalk.surface.above.ring stalk.surface.above.ring            4
	stalk.surface.below.ring stalk.surface.below.ring            5
	stalk.color.above.ring     stalk.color.above.ring            7
	stalk.color.below.ring     stalk.color.below.ring            8
	veil.type                               veil.type            2
	veil.color                             veil.color            2
	ring.number                           ring.number            3
	ring.type                               ring.type            5
	spore.print.color               spore.print.color            7
	population                             population            7
	habitat                                   habitat            8

As we can see, the variable, `gill.attachement` has just one level. Nor, does it make any significant contribution to the target `class` so dropping it.

	# dropping variable with constant variance
	> mushroom.data$gill.attachment<- NULL

The different levels are uninterpretable in their current format. I will use the data dictionary and recode the levels into meaningful names. 

	> table(mushroom.data$class) # Before renaming the levels, e=4208 p=3916

   	e    p 
	4208 3916 
	> levels(mushroom.data$class)<- c("edible","poisonous")
	> table(mushroom.data$class) # After renaming the levels, edible=4208 poisonous=3916

   	edible poisonous 
     4208      3916 
	> levels(mushroom.data$cap.shape)<-c("bell","conical","flat","knobbed","sunken","convex") 
	> table(mushroom.data$cap.surface)

   	f    g    s    y 
	2320    4 2556 3244 
	> levels(mushroom.data$cap.surface)<- c("fibrous","grooves","smooth","scaly")
	> table(mushroom.data$cap.color)

   	b    c    e    g    n    p    r    u    w    y 
 	168   44 1500 1840 2284  144   16   16 1040 1072 
	> levels(mushroom.data$cap.color)<- c("buff","cinnamon","red","gray","brown","pink","green","purple","white","yellow")
	> table(mushroom.data$bruises)

   	f    t 
	4748 3376 
	> levels(mushroom.data$bruises)<- c("bruisesno","bruisesyes")
	> table(mushroom.data$odor)

   	a    c    f    l    m    n    p    s    y 
 	400  192 2160  400   36 3528  256  576  576 
	> levels(mushroom.data$odor)<-c("almond","creosote","foul","anise","musty","nosmell","pungent","spicy","fishy")
	> table(mushroom.data$gill.attachment)

   	a    f 
 	210 7914 
	> levels(mushroom.data$gill.attachment)<- c("attached","free")
	> table(mushroom.data$gill.spacing)

   	c    w 
	6812 1312 
	> levels(mushroom.data$gill.spacing)<- c("close","crowded")
	> table(mushroom.data$gill.size)

   	b    n 
	5612 2512 
	> levels(mushroom.data$gill.size)<-c("broad","narrow")
	> table(mushroom.data$gill.color)

   	b    e    g    h    k    n    o    p    r    u    w    y 
	1728   96  752  732  408 1048   64 1492   24  492 1202   86 
	> levels(mushroom.data$gill.color)<- c("buff","red","gray","chocolate","black","brown","orange","pink","green","purple","white","yellow")
	> table(mushroom.data$stalk.shape)

   	e    t 
	3516 4608 
	> levels(mushroom.data$stalk.shape)<- c("enlarging","tapering")
	> table(mushroom.data$stalk.root) # has a missing level coded as ?

   	?    b    c    e    r 
	2480 3776  556 1120  192 
	> levels(mushroom.data$stalk.root)<- c("missing","bulbous","club","equal","rooted")
	> table(mushroom.data$stalk.surface.above.ring)

   	f    k    s    y 
 	552 2372 5176   24 
	> levels(mushroom.data$stalk.surface.above.ring)<-c("fibrous","silky","smooth","scaly")
	> table(mushroom.data$stalk.surface.below.ring)

   	f    k    s    y 
 	600 2304 4936  284 
	> levels(mushroom.data$stalk.surface.below.ring)<-c("fibrous","silky","smooth","scaly")
	> table(mushroom.data$stalk.color.above.ring)

   	b    c    e    g    n    o    p    w    y 
 	432   36   96  576  448  192 1872 4464    8 
	> levels(mushroom.data$stalk.color.above.ring)<- c("buff","cinnamon","red","gray","brown",                "orange","pink","white","yellow")
	> table(mushroom.data$stalk.color.below.ring)
	
	b    c    e    g    n    o    p    w    y 
 	432   36   96  576  512  192 1872 4384   24 
	> levels(mushroom.data$stalk.color.below.ring)<- c("buff","cinnamon","red","gray","brown",      "orange","pink","white","yellow")
	> table(mushroom.data$veil.type)

   	p 
	8124 
	> levels(mushroom.data$veil.type)<-c("partial")
	> table(mushroom.data$veil.color)

   	n    o    w    y 
  	96   96 7924    8 
	> levels(mushroom.data$veil.color)<- c("brown","orange","white","yellow")
	> table(mushroom.data$ring.number)

   	n    o    t 
  	36 7488  600 
	> levels(mushroom.data$ring.number)<-c("none","one","two")
	> table(mushroom.data$ring.type)

   	e    f    l    n    p 
	2776   48 1296   36 3968 
	> levels(mushroom.data$ring.type)<- c("evanescent","flaring","large","none","pendant")
	> table(mushroom.data$spore.print.color)

   	b    h    k    n    o    r    u    w    y 
  	48 1632 1872 1968   48   72   48 2388   48 
	> levels(mushroom.data$spore.print.color)<- c("buff","chocolate","black","brown","orange","green","purple","white","yellow")
	> table(mushroom.data$population)

   	a    c    n    s    v    y 
 	384  340  400 1248 4040 1712 
	> levels(mushroom.data$population)<- c("abundant","clustered","numerous","scattered","several","solitary")
	> table(mushroom.data$habitat)

   	d    g    l    m    p    u    w 
	3148 2148  832  292 1144  368  192 
	> levels(mushroom.data$habitat)<-c("woods","grasses","leaves","meadows","paths","urban","waste")
	> table(mushroom.data$habitat)

  	woods grasses  leaves meadows   paths   urban   waste 
   	3148    2148     832     292    1144     368     192 

#### 3. Preliminary data visualization 

#### a. Is there a relationship between cap-surface and cap-shape of a mushroom?

	> p<- ggplot(data = mushroom.data, aes(x=cap.shape, y=cap.surface, color=class))
	> p + geom_jitter(alpha=0.3) + scale_color_manual(breaks = c('edible','poisonous'),values=c('darkgreen','red'))
	
![plot1](https://duttashi.github.io/images/casestudy_mushrooms_plot1.png)

Fig-1: Mushroom cap-shape and cap-surface

From Fig-1, we can easily notice, the mushrooms with a, `flat` cap-shape and `scaly`, `smooth` or `fibrous` cap-surface are `poisonous`. While, the mushrooms with a, `bell`,`knob` or `sunken` cap-shape and are `fibrous`, `smooth` or `scaly` are `edible`. A majority of `flat` cap-shaped mushrooms with `scaly` or `smooth` cap surface are `poisonous`. 

#### b. Is mushroom habitat and its population related? 

	> p<- ggplot(data = mushroom.data, aes(x=population, y=habitat, color=class))
	> p + geom_jitter(alpha=0.3) +  
  	scale_color_manual(breaks = c('edible','poisonous'),values=c('darkgreen','red'))

![plot2](https://duttashi.github.io/images/casestudy_mushrooms_plot2.png)

Fig-2: Mushroom cap-shape and cap-surface

From Fig-2, we see that mushrooms which are `clustered` or `scattered` in population and living in `woods` are entirely `poisonous`. Those that live in `grasses`, `wasteland`, `meadows`, `leaves`, `paths` and `urban` area's are `edible`.

#### c. What's the deal with living condition and odor?

	> p<- ggplot(data = mushroom.data, aes(x=habitat, y=habitat, color=class))
	> p + geom_jitter(alpha=0.3) +scale_color_manual(breaks = c('edible','poisonous'),values=c('darkgreen','red'))

![plot3](https://duttashi.github.io/images/casestudy_mushrooms_plot3.png)

Fig-3: Mushroom habitat and odor

From Fig-3, we notice, the mushrooms with `fishy`, `spicy`,`pungent`, `foul`, `musty` and `creosote` odor are clearly marked `poisonous` irrespective of there habitat. Whereas the one's with `almond`, `anise` odour are `edible` mushrooms. We also notice, that a minority of no odour mushrooms are poisonous while the one's living in `meadows` are entirely poisonous in nature.

Although, there could be many other pretty visualizations but I will leave that as a future work.

I will now focus on predictive analytics. 

#### 4. Predictive data analytics

##### a. Correlation detection & treatment for categorical predictors 

Let's check for highly correlated independent variables (or predictors). But there is a problem, the existing dataset is categorical in nature. If we look at the structure of the dataset, we notice that each variable has several factor levels. Moreover, these levels are `unordered`. Such unordered categorical  variables are termed as **nominal variables**. The opposite of unordered is ordered, we all know that. In statistics, the categorical variables having ordered levels are called, **ordinal variables**.
   
"In the measurement hierarchy, interval variables are highest, ordinal variables are next, and nominal variables are lowest. Statistical methods for variables of one type can also be used with variables at higher levels but not at lower levels.", see [Agresti](https://mathdept.iut.ac.ir/sites/mathdept.iut.ac.ir/files/AGRESTI.PDF)

I found this [cheat-sheet](https://stats.idre.ucla.edu/other/mult-pkg/whatstat/) that can aid in determining the right kind of test to perform on categorical predictors (independent/explanatory variables). Also, this [SO post](https://stats.stackexchange.com/questions/108007/correlations-with-categorical-variables) is very helpful. See the answer by user `gung`. 


For categorical variables, the concept of correlation can be understood in terms of **significance test** and **effect size (strength of association)**

The **Pearson’s chi-squared test of independence** is one of the most basic and common hypothesis tests in the statistical analysis of categorical data. It is a **significance test**.  Given 2 categorical random variables, X and Y, the chi-squared test of independence determines whether or not there exists a statistical dependence between them.  Formally, it is a hypothesis test. The chi-squared test assumes a null hypothesis and an alternate hypothesis. The general practice is, if the p-value that comes out in the result is less than a pre-determined significance level, which is `0.05` usually, then we reject the null hypothesis.

*H0: The The two variables are independent*

*H1: The The two variables are dependent*

The null hypothesis of the chi-squared test is that the two variables are independent and the alternate hypothesis is that they are related.

To establish that two categorical variables (or predictors) are dependent, the chi-squared statistic must have a certain cutoff. This cutoff increases as the number of classes within the variable (or predictor) increases. 

In section 3a, 3b and 3c, I found significant relationships between variables by data visualizing. In this section, I will test to prove those relationships to be true or not. As discussed so far in this section, I will apply the chi-squared test of independence to measure if the relationships are significant or not.

	> chisq.test(mushroom.data$cap.shape, mushroom.data$cap.surface, correct = FALSE)
	
	Pearson's Chi-squared test

	data:  mushroom.data$cap.shape and mushroom.data$cap.surface
	X-squared = 1011.5, df = 15, p-value < 2.2e-16

since the p-value is `< 2.2e-16` is less than the cut-off value of `0.05`, we can reject the null hypothesis in favor of alternative hypothesis and conclude, that the variables, `cap.shape` and `cap.surface` are dependent to each other.

	> chisq.test(mushroom.data$habitat, mushroom.data$odor, correct = FALSE)

	Pearson's Chi-squared test

	data:  mushroom.data$habitat and mushroom.data$odor
	X-squared = 6675.1, df = 48, p-value < 2.2e-16    

Similarly, the variables `habitat` and `odor` are dependent to each other as the p-value `< 2.2e-16` is less than the cut-off value `0.05`.


Since, I'm dealing with `nominal` categorical explanatory (or independent or predictor) variables, the **Goodman and Kruskal’s tau** measure is appropriate. Interested readers must see pages 68 and 69 of the [Agresti book](https://mathdept.iut.ac.ir/sites/mathdept.iut.ac.ir/files/AGRESTI.PDF).
 
##### b. What are the important variables that make a significant contribution to a predictive model? 
Now, I will now check for important variables that can be used for building a good classification model. The variable importance plot is generated by growing trees. So, for the purpose of this analysis, I will grow random forest trees.


##### c. Split the dataset into training and testing sets
To start with, lets create 70:30 stratified split, by using the `sample.split()` method from the library `caTools`.  

	> set.seed(56) 
	> library(caTools)
	> sample = sample.split(train01$class, SplitRatio = .7)
	> x_train = subset(train01, sample == TRUE)
	> x_test = subset(train01, sample == FALSE)

	>y_train<-x_train$class
	>y_test <- x_test$class

	> x_train$class<-NULL
	> x_test$class<-NULL


 
 