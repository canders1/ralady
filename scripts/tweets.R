#Zapotec tweets

library(jsonlite)
library(dplyr)      # for %>% and other dplyr functions
library(streamR)

tweets.df <- parseTweets("~/scrapy/ralady/sources/tweets.json",simplify = TRUE)

system("cat ~/scrapy/ralady/sources/def_out.txt")