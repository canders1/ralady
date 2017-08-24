#Scrape Michel Galant's dissertation for Zapotec examples

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
splitt <- data.frame(Zap= character(0), Gloss=character(0), Trans=character(0),Lang=character(0),stringsAsFactors=FALSE)#create a dataframe

for(i in 1:length(text)){
  line <- text[i]
  apos <- gregexpr("‘.*’",line)[[1]]
  trans <- stringr::str_extract(line,"‘[^’]+’")
  rest <- str_trim(stringr::str_sub(line,1,apos-1))
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
    splitt[i,] <- rbind(zap,gloss,trans,"")
  }else{
    if(length(z)==1){
      splitt[i,] <- rbind(z[1],"",trans,"")
    }
  }
}
splitt <- splitt[rowSums(is.na(splitt)) != ncol(splitt),]
write.table(splitt, "~/scrapy/ralady/cleaned_data/galant_data.csv", sep="\t")
```

nos <- grep("^[^0-9“”]",text)#remove lines that don't start with numbers
if(length(nos)>0){
  text <- text[-nos]
}
qs <- grep("^“",text)#Find lines that start with fancy quotes (i.e., translations that got cut)
for(i in 1:length(qs)){
  prev <- qs[i]-1
  text[prev] <- paste(text[prev],text[qs[i]])#reunite quotes with their example sentences
}
text <- text[-qs]
ls <- grep("“",text)
newtext<- vector(mode="character", length=length(ls))
for(i in 1:length(ls)){
  newtext[i] <- text[ls[i]]
}
cites <- grep("\\(.*[0-9][0-9][0-9][0-9].*\\)",newtext)#find cites (likely non-zapotec data points)
munro <- grep("\\(.*Munro",newtext)#remove those cited from other Zapotec scholars
nmcites <- setdiff(cites,munro)
newtext <- newtext[-nmcites]
secs <- grep("^[0-9]+\\.[0-9]+",newtext)#remove section headings with periods
newtext <- newtext[-secs]
secs2 <- grep("^[0-9]+ [aA-zZ]",newtext)#remove section headings without periods
newtext <- newtext[-secs2]
ungrammatical <- grep("\\*",newtext)#remove ungrammatical sentences
newtext <- newtext[-ungrammatical]
infelicitious <- grep("\\#",newtext)#remove infelicitious sentences
newtext <- newtext[-infelicitious]
splitt <- data.frame(Zap= character(0), Gloss=character(0), Trans=character(0),stringsAsFactors=FALSE)#create a dataframe