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
w = 100
h = 100

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
# ns ada 324
# non ns ada 837

# kita generate dulu id untuk train nya
n_train   = 300
id_ns     = sample(length(baca_ns_img),n_train)
id_non_ns = sample(length(baca_non_ns_img),n_train)

# ini id utk test nya
id_ns_t     = c(1:length(baca_ns_img))[-id_ns]
id_non_ns_t = c(1:length(baca_non_ns_img))[-id_non_ns]

# ini kita siapkan label targetnya
train_label_raw = c(rep(1,n_train),rep(0,n_train))
test_label_raw  = c(rep(1,(length(baca_ns_img) - n_train)),
                    rep(0,(length(baca_non_ns_img) - n_train)))

# nah, kedua label ini harus dibuat dalam bentuk one hot encoding
train_label = to_categorical(train_label_raw)
test_label  = to_categorical(test_label_raw)

# Nah, kita buat train datasetnya nih
X_train = NULL
for (i in id_ns){
  X_train = rbind(X_train, baca_ns_img[[i]])
} 
for (i in id_non_ns){
  X_train = rbind(X_train, baca_non_ns_img[[i]])
} 

# Nah, kita buat test datasetnya nih
X_test = NULL
for (i in id_ns_t){
  X_test = rbind(X_test, baca_ns_img[[i]])
} 
for (i in id_non_ns_t){
  X_test = rbind(X_test, baca_non_ns_img[[i]])
} 

# bismillah modelnya
model = keras_model_sequential()
model %>%
  layer_dense(units = 256, activation = 'relu', input_shape = c(25600)) %>%
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
    epochs     = 400,
    verbose    = 2,
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
pred_test <- model %>% predict(X_test) %>% as.data.frame()
pred_test = 
  pred_test %>% 
  mutate(hasil = ifelse(V1 > V2,0,1)) %>% 
  pull(hasil)

# kita bikin confusion matrix
caret::confusionMatrix(factor(pred_test),factor(test_label_raw))

# sekarang kita akan pake marimas punya
X_marimas = NULL
for (i in 1:length(baca_marimas_baru_img)){
  X_marimas = rbind(X_marimas, baca_marimas_baru_img[[i]])
} 

pred_marimas <- model %>% predict(X_marimas) %>% as.data.frame()
pred_marimas = 
  pred_marimas %>% 
  mutate(hasil = ifelse(V1 > V2,"gak mirip","mirip NS"),
         prob  = V2 * 100,
         prob  = round(prob,2),
         persen = paste0(prob,"%")) %>% 
  select(-prob)

bacain_aja = function(nama_gambar){
  gambar = readImage(nama_gambar)
  return(gambar)
}

marimas_baru_img_all = mclapply(marimas_baru_img,bacain_aja,mc.cores = ncore)

i = 2
display(marimas_baru_img_all[[i]])
pred_marimas[i,]


setwd("~/image-classifier/model")
model |> save_model("model.keras")
# loaded_model <- load_model("model.keras")