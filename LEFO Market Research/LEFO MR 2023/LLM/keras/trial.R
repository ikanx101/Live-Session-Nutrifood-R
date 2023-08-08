rm(list=ls())

setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/LLM/keras")

# Install required packages
# install.packages("keras")

# Load necessary libraries
library(keras)
library(tidyverse)


input_length = 30
n_sample = 5
vocab_size = 100
quest_train <- matrix(floor(runif(input_length*n_sample, 1,vocab_size)), ncol = input_length)
tag_train <- matrix(sample(c(0,1), size = input_length*n_sample, replace = T), ncol = input_length)

tag_train_reshape <- to_categorical(tag_train)

input_dim = vocab_size
embed_dim = 50


model <- keras_model_sequential()
model %>%
  layer_embedding(input_dim = input_dim,
                  output_dim = embed_dim) %>%
  layer_dropout(rate = 0.2) %>%
  layer_lstm(units = 128, return_sequences = T) %>%
  layer_dropout(rate = 0.5) %>% 
  time_distributed(layer_dense(units = 2, activation = 'softmax'))

model %>%
  compile(loss = 'categorical_crossentropy', 
          optimizer = 'adam', 
          metrics = c('accuracy'))

model %>% keras::fit(quest_train,  
                     tag_train_reshape, 
                     batch_size = 16 ,
                     epochs = 20,
                     shuffle = TRUE)
