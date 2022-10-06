rm(list=ls())

library(dplyr)
library(rvest)

url = "https://money.kompas.com/"

judul = url %>% read_html %>% html_nodes(".terkini__title") %>% html_text()
judul = stringr::str_trim(judul)
judul
