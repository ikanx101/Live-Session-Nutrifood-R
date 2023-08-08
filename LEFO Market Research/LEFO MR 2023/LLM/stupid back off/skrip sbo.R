# sumber
# https://cran.r-project.org/web/packages/sbo/vignettes/sbo.html

setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/LLM/stupid back off")

rm(list=ls())

library(sbo)
library(dplyr)
library(tidyr)
library(tidytext)

load("data.rda")

p <- sbo_predictor(object = much_ado, # preloaded example dataset
                   N = 4, # Train a 3-gram model
                   dict = target ~ 0.85, # cover 75% of training corpus
                   .preprocess = sbo::preprocess, # Preprocessing transformation 
                   EOS = ".?!:;", # End-Of-Sentence tokens
                   lambda = 0.35, # Back-off penalization in SBO algorithm
                   L = 3L, # Number of predictions for input
                   filtered = "<UNK>" # Exclude the <UNK> token from predictions
)

p %>% summary()

babble(p)

(evaluation <- eval_sbo_predictor(p, test = much_ado))

evaluation %>% summarise(accuracy = sum(correct)/n(), 
                         uncertainty = sqrt(accuracy * (1 - accuracy) / n())
)

evaluation %>% # Accuracy for in-sentence predictions
  filter(true != "<EOS>") %>%
  summarise(accuracy = sum(correct) / n(),
            uncertainty = sqrt(accuracy * (1 - accuracy) / n())
  )


predict(p, "anies")
babble(p, input = "pemilu 2024",
       n_max = 100)
