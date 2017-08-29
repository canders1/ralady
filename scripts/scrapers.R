
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
m <- "Zi:i’lly-ta’ nnyi’ihs gwe:e’eh Wsee. MUCKliq/gas-too water     perf.drink Jos6 ‘Josd drank too much water’ (IV-186)       (Te’ihby)-ze’cy-dya’     liebr nih b-zi:i:i’ Liieb, b-zi:i:i’ one-thus-MUCH book rel perf-buy Felipe perf-buy Rodriiegw. Rodrigo ‘Rodrigo bought as many books as Felipe bought’"
n <- "Nahll cafee. cold coffee ‘The coffee is cold’ If this order is reversed, the string will still be grammatical for those adjec 27 This could for example be the answer to the question in (i): (i) Xi n-a:a asu’all ? what neut-be blue ‘What’s blue?’"
o <- "Z-ya:all-a’    cehnn la:anng. def-come-lsg with 3sg ‘I came with him’ Native SLQZ prepositions are identical to body part words.21 One such ‘face’ but is used to introduce some locative (37) and dative (38) complements and"
res <- quotes(o,"‘","’")

#Takes two strings, where the first in the pair represented a line of original language and glossing, 
#and the second is the translation.
#Finds the division between language data if possible, and returns a list of 
#language data, gloss, translation.

glossFind <- function(p1,p2){
  trans <- p2#Get the quote
  rest <- str_trim(str_replace(p1, "^[^aA-zZ]+", ""))#Get the rest
  z <- stringr::str_split(rest," ")[[1]]#split data/gloss on whitespace
  indexes <- which(z == "")#Remove empty entries
  if(length(indexes)>0){
    z <- z[-indexes]
  }
  if((length(z)%%2)==0){#if there's more than 1 word, assume there is a gloss
    len <- length(z)#calculate starting point of gloss
    half <- floor(len/2)
    lang <- str_trim(paste(z[1:half],collapse=" "))
    gloss <- str_trim(paste(z[-(1:half)],collapse=" "))
  } else{
    lang <- str_trim(paste(z,collapse=" "))
    gloss <- ""
  }
  return(c(lang,gloss,trans))
}

p1 <- "R-gwe dizh Maria cwuan Jwany. HAB-speak word Maria COM Juan."
p2 <- "'Maria speaks with Juan.'"
q1 <- "Finally, here is an example with an intransitive verb: Gu-gaty Jwany lainy hospital. PERF.AND-die Juan in hospital."
q2 <- "'Juan went and died in a hospital.' "

#This function takes a list of strings corresponding to lines in a text, and
# a list of indices that indicate lines that contain the start of an example sentence.
#It looks at X lines below each index and concatenates onto the line, in case parts of the example
#sentence occur below the example sentence start indicator.
#It requires a user-supplied window size.
#It returns the text list modified to contain only lines with example sentences.

exampleSearch <- function(textList, indices, window){
  newText <- c()
  for(i in 1:length(indices)){
    curr <- indices[i]
    if(i < length(indices)){
      neigh <- indices[i+1]
      if((neigh-curr)>window){
        end <- curr+window-1
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
      added <- textList[curr:end]
      newText<- c(newText,paste(added, sep=" ", collapse=" "))
    }
  }
  return(newText)
}

