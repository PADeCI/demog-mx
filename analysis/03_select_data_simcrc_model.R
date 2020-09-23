library(dplyr)

load("data/Estatal/df_mortrate_state_age.Rdata")

df_mortrate_state_age_cdmx <- df_mortrate_state_age %>% 
  filter(state == "Mexico City", 
         year <= 2020 & year >= 2015)

write.csv(df_mortrate_state_age_cdmx, file = "data/Estatal/df_mortrate_state_age_Mexico_City.csv")
