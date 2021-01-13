# dimulai dari hati yang bersih
rm(list=ls())
setwd("~/Documents/Live-Session-Nutrifood-R/Kaggle Data/TiTaNic")

# panggil libraries
library(dplyr)
library(tidyr)
library(keras)
library(tensorflow)
library(caret)

# import data
data = read.csv("train.csv") %>% janitor::clean_names()
test_submit = read.csv("test.csv") %>% janitor::clean_names()

# =========================================
# cek any NA
table(is.na(data))
apply(data, 2, function(x) any(is.na(x)))

# =========================================
# kita gabung saja antara submit dan data
test_submit$survived = NA
data_all = rbind(data,test_submit)

# fungsi mean
mean_new = function(var){
  idx = grep(T,!is.na(var))
  mean(var[idx])
}

data_all$age = ifelse(is.na(data_all$age),mean_new(data_all$age),data_all$age)
data_all$fare = ifelse(is.na(data_all$fare),mean_new(data_all$fare),data_all$fare)

apply(data_all, 2, function(x) any(is.na(x)))

# =========================================
# kita pisah numeric dan character
all_string = 
  data_all %>%
  select(is.character) %>% 
  select(sex,cabin,embarked)
all_numeric = 
  data_all %>% 
  select(is.numeric,-survived,-passenger_id)
target = data_all$survived

# =========================================
# ini utk ngecek
# library(ROCit)
# roc_empirical = rocit(score=data$gpa,class=data$best_performance)
# summary(roc_empirical)
# plot(roc_empirical)

# =========================================
# kita coba telaah dulu yah
# pake library expss
# library(expss)
# library(ggpubr)
# categoric check
# data %>% 
#   tab_cells(job_level) %>% 
#   tab_cols(best_performance) %>% 
#   tab_stat_cpct() %>% 
#   tab_pivot()
# prop.table(table(test_submit$job_level))*100
# kesimpulan: job_level dihapus

# numeric check
# c1 = 
#   data %>% 
#   ggplot(aes(x = sick_leaves)) +
#   geom_density() +
#     facet_wrap(~best_performance)
# c2 = 
#   test_submit %>% 
#   ggplot(aes(x = sick_leaves)) +
#   geom_density()
# ggarrange(c1,c2,widths = c(2,1))
# kesimpulan: -------

# =========================================
# all numeric
# pre process to range
preProcess_range_model = preProcess(all_numeric, method = 'pca')
all_numeric = predict(preProcess_range_model, newdata = all_numeric)
# all string
dmy = dummyVars(" ~ .", data = all_string)
all_string = data.frame(predict(dmy, newdata = all_string))

# gabung data semuanya
data = 
  data.frame(all_numeric,all_string,target)

#label data
Label = data$target

# =========================================
# membuat train dan submit data
train = 
  data %>% 
  filter(!is.na(target))
submit = 
  data %>%
  filter(is.na(target)) %>% 
  select(-target)

# lets check this out
table(Label)

# it's a little bit imbalance
# train and test
set.seed(10104074)
yes = train %>% filter(target == 1)
no = train %>% filter(target == 0)

n = nrow(yes)
m = nrow(no)

# max prop = 342
prop = 320

id_yes = sample(n,prop,replace = F)
id_no = sample(m,prop,replace = F)

train_yes = yes[id_yes,]
train_no = no[id_no,]

test_yes = yes[-id_yes,]
test_no = no[-id_no,]

train_df = rbind(train_yes,train_no)
test_df = rbind(test_yes,test_no)

# change to matrix form
# kita ambil dl utk train label
train_label_raw = train_df$target
train_label_clean = to_categorical(train_label_raw)
train_matrix = as.matrix(train_df[-ncol(train_df)])

# kita ambil dl utk test label
test_label_raw = test_df$target
test_label_clean = to_categorical(test_label_raw)
test_matrix = as.matrix(test_df[-ncol(test_df)])

# KERAS
library(pROC)
# model KERAS
model = keras_model_sequential()
model %>%
  layer_dense(units = 243,activation = 'relu',
              input_shape = c(ncol(train_matrix))) %>%
  layer_dense(units = 172, activation = 'sigmoid') %>%
  layer_dense(units = 85, activation = 'sigmoid') %>%
  layer_dense(units = 44, activation = 'sigmoid') %>%
  layer_dense(units = 2, activation = 'sigmoid')
summary(model)

model %>% compile(
  loss='binary_crossentropy',
  optimizer='adam',
  metrics=c('accuracy')
)

fitModel =
  model %>%
  fit(train_matrix,
      train_label_clean,
      epochs = 50,
      batch_size = 50,
      validation_split = 0.15)

# Pakai train
pred = model %>% predict_classes(train_matrix)
confusionMatrix(reference = as.factor(train_label_raw),
                data = as.factor(pred),
                mode="prec_recall")

roc_obj <- roc(as.numeric(train_label_raw), as.numeric(pred))
auc(roc_obj)

# Pakai test
pred = model %>% predict_classes(test_matrix)
confusionMatrix(reference = as.factor(test_label_raw),
                data = as.factor(pred),
                mode="prec_recall")

roc_obj <- roc(as.numeric(test_label_raw), as.numeric(pred))
auc(roc_obj)

# Save Model Tensorflow
model %>% save_model_tf("model")

# pake submit
submit = as.matrix(submit)
sub = model %>% predict_classes(submit)
submission = data.frame(
  PassengerId = test_submit$passenger_id,
  Survived = sub
)
write.csv(submission,"submit.csv",row.names = F)
