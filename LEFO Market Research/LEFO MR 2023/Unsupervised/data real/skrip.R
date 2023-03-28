rm(list=ls())

setwd("/home/ikanx101/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Unsupervised/data real")

library(dplyr)
library(tidyr)
library(ggplot2)
library(readxl)
library(parallel)

num_core = 6

path_excel = "Rekap Nilai.xlsx"
sht        = excel_sheets(path_excel)

ambil_data = function(shitty){
    df = read_excel("Rekap Nilai.xlsx",sheet = shitty) %>% janitor::clean_names()
    return(df)
}

df_ambil = mclapply(sht,ambil_data,mc.cores = num_core)

df_ambil[[1]] = df_ambil[[1]] |> select(-x12)

data_online = data.frame()
for(i in 1:3){
    data_online = rbind(data_online,df_ambil[[i]])
}

data_offline = data.frame()
for(i in 4:6){
    data_offline = rbind(data_offline,df_ambil[[i]])
}

save(data_online,
     data_offline,
     file = "nbc.rda")