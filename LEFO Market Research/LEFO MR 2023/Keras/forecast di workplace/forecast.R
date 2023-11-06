# dimulai dari hati yang bersih
rm(list=ls())

# memanggil semua libraries yang diperlukan
library(dplyr)
library(tidyr)
library(caret)
library(keras)
library(tensorflow)

setwd("~/ASONG/nitip forecast")

df = read_excel("forecst.xlsx") %>% rename(omset = sales)

df$omset = df$omset/10^8

# saya bikin 6 bulan untuk prediksi 1 bulan
n_bulan = 4
n_data  = nrow(df)
n_ding  = n_data - n_bulan

# membuat data input untuk training
input = data.frame(x1 = 0,
                   x2 = 0,
                   x3 = 0,
                   x4 = 0)
target = rep(0,n_ding)

# mulai iterasi untuk membuat data training
for(i in 1:n_ding){
  save      = df$omset[i:(i + n_bulan - 1)] %>% t() %>% list()
  input[i,] = save[[1]]
  target[i] = df$omset[i + n_bulan]
}

# berikut adalah tampilan hasilnya
input_asal  = input
target_asal = target

head(input,5)
head(target,5)

for(i in 1:300){
  # kita acak
  id = sample(nrow(input_asal),15)
  
  input_generate  = input_asal[id,]
  target_generate = target_asal[id] 
  
  acak_1     = runif(nrow(input_generate),-.4,.4)
  acak_2     = runif(nrow(input_generate),-.3,.3)
  acak_3     = runif(nrow(input_generate),-.4,.4)
  acak_4     = runif(nrow(input_generate),-.3,.3)
  acak_5     = runif(nrow(input_generate),-.3,.3)
  
  input_temp = input_generate %>% mutate(x1 = x1 + acak_1,
                                         x2 = x2 + acak_2,
                                         x3 = x3 + acak_3,
                                         x4 = x4 + acak_4)
  target_temp = target_generate + acak_5
  
  input  = rbind(input,input_temp)
  target = c(target,target_temp)
}

# ini untuk keperluan x awal
x = input %>% as.matrix()
y = target 


model = 
  keras_model_sequential() %>% 
  layer_lstm(units  = 300, activation = "linear", input_shape = c(ncol(x),1)) %>% 
  layer_dense(units = 1,   activation = "linear") %>%
  layer_activation("linear")

model %>% compile(
  loss      = "mape",
  optimizer = "rmsprop", 
  metrics   = list("mean_absolute_percentage_error")
)

model %>% summary()


fitmodel = 
  model %>% keras::fit(x, y, 
                       epochs  = 400,
                       verbose = 0,
                       validation_split = 0.20)

plot(fitmodel)

scores = model %>% evaluate(x, y, verbose = 0)
scores


# prediksi
x_awal = input_asal %>% as.matrix()
y_pred = model %>% predict(x_awal)
# masukin ke df
df$y_pred = c(rep(NA,n_bulan),
              y_pred)
df

# bulan 37 - 41
for(i in 1:5){
  bln_37     = df %>% tail(4)
  input_new  = bln_37$omset %>% t() %>% as.matrix()
  y_pred_n   = model %>% predict(input_new) %>% as.numeric()
  
  df[nrow(df) + 1,] <- list(nrow(df) + 1,
                            y_pred_n,
                            y_pred_n)
}

df$omset[37:41] = NA

plt_1 = 
  df %>% 
  rename(timeline = bulan) %>% 
  mutate(timeline = factor(timeline)) %>% 
  ggplot() +
  geom_line(aes(x = timeline,
                y = y_pred),
            color = "red",
            size = 1,
            alpha = .7,
            group = 1) +
  geom_point(aes(x = timeline,
                 y = y_pred),
             group = 1,
             color = "darkred") +
  geom_line(aes(x = timeline,
                y = omset),
            color = "steelblue",
            size = 1.5,
            alpha = .6,
            group = 1) +
  theme_minimal() +
  labs(x = "Timeline",
       y = "Omset",
       title = "Nilai Forecast vs Realisasi Omset",
       subtitle = "Biru = realisasi omset dan Merah = forecast omset",
       caption = paste0("MAPE = ",round(scores[[2]],7))) +
  theme(axis.text.y = element_blank(),
        plot.title = element_text(size = 20,face = "bold"),
        plot.subtitle = element_text(size = 17,face = "bold"),
        axis.title = element_text(size = 15),
        plot.caption = element_text(size = 17))


save(df,file = "hasil.rda")
save_model_hdf5(model,"keras model.h5")
