---

layout: post
title: Building a data pipeline: uploading external data in AWS S3.
date: 2019-08-07
share: true
excerpt: "In this post, I have suggested some preliminary steps for building a data pipeline in AWS S3. "
categories: blog
tags: [AWS S3, AWS Sagemaker, R]
comments: true
published: true

---

### Building a data pipeline: uploading external data in AWS S3.

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
