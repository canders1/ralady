#Scrapes Zapotec examples from Brook Lillehaugen's dissertation

library(stringr)
source("~/scrapy/ralady/scripts/scrapers.R")

text <- readLines("~/scrapy/ralady/sources/brook_out2.txt")#read in text
text <- str_trim(text)
empty <- grep("^$",text)
text <- text[-empty]
nosend <- grep("^[0-9]*$",text)
outline <- grep("^ *[0-9]*\\.[0-9]",text)
pageheads <- union(nosend,outline)
if(length(pageheads)>0){
  text<- text[-pageheads]
}
subs <- grep("^[a-z]\\.",text)
starts <- grep("^[0-9]*\\.",text)
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

text <- stringr::str_replace_all(text, "^[0-9]*\\. ", "")
text <- str_trim(text)
text <- stringr::str_replace_all(text, "^[a-z]\\. ", "")
text <- str_trim(text)
quote <- grep("'.*'",text)
all <- c(1:length(text))
noquote <- setdiff(all,quote)
if(length(noquote)>0){
  text <- text[-noquote]
}

ungrammatical <- grep("\\*",text)#remove ungrammatical sentences
text <- text[-ungrammatical]
infelicitious <- grep("\\#",text)#remove infelicitious sentences
text <- text[-infelicitious]

splitt <- data.frame(Zap= character(0), Gloss=character(0), Trans=character(0),Lang=character(0),stringsAsFactors=FALSE)#create a dataframe
for(i in 1:length(text)){
  line <- text[i]
  line <- stringr::str_replace_all(line, "√", "")
  line <- str_trim(line)
  apos <- gregexpr("'",line)[[1]]
  trans <- substr(line, apos[length(apos)-1], apos[length(apos)])
  rest <- substr(line, 1, apos[length(apos)-1]-1)
  rest <- str_trim(rest)
  if(stringr::str_sub(rest,nchar(rest),nchar(rest))=="/"){
    tag <- substr(rest,apos[length(apos)-3],apos[length(apos)-2])
    trans <- paste(trans,tag,sep="/")
    rest <- substr(rest,1,apos[length(apos)-3]-1)
  }
  cite <- stringr::str_extract(rest, "\\(.*\\)")
  if(is.na(cite)){
    lang <- ""
  }else{
    rest <- stringr::str_replace_all(rest,"\\(.*\\)","")
    lang <- stringr::str_extract(cite, "[A-Z]+")
  }
  z <- stringr::str_split(rest," ")[[1]]#split data/gloss on whitespace
  indexes <- which(z == "")
  indexes
  if(length(indexes)>0){
    z <- z[-indexes]
  }
  if((length(z)%%2)==0){#if there's more than 1 word, assume there is a gloss
    len <- length(z)#calculate starting point of gloss
    half <- floor(len/2)
    zap <- str_trim(paste(z[1:half],collapse=" "))
    gloss <- str_trim(paste(z[-(1:half)],collapse=" "))
  }else{
    zap <- z[1]
    gloss <- ""
  }
  splitt[i,] <- rbind(zap,gloss,trans,lang)
}
splitt <- splitt[rowSums(is.na(splitt)) != ncol(splitt),]
write.table(splitt, "~/scrapy/ralady/cleaned_data/brook_data.csv", sep="\t")