setwd("/cloud/project/Kaggle Data/WC Qatar 2022")

rm(list=ls())

library(dplyr)
library(tidyr)
library(rvest)
library(RSelenium)

url = "https://www.fifa.com/fifaplus/en/match-centre/match/17/255711/285063/400128082?country=ID&wtw-filter=ALL"


# version chrome
version = "107.0.5304.62"

library(wdman)

# start phantomjs instance
rPJS <- wdman::phantomjs(port = 4680L)

# is it alive?
rPJS$process$is_alive()

#connect selenium to it?
rJS <- RSelenium::remoteDriver(browserName="phantomjs", port=4680L)

# open a browser
rJS$open()

left_team = 
  url %>% 
  read_html() %>% 
  html_nodes(".ff-ml-20") %>% 
  html_text()

right_team = 
  url %>% 
  read_html() %>% 
  html_nodes(".ff-mr-20") %>% 
  html_text()

atributes = 
  url %>% 
  read_html() %>% 
  html_nodes(".ff-mt-20 .ff-mb-8") %>% 
  html_text()

