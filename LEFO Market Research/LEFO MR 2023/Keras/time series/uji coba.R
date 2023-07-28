rm(list=ls())

library(dplyr)
library(tidyr)
library(ggplot2)
library(keras)

load("data.rda")
df$omset = df$omset/10^6

#df$omset = df$omset + runif(1,-100,100)

# kita bikin 5 bulan untuk prediksi 1 bulan
n_bulan = 5
n_data  = nrow(df)
n_ding  = n_data - n_bulan

# bikin data input
input = data.frame(x1 = 0,
                   x2 = 0,
                   x3 = 0,
                   x4 = 0,
                   x5 = 0)
target = rep(0,n_ding)

# mulai iterasi
for(i in 1:n_ding){
  save      = df$omset[i:(i + n_bulan - 1)] %>% t() %>% list()
  input[i,] = save[[1]]
  target[i] = df$omset[i + n_bulan]
}

input = 
  input %>% 
  mutate(x11 = sqrt(x1),
         x12 = sqrt(x2),
         x13 = sqrt(x3),
         x14 = sqrt(x4),
         x15 = sqrt(x5),
         x21 = log(x1),
         x22 = log(x2),
         x23 = log(x3),
         x24 = log(x4),
         x25 = log(x5))

# ==============================================================================
x = input %>% as.matrix()
y = target %>% as.matrix()

head(x)

model = 
  keras_model_sequential() %>% 
  layer_dense(units = 80, activation="linear", input_shape = ncol(x)) %>% 
  layer_dense(units = 50, activation = "linear") %>% 
  layer_dense(units = 50, activation = "linear") %>% 
  layer_dense(units = 50, activation = "relu") %>% 
  layer_dense(units = 50, activation = "linear") %>% 
  layer_dense(units = 50, activation = "relu") %>% 
  layer_dense(units = 50, activation = "linear") %>% 
  layer_dense(units = 50, activation = "relu") %>% 
  layer_dense(units = 50, activation = "relu") %>% 
  layer_dense(units = 1,  activation = "linear")

model %>% compile(
  loss      = "mse",
  optimizer =  "rmsprop", 
  metrics   = list("mean_absolute_error")
)


model %>% summary()

model %>% keras::fit(x, y, 
                     epochs = 300,
                     verbose = 0,
                     validation_split = 0.05)
scores = model %>% evaluate(x, y, verbose = 0)
scores


# prediksi
y_pred = model %>% predict(x)
# masukin ke df
df$y_pred = c(rep(NA,n_bulan),
              y_pred)


plt_1 = 
  df %>% 
  ggplot() +
  geom_line(aes(x = timeline,
                y = omset),
            color = "blue",
            group = 1) +
  geom_line(aes(x = timeline,
                y = y_pred),
            color = "red",
            group = 1)

plt_2 = 
  df %>% 
  ggplot(aes(x = omset,
             y  = y_pred)) +
  geom_point() +
  geom_smooth(method = "lm")

ggpubr::ggarrange(plt_1,plt_2,ncol = 2)
print(scores)
cor(df$omset[(n_bulan+1):nrow(df)],
    df$y_pred[(n_bulan+1):nrow(df)])


# save_model_hdf5(model,"time_series model.h5")
# model = load_model_hdf5("time_series model.h5")
