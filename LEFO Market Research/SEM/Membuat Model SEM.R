# ===================================
# Main Program
# Structural Equation Modelling in R
# ikanx101.com
# ===================================

# saya akan menunjukkan bagaimana caranya membuat SEM dan mengeluarkan outputnya
  # menggunakan R.
  
# Pertama jangan lupa untuk set working directory
setwd()

# Lalu kita panggil libraries yang akan digunakan
library(dplyr)
library(lavaan)

# kita panggil datanya
data = read.csv()

# model
model = "satisfaction =~ a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10"

# hitung modelnya
fit = cfa(model,data=data)
hasil = standardizedSolution(fit)

# kita ekstrak informasinya
hasil %>%
  select(rhs,lhs,est.std) %>%
  filter(lhs == "satisfaction") %>%
  filter(rhs != "satisfaction") %>%
  mutate(bobot = abs(est.std),
         bobot = bobot / sum(bobot),
         bobot = round(bobot*100,2)) %>%
  rename(bobot_dalam_persen = bobot,
         variabel = rhs,
         target = lhs)
