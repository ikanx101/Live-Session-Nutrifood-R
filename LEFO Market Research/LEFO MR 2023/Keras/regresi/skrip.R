rm(list=ls())

library(dplyr)
library(tidyr)
library(ggplot2)

# ==============================================================================
# fungsi untuk menggambar f(x)
gambar_fx = function(f,a,b,delta){
  temp = data.frame(
    x = seq(a,b,by = delta)
  ) %>% 
    mutate(y = f(x)) %>% 
    filter(!is.nan(y))
  subtitle = paste0("Pada selang [",a,",",b,"]")
  caption = "Digambar dengan R\nikanx101.com"
  temp %>% 
    ggplot(aes(x,y)) +
    geom_line(color = "steelblue") +
    theme_minimal() +
    labs(title = "Grafik f(x)",
         subtitle = subtitle,
         caption = caption)
  
}

# ini f(x)
f = function(x){sin(x) * cos(x) + sin(5^(-x))}

# ini selang
a = -2
b = pi
delta = 0.0001

# ini gambarnya
gambar_fx(f,a,b,delta)

# kita akan buat regresi dari data ini:
df = data.frame(x = seq(a,b,by = delta))
df = df %>% mutate(y = sapply(x,f))
# ==============================================================================


# ==============================================================================
# percobaan dengan menggunakan polinom order 25
poli_model5 = lm(y ~ polym(x,degree = 25), data = df)
pred_y      = predict(poli_model5,df)
df_poli     = df %>% mutate(y_pred = pred_y)
df_poli %>% 
  ggplot() +
  geom_line(aes(x,y),
            group = 1,
            color = "red") +
  geom_line(aes(x,y_pred),
            group = 1,
            color = "blue")

# ==============================================================================
library(keras)
library(tensorflow)
library(caret)

# kita buat dulu targetnya
target   = df$y

# kita buat fungsi untuk membuat macem-macem ya
reformulasi = function(){
  # kita buat data train nya
  df_train = df %>% select(x)
  df_train %>% 
    mutate(x_0 = x,
           x_1 = x^2,
           x_2 = x^3,
           x_3 = x^4,
           x_4 = x^5,
           x_5 = x/2,
           x_6 = x/3,
           x_7 = x/4,
           x_8 = x/5,
           x_9 = exp(x)) %>% 
    select(-x)
}

x = reformulasi() %>% as.matrix()
y = target %>% as.matrix()

head(x)

model = keras_model_sequential() %>% 
  layer_dense(units = 86, activation="relu", input_shape = ncol(x)) %>% 
  layer_dense(units = 21, activation = "relu") %>% 
  layer_dense(units = 12, activation = "relu") %>% 
  layer_dense(units = 7,  activation = "relu") %>% 
  layer_dense(units = 1,  activation = "linear")

model %>% compile(
  loss = "mse",
  optimizer =  "adam", 
  metrics = list("mean_absolute_error")
)

model %>% summary()

model %>% keras::fit(x, y, epochs = 100,verbose = 0)
scores = model %>% evaluate(x, y, verbose = 0)
print(scores)

# kita save modelnya terlebih dahulu
save_model_hdf5(model,"model regresi keras.h5")

y_pred = model %>% predict(x)
df$y_pred = y_pred


df %>% 
  ggplot() +
  geom_line(aes(x,y),color = "blue",linewidth = .5) +
  geom_line(aes(x,y_pred),color = "red",linewidth = .5,alpha = .5)




# ===================================
# preskidi
a          = -pi
b          = 1
df         = data.frame(x = seq(a,b,by = delta))
df         = df %>% mutate(y = sapply(x,f))
# menggunakan model regresi
y_pred     = poli_model5 %>% predict(df)
df$y_pred2 = y_pred
# target
target     = df$y
x          = reformulasi() %>% as.matrix()
y          = target %>% as.matrix()
# menggunakan model keras
y_pred     = model %>% predict(x)
df$y_pred1 = y_pred


df %>% 
  ggplot() +
  geom_line(aes(x,y),color = "blue",linewidth = .5) +
  geom_line(aes(x,y_pred1),color = "red",linewidth = .5,alpha = .5) +
  geom_line(aes(x,y_pred2),color = "green",linewidth = .5,alpha = .5)
  
