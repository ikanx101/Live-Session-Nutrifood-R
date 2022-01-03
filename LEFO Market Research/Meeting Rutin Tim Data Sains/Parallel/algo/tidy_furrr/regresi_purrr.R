rm(list=ls())

library(dplyr)
library(purrr)
library(furrr)
library(tidyr)


df = mtcars %>% select(mpg,am,gear) %>% nest(data = c(mpg,gear))

plan(sequential)

start = Sys.time()

model_df = 
  df %>%
  mutate(model = future_map(data, function(df){
		     Sys.sleep(5)
		     lm(mpg ~ gear, data = df)
		     }
		    )
	)

waktu = Sys.time() - start

cat(rep("\n",20))
print("Modelling regresi linear standar dengan purrr")
print("Menggunakan data mtcars, melakukan regresi linear antara:")
print("mpg ~ gear per tipe transmisi mobil")
print("===========================================================")
print("Runtime:")
print(waktu)

print(model_df$model[1])
print(model_df$model[2])
