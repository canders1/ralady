#Combine data from multiple talking dictionaries into one csv

langlist <- c("slqz","tlac","tlaco","teo","msbl")#List of languages

#Create an empty dataframe
corpus <- data.frame(zap= character(0), ipa=character(0), trans=character(0),lang=character(0),stringsAsFactors=FALSE)
for(i in 1:length(langlist)){#For each language,
  lang <- langlist[i]
  df <- read.csv(paste(c("~/scrapy/ralady/sources/",lang,"_talkdict.csv"),collapse=""))#Get the csv
  df <- subset(df, select = -c(prev,sourcepage) )#Delete junk columns
  df <- unique(df)#Delete duplicate rows
  df$source <- lang #source is now language name
  names(df)[names(df) == 'source'] <- 'lang'
  df <- subset(df, select = -c(id) )#Delet id column
  corpus <- rbind(corpus,df)#Combine with other corpora
}

write.table(df, "~/scrapy/ralady/cleaned_data/all_dict_data.Rdata", sep="\t")#Output to csv