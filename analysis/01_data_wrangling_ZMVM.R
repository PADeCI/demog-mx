#*****************************************************************************# 
#
#   
#   load("~/GitHub/demog-model-mex/data/df_pop_state.Rdata")
#   vars: year, state, CV_GEO, population
#   
#   Depends on: 
#   Author: Regina Isabel Medina Rosales
#   
#*****************************************************************************# 

rm(list = ls()) # to clean the workspace

# *****************************************************************************
#### 01.01_Load_packages ####
# *****************************************************************************
library(data.table)
library(dplyr)

# *****************************************************************************
#### 01.02_Load_data####
# *****************************************************************************
load(df_pop_county)


# *****************************************************************************
#### 01.03_Clean_data####
# *****************************************************************************
df_pop_ZMVM_counties <- df_pop_county %>%
  mutate (ZMVM = case_when(county_id == "09002" ~ 1,
    county_id == "09003"~ 1,
    county_id == "09004" ~ 1,
    county_id == "09005"~ 1,
    county_id == "09006" ~ 1,
    county_id == "09007"~ 1,
    county_id == "09008" ~ 1,
    county_id == "09009"~ 1,
    county_id == "09010" ~ 1,
    county_id == "09011"~ 1,
    county_id == "09012" ~ 1,
    county_id == "09013"~ 1,
    county_id == "09014" ~ 1,
    county_id == "09015"~ 1,
    county_id == "09016" ~ 1,
    county_id == "09017"~ 1,
    county_id == "13069" ~ 1,
    county_id == "15002"~ 1,
    county_id == "15009" ~ 1,
    county_id == "15010"~ 1,
    county_id == "15011" ~ 1,
    county_id == "15013"~ 1, 
    county_id == "15015" ~ 1, 
    county_id == "15016"~ 1, 
    county_id == "15017" ~ 1, 
    county_id == "15020"~ 1, 
    county_id == "15022" ~ 1, 
    county_id == "15023"~ 1, 
    county_id == "15024" ~ 1, 
    county_id == "15025"~ 1, 
    county_id == "15028" ~ 1, 
    county_id == "15029"~ 1, 
    county_id == "15030" ~ 1, 
    county_id == "15031"~ 1, 
    county_id == "15033" ~ 1, 
    county_id == "15034"~ 1, 
    county_id == "15035" ~ 1, 
    county_id == "15036"~ 1, 
    county_id == "15037" ~ 1, 
    county_id == "15038"~ 1, 
    county_id == "15039" ~ 1, 
    county_id == "15044"~ 1, 
    county_id == "15046" ~ 1, 
    county_id == "15050"~ 1,
    county_id == "15053" ~ 1,
    county_id == "15057"~ 1,
    county_id == "15058" ~ 1,
    county_id == "15059"~ 1,
    county_id == "15060" ~ 1,
    county_id == "15061"~ 1,
    county_id == "15065" ~ 1,
    county_id == "15068"~ 1,
    county_id == "15069" ~ 1,
    county_id == "15070"~ 1,
    county_id == "15075" ~ 1,
    county_id == "15081"~ 1,
    county_id == "15083" ~ 1,
    county_id == "15084"~ 1,
    county_id == "15089" ~ 1,
    county_id == "15091"~ 1,
    county_id == "15092" ~ 1,
    county_id == "15093"~ 1,
    county_id == "15094" ~ 1,
    county_id == "15095"~ 1,
    county_id == "15096" ~ 1,
    county_id == "15099"~ 1,
    county_id == "15100" ~ 1,
    county_id == "15103"~ 1,
    county_id == "15104" ~ 1,
    county_id == "15108"~ 1,
    county_id == "15109" ~ 1,
    county_id == "15112"~ 1,
    county_id == "15120" ~ 1,
    county_id == "15121"~ 1,
    county_id == "15122" ~ 1,
    county_id == "15125"~ 1))  %>%
  filter(ZMVM == 1) 

df_pop_ZMVM <- df_pop_ZMVM_counties %>%
  summarise(population = sum(population)) %>%
  mutate(entidad = "ZMVM", 
          county_name_esp = "ZMVM",
          state = "MCMA",
          county_name_eng = "MCMA") %>%
  select(entidad, county_name_esp, state, county_name_eng, population)

# *****************************************************************************
#### 01.04_Save_data####
# *****************************************************************************
save(df_pop_ZMVM, file = "~/GitHub/demog-model-mex/data/df_pop_ZMVM.Rdata")

