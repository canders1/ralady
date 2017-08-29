#Scrapes Pamela Munro's definiteness paper for Zapotec examples
#Outputs data to csv

library(stringr)
source("~/scrapy/ralady/scripts/scrapers.R")

text <- readLines("~/scrapy/ralady/sources/def_out.txt")#read in text
text <- stringr::str_replace(text,"\f","")
empty <- grep("^$",text)
text <- text[-empty]
justno <- grep("^[ ]*[0-9]+[ ]*$",text)
text <- text[-justno]
text <- stringr::str_replace(text,"    ","")
fulllines <- grep("^[aA-zZ]",text)
text <- text[-fulllines]
secs <- grep("^[0-9]",text)
text <- text[-secs]
twospace <- grep("^  [A-Z]",text)
text <- text[-twospace]
text <- str_trim(text)

subs <- grep("^[a-z]\\.",text)
starts <- grep("^\\([0-9]*\\)",text)
cands <- union(subs,starts)
cands <- sort(cands)

text <- exampleSearch(text,cands,8)

text <- stringr::str_replace_all(text, "^\\([0-9]*\\)", "")
text <- str_trim(text)
text <- stringr::str_replace_all(text, "^[a-z]\\.", "")
text <- str_trim(text)
text <- stringr::str_replace(text,"^—","")
text <- str_trim(text)
quote <- grep("‘.*’",text)
all <- c(1:length(text))
noquote <- setdiff(all,quote)
if(length(noquote)>0){
  text <- text[-noquote]
}
ungrammatical <- grep("\\*",text)#remove ungrammatical sentences
text <- text[-ungrammatical]
pairs <- c()
for(i in 1:length(text)){
  line <- text[i]
  full <- quotes(line,"‘","’")
  indexes <- which(full == "")
  if(length(indexes)>0){
    full <- full[-indexes]
  }
  if(length(full)%%2==0){#If there is an uneven number of items, something has gone wrong
    pairs <- c(full,pairs)
  }
}
splitt <- data.frame(Zap= character(0), Gloss=character(0), Trans=character(0),Lang=character(0),stringsAsFactors=FALSE)#create a dataframe
for(p in 1:length(pairs)){
    if(p%%2==1){
      glossed <- glossFind(pairs[p],pairs[p+1])
      zap <- glossed[1]
      gloss <- glossed[2]
      trans <- glossed[3]
      splitt[p,] <- rbind(zap,gloss,trans,"SLQZ")
    }
  }
splitt <- splitt[rowSums(is.na(splitt)) != ncol(splitt),] #remove rows that are all NA
write.table(splitt, "~/scrapy/ralady/cleaned_data/def_data.csv", sep="\t") #output to csv