library(streamR)
library(ROAuth)

setwd("~/Documents")
load("my_oauth.Rdata")

# Now set your working directory to the location where you would like to save
# the tweets you are about to collect:
setwd("~/scrapy/ralady/sources")

filterStream("tweets.json",
             track = c("#UsaTuVoz", "UsaTuVoz", "Zapoteco","#usatuvoz","Zapotec","todaslenguas","TodasLenguas"),
             timeout = 10000,
             oauth = my_oauth)

system("mutt -s \"All done\" canders277@gmail.com < ~/scrapy/rlady/sources/tweets.json")