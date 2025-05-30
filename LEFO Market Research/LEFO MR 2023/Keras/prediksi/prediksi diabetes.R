# set libraries
rm(list=ls())
library(dplyr)
library(keras)
library(tensorflow)
library(caret)
library(janitor)

# import data
data = read.csv("https://raw.githubusercontent.com/ikanx101/Live-Session-Nutrifood-R/master/Kaggle%20Data/Diabetes/raw%20data/diabetes.csv") 
colnames(data) = tolower(colnames(data))

# proses resampling data
n_data   = nrow(data)
n_sample = sample(n_data,40,replace = T)

data_new = data[n_sample,]
data     = rbind(data,data_new)
# ===================================

# bikin tabulasi dulu
data %>% tabyl(outcome)

save_dulu = data$outcome
data =
  data %>%
  select(-bloodpressure,-skinthickness,-outcome,-insulin)


preProcess_range_model = preProcess(data, method='center')
data = predict(preProcess_range_model, newdata = data) #variabel targetnya hilang di sini
data$outcome = save_dulu

head(data)
tabyl(data$outcome)

# kita pisah pecah dua
data_0 = 
  data %>% 
  filter(outcome == 0)
data_1 = 
  data %>% 
  filter(outcome == 1)

# set minimal n for train data
set.seed(10104074)
n = 150

id_0 = sample(nrow(data_0),n,replace = F)
data_0_1 = data_0[id_0,]
data_0_2 = data_0[-id_0,]

id_1 = sample(nrow(data_1),n,replace = F)
data_1_1 = data_1[id_1,]
data_1_2 = data_1[-id_1,]

# set train and test
train_df = rbind(data_0_1,data_1_1)
test_df = rbind(data_0_2,data_1_2)

# let's see
# train
train_label_raw = train_df$outcome 
train_label_clean = to_categorical(train_label_raw,num_classes = 2)
train_matrix = as.matrix(train_df[-ncol(train_df)])

to_categorical(train_label_raw,num_classes = 1)

# test
test_label_raw = test_df$outcome
test_label_clean = to_categorical(test_label_raw)
test_matrix = as.matrix(test_df[-ncol(train_df)])


model = keras_model_sequential()
model %>%
  layer_dense(units = 1986,activation = 'sigmoid',
              input_shape = c(ncol(train_matrix))) %>%
  layer_dense(units = 21, activation = 'sigmoid') %>%
  layer_dense(units = 12, activation = 'sigmoid') %>%
  layer_dense(units = 7, activation = 'relu') %>%
  layer_dense(units = 2, activation = 'sigmoid')

summary(model)

model %>% compile(
  loss='binary_crossentropy',
  optimizer='adam',
  metrics=c('accuracy')
)


fitModel =
  model %>%
  keras::fit(train_matrix,
             train_label_clean,
             epochs = 90,
             batch_size = 30,
             steps_per_epoch = 10,
             validation_split = 0.15)


# evaluasi dengan train
model %>% evaluate(train_matrix, train_label_clean, verbose = 0)

# evaluasi dengan test
model %>% evaluate(test_matrix, test_label_clean, verbose = 0)


# Pakai train
pred_train = predict(model, train_matrix) %>% k_argmax() %>% as.vector()
table(pred_train,train_label_raw)
mean(train_label_raw == pred_train)

# Pakai test
pred_test = predict(model, test_matrix) %>% k_argmax() %>% as.vector()
table(pred_test,test_label_raw)
mean(test_label_raw == pred_test)
