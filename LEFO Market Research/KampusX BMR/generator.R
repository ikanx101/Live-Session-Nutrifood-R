setwd("~/Live-Session-Nutrifood-R/LEFO Market Research/KampusX BMR")

rm(list=ls())

library(dplyr)

n_resp = 250

nama   = randomNames::randomNames(which.names = "first",n_resp)
gender = sample(c("Pria","Wanita"),n_resp,replace = T,prob = c(.55,.45))
usia   = sample(c("<20","20-29","30-39","40-49",">50"),
                n_resp,
                replace = T,
                prob = c(.1,.2,.3,.25,.09))

# nonton TV
ntn_tv  = sample(c("ya","tidak"),
                 n_resp,
                 replace = T,
                 prob = c(.95,.05))

# spontan awareness
spontan  = sample(c("ya","tidak"),
                  n_resp,
                  replace = T,
                  prob = c(.2,.8))
spontan  = ifelse(ntn_tv == "ya",spontan,NA)

# aided awareness
aided    = sample(c("ya","tidak"),
                  n_resp,
                  replace = T,
                  prob = c(.7,.3))
aided    = ifelse(ntn_tv == "ya",aided,NA)

# message delivered
message  = sample(c("ya","tidak"),
                  n_resp,
                  replace = T,
                  prob = c(.6,.4))
message  = ifelse(aided == "ya",message,NA)

# bikin data frame
df = data.frame(id = 1:n_resp,
                nama,
                gender,
                usia = factor(usia,levels = c("<20","20-29","30-39","40-49",">50")),
                ntn_tv,
                spontan,aided,
                message)

save(df,file = "hasil_interview.rda")