rm(list=ls())

# panggil libraries
library(chromote) # web scraping
library(dplyr) # buat data manipulation
library(hayalbaz)
library(rvest)

# buka situs tanpa harus buka devtools
test = puppet$new("http://www.panganku.org/id-ID/semua_nutrisi")

# click pertama
test$click(".odd:nth-child(1) td:nth-child(3)")
# buat view devtools
test$view()

# scrape
kode = test$get_element("tr:nth-child(1) td~ td+ td")
kode %>% html_text()
