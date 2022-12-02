# ==========================================================
rm(list=ls())
set.seed(20921004)

# available models
# https://topepo.github.io/caret/available-models.html

options(scipen = 99)
setwd("~/Live-Session-Nutrifood-R/Kaggle Data/WC Qatar 2022/rekapan all")

library(dplyr)
library(caret)

# ==========================================================
load("all.rda")
write.csv(final_data,"data WC.csv")

final_data = final_data %>% select(-negara,-goals) %>% mutate(status = ifelse(status == "win",1,0),
                                                       status = as.factor(status))


inTraining = createDataPartition(final_data$status, p = .7, list = FALSE)
training = final_data[ inTraining,]
testing  = final_data[-inTraining,]

# ==========================================================
fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)

# ==========================================================
# model 1 GBM
gbmFit1 = train(status ~ ., data = training, 
                method = "gbm", 
                trControl = fitControl,
                verbose = FALSE)

prediksi = predict(gbmFit1, newdata = testing)
table(prediksi,testing$status)
akurasi_GBM_test = mean(prediksi == testing$status) * 100

train_pred = predict(gbmFit1, newdata = training)
table(train_pred,training$status)
akurasi_GBM_train = mean(train_pred == training$status) * 100

# ==========================================================
# model 2 random forest
model_rf = train(status ~ .,
                 data = training, 
                 method='rf', 
                 tuneLength=5, 
                 trControl = fitControl)

prediksi = predict(model_rf, newdata = testing)
table(prediksi,testing$status)
akurasi_RF_test = mean(prediksi == testing$status) * 100

train_pred = predict(model_rf, newdata = training)
table(train_pred,training$status)
akurasi_RF_train = mean(train_pred == training$status) * 100


# ==========================================================
model_SVMRadial = train(status ~ ., 
                        data = training, 
                        method='svmRadial', 
                        tuneLength=15, 
                        trControl = fitControl, 
                        verbose=F)

prediksi = predict(model_SVMRadial, newdata = testing)
table(prediksi,testing$status)
akurasi_SVMRadial_test = mean(prediksi == testing$status) * 100

train_pred = predict(model_SVMRadial, newdata = training)
table(train_pred,training$status)
akurasi_SVMRadial_train = mean(train_pred == training$status) * 100

# ==========================================================
model_GLMNet = train(status ~ ., 
                        data = training, 
                        method='glmnet', 
                        tuneLength=15, 
                        trControl = fitControl, 
                        verbose=F)

prediksi = predict(model_GLMNet, newdata = testing)
table(prediksi,testing$status)
akurasi_GLMNet_test = mean(prediksi == testing$status) * 100

train_pred = predict(model_GLMNet, newdata = training)
table(train_pred,training$status)
akurasi_GLMNet_train = mean(train_pred == training$status) * 100

# ==========================================================
model_EARTH = train(status ~ ., 
                     data = training, 
                     method='earth')

prediksi = predict(model_EARTH, newdata = testing)
table(prediksi,testing$status)
akurasi_EARTH_test = mean(prediksi == testing$status) * 100

train_pred = predict(model_EARTH, newdata = training)
table(train_pred,training$status)
akurasi_EARTH_train = mean(train_pred == training$status) * 100


# ==========================================================
model_NB = train(status ~ ., 
                    data = training, 
                    method='naive_bayes')

prediksi = predict(model_NB, newdata = testing)
table(prediksi,testing$status)
akurasi_NB_test = mean(prediksi == testing$status) * 100

train_pred = predict(model_NB, newdata = training)
table(train_pred,training$status)
akurasi_NB_train = mean(train_pred == training$status) * 100

# ==========================================================
model_parRF = train(status ~ ., 
                 data = training, 
                 method='parRF',
                 trControl = fitControl)

prediksi = predict(model_parRF, newdata = testing)
table(prediksi,testing$status)
akurasi_parRF_test = mean(prediksi == testing$status) * 100

train_pred = predict(model_parRF, newdata = training)
table(train_pred,training$status)
akurasi_parRF_train = mean(train_pred == training$status) * 100

# ==========================================================
# kita bikin rekap
rekap = data.frame(
  model = c("GBM","Random forest","SVM Radial",
            "GLMNet","Multivariate Adaptive Regression Spline",
            "Naive Bayes","Parallel Random Forest"),
  akurasi_test = c(akurasi_GBM_test,akurasi_RF_test,akurasi_SVMRadial_test,
                   akurasi_GLMNet_test,akurasi_EARTH_test,
                   akurasi_NB_test,akurasi_parRF_test),
  akurasi_train = c(akurasi_GBM_train,akurasi_RF_train,akurasi_SVMRadial_train,
                    akurasi_GLMNet_train,akurasi_EARTH_train,
                    akurasi_NB_train,akurasi_parRF_train)
)

rekap %>% arrange(desc(akurasi_test))

# prediksi pertandingan nanti malam
load("all.rda")
final_data$negara %>% unique() %>% sort()
match = 
  final_data %>%
  select(-status) %>% 
  filter(negara %in% c("ghana","uruguay","korea","portugal")) %>% 
  group_by(negara) %>% 
  summarise_all(mean) %>% 
  ungroup()

prediksi = predict(model_GLMNet, 
                   newdata = match,type="prob") %>% 
           as.data.frame()
data.frame(negara = match$negara,
           win_prob = prediksi$`1` * 100,
           not_win_prob = prediksi$`0` * 100) %>% 
  mutate(win_prob = round(win_prob,1),
         not_win_prob = round(not_win_prob,1))

