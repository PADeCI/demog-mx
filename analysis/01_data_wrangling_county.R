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
load(file = "data/df_pop_state_age.Rdata")


# *****************************************************************************
#### 01.03 Population projections                                          ####
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
# Assuming population of ages above 69 are equal to 0 
df_pop_county_age_1 <- df_pop_binded %>%
        group_by(entidad, county_name_esp, county_id, age_groups) %>%
        summarise_at("population", sum, na.rm = TRUE) %>%
        rename(pop_grouped = "population") %>%
        mutate(population = pop_grouped/5) %>%
        uncount(5) %>%
        mutate(age = 0:69) %>%
        # Expand to 109 to match death df
        complete(age = 0:109, fill = list(0)) %>%
        mutate(age = as.numeric(age)) %>%
        select(entidad, county_name_esp, county_id, age_groups, pop_grouped, age, population)

# Compare total population 
sum(df_pop_county$population, na.rm = T)
sum(df_pop_county_age_1$population, na.rm = T)       
sum(df_pop_county$population, na.rm = T) - sum(df_pop_county_age_1$population, na.rm = T)       


# Assuming there is the same amount of population for all ages above 64
df_pop_county_age_2 <- df_pop_county_age_1 %>% 
        mutate(population = as.numeric(population), 
                age = as.numeric(age)) %>%
        mutate(population = case_when(
                age <= 64 ~ population, 
                age >= 65 ~ (population[age == 65])*5/45)) 
        # Population at age 65 it's first multiplied by 5 since we need the grouped value of 65-69 population
        # Then we divide this number by the amount of years missing (109-64)

# Compare total population
sum(df_pop_county_age_2$population)
sum(df_pop_county$population, na.rm = T) - sum(df_pop_county_age_2$population, na.rm = T)
sum(df_pop_county_age_1$population, na.rm = T)-sum(df_pop_county_age_2$population, na.rm = T)
sum(df_pop_county_age_2$pop_grouped, na.rm = T)/5 -sum(df_pop_county_age_1$population, na.rm = T)

# Test by age group
df_test_grouped  <- df_pop_county_age_1 %>%
        filter(age >= 65)

df_test_expanded <- df_pop_county_age_2 %>%
        filter(age >= 65)

sum(df_test_grouped$population, na.rm = T)
sum(df_test_expanded$population)

# Searching the population decrease pattern in state data
# Get the ratio of population for all ages >= 65
df_pop_age_ratio_cdmx <- df_pop_state_age %>%
        filter(year == 2020, 
                state == "Mexico City", 
                age >= 65) %>%
        mutate(pop_tot = sum(population), 
                age_pop_ratio = population/pop_tot*100) %>%
        select(age, age_pop_ratio)

# Assuming there is the same proportion of population after 65 than at the national level
df_pop_county_age_3 <- df_pop_county_age_1 %>%
        mutate(population = as.numeric(population), 
                pop_grouped = as.numeric(population), 
                age = as.numeric(age)) %>%
        left_join(df_pop_age_ratio_cdmx, by = "age") %>%
        mutate(population = case_when(
                age <= 64 ~ population,
                age >= 65 ~ (pop_grouped[age == 65]))) %>%
        mutate(population = case_when(
                age <= 64 ~ population,
                age >= 65 ~ (population*age_pop_ratio/100))) %>%
        mutate(population = as.integer(population)) %>%
        select(entidad, county_name_esp, county_id, age, population)

        
sum(df_pop_county$population, na.rm = T) - sum(df_pop_county_age_3$population, na.rm = T)
sum(df_pop_county_age_3$population)

# Select final df according to desired assumption
df_pop_county_age <- df_pop_county_age_3

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
save(df_pop_county_age, file = "~/GitHub/demog-model-mex/data/df_pop_county_age.Rdata")
save(df_mort_county_age, file = "~/GitHub/demog-model-mex/data/df_mort_county_age.Rdata")

