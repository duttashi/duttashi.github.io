---
layout: post
title: Installing Apache Spark on Windows 7 environment
date: 2015-06-11 18:10
share: true
excerpt: "Step wise instructions on installing apache spark on windows environment"
categories: blog
tags: [Apache Spark]
comments: true
published: true
categories: blog

---
Apache Spark is a lightening fast cluster computing engine conducive for big data processing. In order to learn how to work on it currently there is a MOOC conducted by UC Berkley <a href="https://courses.edx.org/courses/BerkeleyX/CS100.1x/1T2015/info">here</a>. However, they are using a pre-configured VM setup specific for the MOOC and for the lab exercises. But I wanted to get a taste of this technology on my personal computer. I invested two days searching the internet trying to find out how to install and configure it on a windows based environment. And finally, I was able to come up with the following brief steps that lead me to a working instantiation of Apache Spark.

To install Spark on a windows based environment the following prerequisites should be fulfilled first.

<strong>Requirement 1:</strong>
<ul>
	<li>If you are a Python user then Install Python 2.6+ or above otherwise this step is not required. If you are not a python user then you also do not need to setup the python path as the environment variable</li>
	<li>Download a pre-built Spark binary for Hadoop. I chose Spark release 1.2.1, package type Pre-built for Hadoop 2.3 or later from <a href="https://spark.apache.org/downloads.html">here</a>.</li>
	<li>Once downloaded I unzipped the *.tar file by using WinRar to the D drive. (You can unzip it to any drive on your computer)</li>
	<li>The benefit of using a pre-built binary is that you will not have to go through the trouble of building the spark binaries from scratch.</li>
	<li>Download and install Scala version 2.10.4 from <a href="http://www.scala-lang.org/download/" target="_blank">here</a> only if you are a Scala user otherwise this step is not required. If you are not a scala user then you also do not need to setup the scala path as the environment variable</li>
	<li>Download and install <a href="http://en.osdn.jp/projects/win-hadoop/downloads/62852/hadoop-winutils-2.6.0.zip/" target="_blank">winutils.exe</a> and place it in any location in the D drive. Actually, the official release of Hadoop 2.6 does not include the required binaries (like winutils.exe) which are required to run Hadoop. Remember, Spark is a engine built over Hadoop.</li>
</ul>
<strong>Setting up the PATH variable in Windows environment :</strong>

This is the most important step. If the Path variable is not properly setup, you will not be able to start the spark shell. Now how to access the path variable?
<ul>
	<li>Right click on Computer- Left click on Properties</li>
	<li>Click on Advanced System Settings</li>
	<li>Under Start up &amp; Recovery, Click on the button labelled as "Environment Variable"</li>
	<li>You will see the window divided into two parts, the upper part will read User variables for username and the lower part will read System variables. We will create two new system variables, So click on "New" button under System variable</li>
	<li>Set the variable name as[sourcecode language="R"]JAVA_HOME [/sourcecode]

(in case JAVA is not installed on your computer then follow these steps). Next set the variable value as the <code>JDK PATH</code>. In my case it is <code>'C:\Program Files\Java\jdk1.7.0_79\'</code>

(please type the path without the single quote)</li>
	<li>Similarly, create a new system variable and name it as</li>
<code>PYTHON_PATH</code>

Set the variable value as the Python Path on your computer. In my case it is <code> 'C:\Python27\' </code>

(please type the path without the single quote)</li>
	<li>Create a new system variable and name it as</li> 
<code>HADOOP_HOME</code>

Set the variable value as <code>C:\winutils</code> 

(Note: There is no need to install Hadoop. The spark shell only requires the Hadoop path which in this case holds the value to winutils that will let us compile the spark program on a windows environment.</li>
	<li>Create a new system variable and name it as </li> 
<code>SPARK_HOME </code>

Assign the variable value as the path to your Spark binary location. In my case it is in <code>'C:\SPARK\BIN'</code>

<span style="text-decoration:underline;"><strong>NOTE:</strong></span><strong> Apache Maven installation is an optional step. </strong>I am mentioning it here because I want to install SparkR a R version of Spark.
<ul>
	<li>Download Apache Maven 3.1.1 from <a href="https://maven.apache.org/download.cgi" target="_blank">here</a> 
	<li>Choose Maven 3.1.1. (binary zip) and unpack it using WinZip or WinRAR. Create a new system variable and name it as</li>
	
	MAVEN_HOME and M2_HOME 
</ul>
<strong> </strong>Assign the both these variables the value as the path to your Maven binary location. In my case it is in

	'D:\APACHE-MAVEN-3.1.1\BIN' 
so I have
 
	MAVEN_HOME=D:\APACHE-MAVEN-3.1.1\BIN 
and
 
	M2_HOME=D:\APACHE-MAVEN-3.1.1\BIN
Now, all you have to do is append these four system variables namely JAVA_HOME, PYTHON_PATH, HADOOP_HOME &amp; SPARK_HOME to your Path variable. Which can be done as follows

	%JAVA_HOME%\BIN; %PYTHON_PATH%; %HADOOP_HOME%; %SPARK_HOME%; %M2_HOME%\BIN %MAVEN_HOME%\BIN  
(Note: Do not forget to end each entry with a semi-colon) 

Click on Ok to close the Environment variable window and then similarly on System properties window.

<strong>How to start Spark on windows</strong>

To run spark on windows environment
<ol>
	<li>Open up the command prompt terminal</li>
	<li>Change directory to the location where the spark directory is. For example in my case its present in the D directory</li>
	<li>Navigate into the bin directory like cd bin</li>
	<li>Run the command spark-shell and you should see the spark logo with the scala prompt</li>
</ol>

![image](https://duttashi.github.io/images/spark-shell1.png)

![image](https://duttashi.github.io/images/spark-shell2.png)

<ol>
	<li>Open up the web browser and type localhost:4040 in the address bar and you shall see the Spark shell application UI<a href="https://edumine.files.wordpress.com/2015/06/spark-shell2.png">
</a></li>
</ol>

![image](https://duttashi.github.io/images/spark-ui.png)

<ol>
	<li>To quit Spark, at the command prompt type <code> exit</code> </li>
</ol> 

That is all to install and run a standalone spark cluster on a windows based environment. 

Cheers!