---

layout: post
title: Scraping twitter data to visualize trending tweets in Kuala Lumpur
date: 2018-10-01
share: true
excerpt: "In this post, I've scraped twitter data to search some hash-tags and visualized them. "
categories: blog
tags: [data analysis, R, visualization, web scraping]
comments: true
published: true

---


*(Disclaimer: I've no grudge against python programming language per se. I think its equally great. In the following post, I'm merely recounting my experience.)*

It's been quite a while since I last posted. The reasons are numerous, notable being, unable to decide which programming language to choose for web data scraping. The contenders were data analytic maestro, `R` and data scraping guru, `python`. So, I decided to give myself some time to figure out which language will be best for my use case. My use case was, *Given some search keywords, scrape twitter for related posts and visualize the result*. First, I needed the *live data*. Again, I was at the cross-roads, "R or Python". Apparently python has some great packages for twitter data streaming like `twython`,`python-twitter`, `tweepy` and [twint](https://github.com/twintproject/twint) (*Acknowledgment: The library twint was suggested by a reader. See comments section*). Equivalent R libraries are `twitteR`,`rwteet`. I chose the `rtweet` package for data collection over python for following reasons;

- I do not have to create a `credential file` (unlike in python) to log in to my twitter account. However, you do need to authenticate the twitter account when using the `rtweet` package. This authentication is done just once if using the `rtweet` package. Your twitter credentials will be stored locally.
- Coding and code readability is far more easier as compared to python.
- The `rtweet` package allows for multiple hash tags to be searched for.
- To localize the data, the package also allows for specifying geographic coordinates.

So, using the following code snippet, I was able to scrape data. The code has following parts;

1. A custom search for tweets function which will accept the search string. If search string is `NULL`, it will throw a message and stop, else it will search for hash tags specified in search string and return a data frame as output.

	library(rtweet)
	library(tidytext)
	library(tidyverse)
	library(stringr)
	library(stopwords)
	library(rtweet) # for search_tweets()

2. A data frame containing the search terms. Note, here my search hash-tags are `KTM`, `MRT` and `monorail`. 

Create a function that will accept multiple hashtags and will search the twitter api for related tweets

	search_tweets_queries <- function(x, n = 100, ...) {
	  ## check inputs
	  stopifnot(is.atomic(x), is.numeric(n))
	  if (length(x) == 0L) {
	    stop("No query found", call. = FALSE)
	  }  
	  ## search for each string in column of queries
	  rt <- lapply(x, search_tweets, n = n, ...)
	  ## add query variable to data frames
	  rt <- Map(cbind, rt, query = x, stringsAsFactors = FALSE)
	  ## merge users data into one data frame
	  rt_users <- do.call("rbind", lapply(rt, users_data))
	  ## merge tweets data into one data frame
	  rt <- do.call("rbind", rt)
	  ## set users attribute
	  attr(rt, "users") <- rt_users
	  ## return tibble (validate = FALSE makes it a bit faster)
	  tibble::as_tibble(rt, validate = FALSE)
	}

