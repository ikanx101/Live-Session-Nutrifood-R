rm(list=ls())

setwd("/cloud/project/Kaggle Data/WC Qatar 2022")

library(dplyr)
library(tidyr)

list_rda = list.files(pattern = "*rda")
temp = vector("list",length(list_rda))
for(i in 1:length(list_rda)){
  load(list_rda[i])
  temp[[i]] = final
  print(i)
}

final_data = do.call(bind_rows,temp) %>% mutate(negara = ifelse(negara == "jepang","japan",negara),
                                                negara = ifelse(negara == "jerman","germany",negara))
final_data$negara %>% unique() %>% sort()

save(final_data,file = "/cloud/project/Kaggle Data/WC Qatar 2022/rekapan all/all.rda")