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
library(tidyverse)
library(splitstackshape)

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
#### 01.03 Population projections                       ####
# *****************************************************************************
#### 01.03.1 County population
df_pop_binded <- df_counties_1 %>%
        bind_rows(df_counties_2) %>%
        rename(year = "AÑO", 
                entidad = "NOM_ENT",
                county_name_esp = "MUN", 
                county_id = "CLAVE") %>%
        rename(population = "POB", 
                age_groups = "EDAD_QUIN") %>%
        filter(year == 2020)

df_pop_binded_sum <- df_pop_binded %>%
        group_by(entidad, county_name_esp, county_id) %>%
        summarise_at("population", sum, na.rm = TRUE)

df_pop_county_full <- df_names %>%
        left_join(df_pop_binded_sum, by = "county_id")

# Cleaning up
df_pop_county <- df_pop_county_full %>%
        rename(county_name_esp = county_name_esp.x) %>%
        select(entidad, county_name_esp, county_name_eng, county_id, population)


#### 01.03.2 County population per ages
df_pop_county_age <- df_pop_binded %>%
        group_by(entidad, county_name_esp, county_id, age_groups) %>%
        summarise_at("population", sum, na.rm = TRUE) %>%
        rename(pop_grouped = "population") %>%
        mutate(population = pop_grouped/5) %>%
        uncount(5) %>%
        mutate(age = 0:69) %>%
        # Expand to 109 to match death df
        complete(age = 0:109, fill = list(0)) %>% 
        select(entidad, county_name_esp, county_id, age_groups, pop_grouped, age, population)

 sum(df_pop_county_age$population, na.rm = T)       
        
# *****************************************************************************
#### 01.04 Mortality projections                                           ####
# *****************************************************************************
df_mort_county_age_sex <- data.table::fread(input = "data-raw/def_edad_proyecciones.csv",
        encoding="Latin-1")

# Df meant only for comparison 
df_mort_county_age_sex_2020 <- df_mort_county_age_sex %>%
        rename(year = "AÑO", 
                entidad = "ENTIDAD",
                deaths = "DEFUNCIONES", 
                age = "EDAD",
                state_id = "CVE_GEO") %>% 
        filter(year == 2020) 

df_mort_county_age <- df_mort_county_age_sex %>%
        rename(year = "AÑO", 
                entidad = "ENTIDAD",
                deaths = "DEFUNCIONES", 
                age = "EDAD",
                state_id = "CVE_GEO") %>% 
        filter(year == 2020) %>%
        group_by(entidad, state_id, age) %>%
        summarise_at("deaths", sum, na.rm = T)

df_mort_county <- df_mort_county_age_sex %>%
        rename(year = "AÑO", 
                entidad = "ENTIDAD",
                deaths = "DEFUNCIONES", 
                age = "EDAD",
                state_id = "CVE_GEO") %>% 
        filter(year == 2020) %>%
        group_by(entidad, state_id) %>%
        summarise_at("deaths", sum, na.rm = T)

# Check numbers 
sum(df_mort_county_age_sex_2020$deaths)
sum(df_mort_county_age$deaths)
sum(df_mort_county$deaths)

# *****************************************************************************
#### 01.05_Save_data####
# *****************************************************************************
save(df_pop_county, file = "~/GitHub/demog-model-mex/data/df_pop_county.Rdata")
save(df_pop_county_age, file = "~/GitHub/demog-model-mex/data/df_pop_county_ages.Rdata")
save(df_mort_county_age, file = "~/GitHub/demog-model-mex/data/df_mort_county_age.Rdata")

