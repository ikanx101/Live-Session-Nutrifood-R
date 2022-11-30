rm(list=ls())

# available models
# https://topepo.github.io/caret/available-models.html

setwd("~/Live-Session-Nutrifood-R/Kaggle Data/WC Qatar 2022/rekapan all")

library(dplyr)
library(caret)

load("all.rda")

final_data = final_data %>% select(-negara) %>% mutate(status = ifelse(status == "win",1,0),
                                                       status = as.factor(status))

set.seed(20921004)

inTraining = createDataPartition(final_data$status, p = .8, list = FALSE)
training = final_data[ inTraining,]
testing  = final_data[-inTraining,]

fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)

gbmFit1 <- train(status ~ ., data = training, 
                 method = "gbm", 
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE)

gbmFit1

prediksi = predict(gbmFit1, newdata = testing)
table(prediksi,testing$status)

train_pred = predict(gbmFit1, newdata = training)
table(train_pred,training$status)


rdaFit <- train(status ~ ., data = training, 
                method = "earth")
rdaFit          

prediksi = predict(rdaFit, newdata = testing)
table(prediksi,testing$status)

train_pred = predict(rdaFit, newdata = training)
table(train_pred,training$status)
