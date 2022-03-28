library(dplyr)
library(rvest)
library(RSelenium)

rm(list=ls())

url = "https://dapo.kemdikbud.go.id/pd/3/020520"

driver <- RSelenium::rsDriver(browser = "chrome",
                              chromever = "99.0.4844.35" )
remote_driver <- driver[["client"]] 

remote_driver$navigate(url)
Sys.sleep(5)
button_element <- remote_driver$findElement(using = 'css', value = ".buttons-excel")
Sys.sleep(3)
button_element$clickElement()
Sys.sleep(10)

remote_driver$close()

remote_driver$server$stop()

gc()
