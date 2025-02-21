# Langkah 1: Memuat Library yang Dibutuhkan
library(dplyr)      # Untuk manipulasi data yang lebih mudah
library(caret)      # Untuk one-hot encoding dan pemrosesan data
library(ggplot2)    # Untuk visualisasi (opsional)

rm(list=ls())
gc()

load("tahap1.rda")

var_terlibat = c("pakai_produk_diabetes_gab","a2","pekerjaan",
                 "age_group","sesf","c4")

df_survey = df |> select(all_of(var_terlibat))
colnames(df_survey) = c("user","gender","pekerjaan","usia","ses","status")

prediktor_kategorik <- c("gender","pekerjaan","usia","ses","status")


# Langkah 4: Melakukan One-Hot Encoding
# Menggunakan fungsi dummyVars dari package 'caret'
dmy <- dummyVars(" ~ gender + pekerjaan + usia + ses + status", data = df_survey)
data_encoded <- data.frame(predict(dmy, newdata = df_survey))

# Menggabungkan kembali dengan kolom numerik dan variabel respons
data_final <- data_encoded %>% mutate(user = df_survey$user,
                                      user = ifelse(user == "Ya",1,0))
# cek dulu
data_final |> tabyl(user)

# Langkah 5: Melakukan Regresi Logistik
# Formula untuk regresi logistik
formula_regresi <- user ~ . # '.' berarti semua prediktor lainnya

# Melatih model regresi logistik
model_logistik <- glm(formula = formula_regresi, data = data_final, family = "binomial")

# Menampilkan ringkasan model
summary(model_logistik)

save(model_logistik,file = "model.rda")
