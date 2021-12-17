# UJI COBA SCRAPING PAKE VIRTUAL MACHINE
# by: ikanx101.com

# ============================================
# panggil libraries
library(rvest) # web scraping
library(dplyr) # buat data manipulation

# hapus environment
rm(list=ls())

# ====================================
# Contoh
url = "https://shopee.co.id/Zwitsal-Eau-De-Toilette-100-Ml-Parfum-Eau-De-Toilette-Parfum-Pakaian-Aroma-Bayi-i.14318452.4132994147"

url %>%
  read_html() %>%
  html_nodes(".attM6y span") %>%
  html_text()

