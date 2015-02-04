---
title       : Flight Delay Prediction
subtitle    : 
author      : Tim Boomer
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<style>
.title-slide {background-color: #FFF}
</style>

## Overview

Travelers making flight arrangements often have to consider the probability of cancellation or delay  when planning travel to a scheduled event. This application provides a summary based on historical on-time data to help the traveller assess the risk of a delay or cancellation. The following slides set out:

- Flight Data Source and Preparation
- Input Factor Selection
- Potential Enhancements

---

## Flight Data Source and Preparation
The US Department of Transportation Bureau of Transportation Statistics gathers data on virtually all scheduled flights between points in the United States and territories.

- Flight data from December 2013 through November 2014 was downloaded from the DOT website into monthly zip files.
- The data was compiled into a dataframe of 5.86 million flights. The script is not embedded in this presentation but can be viewed [DataPrep.R](https://github.com/tboomer/FlightDelay)
- For the purposes of this analysis and application, flight outcomes were grouped into four categories: On-time, Delayed, Diverted, or Cancelled
- The data was subset twice because of performance issues. Fields were reduced to only those required by the application because of shiny.io storage limits and the number of airports and carriers was minimized because shiny.io would freeze during the calculations.

---

## Input Factor Selection

Different parameters were reviewed to determine which ones to use for user selection. For example.





![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-3-1.png) 

---

## Potential Enhancements

Several UI enhancements were identified but not yet implemented because of the time required debugging the application and slidify.

- Improve error handling when no flights match the search criteria
- Add a lookup of carrier and airport codes

Possible functionality enhancements include:

- Chunking and aggregating data to improve performance and allow an expanded range of airports and carriers to be supported.
- Add conditional criteria such as "is there a departure delay?"



