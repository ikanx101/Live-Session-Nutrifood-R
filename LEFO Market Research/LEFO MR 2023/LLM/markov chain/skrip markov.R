# sumber
# https://rpubs.com/nabiilahardini/text-generator

rm(list=ls())

setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/LLM/markov chain")

library(markovchain)
library(tokenizers)
library(dplyr)
library(tidyr)
library(tidytext)
library(stringr)

load("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/LLM/stupid back off/data.rda")

text_tlp = much_ado %>% strsplit(split = " ") %>% unlist()

fit_markov <- markovchainFit(text_tlp)

create_me <- function(num, first_word, n) {
  for (i in 1:num) {
    set.seed(i+5)
    markovchainSequence(n = n, # generate 2 additional random words
                        markovchain = fit_markov$estimate,
                        t0 = tolower(first_word), include.t0 = T) %>% 
      # joint words
      paste(collapse = " ") %>% # join generated words with space
      # create proper sentence form
      str_replace_all(pattern = " ,", replacement = ",") %>% 
      str_replace_all(pattern = " [.]", replacement = ".") %>% 
      str_replace_all(pattern = " [!]", replacement = "!") %>% 
      str_to_sentence() %>% # start every sentences with capitalization
      print()   
  }
}

create_me(2,"anies",5)
create_me(2,"ganjar",20)
create_me(2,"prabowo",20)
create_me(2,"indonesia",20)
