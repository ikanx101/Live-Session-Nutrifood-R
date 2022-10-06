rm(list=ls())

library(dplyr)
library(rvest)
library(txtplot)

url = "https://www.worldometers.info/coronavirus/"

tabel = url %>% read_html() %>% html_table(fill = T)

df = tabel[[1]] %>% janitor::clean_names()
df %>% 
  filter(!is.na(number)) %>% 
  mutate(new_cases = gsub("\\,",""))
