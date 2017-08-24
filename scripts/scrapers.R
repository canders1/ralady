
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

