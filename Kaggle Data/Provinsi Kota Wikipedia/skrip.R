rm(list=ls())

# set working directories
setwd("~/Live-Session-Nutrifood-R/Kaggle Data/Provinsi Kota")

# libraries yang dibutuhkan
library(dplyr)
library(tidyr)
library(rvest)

# url dari wikipedia
url = "https://id.wikipedia.org/wiki/Daftar_kabupaten_dan_kota_di_Indonesia"

# kita mulai ambil tabel dari wikipedia
tabel = 
  url %>% 
  read_html() %>% 
  html_table(fill = T)

# tabel summary
df_summary = tabel[[1]] %>% janitor::clean_names()


# Aceh
i    = 2
df_1 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_2,jumlah_penduduk_2020) %>% 
  rename(luas_wilayah = luas_wilayah_km2_2,
         jml_penduduk = jumlah_penduduk_2020) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Aceh")



# Sumatra Utara
i    = 3
df_2 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_3,jumlah_penduduk_2020) %>% 
  rename(luas_wilayah = luas_wilayah_km2_3,
         jml_penduduk = jumlah_penduduk_2020) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Sumatra Utara")



# Sumatra Barat
i    = 4
df_3 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_4,jumlah_penduduk_2020_5) %>% 
  rename(luas_wilayah = luas_wilayah_km2_4,
         jml_penduduk = jumlah_penduduk_2020_5) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Sumatra Barat")



# Riau
i    = 5
df_4 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_6,jumlah_penduduk_2023_7) %>% 
  rename(luas_wilayah = luas_wilayah_km2_6,
         jml_penduduk = jumlah_penduduk_2023_7) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Riau")



# Jambi
i    = 6
df_5 = 
  tabel[[i]] %>% 
  janitor::clean_names()
colnames(df_5) = df_5[1,]
df_5           = df_5[-1,]

df_5 =
  df_5 %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_8,jumlah_penduduk_2021_8) %>% 
  rename(luas_wilayah = luas_wilayah_km2_8,
         jml_penduduk = jumlah_penduduk_2021_8) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Jambi")



# Sumatra Selatan
i    = 7
df_6 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_9,jumlah_penduduk_2021_9_2) %>% 
  rename(luas_wilayah = luas_wilayah_km2_9,
         jml_penduduk = jumlah_penduduk_2021_9_2) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Sumatra Selatan")



# Bengkulu
i    = 8
df_7 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_10,jumlah_penduduk_2021_10) %>% 
  rename(luas_wilayah = luas_wilayah_km2_10,
         jml_penduduk = jumlah_penduduk_2021_10) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Bengkulu")



# Lampung
i    = 9
df_8 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota_11,luas_wilayah_km2_12,jumlah_penduduk_2020_12) %>% 
  rename(ibu_kota     = ibu_kota_11,
         luas_wilayah = luas_wilayah_km2_12,
         jml_penduduk = jumlah_penduduk_2020_12) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Lampung")



# Kepulauan Bangka Belitung
i    = 10
df_9 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_9,jumlah_penduduk_2021_9) %>% 
  rename(luas_wilayah = luas_wilayah_km2_9,
         jml_penduduk = jumlah_penduduk_2021_9) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Kepulauan Bangka Belitung")



# Kepulauan Riau
i     = 11
df_10 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_13,jumlah_penduduk_2024_13) %>% 
  rename(luas_wilayah = luas_wilayah_km2_13,
         jml_penduduk = jumlah_penduduk_2024_13) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Kepulauan Riau")



# Daerah Khusus Ibukota Jakarta
i     = 12
df_11 = 
  tabel[[i]] %>% 
  janitor::clean_names()

df_11 = 
  df_11[-1,] %>% 
  select(kabupaten_kota_administrasi_14,
         pusat_pemerintahan,
         luas_wilayah_km2_15,jumlah_penduduk_2015_16) %>% 
  rename(kabupaten_kota = kabupaten_kota_administrasi_14,
         ibu_kota     = pusat_pemerintahan,
         luas_wilayah = luas_wilayah_km2_15,
         jml_penduduk = jumlah_penduduk_2015_16) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Daerah Khusus Ibukota Jakarta")


# Jawa Barat
i     = 13
df_12 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_17,jumlah_penduduk_2020_18) %>% 
  rename(luas_wilayah = luas_wilayah_km2_17,
         jml_penduduk = jumlah_penduduk_2020_18) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Jawa Barat")



