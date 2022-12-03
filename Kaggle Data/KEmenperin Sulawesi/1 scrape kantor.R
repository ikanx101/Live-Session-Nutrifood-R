rm(list=ls())

library(dplyr)
library(rvest)

url = paste0("https://kemenperin.go.id/direktori-perusahaan?what=&prov=73&hal=",1:9)

i = 1

temp = vector("list",9)
for(i in 1:10){
  temp[[i]] = url[i] %>% read_html() %>% html_table(fill = T) %>% .[[1]]
}

final = do.call(rbind,temp) %>% janitor::clean_names()

final %>% write.csv("kantor.csv",row.names = F)
