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
df_counties_1 <- data.table::fread(input = "data-raw/base_municipios_final_datos_01.csv",
        encoding = "Latin-1")
df_counties_2 <- data.table::fread(input = "data-raw/base_municipios_final_datos_02.csv",
        encoding = "Latin-1")
df_names <- data.table::fread(input = "data-raw/municipios_nombres.csv", 
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

df_pop_county$entidad <- gsub("Oaxaca-Región Mixteca", "Oaxaca", df_pop_county$entidad)
df_pop_county$entidad <- gsub("Oaxaca-Región Sierra Norte", "Oaxaca", df_pop_county$entidad)
df_pop_county$entidad <- gsub("Oaxaca-Región Valles Centrales", "Oaxaca", df_pop_county$entidad)
df_pop_county$entidad <- gsub("Oaxaca-Región Costa", "Oaxaca", df_pop_county$entidad)
df_pop_county$entidad <- gsub("Oaxaca-Región Cañada", "Oaxaca", df_pop_county$entidad)
df_pop_county$entidad <- gsub("Oaxaca-Región Sierra Sur", "Oaxaca", df_pop_county$entidad)
df_pop_county$entidad <- gsub("Oaxaca-Región Istmo", "Oaxaca", df_pop_county$entidad)
df_pop_county$entidad <- gsub("Oaxaca-Región Papaloapam", "Oaxaca", df_pop_county$entidad)

view(df_pop_county)

#### 01.03.2 County population per ages
df_pop_H <- df_pop_binded %>%
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

view(df_pop_H)

df_pop_age_ratio_cdmx <- df_pop_state_age %>%
        filter(year == 2020, 
               state == "Mexico City", 
               age >= 65) %>%
        mutate(pop_tot = sum(population), 
               age_pop_ratio = population/pop_tot) %>%
        select(age, age_pop_ratio)


df_pop_H_n65m <- df_pop_H %>% 
        filter(age < 65)

df_pop_H_65m <- df_pop_H %>% 
        filter(age >= 65)%>% 
        fill(pop_grouped) %>% 
        left_join(df_pop_age_ratio_cdmx, by = "age") %>% 
        mutate(population =  pop_grouped*age_pop_ratio) %>% 
        mutate(population = as.numeric(population)) %>% 
        select(c(1:7))

df_pop_county_age <- rbind(df_pop_H_n65m,df_pop_H_65m) %>% 
        arrange(county_id)

df_pop_county_age$entidad <- gsub("Oaxaca-Región Mixteca", "Oaxaca", df_pop_county_age$entidad)
df_pop_county_age$entidad <- gsub("Oaxaca-Región Sierra Norte", "Oaxaca", df_pop_county_age$entidad)
df_pop_county_age$entidad <- gsub("Oaxaca-Región Valles Centrales", "Oaxaca", df_pop_county_age$entidad)
df_pop_county_age$entidad <- gsub("Oaxaca-Región Costa", "Oaxaca", df_pop_county_age$entidad)
df_pop_county_age$entidad <- gsub("Oaxaca-Región Cañada", "Oaxaca", df_pop_county_age$entidad)
df_pop_county_age$entidad <- gsub("Oaxaca-Región Sierra Sur", "Oaxaca", df_pop_county_age$entidad)
df_pop_county_age$entidad <- gsub("Oaxaca-Región Istmo", "Oaxaca", df_pop_county_age$entidad)
df_pop_county_age$entidad <- gsub("Oaxaca-Región Papaloapam", "Oaxaca", df_pop_county_age$entidad)

view(df_pop_county_age)

       
# *****************************************************************************
#### 01.04 Mortality projections                                           ####
# *****************************************************************************
df_mort_county <- data.table::fread(input = "data-raw/def_edad_proyecciones_rate.csv",
        encoding="Latin-1")
view(df_mort_county)

df_pop_d_county_age <- df_pop_county_age %>% 
        left_join(df_mort_county, by = c("entidad" = "ENTIDAD", "age" = "EDAD")) %>% 
        mutate(deaths = population*PROP) %>% 
        select(c(2,3,4,5,6,7,14))

view(df_pop_d_county_age)

df_mort_pop_state_age <- df_pop_d_county_age %>% 
        group_by(entidad, age) %>% 
        summarise(population =  sum(population), deaths =  sum(deaths)) %>% 
        mutate(country = "Mexico") %>% 
        select(c(5,1,2,3,4)) %>% 
        as.data.frame()
setnames(df_mort_pop_state_age, old = c("entidad"), new = c("state"))

view(df_mort_pop_state_age)


# Df meant only for comparison 
#df_mort_county_age_sex_2020 <- df_mort_county_age_sex %>%
#        rename(year = "AÑO", 
#                entidad = "ENTIDAD",
#                deaths = "DEFUNCIONES", 
#                age = "EDAD",
#                state_id = "CVE_GEO") %>% 
#        filter(year == 2020) 
#
#df_mort_county_age <- df_mort_county_age_sex %>%
#        rename(year = "AÑO", 
#                entidad = "ENTIDAD",
#                deaths = "DEFUNCIONES", 
#                age = "EDAD",
#                state_id = "CVE_GEO") %>% 
#        filter(year == 2020) %>%
#        group_by(entidad, state_id, age) %>%
#        summarise_at("deaths", sum, na.rm = T)
#
#df_mort_county <- df_mort_county_age_sex %>%
#        rename(year = "AÑO", 
#                entidad = "ENTIDAD",
#                deaths = "DEFUNCIONES", 
#                age = "EDAD",
#                state_id = "CVE_GEO") %>% 
#        filter(year == 2020) %>%
#        group_by(entidad, state_id) %>%
#        summarise_at("deaths", sum, na.rm = T)
#
## Check numbers 
#sum(df_mort_county_age_sex_2020$deaths)
#sum(df_mort_county_age$deaths)
#sum(df_mort_county$deaths)

# *****************************************************************************
#### 01.05_Save_data####
# *****************************************************************************
save(df_pop_county, file = "data/df_pop_county.Rdata")
save(df_pop_county_age, file = "data/df_pop_county_age.Rdata")
save(df_mort_county_age, file = "data/df_mort_county_age.Rdata")
save(df_mort_pop_state_age, file = "data/df_mort_pop_state_age.Rdata")
