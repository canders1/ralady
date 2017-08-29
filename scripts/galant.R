#Scrape Michel Galant's dissertation for Zapotec examples

library(stringr)
source("~/scrapy/ralady/scripts/scrapers.R")

text <- readLines("~/scrapy/ralady/sources/galant_out2.txt")#read in text
empty <- grep("^$",text)
text <- text[-empty]
text <- stringr::str_replace(text,"                            ","")
text <- stringr::str_replace(text,"\f","")
outline <- grep("^ *[0-9]*\\.[0-9]",text)
text <- text[-outline]
fulllines <- grep("^[aA-zZ]",text)
text <- text[-fulllines]
spacy <- grep("^ [aA-zZ]",text)
text <- text[-spacy]
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

quote <- grep("‘.*’",text)
all <- c(1:length(text))
noquote <- setdiff(all,quote)
if(length(noquote)>0){
  text <- text[-noquote]
}
ungrammatical <- grep("[*#]",text)#remove ungrammatical sentences
if(length(ungrammatical)>0){
  text <- text[-ungrammatical]
}

pairs <- c()
for(i in 1:length(text)){
  line <- text[i]
  full <- quotes(line, "‘","’")#Get text/quote pairs as a list
  indexes <- which(full == "")#Remove empty entries
  if(length(indexes)>0){
    full <- full[-indexes]
  }
  if(length(full)%%2==0){#If there is an uneven number of items, something has gone wrong
    pairs <- c(full,pairs)
  }
}
splitt <- data.frame(Zap= character(0), Gloss=character(0), Trans=character(0),Lang=character(0),stringsAsFactors=FALSE)#create a dataframe
for(p in 1:length(pairs)){#For each text/quote pair
    if(p%%2==1){#For each text item
      glossed <- glossFind(pairs[p],pairs[p+1])
      zap <- glossed[1]
      gloss <- glossed[2]
      trans <- glossed[3]
      splitt[p,] <- rbind(zap,gloss,trans,"")
    }
  }
splitt <- splitt[rowSums(is.na(splitt)) != ncol(splitt),]#Remove any empty rows
write.table(splitt, "~/scrapy/ralady/cleaned_data/galant_data.csv", sep="\t")
