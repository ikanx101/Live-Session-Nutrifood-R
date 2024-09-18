# sumber:
# https://cran.r-project.org/web/packages/kgrams/vignettes/kgrams.html

rm(list=ls())
gc()

library(kgrams)
library(dplyr)
library(tidyr)
library(tidytext)
library(rvest)

setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/LLM/k grams")

urls  = readLines("links.txt")

ekstrak = function(url){
  baca = url %>% read_html() %>% html_nodes("p") %>% html_text() %>% unique()
  dummy = data.frame(id = 1:length(baca),
                     baca)
  dummy %>% 
    unnest_tokens(word,baca) %>% 
    group_by(id) %>% 
    summarise(kalimat = paste(word,collapse = " ")) %>% 
    ungroup() %>% 
    .$kalimat %>% 
    unique() %>% 
    stringr::str_trim()
}

baca = c()
for(i in 1:length(urls)){
  baca_temp = ekstrak(urls[i])
  baca      = c(baca,baca_temp)
  print(i)
}


# step 1
# pakai data ini
much_ado = baca %>% unique()

save(much_ado,file = "~/Live-Session-Nutrifood-R/LEFO Market Research/LEFO MR 2023/LLM/stupid back off/data.rda")

# step 2
# pre processing
.preprocess <- function(x) {
  x <- kgrams::preprocess(x)
  # Collapse to a single string to avoid splitting into more sentences at the end of lines
  x <- paste(x, collapse = " ")
  return(x)
}

.tknz_sent <- function(x) {
  # Tokenize sentences
  x <- kgrams::tknz_sent(x, keep_first = TRUE)
  # Remove empty sentences
  x <- x[x != ""]
  return(x)
}

# step 3
freqs <- kgram_freqs(much_ado, # Read Shakespeare's text from connection
                     N = 3, # Store k-gram counts for k <= 5
                     .preprocess = .preprocess,  # preprocess text
                     .tknz_sent = .tknz_sent, # tokenize sentences
                     verbose = FALSE
)
freqs
summary(freqs)


# step 4 
# build the final language model
smoothers()
info("kn")

kn <- language_model(freqs, "kn", D = 0.8)
kn
summary(kn)

probability(c("hoegeng"),
model = kn
)


#set.seed(10104074)
sample_sentences(model = kn, 
                 n = 2,
                 max_length = 50,
                 t = 10
)








