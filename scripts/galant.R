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

quote <- grep("‘.*’",text)
all <- c(1:length(text))
noquote <- setdiff(all,quote)
if(length(noquote)>0){
  text <- text[-noquote]
}
ungrammatical <- grep("\\*",text)#remove ungrammatical sentences
text <- text[-ungrammatical]
infelicitious <- grep("\\#",text)#remove infelicitious sentences
text <- text[-infelicitious]
pairs <- c()
for(i in 1:length(text)){
  line <- text[i]
  full <- quotes(line, "‘","’")#Get text/quote pairs as a list
  indexes <- which(full == "")#Remove empty entries
  if(length(indexes)>0){
    full <- full[-indexes]
  }
  if(length(full)%%2==0){
    pairs <- c(full,pairs)
  }
}
splitt <- data.frame(Zap= character(0), Gloss=character(0), Trans=character(0),Lang=character(0),stringsAsFactors=FALSE)#create a dataframe
for(p in 1:length(pairs)){#For each text/quote pair
    if(p%%2==1){#For each text item
      trans <- pairs[p+1]#Get the quote
      rest <- str_trim(str_replace(pairs[p], "^[,/->—»]+", ""))#Get the rest
      z <- stringr::str_split(rest," ")[[1]]#split data/gloss on whitespace
      indexes <- which(z == "")#Remove empty entries
      if(length(indexes)>0){
        z <- z[-indexes]
      }
      if((length(z)%%2)==0){#if there's more than 1 word, assume there is a gloss
        len <- length(z)#calculate starting point of gloss
        half <- floor(len/2)
        zap <- str_trim(paste(z[1:half],collapse=" "))
        gloss <- str_trim(paste(z[-(1:half)],collapse=" "))
        splitt[p,] <- rbind(zap,gloss,trans,"")#Enter into dataframe (index has to take into account double text/quote pairs per line)
      } else{
        splitt[p, ] <- rbind(str_trim(paste(z,collapse=" ")), "", trans, "")
      }
    }
  }
splitt <- splitt[rowSums(is.na(splitt)) != ncol(splitt),]#Remove any empty rows
write.table(splitt, "~/scrapy/ralady/cleaned_data/galant_data.csv", sep="\t")
