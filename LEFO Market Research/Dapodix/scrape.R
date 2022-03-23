library(dplyr)
library(rvest)

rm(list=ls())

# bikin function buat scrape tabel sekolah
scrape_sekolah = function(url){
  tabel = 
    url %>% # import url
    read_html() %>% # baca url
    html_table(fill = T) # parsing tabel
  
  tabel = tabel[[1]] # ambil tabel dari list pertama
  tabel$sumber = url # kasih keterangan nama kecamatan
  return(tabel)
}

# set path ambil data dulu
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/Dapodix/bogor")

# ambil semua file html
urls = list.files(pattern = "html")

# set template dulu
data_all = data.frame()

# scraping all
for(i in 1:length(urls)){
  temp = scrape_sekolah(urls[i])
  data_all = rbind(temp,data_all)
  print(paste0("Sekolah dari: ",urls[i]," -- DONE"))
}

# set path untuk save
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/Dapodix")
write.csv(data_all,"bogor.csv")