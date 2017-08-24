
#Takes a list of recording filenames and returns a list of strings 
# where each string is the name of the speaker in the recording

speakerName <- function(lang,fileList){ 
    resList <- stringr::str_replace(fileList,lang,"")
    resList <- stringr::str_replace_all(resList,"_","")
    resList <- stringr::str_extract(resList,"[aA-zZ]+")
    return(resList)
  }

#exList <- c("SLQZ_27_Felipe","SLQZ_FElipe_28","1__SLQZ_ROSA.wav")
#speakerName("SLQZ",exList)

#Takes a line of text, a quotation open symbol, and a quotation close symbol
#Breaks the line on quoted expressions
#Returns a list of strings, where each pair of elements is the text associated with a 
#quoted expression followed by the quoted expression
#This is useful for separating translations from the original language data/linguistic glossing
#in a data point.

quotes <- function(line,qopen,qclose){
  qsearch <- paste(c(qopen,"[^",qclose,"]+",qclose),collapse="")#build a regex for quoted expressions
  iquotes <- gregexpr(qsearch,line)#get quoted expressions
  startfirstquote <- iquotes[[1]][1]#starting point of quote
  trans <- stringr::str_extract(line,qsearch)
  #cat(trans)
  rest <- str_trim(stringr::str_sub(line,1,startfirstquote-1))
  extra <- ""
  if(length(iquotes[[1]])>1){
    nextquote <- iquotes[[1]][2]
    tail <- str_trim(stringr::str_sub(line,startfirstquote,nchar(line)))
    endsearch <- paste(c("[^",qclose,"]",qclose),collapse="")
    endfirst <- gregexpr(endsearch, tail)
    endfirstquote <- endfirst[[1]][1]
    newline <- str_trim(stringr::str_sub(tail,endfirst[[1]][1]+2,nchar(line)))
    extra <- quotes(newline,qopen,qclose)
  }
  return(c(rest,trans,extra))
}

