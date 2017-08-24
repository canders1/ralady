#Reads in fieldwork data from csv files and combines data from multiple summers

library(plyr)
source("~/scrapy/ralady/scripts/scrapers.R")

#Read in csv files as dataframes
filename16 <- "~/scrapy/ralady/sources/2016data.csv"
df16 <- read.csv(filename16,stringsAsFactors=FALSE)
filename17 <- "~/scrapy/ralady/sources/2017data.csv"
df17 <- read.csv(filename17,stringsAsFactors=FALSE)

#Name columns
colnames(df17) <- c("rec","zap","trans","context","note")
colnames(df16) <- c("zap","trans","context","speaker","a","count","x")

#Find speaker names from recording names
df17$rec <- speakerName("SLQZ",df17$rec)
names(df17)[names(df17) == 'rec'] <- 'speaker'
df16$speaker <- speakerName("SLQZ",df16$speaker)

#Remove junk columns
df16 <- subset(df16, select = -c(a,count,x) )

#Join dataframes
df <- join(df16, df17, by = NULL, type = "full", match = "all")

#Output as csv
write.table(df, "~/scrapy/ralady/cleaned_data/field_data.csv", sep="\t")
