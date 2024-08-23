rm(list = ls())

library(dplyr)
library(tidyr)
library(parallel)
library(rvest)

n_core = detectCores()

setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/Scrape Dapodik/output")

csvs = list.files(full.names = T)

ambilin = function(target) {
  df = read.csv(target)
  return(df)
}

df_temp = mclapply(csvs, ambilin, mc.cores = n_core)
df_temp = data.table::rbindlist(df_temp, fill = T) %>% as.data.frame()
df_temp = df_temp %>% distinct() %>% arrange(prov, kota_kab) %>% select(-X)
df_temp = df_temp %>% mutate(prov = ifelse(prov == "Jawa Barat", "Prov. Jawa Barat", prov))
df_temp = df_temp %>% janitor::clean_names() %>% distinct()

provinsi_done = df_temp %>% pull(prov) %>% unique() %>% sort()
provinsi_done

setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/Scrape Dapodik")
# kita cek mana yang belum
html = "Data Peserta Didik Nasional - Dapodikdasmen.html"

default = 
  html %>% 
  read_html() %>% 
  html_table(fill = T) %>% 
  .[[1]] %>% 
  janitor::row_to_names(1) %>% 
  janitor::clean_names()

# provinsi yang belum diambil
default %>% 
  filter(!wilayah %in% provinsi_done) %>% 
  pull(wilayah)

# sekarang kita save hasil akhirnya
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/Scrape Dapodik")
df_temp %>% openxlsx::write.xlsx("dapodix.xlsx")






