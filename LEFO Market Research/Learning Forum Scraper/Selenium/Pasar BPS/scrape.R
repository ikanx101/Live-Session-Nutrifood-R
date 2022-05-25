rm(list=ls())
setwd("~/Documents/Live-Session-Nutrifood-R/LEFO Market Research/Learning Forum Scraper/Selenium/Pasar BPS")

# load libraries 
library(dplyr)
library(rvest)
library(RSelenium)

# ===============================================================================
# memulai selenium
driver = RSelenium::rsDriver(browser = "chrome",
                             chromever = "101.0.4951.41" )
remote_driver = driver[["client"]] 

# url
url = "https://bps.go.id/pasar/app/direktori"
# navigate
remote_driver$navigate(url)

# download excel
donglots = function(){
  rekap_hasil = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>%
    html_table(fill = T) %>% 
    .[[1]] %>% 
    janitor::clean_names()
  return(rekap_hasil)
}

# hit next button
next_please = function(){
  # cari tombol next
  tombol_next = 
    remote_driver$findElement(using = "css",
                              value = "#tbl-direktori_next .page-link")
  # klik tombolnya
  tombol_next$clickElement()
}

# kita mulai loopingnya
temp = vector("list",74)
# page pertama langsung download
temp[[1]] = donglots()
# page kedua dan seterusnya
for(i in 75:100){
  next_please()
  Sys.sleep(6)
  temp[[i]] = donglots()
  print(paste0("page ",i,"- DONE"))
}


finalista = do.call(rbind,temp) %>% distinct()
save(finalista,file = "all data.rda")
openxlsx::write.xlsx(finalista,"all pasar.xlsx")