3. Using the `search_tweets_queries` defined in step 1, to search for tweets. Note, the usage of `retryonratelimit=TRUE` indicates if search rate limit reached, then the crawler will sleep for a while and start again. Refer to the `rtweet` [documentation](https://rtweet.info/) for more information.

		df_query <- data.frame(query = c("KTM", "monorail","MRT"),
	  	  n = rnorm(3), # change this number according to the number of searchwords in parameter query. As of now, the parameter got 3 keywords, therefore this nuber is set to 3.
		  stringsAsFactors = FALSE
	)

		df_collect_tweets <- search_tweets_queries(df_query$query, include_rts = FALSE,retryonratelimit = TRUE, 
	    #geocode for Kuala Lumpur
	    geocode = "3.14032,101.69466,93.5mi")

4. Once the data is collected, I'll keep some selected columns only.

		df_select_tweets<- df_collect_tweets %>%
		  select(c(user_id,created_at,screen_name, !is.na(hashtags),text,
		   source,display_text_width>0,lang,!is.na(place_name),
		   !is.na(place_full_name),
		   !is.na(geo_coords), !is.na(country), !is.na(location),
		   retweet_count,account_created_at, account_lang, query)
		 )

5. **Text mining**: The collected data need to be cleaned. Therefore, I've used the basic `gsub()` function and `str_replace_all()` from the `stringr` library.

	    # Saving the selected columns data
	    > df_select_tweets_1 = data.frame(lapply(df_select_tweets, as.character), stringsAsFactors=FALSE)
	    ### Text preprocessing
	    
	    # 1. Remove URL from text
	    # collapse to long format
	    > clean_tweet<- df_select_tweets_1
	    
	    #clean_tweet<- paste(df_select_tweets_1, collapse=" ")
	    > clean_tweet$text = gsub("&amp", "", clean_tweet$text)
	    > clean_tweet$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet$text)
	    > clean_tweet$text = gsub("@\\w+", "", clean_tweet$text)
	    > clean_tweet$text = gsub("[[:punct:]]", "", clean_tweet$text)
	    > clean_tweet$text = gsub("[[:digit:]]", "", clean_tweet$text)
	    > clean_tweet$text = gsub("http\\w+", "", clean_tweet$text)
	    > clean_tweet$text = gsub("[ \t]{2,}", "", clean_tweet$text)
	    > clean_tweet$text = gsub("^\\s+|\\s+$", "", clean_tweet$text)

		#get rid of unnecessary spaces
		> clean_tweet$text <- str_replace_all(clean_tweet$text," "," ")
		# Get rid of URLs
		> clean_tweet$text<- str_replace_all(clean_tweet$text, "https://t.co/[a-z,A-Z,0-9]*","")
		> clean_tweet$text<- str_replace_all(clean_tweet$text, "http://t.co/[a-z,A-Z,0-9]*","")
		# Take out retweet header, there is only one
		> clean_tweet$text <- str_replace(clean_tweet$text,"RT @[a-z,A-Z]*: ","")
		# Get rid of hashtags
		> clean_tweet$text <- str_replace_all(clean_tweet$text,"#[a-z,A-Z]*","")
		# Get rid of references to other screennames
		> clean_tweet$text <- str_replace_all(clean_tweet$text,"@[a-z,A-Z]*","") 

	
	a. Next, I'll use the `tidytext` library for `token` extraction

	    # Unnest the tokens
	    > df.clean<- clean_tweet %>%
	      unnest_tokens(word, text)
	    
	    > clean_tweets<- tibble()
	    > clean_tweets<- rbind(clean_tweets, df.clean)
	    
	    # Basic calculations
	    # calculate word frequency
	    > word_freq <- clean_tweets %>%
	      count(word, sort=TRUE)
	    > word_freq 

		# A tibble: 5,291 x 2
		   wordn
		   <chr>   <int>
		 1 mrt   596
		 2 ktm   582
		 3 ke455
		 4 kl259
		 5 ni251
		 6 naik  221
		 7 the   214
		 8 at208
		 9 sentral   195
		10 nak   193
		# ... with 5,281 more rows

	b. It should be noted, the national language of Malaysia is `Bahasa Melayu (BM)`. To remove the stop words in BM, I've used the `stopwords` library. lots of stop words like the, and, to, a etc. Let's remove the stop words. We can remove the stop words from our tibble with anti_join and the built-in stop_words data set provided by tidytext.

	    > clean_tweets %>%
	      # remove the stopwords in Bahasa Melayu (BM). Use `ms` for BM. See this reference for other language codes: https://en.wikipedia.org/wiki/ISO_639-1
	      anti_join(get_stopwords(language="ms", source="stopwords-iso")) %>%
	      # remove the stopwords in english
	      anti_join(get_stopwords(language="en", source="stopwords-iso")) %>%
	      count(word, sort=TRUE) %>%
	      top_n(10) %>%
	      ggplot(aes(word,n, fill=word))+
	      geom_bar(stat = "identity")+
	      xlab(NULL)+
	      ylab(paste('Word count'))+
	      ggtitle(paste('Most common words in tweets')) +
	      theme(legend.position="none") +
	      theme_minimal()+
	      coord_flip()

6. Finally, I present a basic bar plot to show the trending words.

    ![kl_tweets](https://i.imgur.com/TpBec4E.png)
	Barplot: Trending twitter words in kuala lumpur, malaysia

#### Area's of further improvement
- How to extract tweets within a given time range?


See the code on my [Github account](https://github.com/duttashi/scrapers/blob/master/src/R/twitter_data_scraping_00.R)

    
    
    


  