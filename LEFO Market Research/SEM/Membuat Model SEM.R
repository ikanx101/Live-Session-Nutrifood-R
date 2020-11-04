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
model = "
produk =~ a1 + a2 + a3
price =~ a4 + a5
promotion =~ a6 + a7 + a8
price =~ a9 + a10
"

fit = sem(model,data=data)
summary(fit, standardized = TRUE)
