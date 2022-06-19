rm(list=ls())

library(readxl)
library(dplyr)
library(stringr)
library(reshape2)
library(openxlsx)

# data mentah
df = read_excel("Rekap Sensus BPS 2020 (5).xlsx",sheet = "Raw BPS",skip = 4)

# hitung total sensus dari data mentah
df %>% 
  filter(grepl("total",gender,ignore.case = T)) %>% 
  filter(grepl("total",usia,ignore.case = T)) %>% 
  filter(stringr::str_length(kode_wilayah) < 4) %>% 
  mutate(jml_penduduk = as.numeric(jml_penduduk)) %>% 
  summarise(sum(jml_penduduk))

# ambil data clean
df_clean = read_excel("Rekap Sensus BPS 2020 (5).xlsx",sheet = "Clean BPS",skip = 4)
# ambil total data clean
df_clean %>% summarise(sum(total_penduduk))

# hasilnya
df_clean2 =
  df %>% 
  filter(!grepl("total",gender,ignore.case=T)) %>%
  filter(!grepl("total",usia,ignore.case=T)) %>%
  mutate(jml_penduduk = as.numeric(jml_penduduk),
         len = str_length(kode_wilayah)) %>%
  filter(len > 2)


dfinal =
  df_clean2 %>% 
  dcast(provinsi + kota_kab + kode_wilayah + usia ~ gender,
        value.var = "jml_penduduk",
        sum) %>%
  janitor::clean_names()

dfinal %>% summarise(sum(laki_laki + perempuan))

write.xlsx(df,file = "raw data bps.xlsx")

write.xlsx(dfinal,file = "clean data bps.xlsx")
