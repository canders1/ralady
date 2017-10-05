#Zapotec tweets

library(jsonlite)
library(dplyr)      # for %>% and other dplyr functions
library(streamR)

tweets.df <- parseTweets("~/scrapy/ralady/sources/tweets.json",simplify = TRUE)
str <- ""
for(line in tweets.df$text){
  str <- paste0(str,line,sep="\n")
}
print(str)
