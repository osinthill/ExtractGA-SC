options(java.parameters = c("-XX:+UseConcMarkSweepGC", "-Xmx8192m"))
library(googleAnalyticsR)
library(janitor)
library(googlesheets)
library(tidyverse)
library(xlsx)
library(data.table)

ga_auth()
MyView <- ga_account_list()
id <- 00000000 #PUT THE ID OF YOUR GA ACCOUNT

# FILTRES
fc2 <- filter_clause_ga4(list(dim_filter("medium", 
                                         "REGEXP", 
                                         "organic")
))

delta_sess <- order_type("sessions","DESCENDING")




Q3 <- google_analytics(id, c("2019-01-01", "2019-01-02"),
                                 dimensions=c('date','deviceCategory','landingPagePath'),
                                 metrics = c('sessions'),
                                 dim_filters = fc2,
                                 anti_sample = TRUE,
                                 order = delta_sess,
                                 anti_sample_batch = 1)



#SEARCH CONSOLE

library(searchConsoleR)
scr_auth()
data <- search_analytics("https://www.example.com",
                         "2017-04-01", "2017-09-01",
                         c("date","query","page"), 
                         walk_data = "byDate",
                         searchType="web")



#WRITE CSV#
GA = as.data.frame(Q3)
SC = as.data.frame(data)


fwrite(GA, "SEO Performance CSV - GA.csv")
fwrite(SC, "SEO Performance CSV - SC.csv")



#COMBINE CSV#

setwd("Y:/Patch/CSV/files/")

files  <- list.files(pattern = '\\.csv')
tables <- lapply(files, read.csv, header = TRUE)
combined.df <- do.call(rbind , tables)
s <- sapply(combined.df, is.numeric)

write.csv(combined.df, file = "all.csv")





