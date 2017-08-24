
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
#Works even if the quote-open and quote-close symbols are the same.

quotes <- function(line,qopen,qclose){
  qsearch <- paste(c(qopen,"[^",qclose,"]+",qclose),collapse="")#regex for quoted expressions
  iquotes <- gregexpr(qsearch,line)#get quoted expressions
  startquote <- iquotes[[1]][1]#starting point of first quotation
  trans <- stringr::str_extract(line,qsearch)#pull out the first quotation
  rest <- str_trim(stringr::str_sub(line,1,startquote-1))#Everything before the quotation
  extra <- "" #If there's just one quote, then extra is empty
  if(length(iquotes[[1]])>1){#Otherwise, recursively call the function on the tail of the text
    qtail <- str_trim(stringr::str_sub(line,startquote+1,nchar(line)))#from the beginning of the first quote to end of line
    endquote <- gregexpr(qclose, qtail)[[1]][1]#Find the end of the quote
    ttail <- str_trim(stringr::str_sub(qtail,endquote+1,nchar(qtail)))#get the tail of the text
    extra <- quotes(ttail,qopen,qclose)#Recursively search for more quote/text pairs
  }
  return(c(rest,trans,extra))
}

l <- "R-gwe dizh Maria cwuan Jwany. HAB-speak word Maria COM Juan. 'Maria speaks with Juan.' Finally, here is an example with an intransitive verb: Gu-gaty Jwany lainy hospital. PERF.AND-die Juan in hospital. 'Juan went and died in a hospital.' YAY! 'Toodles.'"
res <- quotes(l,"'","'")

