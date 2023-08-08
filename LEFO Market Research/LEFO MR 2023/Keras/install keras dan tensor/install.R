# sumber instalasi
# https://tensorflow.rstudio.com/install/

install.packages("tensorflow")

library(reticulate)
path_to_python <- install_python()
virtualenv_create("r-reticulate", python = path_to_python)

library(tensorflow)
install_tensorflow(envname = "r-reticulate")

install.packages("keras")
library(keras)
install_keras(envname = "r-reticulate")

reticulate::install_miniconda(force = T) 
reticulate::install_python()

library(tensorflow)
tf$constant("Hello Tensorflow!")
