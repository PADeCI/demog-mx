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
df_counties_1 <- data.table::fread(input = "~/GitHub/demog-model-mex/data-raw/base_municipios_final_datos_01.csv",
        encoding = "Latin-1")
df_counties_2 <- data.table::fread(input = "~/GitHub/demog-model-mex/data-raw/base_municipios_final_datos_02.csv",
        encoding = "Latin-1")
df_names <- data.table::fread(input = "~/GitHub/demog-model-mex/data-raw/municipios_nombres.csv", 
        encoding = "Latin-1")


# *****************************************************************************
#### 01.03_Clean_data####
# *****************************************************************************
df_pop_binded <- df_counties_1 %>%
        bind_rows(df_counties_2) %>%
        rename(year = "AÑO", 
                entidad = "NOM_ENT",
                county_name_esp = "MUN", 
                county_id = "CLAVE") %>%
        mutate(population = POB) %>%
        filter(year == 2020) %>%
        group_by(entidad, county_name_esp, county_id) %>%
        summarise_at("population", sum, na.rm = TRUE)

df_pop_county_full <- df_names %>%
        left_join(df_pop_binded, by = "county_id")

# Cleaning for final version
df_pop_county <- df_pop_county_full %>%
        rename(county_name_esp = county_name_esp.x) %>%
        select(entidad, county_name_esp, county_name_eng, county_id, population)

# *****************************************************************************
#### 01.04_Save_data####
# *****************************************************************************
save(df_pop_county, file = "~/GitHub/demog-model-mex/data/df_pop_county.Rdata")
