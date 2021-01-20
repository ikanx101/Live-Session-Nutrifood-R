setwd("~/Documents/Live-Session-Nutrifood-R/LEFO Market Research/SeleniumR")
rm(list=ls())
url_dow = "https://news.detik.com/berita/d-5340933/visi-presisi-komjen-sigit-calon-kapolri"

writeLines(paste0("var webPage = require('webpage');
var page = webPage.create();
var fs = require('fs');

var url  = '",url_dow,"'
var path = 'saved.html'


page.open(url, function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();
});"), con = paste0("scrape_web.js"))

system("phantomjs scrape_web.js")