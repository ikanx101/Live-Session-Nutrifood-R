# ============================================================================
rm(list=ls())

# buat data untuk keperluan dashboard
# fieldnya
    # nama
    # usia
    # area
    # ses
    # awareness (tom)
    # awareness (unaided)
    # user ts
    # user ns

# libraries yang digunakan
library(dplyr)
library(tidyr)
library(randomNames)
library(parallel)

# banyak core
n_core = 5

# banyak responden
n_resp = n_core * 400
# ============================================================================


# ============================================================================
# nama 
nama_gen = function(n_resp){
    randomNames(n_resp)
}

# usia
usia_gen = function(n_resp){
    usia_temp = c("11 - 15 th","16 - 20 th","21 - 25 th","26 - 30 th","> 30 th")
    sample(usia_temp,n_resp,replace = T,prob = c(.1,.2,.3,.2,.1))
}

# area
area_gen = function(n_resp){
    area_temp = c("Jabodetabek","SUM 1","SUM 2","BARA","PUMA","Kalimantan","Sulawesi","Jateng","Jabar","Jatim")
    sample(area_temp,n_resp,replace = T,prob = c(.4,.1,.2,.1,.2,.1,.1,.2,.2,.2))
}

# ses
ses_gen = function(n_resp){
    ses_temp = c("Super","Up1","Up2","Mid")
    sample(ses_temp,n_resp,replace = T,prob = c(.2,.2,.1,.4))
}

# stasiun tv
tv_temp = c("trans7",
            "trans tv",
            "net",
            "rcti",
            "sctv",
            "mnc tv",
            "inews",
            "tv one",
            "indosiar") 

# generator untuk stasiun tv
tv_gen = function(n_resp){
    sample(tv_temp,4,replace = F,prob = c(.4,.3,.5,.2,.3,.2,.2,.1,.1))
}

input_tv        = vector("list",n_resp)
tv              = mclapply(input_tv,tv_gen,mc.cores = n_core)
df_tv           = do.call(rbind,tv) |> as.data.frame()
colnames(df_tv) = c("tom","unaided_1","unaided_2","unaided_3")

# user ns dan ts
user_ts_gen = function(n_resp){
    sample(c("ya","tidak"),n_resp,replace = T,prob = c(.6,.4))
}

user_ns_gen = function(n_resp){
    sample(c("ya","tidak"),n_resp,replace = T,prob = c(.8,.2))
}


# rekap
df_survey = 
 data.frame(
    nama    = mcmapply(nama_gen,n_resp,mc.cores = n_core) |> as.character(),
    usia    = mcmapply(usia_gen,n_resp,mc.cores = n_core) |> as.character(),
    area    = mcmapply(area_gen,n_resp,mc.cores = n_core) |> as.character(),
    ses     = mcmapply(ses_gen,n_resp,mc.cores = n_core) |> as.character(),
    user_ts = mcmapply(user_ts_gen,n_resp,mc.cores = n_core) |> as.character(),
    user_ns = mcmapply(user_ns_gen,n_resp,mc.cores = n_core) |> as.character()
 ) |>
 cbind(df_tv)

write.csv(df_survey,
          row.names = F,
          "/home/ikanx101/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Dashboard Shiny/generating data/data.survey.csv")
