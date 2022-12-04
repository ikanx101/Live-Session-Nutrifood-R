setwd("~/Live-Session-Nutrifood-R/Kaggle Data/KEmenperin Sulawesi")

rm(list = ls())

library(dplyr)
library(tidyr)

load("save data scrape kantor.rda")

df_clean = 
  df_plan %>% 
  separate(url,
           into = c("dummy","temp"),
           sep = "/@") %>% 
  select(-dummy) %>%
  separate(temp,
           into = c("temp","dummy"),
           sep = "z/") %>% 
  select(-dummy) %>%
  separate(temp,
           into = c("lat","lon"),
           sep = "\\,") %>% 
  mutate(lat = as.numeric(lat),
         lon = as.numeric(lon))

openxlsx::write.xlsx(df_clean,file = "Data Perkantoran.xlsx")
