#Zapotec tweets

library(jsonlite)
library(dplyr)      # for %>% and other dplyr functions
library(streamR)

data <- read.csv("~/Desktop/tweets.json")
tweets.df <- parseTweets("~/Desktop/tweets_copy.json",simplify = TRUE)