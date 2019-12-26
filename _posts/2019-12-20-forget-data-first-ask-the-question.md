---

layout: post
title: Forget data, what is the question?
date: 2019-12-20
share: true
excerpt: "Something is amiss in data science domain. Please, can we stop dumping data on engineers/scientists?"
categories: blog
tags: [AWS S3]
comments: true
published: false

---

### Introduction

I see a race. A race to collect hordes of data in different shapes and sizes. I see the data science society, fragmented into groups. The (*business*) stakeholders are generally oblivious of the question they want to solve. Their ideology is, "*as long as data is being collected, we are doing good*". The technical group in the business are oblivious of proper data governance practices. They think by maintaining the traditional relational data repositories (*SQL*) and the database system design document (DSDD), they are good to go. The client is (*generally*) oblivious of the question to be addressed. I see a race, where everyone is keen to surf this *data wave*, with an absolute disregard to a clear concise strategy.  

If you've read so far, you'll notice a few imminent common themes, namely:

1. What is the question('s), I (*business*) want to solve?
2. How does (*my*) existing data help me to solve the question('s)?

### Forget data. what is the question?

Besides my research, I offer consultation service in data science domain. Most of my clients are simply unaware of a clear formulated question. They (`read client`) will acquire the data from some place and then recruit Subject Matter Experts (SMEs), Data Engineer/Scientist (DS) to figure out what the data means!

Consider the following hypothetical scenario. A company say `X` acquires some product sales data  say `PE data` from another company say `Y`. `X` wants to build a predictive model, using `PE data` to determine correlated variables responsible for dropping product sales. `X` hires a SME, and a DS to build the model. Needless to state, `X` has no PD nor DD on the project. The SME evaluates the `PE data` to identify `correlated variables (corr_vars)`. The DS objects that some of the independent `corr_vars`, display a correlation above 75% with the dependent variable and are thus not contributing to the prediction sensitivity. A stalemate condition. What is the solution then?

There is no Project Documentation (PD) nor Data Dictionaries (DD) in place. It's like `reverse engineering`. I think this business strategy is short-sighted and will do nobody any good. I think building PD and DD from `observed data` is incorrect, because, it leaves many unanswered questions like:

Q. How to determine the observed data is correct?

Possible answer: A school of thought is to consult the relevant SME for the dataset to validate the observed data.

But then another question arises, 

Q. What is the guarantee the SME's data validation verdict is correct?

Possible answer: if the SME is unable to provide a satisfactory response to its data validation actions, then I think the project is in trouble. A satisfactory response must consist of an/or assumption about data and the validation method. Suppose the SME says, 

> Prepare a normally distributed data because the current data in question suffers from ... (*SME provides the reason for the assumption*)

 
   



          