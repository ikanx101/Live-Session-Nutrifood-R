rm(list=ls())

# libraries
library(rvest)
library(dplyr)
library(stringr)

# killer method
  # disave dl as complete webpage lalu diambil
  url = "uji coba.html"

# prosesnya
data = 
  url %>% 
  read_html() %>% {tibble(
    nama = html_nodes(.,".product-name") %>% html_text() %>% str_squish(),
    harga = html_nodes(.,".product-price__after") %>% html_text() %>%  str_squish(),
    terjual = html_nodes(.,".product-statistics__sold-seen") %>% html_text() %>%  str_squish(),
    toko = html_nodes(.,".seller__name .text") %>% html_text() %>%  str_squish()
  )} 