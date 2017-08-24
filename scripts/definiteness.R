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
for(i in 1:length(cands)){
  curr <- cands[i]
  if(i < length(cands)){
    neigh <- cands[i+1]
    if((neigh-curr)>8){
      end <- curr+7
    }
    else{
      if((neigh-curr)>2){
        end <- neigh-1
      }else{
        if((neigh-curr)>1){
          end <- curr+1
        }else{
          end <- curr
        }
      }
    }
    added <- text[curr:end]
    text[curr]<- paste(added, sep=" ", collapse=" ")
  }
}
all <- c(1:length(text))
negs <- setdiff(all,cands)
if(length(negs)>0){
  text <- text[-negs]
}

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
splitt <- data.frame(Zap= character(0), Gloss=character(0), Trans=character(0),Lang=character(0),stringsAsFactors=FALSE)#create a dataframe
for(i in 1:length(text)){
  line <- text[i]
  full <- quotes(line,"‘","’")
  indexes <- which(full == "")
  if(length(indexes)>0){
    full <- full[-indexes]
  }
  for(p in 1:length(full)){
    if(p%%2==1){
      trans <- full[p+1]
      rest <- full[p]
      z <- stringr::str_split(rest," ")[[1]]#split data/gloss on whitespace
      indexes <- which(z == "")
      if(length(indexes)>0){
        z <- z[-indexes]
      }
      if((length(z)%%2)==0){#if there's more than 1 word, assume there is a gloss
        len <- length(z)#calculate starting point of gloss
        half <- floor(len/2)
        zap <- str_trim(paste(z[1:half],collapse=" "))
        gloss <- str_trim(paste(z[-(1:half)],collapse=" "))
        splitt[i,] <- rbind(zap,gloss,trans,"SLQZ")
      }else{
        splitt[i,] <- rbind(str_trim(paste(z,collapse=" ")),"",trans,"SLQZ")
      }
    }
  }
}
splitt <- splitt[rowSums(is.na(splitt)) != ncol(splitt),] #remove rows that are all NA
write.table(splitt, "~/scrapy/ralady/cleaned_data/def_data.csv", sep="\t") #output to csv