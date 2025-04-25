# https://keras3.posit.co/articles/examples/index.html

# Kita bersihkan hati dan pikiran dulu
rm(list=ls())
gc()

# panggil package yang akan digunakan
library(keras3)
library(tensorflow)
library(EBImage)
library(dplyr)
library(tidyr)
library(parallel)

# berapa banyak cores
ncore = detectCores()

# set working directory
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2025/Q1 Image/image_data")

# ambil semua nama folder
folder_all = list.dirs()

# ambil semua folder ns dan isi filesnya
dhani_folder = folder_all[grepl("dhani",folder_all)]
maia_folder  = folder_all[grepl("maia",folder_all)]

dhani_img = list.files(dhani_folder,full.names = T)
maia_img  = list.files(maia_folder,full.names = T)


# kita akan buat function untuk melakukan pembacaan dan resize image
# definisikan dulu width dan height
w = 50
h = 50

bacain = function(nama_gambar){
  gambar = readImage(nama_gambar)
  gambar = resize(gambar,w,h)
  # karena bentuk imagenya png jadi ada 4 layer ya
  output = array_reshape(gambar,c(w,h,4))
  return(output)
}

# kita baca images nya
baca_dhani = mclapply(dhani_img,bacain,mc.cores = ncore)
baca_maia  = mclapply(maia_img,bacain,mc.cores = ncore)

# sekarang kita akan buat train dan test nya
# kita buat proporsinya merata aja ya
# dhani ada 500
# maia ada 380

# kita generate dulu id untuk train nya
n_train   = 300
id_dhani  = sample(length(baca_dhani),n_train)
id_maia   = sample(length(baca_maia),n_train)

# ini id utk test nya
id_dhani_t = c(1:length(baca_dhani))[-id_dhani]
id_maia_t  = c(1:length(baca_maia))[-id_maia]

# ini kita siapkan label targetnya
# 1 utk dhani
# 0 utk maia
train_label_raw = c(rep(1,n_train),rep(0,n_train))
test_label_raw  = c(rep(1,(length(baca_dhani) - n_train)),
                    rep(0,(length(baca_maia) - n_train)))

# nah, kedua label ini harus dibuat dalam bentuk one hot encoding
train_label = to_categorical(train_label_raw)
test_label  = to_categorical(test_label_raw)

# Nah, kita buat train datasetnya nih
X_train = NULL
for (i in id_dhani){
  X_train = rbind(X_train, baca_dhani[[i]])
} 
for (i in id_maia){
  X_train = rbind(X_train, baca_maia[[i]])
} 

# Nah, kita buat test datasetnya nih
X_test = NULL
for (i in id_dhani_t){
  X_test = rbind(X_test, baca_dhani[[i]])
} 
for (i in id_maia_t){
  X_test = rbind(X_test, baca_maia[[i]])
} 

# bismillah modelnya
model = keras_model_sequential()
model %>%
  layer_dense(units = 256, activation = 'relu', input_shape = c(10000)) %>%
  layer_dense(256, activation = "relu") |>
  layer_dense(256, activation = "relu") |>
  layer_dropout(0.3) |>
  layer_dense(256, activation = "relu") |>
  layer_dropout(0.3) |>
  layer_dense(2, activation = "sigmoid")

# Summary model    
summary(model)

# Optimizer Model
model |> compile(
  optimizer = optimizer_adam(1e-2),
  loss    = "binary_crossentropy",
  metrics = c('accuracy')
)


# Model fitting
fitModel =
  model |> fit(
    X_train,
    train_label,
    batch_size = 200,
    epochs     = 300,
    verbose    = 3,
    validation_split = .25
  )

# Plot model fitting    
plot(fitModel)

# Evaluasi Model
# menggunakan train dataset
model %>% evaluate(X_train, train_label)
# membuat prediksi dari train dataset
pred_train <- model %>% predict(X_train) %>% as.data.frame()
pred_train = 
  pred_train %>% 
  mutate(hasil = ifelse(V1 > V2,0,1)) %>% 
  pull(hasil)

# kita bikin confusion matrix
caret::confusionMatrix(factor(pred_train),factor(train_label_raw))

# menggunakan test dataset
model %>% evaluate(X_test, test_label)
pred_test <- model %>% predict(X_test) %>% as.data.frame()
pred_test = 
  pred_test %>% 
  mutate(hasil = ifelse(V1 > V2,0,1)) %>% 
  pull(hasil)

# kita bikin confusion matrix
caret::confusionMatrix(factor(pred_test),factor(test_label_raw))

# model |> save_model("model_belajar_lagi_lagi_lagi.keras")
# model <- load_model("model_belajar_lagi_lagi.keras")