# Jawa Tengah
i     = 14
df_13 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_9,jumlah_penduduk_2020) %>% 
  rename(luas_wilayah = luas_wilayah_km2_9,
         jml_penduduk = jumlah_penduduk_2020) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "Jawa Tengah")



# DI Yogyakarta
i     = 15
df_14 = 
  tabel[[i]] %>% 
  janitor::clean_names() %>% 
  select(kabupaten_kota,ibu_kota,luas_wilayah_km2_19,jumlah_penduduk_2020) %>% 
  rename(luas_wilayah = luas_wilayah_km2_19,
         jml_penduduk = jumlah_penduduk_2020) %>% 
  mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
         luas_wilayah = gsub("\\,",".",luas_wilayah),
         jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
  mutate(provinsi = "DI Yogyakarta")


# =============================================================================
# karena polanya sama kita bikin function saja
data_scrape = function(i,input_f){
  temp = tabel[[i]] %>% janitor::clean_names()
  nama_kol = colnames(temp)
  nama_kol = ifelse(grepl("kabupaten",nama_kol,ignore.case = T),
                    "kabupaten_kota",
                    nama_kol)
  nama_kol = ifelse(grepl("luas",nama_kol,ignore.case = T),
                    "luas_wilayah",
                    nama_kol)
  nama_kol = ifelse(grepl("jumlah",nama_kol,ignore.case = T),
                    "jml_penduduk",
                    nama_kol)
  nama_kol = ifelse(grepl("pusat",nama_kol,ignore.case = T),
                    "ibu_kota",
                    nama_kol)
  colnames(temp) = nama_kol
  output = 
    temp %>% 
    select(kabupaten_kota,ibu_kota,luas_wilayah,jml_penduduk) %>% 
    mutate(luas_wilayah = gsub("\\.","",luas_wilayah),
           luas_wilayah = gsub("\\,",".",luas_wilayah),
           jml_penduduk = gsub("\\.","",jml_penduduk)) %>% 
    mutate(provinsi = input_f)
  
  return(output)
}

# kita mulai
df_15 = data_scrape(16,df_summary$provinsi[15])
df_16 = data_scrape(17,df_summary$provinsi[16])
df_17 = data_scrape(18,df_summary$provinsi[17])
df_18 = data_scrape(19,df_summary$provinsi[18])
df_19 = data_scrape(20,df_summary$provinsi[19])
df_20 = data_scrape(21,df_summary$provinsi[20])
df_21 = data_scrape(22,df_summary$provinsi[21])
df_22 = data_scrape(23,df_summary$provinsi[22])
df_23 = data_scrape(24,df_summary$provinsi[23])
df_24 = data_scrape(25,df_summary$provinsi[24])
df_25 = data_scrape(26,df_summary$provinsi[25])
df_26 = data_scrape(27,df_summary$provinsi[26])
df_27 = data_scrape(28,df_summary$provinsi[27])
df_28 = data_scrape(29,df_summary$provinsi[28])
df_29 = data_scrape(30,df_summary$provinsi[29])
df_30 = data_scrape(31,df_summary$provinsi[30])
df_31 = data_scrape(32,df_summary$provinsi[31])
df_32 = data_scrape(33,df_summary$provinsi[32])
df_33 = data_scrape(34,df_summary$provinsi[33])
df_34 = data_scrape(35,df_summary$provinsi[34])
df_35 = data_scrape(36,df_summary$provinsi[35])
df_36 = data_scrape(37,df_summary$provinsi[36])
df_37 = data_scrape(38,df_summary$provinsi[37])
df_38 = data_scrape(39,df_summary$provinsi[38])

i = 35

data_all   = list(df_1,df_2,df_3,df_4,df_5,
                  df_6,df_7,df_8,df_9,df_10,
                  df_11,df_12,df_13,df_14,df_15,
                  df_16,df_17,df_18,df_19,df_20,
                  df_21,df_22,df_23,df_24,df_25,
                  df_26,df_27,df_28,df_29,df_30,
                  df_31,df_32,df_33,df_34,df_35,
                  df_36,df_37,df_38)
data_final = do.call(rbind,data_all)


data_final = 
  data_final %>% 
  filter(ibu_kota != "Ibu kota[11]")


openxlsx::write.xlsx(data_final,file = "data provinsi.xlsx")
