setwd("~/Live-Session-Nutrifood-R/Kaggle Data/Provinsi Kota")

rm(list=ls())

library(dplyr)
library(tidyr)

df = read.csv("https://raw.githubusercontent.com/kodewilayah/permendagri-72-2019/main/dist/base.csv",
              header = F)

colnames(df) = c("kode","nama_area")

df_1 = 
  df %>% 
  separate(kode,
           into = c("prov","kota_kab","kecamatan","kelurahan"),
           sep = "\\.") 

df_2 = 
  df_1 %>% 
  mutate(prov = ifelse(is.na(kota_kab) & is.na(kecamatan) & is.na(kelurahan),
                       nama_area,
                       NA)
         ) %>% 
  fill(prov,.direction = "down") %>% 
  filter(!is.na(kota_kab)) %>% 
  mutate(kota_kab = ifelse(is.na(kecamatan) & is.na(kelurahan),
                           nama_area,
                           NA)
         ) %>% 
  fill(kota_kab,.direction = "down") %>% 
  filter(!is.na(kecamatan)) %>% 
  mutate(kecamatan = ifelse(is.na(kelurahan),
                           nama_area,
                           NA)
  ) %>% 
  fill(kecamatan,.direction = "down") %>% 
  filter(!is.na(kelurahan)) %>% 
  select(-kelurahan) %>% 
  rename(kelurahan = nama_area)

openxlsx::write.xlsx(df_2,
                     file = "data all.xlsx")

