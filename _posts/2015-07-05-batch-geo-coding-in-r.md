---
layout: post
title: Batch Geo-coding in R
date: 2015-07-05 02:34
excerpt: "Learn how to geocode geographical locations in R"
categories: blog
tags: [R, geocoding, preprocessing]
comments: true
share: true

---

Geocoding (sometimes called forward <b>geocoding</b>) is the process of enriching a description of a location, most typically a postal address or place name, with geographic coordinates from spatial reference data such as building polygons, land parcels, street addresses, postal codes (e.g. ZIP codes, CEDEX) and so on.

Google API for Geo-coding restricts coordinates lookup to 2500 per IP address per day. So if you have more than this limit of addresses then searching for an alternative solution is cumbersome.

The task at hand was to determine the coordinates of a huge number of addresses to the tune of over 10,000. 

The question was how to achieve this in R?

	> library(RgoogleMaps)
	> DF <- with(caseLoc, data.frame(caseLoc, t(sapply(caseLoc$caseLocation, getGeoCode))))
 	#caseLoc is the address file and caseLocation is the column header