rm(list=ls())
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Keras/time series")

library(dplyr)
library(tidyr)
library(ggplot2)

rm(list=ls())

time_label = c(paste(1:12,2019,sep = "-"),
               paste(1:12,2020,sep = "-"),
               paste(1:12,2021,sep = "-"),
               paste(1:12,2022,sep = "-"),
               paste(1:12,2023,sep = "-"))

df = 
  df_all %>% 
  group_by(bulan,tahun) %>% 
  summarise(omset = sum(value_nett)) %>% 
  ungroup() %>% 
  arrange(tahun,bulan) %>% 
  mutate(timeline = paste(bulan,tahun,sep = "-")) %>% 
  mutate(timeline = factor(timeline,levels = time_label))

df %>% 
  ggplot(aes(x = timeline,
           y = omset)) +
  geom_line(group = 1)

save(df,file = "data.rda")
