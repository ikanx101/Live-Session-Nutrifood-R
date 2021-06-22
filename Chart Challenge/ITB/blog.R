rm(list=ls())

setwd("~/Live-Session-Nutrifood-R/Chart Challenge/ITB")

library(dplyr)
library(tidyr)
library(ggplot2)
library(rvest)

url = "https://www.itb.ac.id/staf/fakultas-sekolah/FMIPA"

data = url %>% read_html() %>% html_table(fill = T)

data = 
  data[[1]] %>% 
  janitor::clean_names() %>% 
  mutate(departemen = case_when(
    grepl("matematik|statis|aljabar|geometri",kelompok_keahlian,ignore.case = T) ~ "Matematika",
    grepl("fisika",kelompok_keahlian,ignore.case = T) ~ "Fisika",
    grepl("kimia",kelompok_keahlian,ignore.case = T) ~ "Kimia",
    grepl("astronomi",kelompok_keahlian,ignore.case = T) ~ "Astronomi"
  )
         ) %>% 
  filter(!is.na(departemen))

library(ggalluvial)

data %>% 
  group_by(sekolah_fakultas,departemen,kelompok_keahlian) %>% 
  summarise(freq = n()) %>% 
  ungroup() %>% 
  ggplot(aes(y = freq,
             axis1 = sekolah_fakultas,
             axis2 = departemen,
             axis3 = kelompok_keahlian,
             fill = kelompok_keahlian)) +
  geom_alluvium() +
  geom_stratum(width = 1/12) +
  geom_label(stat = "stratum", 
             aes(label = after_stat(stratum),
                 size = freq)
             ) +
  scale_x_discrete(limits = c("Fakultas", "Departemen", "KK")) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("fmipa.png",
       height = 20,
       width = 24,
       dpi = 750)
