# set libraries
rm(list=ls())
library(dplyr)
library(keras)
library(tensorflow)
library(caret)

train = read.csv("train.csv") %>% select(-id)
test  = read.csv("test.csv") %>% select(-id)

# proses resampling data
n_data   = nrow(train)
n_sample = sample(n_data,400,replace = T)

data_new = train[n_sample,]
train     = rbind(train,data_new)

df_all = bind_rows(train,test)
target = df_all$target
df_all = df_all %>% select(-target)

#preProcess_range_model = preProcess(df_all, method='range')
#df_all                 = predict(preProcess_range_model, newdata = df_all) #variabel targetnya hilang di sini
df_all$target          = target

df_all = df_all %>% filter(!is.na(target))

# let's see
# train
train_label_raw   = df_all$target
train_label_clean = to_categorical(train_label_raw)
train_matrix      = as.matrix(df_all[-ncol(df_all)])

model = keras_model_sequential()
model %>%
  layer_dense(units = 1986,activation = 'sigmoid',
              input_shape = c(ncol(train_matrix))) %>%
  layer_dense(units = 21, activation = 'softmax') %>%
  layer_dense(units = 12, activation = 'sigmoid') %>%
  layer_dense(units = 2, activation = 'softmax')

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
             epochs = 50,
             batch_size = 30,
             steps_per_epoch = 10,
             validation_split = 0.15)


# evaluasi dengan train
model %>% evaluate(train_matrix, train_label_clean, verbose = 0)

# Pakai train
pred_train = predict(model, train_matrix) %>% k_argmax() %>% as.vector()
table(pred_train,train_label_raw)
mean(train_label_raw == pred_train)

# pakai test
test_matrix = as.matrix(test)
pred_test   = predict(model, test_matrix) %>% k_argmax() %>% as.vector()

jawaban = data.frame(id     = 1:160,
                     target = pred_test)

write.csv(jawaban,"submisi_1.csv",row.names = F)
