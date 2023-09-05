library(keras)
library(tidyverse)
library(janeaustenr)
library(tokenizers)
library(readxl)
library(parallel)

rm(list=ls())
setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/LLM/keras/masuk nfi")

# define numcore
n_core = 5


# ==============================================================================
# tahap 1
# kita masukin teks feedingnya terlebih dahulu
df_input = read_excel("Data Essay CV - Jun 2023.xlsx") %>% janitor::clean_names()
df_input = df_input
texts    = 
  df_input %>% 
  mutate(teks = tolower(layak_dirumah_kedua),
         #teks = gsub("[0-9]","",teks),
         teks = gsub("\\,","",teks),
         teks = gsub("\\.","",teks),
         teks = gsub("[[:punct:]]","",teks),
         teks = stringr::str_trim(teks),
         teks = gsub("aku","saya",teks),
         teks = paste0("saya layak di rumah kedua karena ",teks)) %>% 
  pull(teks)

# kita akan coba pisah per elemen teks ya
pecah_split = function(input){
  input %>% strsplit(split = " ") %>% unlist()
}

# kita pecah lagi per elemen ya
list_teks = mclapply(texts,pecah_split,mc.cores = n_core)

# ini kita pecah tapi keseluruhan
# gabung dulu
teks_gabung =
  texts %>% 
  paste(texts,collapse = " ") %>% 
  strsplit(split = " ") %>% 
  unlist()
# ==============================================================================



# ==============================================================================
# tahap 2

# pada bagian ini kita bikin "kamus" alias rumah untuk data secara keseluruhan terlebih dahulu

# memberikan informasi berapa banyak corpus
print(sprintf("Banyaknya Corpus: %d", length(teks_gabung)))

# menentukan semua kata yang terlibat
chars =
  teks_gabung %>%
  unique() %>%
  sort()
print(sprintf("Banyaknya kata-kata yang terlibat: %d", length(chars)))
# ==============================================================================



# ==============================================================================
# tahap 3
# berapa banyak n grams nya
max_length = 5

# ini saya akan buat function yang bertugas untuk menuliskan n-grams yang mungkin dari satu kalimat
buat_dataset_train = function(input_contoh){
  # ini saya buat seq dengan by = 1
  dataset <- map(
    seq(1, length(input_contoh) - max_length - 1, by = 1), 
    ~list(sentence  = input_contoh[.x:(.x + max_length - 1)], 
          next_char = input_contoh[.x + max_length])
  )
  return(dataset)
}

# contoh
# buat_dataset_train(list_teks[[2]])
train = buat_dataset_train(teks_gabung)

# sekarang kita transpose datasetnya
dataset = transpose(train)
# ==============================================================================


# ==============================================================================
# tahap 4
# pada tahap ini kita vectorize hasil dataset sebelumnya

# saya buat dulu function-nya
vectorize = function(data){
  x = array(0, dim = c(length(data$sentence), max_length, length(chars)))
  y = array(0, dim = c(length(data$sentence), length(chars)))
  
  for(i in 1:length(data$sentence)){
    x[i,,] <- sapply(chars, function(x){
      as.integer(x == data$sentence[[i]])
    })
    y[i,] <- as.integer(chars == data$next_char[[i]])
  }
  # output
  list(y = y,
       x = x)
}

# karena pake parallel processing gak kuku
# maka kita gunakan looping seperti biasa
# vectors <- vectorize(dataset)

# tahap 6
tes = list(sentence  = dataset$sentence[10],
           next_char = dataset$next_char[10])

tes
pred_donk = vectorize(tes)


# tahap 7
create_model <- function(chars, max_length){
  keras_model_sequential() %>%
    layer_lstm(258, input_shape = c(max_length, length(chars))) %>%
    layer_dense(length(chars)) %>%
    layer_activation("softmax") %>% 
    compile(
      loss = "categorical_crossentropy", 
      metric = c("accuracy"),
      optimizer = optimizer_rmsprop(learning_rate = 0.05)
    )
}

fit_model <- function(model, vectors, epochs){
  model %>% keras::fit(
    vectors$x, 
    vectors$y,
    batch_size = 258,
    validation_split = 0.15,
    epochs = epochs
  )
  NULL
}

# tahap 9
model <- create_model(chars, max_length)



n_sample = length(dataset$sentence)

for(i in 1:5){
  # kita sampling dulu
  sampling = sample(n_sample,800,replace = F)
  # ambil
  d_1 = list(sentence  = dataset$sentence[sampling],
             next_char = dataset$next_char[sampling])
  # ubah
  vectors <- vectorize(d_1)
  # train
  fit_model(model, vectors,50)
  print(i)
  Sys.sleep(5)
}

# tahap 10
preds <- predict(model, pred_donk$x) %>% as.data.frame()
mana = t(preds) %>% as.data.frame() %>% .$V1 %>% which.max()
tes
chars[mana]

save_model_hdf5(model,"keras model nutrifood.h5")
# model = load_model_hdf5("keras model nutrifood.h5")

# tahap 10
# generate dari teks
generate_input <- function(model, text, chars, max_length, diversity,input){
  
  # this function chooses the next character for the phrase
  choose_next_char <- function(preds, chars, temperature){
    preds <- log(preds) / temperature
    exp_preds <- exp(preds)
    preds <- exp_preds / sum(exp(preds))
    
    next_index <- rmultinom(1, 1, preds) %>% 
      as.integer() %>%
      which.max()
    chars[next_index]
  }
  
  # this function takes a sequence of characters and turns it into a numeric array for the model
  convert_sentence_to_data <- function(sentence, chars){
    x <- sapply(chars, function(x){
      as.integer(x == sentence)
    })
    array_reshape(x, c(1, dim(x)))
  }
  
  # the inital sentence is from the text
  sentence = input
  sentence = strsplit(sentence,split = " ") %>% unlist()
  kurang   = max_length - length(sentence)
  sentence = c(sentence,rep(" ",kurang))
  generated = c(input)
  
  # while we still need characters for the phrase
  for(i in 1:(max_length * 10)){
    
    sentence_data <- convert_sentence_to_data(sentence, chars)
    
    # get the predictions for each next character
    preds <- predict(model, sentence_data)
    
    # choose the character
    next_char <- choose_next_char(preds, chars, diversity)
    
    # add it to the text and continue
    generated <- paste(generated, next_char, collapse = " ")
    sentence <- c(sentence[-1], next_char)
    #print(sentence)
  }
  
  generated
}

input = "saya adalah orang yang"
diversity = .9
generate_input(model, text, chars, max_length, diversity,input)
