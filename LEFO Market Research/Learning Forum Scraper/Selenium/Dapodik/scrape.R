rm(list=ls())
setwd("~/Documents/Live-Session-Nutrifood-R/LEFO Market Research/Learning Forum Scraper/Selenium/Dapodik")

# load libraries 
library(dplyr)
library(rvest)
library(RSelenium)

# ===============================================================================
# memulai selenium
driver = RSelenium::rsDriver(browser = "chrome",
                             chromever = "99.0.4844.35" )
remote_driver = driver[["client"]] 

# url
url = "https://dapo.kemdikbud.go.id/sp"

remote_driver$navigate(url)
df = 
  remote_driver$getPageSource()[[1]] %>% 
  read_html() %>% 
  html_table(fill = T)

df_1 = df[[1]] %>% .[-1,]

colnames(df_1) = paste0(colnames(df_1),
                        "_",
                        df[[1]] %>% .[1,])

colnames(df_1)[1:2] = c("No","Wilayah")

save(df,df_1,file = "bahan_blog.rda")
