# ==============================================================================
rm(list=ls())

# libraries
library(dplyr)
library(rvest)
library(RSelenium)

# ==============================================================================
# D O C K E R
#
# run di docker - powershell
# docker run -d -p 4445:4444 selenium/standalone-firefox:4.8.0-20230123

# buka session selenium menggunakan Docker
remote_driver = remoteDriver(remoteServerAddr = "localhost", #"172.17.0.3" 
                             port             = 4445L,       # 4444L 
                             browserName      = "firefox")
remote_driver$open()
# ==============================================================================


# ==============================================================================
# S E L E N I U M
#
# memulai selenium
driver =  RSelenium::rsDriver(browser = "chrome",
                              chromever = "105.0.5195.19") # sesuaikan dengan versi chrome
# situs nya:
 # https://chromedriver.chromium.org/downloads
 # https://ikanx101.com/blog/web-driver/

remote_driver = driver[["client"]]
# ==============================================================================

# contoh URL
url = "https://www.reuters.com/markets/commodities/"

# menuju situsnya
remote_driver$navigate(url)

# load more dulu
load_css = ".topic__loadmore__2s1t0"

load_more = remote_driver$findElement("css", load_css)
for(i in 1:5){
  load_more$clickElement()
  Sys.sleep(1)
}


judul_css = ".link__inherit-line-height__2qjXx"

baca = 
  remote_driver$getPageSource()[[1]] %>% 
  read_html()

judul = baca %>% html_nodes(judul_css) %>% html_text()
link  = baca %>% html_nodes(judul_css) %>% html_attr("href")

output = data.frame(judul,
                    link = paste0("https://www.reuters.com",link)
                    )

View(output)
