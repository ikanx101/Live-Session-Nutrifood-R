# https://www.kaggle.com/competitions/icr-identify-age-related-conditions/leaderboard?

# set libraries
rm(list=ls())
library(dplyr)
library(keras)
library(tensorflow)
library(caret)

Id = 1:617
class_0 = .5
class_1 = .5

df = data.frame(Id,class_0,class_1)

write.csv(df,file = "submisi.csv")