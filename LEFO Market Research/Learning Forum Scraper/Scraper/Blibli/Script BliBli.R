rm(list=ls())

# libraries
library(rvest)
library(dplyr)
library(stringr)

# nama folder tempat save htmlnya
# silakan modifikasi bagian ini
path = "~/Live-Session-Nutrifood-R/LEFO Market Research/Learning Forum Scraper/Scraper/Blibli/Saved blibli"

# ===============================================================
# baris ini ke bawah biarkan as it is

# function nya
scrape_blibli = function(url){
  data = 
    url %>% 
    read_html() %>% {tibble(
      nama = html_nodes(.,"#product-info .product-name") %>% html_text() %>% str_squish(),
      harga = html_nodes(.,".product-price__after") %>% html_text() %>%  str_squish(),
      terjual = html_nodes(.,".product-statistics__sold-seen") %>% html_text() %>%  str_squish(),
      toko = html_nodes(.,".seller__name .text") %>% html_text() %>%  str_squish(),
      lokasi = html_nodes(.,".text-ellipsis") %>% html_text() %>%  str_squish(),
      waktu_scrape = Sys.Date()
    )} 
  
  return(data)
}

# buat ambil semua filenya
html_file = list.files(path)
html_file = paste0(path,"/",html_file)

# proses ambil
data_final = data.frame()
for(i in 1:length(html_file)){
  temp = scrape_blibli(html_file[i])
  data_final = rbind(temp,data_final)
  print(paste0(i," sukses di ekstrak"))
}

# hasil final
data_final = 
  data_final %>% 
  mutate(harga = gsub("Rp","",harga),
         harga = gsub("\\.","",harga),
         harga = as.numeric(harga),
         terjual = gsub("[A-z]","",terjual),
         terjual = gsub(" ","",terjual),
         terjual = as.numeric(terjual))

# export ke excel
nama_file = paste0("blibli scrape ",Sys.Date(),".xlsx")
data_final %>% openxlsx::write.xlsx(nama_file)

# ============================================================