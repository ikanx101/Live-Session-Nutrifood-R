rm(list=ls())
library(ralger)
library(dplyr)

# contoh
link = "https://news.detik.com/berita/d-5340875/calon-kapolri-komjen-listyo-sigit-jalani-fit-and-proper-test-hari-ini?tag_from=wp_nhl_3&_ga=2.191338153.2056449080.1611101558-2042838175.1595213097"
link_2 = "https://www.tokopedia.com/manshopjakarta/on-wgs-on-whey-gold-standard-5-lbs-5lbs-whey-protein-isolate-coklat?src=topads"

# getting images link
images_preview(link, askRobot = FALSE)

# scrap the image
images_scrap(link, imgpath = getwd(), extn = "png", askRobot = FALSE)

# scrap paragraph
paragraphs_scrap(link)

# node scrap
node = ".detail__title"
scrap(link,node)

# title scrap
titles_scrap(link)