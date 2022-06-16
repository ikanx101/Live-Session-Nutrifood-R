rm(list=ls())

library(readxl)
library(dplyr)

df = read_excel("Rekap Sensus BPS 2020 (5).xlsx",sheet = "Raw BPS",skip = 4)

df %>% 
  filter(grepl("total",gender,ignore.case = T)) %>% 
  filter(grepl("total",usia,ignore.case = T)) %>% 
  filter(stringr::str_length(kode_wilayah) < 4) %>% 
  mutate(jml_penduduk = as.numeric(jml_penduduk)) %>% 
  summarise(sum(jml_penduduk))


df_clean = read_excel("Rekap Sensus BPS 2020 (5).xlsx",sheet = "Clean BPS",skip = 4)
df_clean %>% summarise(sum(total_penduduk))
