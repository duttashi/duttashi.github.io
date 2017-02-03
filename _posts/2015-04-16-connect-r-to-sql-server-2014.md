---

layout: post

title: Connect R to SQL Server 2014

date: 2015-04-16 16:58

comments: true

categories: [Environment Setup]

tags: R

---
For a long time, I had been traversing a long winding road for data extraction from SQL Server. Initially, I was using MS BI Studio to connect MS SQL Server to Excel to extract data from SQL Server and write it to .csv format. Which was then imported into R data frame. This process was indeed cumbersome to me. My recent involvement with R and its majestic features have indeed got me hooked to it. So, to cut the story short in this post we will see how to connect R to SQL Server 2014 and manipulate the SQL database tables in R data frames. So let’s get started.

<strong>Creating an ODBC DSN Data Source</strong>
The first time you connect R to your SQL Server instance you need to perform a few one-time set up tasks as follows;

1. Create an ODBC DSN data source
2. Install the necessary R ODBC package from CRAN

a. Create DSN

First we need to setup a user DSN data source pointing at our SQL Server using ODBC. The data source will be called from R using the package “RODBC”

b. Open “Administrative Tools” and “ODBC Data Sources (32 bit)”

![image](https://duttashi.github.io/images/admin-tools.png)

c. On the tab “User DSN” press “Add”

d. Select “SQL Server” in the provider list

![image](https://duttashi.github.io/images/pic-2.png)

e. Now give the data source a name and a description. Remember this name – you will need it later on in the process. Last provide the name of the server where the SQL Server is installed. Press “Next”.

![image](https://duttashi.github.io/images/pic-3.png)

f. Select the way in which you will authenticate against the SQL Server. In this case we use the default settings as shown below and click “Next”.

![image](https://duttashi.github.io/images/pic-4.png)

g. You now have the possibility to select the default database for the data source. What this means is that first put a check mark on "Change the default database to" and then click on the drop down arrow besides it and select your database name that you have created in SQL Server. Press “Next” and the “Finish”.

![image](https://duttashi.github.io/images/pic-5.png)

h. On the last page remember to press the “Test Data Source” button and ensure that the connection could be established. 

![image](https://duttashi.github.io/images/connected.png)

i. The User DSN is now created and active.

<strong>Install and load RODBC</strong>

<span style="text-decoration:underline;">Step 2:</span>

1. Support for SQL Server is not possible using native R – therefore we have to install the RODBC package from CRAN. Open up R and in the console window type:
	> install.packages(“RODBC”) 

![image](https://duttashi.github.io/images/install-rodbc.png)

2. The RODBC packages is now downloaded and installed on your system. Next step is to load the package into R so the functions of the package can be used. In the console window type: 

	> library(“RODBC”)

![image](https://duttashi.github.io/images/load-rodbc.png)

The RODBC package is now loaded and is ready

<strong>Connect SQL Server 2014 with R</strong>

<span style="text-decoration:underline;">Step 3:</span> Now it is time to connect to the SQL Server database from R and retrieve a table

So for this example, I opened the connection like

	> odbChannel=odbcConnect("YourDatabaseName")

![image](https://duttashi.github.io/images/establishconn.png)

Now if you want to store your SQL Server database table to a data frame in R, it’s easy. Use the sqlFetch() command like given

	> dataframeName=sqlFetch(odbChannel, “Your database table name”)

![image](https://duttashi.github.io/images/sqlfetch.png)

To get help on RODBC package use the RShowDoc command as follows

	> RShowDoc (“RODBC”, package=”RODBC”)
This will open up the pdf help version of RODBC package

To see what all tables as there in the database use sqlTables command as follows

	> sqlTables (odbChannel, tableType=”TABLE”)

To execute a SQL query and store the result in a R data frame use the sqlQuery() function like

	> dataFrameName=sqlQuery (odbChannel, “select * from tableName”)

I hope this tutorial helped you in connecting R with SQL Server 2014. 

Cheers!
