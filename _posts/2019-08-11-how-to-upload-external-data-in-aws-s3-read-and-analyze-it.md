---

layout: post
title: Building a data pipeline: uploading external data in AWS S3.
date: 2019-08-11
share: true
excerpt: "In this post, I have suggested some preliminary steps for building a data pipeline in AWS S3"
categories: blog
tags: [AWS S3, AWS Sagemaker]
comments: true
published: true

---
### Introduction

Recently, I stepped into the AWS ecosystem to learn and explore its capabilities. I'm documenting my experiences in these series of posts. Hopefully, they will serve as a reference point to me in future or for anyone else following this path. The objective of this post is, to understand how to create a data pipeline. Read on to see how I did it. Certainly, there can be much more efficient ways, and I hope to find them too. If you know such better method's, please suggest them in the `comments` section.

#### How to upload external data in Amazon AWS S3

**Step 1**: In the AWS S3 user management console, click on your bucket name.

![plot1](https://duttashi.github.io/images/s3-1.PNG)


**Step 2:** Use the upload tab to upload external data into your bucket.

![plot2](https://duttashi.github.io/images/s3-2.PNG)


**Step 3:** Once the data is uploaded, click on it. In the `Overview` tab, at the bottom of the page you'll see, `Object Url`. Copy this url and paste it in notepad.

![plot3](https://duttashi.github.io/images/s3-3.PNG)


**Step 4:**

Now click on the `Permissions` tab.

Under the section, `Public access`, click on the radio button `Everyone`. It will open up a window.

Put a checkmark on `Read object permissions` in `Access to this objects ACL`. This will give access to reading the data from the given object url.

Note: Do not give *write object permission access*. Also, if read access is not given then the data cannot be read by Sagemaker

![plot4](https://duttashi.github.io/images/s3-4.PNG)

### AWS Sagemaker for consuming S3 data

**Step 5**

- Open `AWS Sagemaker`.

- From the Sagemaker dashboard, click on the button `create a notebook instance`. I have already created one as shown below.

![plot5](https://duttashi.github.io/images/s3-5.PNG)

- click on `Open Jupyter` tab

**Step 6**

- In Sagemaker Jupyter notebook interface, click on the `New` tab (see screenshot) and choose the programming environment of your choice.

![plot6](https://duttashi.github.io/images/sagemaker-1.PNG)

**Step 7**

- Read the data in the programming environment. I have chosen `R` in step 6.

![plot7](https://duttashi.github.io/images/sagemaker-2.PNG)


### Accessing data in S3 bucket with python

There are two methods to access the data file;

1. The Client method
1. The Object URL method

See this [IPython notebook](https://github.com/duttashi/serverless/blob/master/scripts/S3/accessing%20data%20in%20s3%20bucket%20with%20python.ipynb) for details.

**AWS Data pipeline**

To build an AWS Data pipeline, following steps need to be followed;

- Ensure the user has the required `IAM Roles`. See this [AWS documentation](https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-get-setup.html)
- To use AWS Data Pipeline, you create a pipeline definition that specifies the business logic for your data processing. A typical pipeline definition consists of [activities](https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-concepts-activities.html) that define the work to perform, [data nodes](https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-concepts-datanodes.html) that define the location and type of input and output data, and a [schedule](https://docs.aws.amazon.com/datapipeline/latest/DeveloperGuide/dp-concepts-schedules.html) that determines when the activities are performed.


- 