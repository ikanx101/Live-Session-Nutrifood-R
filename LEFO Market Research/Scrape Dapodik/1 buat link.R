rm(list=ls())

library(readxl)
library(dplyr)
library(tidyr)

excel = "data_kec.xlsx"
df    = read_excel(excel) %>% janitor::clean_names()

df = 
  df %>% 
  filter(!grepl("jawa barat|jawa timur",propinsi,ignore.case = T))

link = paste0("https://dapo.kemdikbud.go.id/pd/3/",
              df$kode_kecamatan)

write.table(link,file = "link.txt",row.names = F,col.names = F)
