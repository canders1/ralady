#Script for scraping Felicia Lee's dissertation for Zapotec examples

library(stringr)

text <- readLines("~/scrapy/ralady/sources/lee.txt")#read in text
#head(text, 50)
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
ungrammatical <- grep("[#*]",newtext)#remove ungrammatical sentences
newtext <- newtext[-ungrammatical]
splitt <- data.frame(Zap= character(0), Gloss=character(0), Trans=character(0),stringsAsFactors=FALSE)#create a dataframe
for(i in 1:length(newtext)){
  t <- newtext[i]
  t <- stringr::str_replace_all(t,"[0-9]*\\.", "")#remove numbering
  lines <- stringr::str_split(t, "“")#split the translation off
  lines[[1]] <-  stringr::str_replace_all(lines[[1]],"[\\[\\]\n\",”]","")#clean up punctuation
  lines[[1]] <- str_trim(lines[[1]])#trim trailing whitespace
  trans <- lines[[1]][[2]]
  z <- stringr::str_split(lines[[1]][[1]]," ")#split data/gloss on whitespace
  indexes <- which(z == "")
  if(length(indexes)>0){
    z <- z[-indexes]
  }
  if(length(z)>0){#if there's more than 1 word, assume there is a gloss
    length <- length(z[[1]])#calculate starting point of gloss
    half <- length/2
    zap <- paste(z[[1]][-(half+1:length)],collapse = " ")
    gloss <- paste(z[[1]][-(1:half)],collapse = " ")
  }else{
    zap<- ""
    gloss <- ""
  }
  splitt[i,] <- rbind(zap,gloss,trans)
}