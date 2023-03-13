rm(list=ls())
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/Greedy Algorithm/Spiral Algo")

# ==============================================================================
# libraries
library(dplyr)
library(tidyr)
library(parallel)
library(ggplot2)

# kita ambil dulu function-nya
source("rotator.R")

# kita set corenya berapa
numcore = 7

# banyaknya calon solusi yang hendak di-generate
n_calon_solusi = 7*50

# berapa banyak SDOA dilakukan
n_SDOA  = 60
# ==============================================================================

# Misalkan:
# Suatu sekolah memiliki kelas berisi 20 orang siswa. Mereka hendak menggelar PTMT dengan aturan sebagai berikut:
  
# PTMT digelar dari Senin hingga Jumat (5 hari).
# Dalam sehari, siswa yang boleh hadir dibatasi 4-8 orang saja.
# Dalam seminggu, diharapkan siswa bisa hadir 2-3 kali.
# Siswa yang hadir di selang sehari baru bisa hadir kembali.

jadwal = data.frame(hari = 1:5,peserta = NA)
for(i in 1:5){
  jadwal$peserta[i] = sample(20,8)
}
