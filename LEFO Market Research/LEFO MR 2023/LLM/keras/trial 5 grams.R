library(keras)
library(tidyverse)
library(janeaustenr)
library(tokenizers)

rm(list=ls())

# tahap 1
# kita masukin teks feedingnya terlebih dahulu
load("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/LLM/markov chain/data 1.rda")

texts = much_ado[1:3]

#texts

# tahap 2
max_length <- 5

text =
  texts %>% 
  str_c(collapse = " ") %>% 
  strsplit(split = " ") %>% 
  unlist()

text
print(sprintf("Corpus length: %d", length(text)))

chars <- text %>%
  unique() %>%
  sort()
chars
print(sprintf("Total characters: %d", length(chars)))

# tahap 3
dataset <- map(
  seq(1, length(text) - max_length - 1, by = 4), 
  ~list(sentence = text[.x:(.x + max_length - 1)], 
        next_char = text[.x + max_length])
)
dataset

# tahap 4
dataset <- transpose(dataset)
dataset


# tahap 5
vectorize <- function(data, chars, max_length){
  x <- array(0, dim = c(length(data$sentence), max_length, length(chars)))
  y <- array(0, dim = c(length(data$sentence), length(chars)))
  
  for(i in 1:length(data$sentence)){
    x[i,,] <- sapply(chars, function(x){
      as.integer(x == data$sentence[[i]])
    })
    y[i,] <- as.integer(chars == data$next_char[[i]])
  }
  
  list(y = y,
       x = x)
}

vectors <- vectorize(dataset, chars, max_length)
vectors$y


# tahap 6
tes = list(sentence  = dataset$sentence[1],
           next_char = dataset$next_char[1])

tes
pred_donk = vectorize(tes,chars,max_length)


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


# tahap 8
generate_phrase <- function(model, text, chars, max_length, diversity){
  
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
  start_index <- sample(1:(length(text) - max_length), size = 1)
  sentence <- text[start_index:(start_index + max_length - 1)]
  generated <- ""
  
  # while we still need characters for the phrase
  for(i in 1:(max_length * 20)){
    
    sentence_data <- convert_sentence_to_data(sentence, chars)
    
    # get the predictions for each next character
    preds <- predict(model, sentence_data)
    
    # choose the character
    next_char <- choose_next_char(preds, chars, diversity)
    
    # add it to the text and continue
    generated <- paste(generated, next_char, collapse = " ")
    sentence <- c(sentence[-1], next_char)
  }
  
  generated
}

# tahap 9
model <- create_model(chars, max_length)

fit_model(model, vectors,10)


# tahap 10
preds <- predict(model, pred_donk$x) %>% as.data.frame()
mana = t(preds) %>% as.data.frame() %>% .$V1 %>% which.max()
tes
chars[mana]

# generate random
generate_phrase(model,text,chars,max_length,.9)


# tahap 11
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
  for(i in 1:(max_length * 20)){
    
    sentence_data <- convert_sentence_to_data(sentence, chars)
    
    # get the predictions for each next character
    preds <- predict(model, sentence_data)
    
    # choose the character
    next_char <- choose_next_char(preds, chars, diversity)
    
    # add it to the text and continue
    generated <- paste(generated, next_char, collapse = " ")
    sentence <- c(sentence[-1], next_char)
  }
  
  generated
}

input = "anies baswedan"
diversity = .6
generate_input(model, text, chars, max_length, diversity,input)
