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
  select(sex,embarked)
all_numeric = 
  data_all %>% 
  select(is.numeric,-survived,-passenger_id)
target = data_all$survived

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
  data.frame(all_numeric,target)

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
prop = 340

id_yes = sample(n,prop,replace = F)
id_no = sample(m,prop,replace = F)

train_yes = yes[id_yes,]
train_no = no[id_no,]

test_yes = yes[-id_yes,]
test_no = no[-id_no,]

train_df = rbind(train_yes,train_no)
test_df = rbind(test_yes,test_no)

# discriminant analysis
library(MASS)
library(klaR)
model<- lda(target~., train_df)
model

pred = predict(model,submit)
pred = pred$class
submission = data.frame(
  PassengerId = test_submit$passenger_id,
  Survived = pred
)
write.csv(submission,"submit lda new.csv",row.names = F)