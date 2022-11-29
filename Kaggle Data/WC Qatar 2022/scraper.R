setwd("/cloud/project/Kaggle Data/WC Qatar 2022")

rm(list=ls())

library(dplyr)
library(rvest)
library(jsonlite)
library(readxl)
library(RSelenium)  # web scraping

rm(list=ls())

options(scipen = 99)

# qatar equador
json_ad = "https://fdh-api.fifa.com/v1/stats/match/128084/teams.json"
tes = read_json(json_ad)
nama_var_1 = rep(NA,110)
nama_var_2 = nama_var_1
tim_1 = nama_var_1
tim_2 = nama_var_1
for(i in 1:110){
  nama_var_1[i] = tes$`43834`[[i]][1] %>% as.character()
  tim_1[i] = tes$`43834`[[i]][2] %>% as.numeric()
  nama_var_2[i] = tes$`43927`[[i]][1] %>% as.character()
  tim_2[i] = tes$`43927`[[i]][2] %>% as.numeric()
}

temp = matrix(NA,ncol = 110,nrow = 1) %>% as.data.frame()

temp_1 = temp
colnames(temp_1) = nama_var_1
temp_1[1,] = tim_1
temp_1 = temp_1 %>% mutate(negara = "Qatar")

temp_2 = temp
colnames(temp_2) = nama_var_2
temp_2[1,] = tim_2
temp_2 = temp_2 %>% mutate(negara = "Equador")

final = bind_rows(temp_1,temp_2) %>% janitor::clean_names()


final %>% select(goals,negara)

save(final,file = "qatar v equador.rda")
