setwd("~/Live-Session-Nutrifood-R/Kaggle Data/WC Qatar 2022")

rm(list=ls())

library(dplyr)
library(rvest)
library(jsonlite)
library(readxl)
library(RSelenium)  # web scraping

url_utama = "https://www.fifa.com/fifaplus/en/tournaments/mens/worldcup/qatar2022/scores-fixtures?country=ID&wtw-filter=ALL"

rm(list=ls())

options(scipen = 99)

match = "saudi v mexico"
json_ad = "https://fdh-api.fifa.com/v1/stats/match/133030/teams.json"

# ======================================================================
nama_rda = paste0(match,".rda")
nama_tim = strsplit(match,split = " ") %>% unlist()
nama_tim_1 = nama_tim[1]
nama_tim_2 = nama_tim[3]


tes = read_json(json_ad)
nama_var_1 = rep(NA,110)
nama_var_2 = nama_var_1
tim_1 = nama_var_1
tim_2 = nama_var_1

for(i in 1:110){
  nama_var_1[i] = tes[[2]][[i]][1] %>% as.character()
  tim_1[i] = tes[[2]][[i]][2] %>% as.numeric()
  
  nama_var_2[i] = tes[[3]][[i]][1] %>% as.character()
  tim_2[i] = tes[[3]][[i]][2] %>% as.numeric()
}

temp = matrix(NA,ncol = 110,nrow = 1) %>% as.data.frame()

# dataframe pertama
temp_1 = temp
colnames(temp_1) = nama_var_1
temp_1[1,] = tim_1
temp_1 = temp_1 %>% mutate(negara = nama_tim_1)
# dataframe kedua
temp_2 = temp
colnames(temp_2) = nama_var_2
temp_2[1,] = tim_2
temp_2 = temp_2 %>% mutate(negara = nama_tim_2)

final = bind_rows(temp_1,temp_2) %>% janitor::clean_names()

# final check
final$status = c("lose","win")
final %>% select(possession,goals,negara,status)

save(final,file = nama_rda)
