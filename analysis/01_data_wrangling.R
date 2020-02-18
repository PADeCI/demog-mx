#*****************************************************************************# 
# This script loads and formats the data from CONAPO's "Proyecciones de la    #
# Población de México y de las Entidades Federativas, 2016-2050" Downloaded   #
# from https://datos.gob.mx/busca/dataset/proyecciones-de-la-poblacion-de-mexico-y-de-las-entidades-federativas-2016-2050 #
# accessed on 02/14/2020                                                      # 
#                                                                             # 
# Depends on:                                                                 #
# Author: Fernando Alarid-Escudero                                            # 
# E-mail: fernando.alarid@cide.edu                                            # 
#*****************************************************************************# 

rm(list = ls()) # to clean the workspace

# *****************************************************************************
#### 01.01_Load_packages ####
# *****************************************************************************

# library(foreign)
library(data.table)
library(dplyr)
# library(ggplot2)
# library(stringr)
# library(epitools)
# library(tidyr)

# *****************************************************************************
#### 01.02 Population Projections ####
# *****************************************************************************
### Load data with Spanish encoding
df_pop_state_age_sex <- data.table::fread(input = "data-raw/pob_ini_proyecciones.csv",
                                          encoding = "Latin-1")

### Rename variables
df_pop_state_age_sex <- df_pop_state_age_sex %>%
  rename(year = AÑO,
         state = ENTIDAD,
         age = EDAD,
         population = POBLACION)

### Rename and recode sex
df_pop_state_age_sex <- df_pop_state_age_sex %>%
  mutate(SEXO = factor(SEXO)) %>%
  rename(sex = SEXO)

levels(df_pop_state_age_sex$sex)[levels(df_pop_state_age_sex$sex) == "Hombres"] = "Male"
levels(df_pop_state_age_sex$sex)[levels(df_pop_state_age_sex$sex) == "Mujeres"] = "Female"

### Recode States
df_pop_state_age_sex <- df_pop_state_age_sex %>%
  mutate(state = replace(state, state == "Aguascalientes", "01"),
         state = replace(state, state == "Baja California", "02"),
         state = replace(state, state == "Baja California Sur", "03"),
         state = replace(state, state == "Campeche", "04"),
         state = replace(state, state == "Coahuila", "05"),
         state = replace(state, state == "Colima", "06"),
         state = replace(state, state == "Chiapas", "07"),
         state = replace(state, state == "Chihuahua", "08"),
         state = replace(state, state == "Ciudad de México", "09"),
         state = replace(state, state == "Durango", "10"),
         state = replace(state, state == "Guanajuato", "11"),
         state = replace(state, state == "Guerrero", "12"),
         state = replace(state, state == "Hidalgo", "13"),
         state = replace(state, state == "Jalisco", "14"),
         state = replace(state, state == "México", "15"),
         state = replace(state, state == "Michoacán", "16"),
         state = replace(state, state == "Morelos", "17"),
         state = replace(state, state == "Nayarit", "18"),
         state = replace(state, state == "Nuevo León", "19"),
         state = replace(state, state == "Oaxaca", "20"),
         state = replace(state, state == "Puebla", "21"),
         state = replace(state, state == "Querétaro", "22"),
         state = replace(state, state == "Quintana Roo", "23"),
         state = replace(state, state == "San Luis Potosí", "24"),
         state = replace(state, state == "Sinaloa", "25"),
         state = replace(state, state == "Sonora", "26"),
         state = replace(state, state == "Tabasco", "27"),
         state = replace(state, state == "Tamaulipas", "28"),
         state = replace(state, state == "Tlaxcala", "29"),
         state = replace(state, state == "Veracruz", "30"),
         state = replace(state, state == "Yucatán", "31"),
         state = replace(state, state == "Zacatecas", "32"),
         state = replace(state, state == "República Mexicana", "33"))

df_pop_state_age_sex <- df_pop_state_age_sex %>%
  mutate(state = as.factor(state))

## Label states
v_names_states <- c("Aguascalientes", "Baja California", 
                    "Baja California Sur", "Campeche", "Coahuila", 
                    "Colima", "Chiapas", "Chihuahua", 
                    "Mexico City", "Durango", "Guanajuato", 
                    "Guerrero", "Hidalgo", "Jalisco", 
                    "State of Mexico", "Michoacan", "Morelos", 
                    "Nayarit", "Nuevo Leon", "Oaxaca", "Puebla", 
                    "Queretaro", "Quintana Roo", "San Luis Potosi", 
                    "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", 
                    "Tlaxcala", "Veracruz", "Yucatán", "Zacatecas", 
                    "National")
levels(df_pop_state_age_sex$state) <- v_names_states

### Compute general estimates NOT by sex
df_pop_state_age <- df_pop_state_age_sex %>%
  group_by(year, state, CVE_GEO, age) %>%
  summarise(population = sum(population))

### Compute general estimates NOT by age
df_pop_state <- df_pop_state_age %>%
  group_by(year, state, CVE_GEO) %>%
  summarise(population = sum(population))

### Save Population Projections data.frames
save(df_pop_state_age_sex, file = "data/df_pop_state_age_sex.Rdata")
save(df_pop_state_age,     file = "data/df_pop_state_age.Rdata")
save(df_pop_state,         file = "data/df_pop_state.Rdata")


# *****************************************************************************
#### 01.03 Birth Projections ####
# *****************************************************************************
### Load data with Spanish encoding
df_birth_state_agegrp <- data.table::fread(input = "data-raw/tef_nac_proyecciones.csv",
                                           encoding="Latin-1")
### Rename variables
df_birth_state_agegrp <- df_birth_state_agegrp %>%
  rename(year = AÑO,
         state = ENTIDAD,
         age_group = GPO_EDAD,
         births = NACIMIENTOS)

### Recode States
df_birth_state_agegrp <- df_birth_state_agegrp %>%
  mutate(state = replace(state, state == "Aguascalientes", "01"),
         state = replace(state, state == "Baja California", "02"),
         state = replace(state, state == "Baja California Sur", "03"),
         state = replace(state, state == "Campeche", "04"),
         state = replace(state, state == "Coahuila", "05"),
         state = replace(state, state == "Colima", "06"),
         state = replace(state, state == "Chiapas", "07"),
         state = replace(state, state == "Chihuahua", "08"),
         state = replace(state, state == "Ciudad de México", "09"),
         state = replace(state, state == "Durango", "10"),
         state = replace(state, state == "Guanajuato", "11"),
         state = replace(state, state == "Guerrero", "12"),
         state = replace(state, state == "Hidalgo", "13"),
         state = replace(state, state == "Jalisco", "14"),
         state = replace(state, state == "México", "15"),
         state = replace(state, state == "Michoacán", "16"),
         state = replace(state, state == "Morelos", "17"),
         state = replace(state, state == "Nayarit", "18"),
         state = replace(state, state == "Nuevo León", "19"),
         state = replace(state, state == "Oaxaca", "20"),
         state = replace(state, state == "Puebla", "21"),
         state = replace(state, state == "Querétaro", "22"),
         state = replace(state, state == "Quintana Roo", "23"),
         state = replace(state, state == "San Luis Potosí", "24"),
         state = replace(state, state == "Sinaloa", "25"),
         state = replace(state, state == "Sonora", "26"),
         state = replace(state, state == "Tabasco", "27"),
         state = replace(state, state == "Tamaulipas", "28"),
         state = replace(state, state == "Tlaxcala", "29"),
         state = replace(state, state == "Veracruz", "30"),
         state = replace(state, state == "Yucatán", "31"),
         state = replace(state, state == "Zacatecas", "32"),
         state = replace(state, state == "República Mexicana", "33"))

df_birth_state_agegrp <- df_birth_state_agegrp %>%
  mutate(state = as.factor(state))

levels(df_birth_state_agegrp$state) <- v_names_states

### Compute general estimates NOT by age groups
df_birth_state <- df_birth_state_agegrp %>%
  group_by(year, state, CVE_GEO) %>%
  summarise(births = sum(births))
df_birth_state

### Save Birth Projections data.frames
save(df_birth_state_agegrp, file = "data/df_birth_state_agegrp.Rdata")
save(df_birth_state, file = "data/df_birth_state.Rdata")

# *****************************************************************************
#### 01.04 Mortality Projections ####
# *****************************************************************************
### Load data with Spanish encoding
df_mort_state_age_sex <- data.table::fread(input = "data-raw/def_edad_proyecciones.csv",
                                           encoding="Latin-1")
### Rename variables
df_mort_state_age_sex <- df_mort_state_age_sex %>%
  rename(year = AÑO,
         state = ENTIDAD,
         age = EDAD,
         deaths = DEFUNCIONES)

### Rename and recode sex
df_mort_state_age_sex <- df_mort_state_age_sex %>%
  mutate(SEXO = factor(SEXO)) %>%
  rename(sex = SEXO)

levels(df_mort_state_age_sex$sex)[levels(df_mort_state_age_sex$sex) == "Hombres"] = "Male"
levels(df_mort_state_age_sex$sex)[levels(df_mort_state_age_sex$sex) == "Mujeres"] = "Female"

### Recode States
df_mort_state_age_sex <- df_mort_state_age_sex %>%
  mutate(state = replace(state, state == "Aguascalientes", "01"),
         state = replace(state, state == "Baja California", "02"),
         state = replace(state, state == "Baja California Sur", "03"),
         state = replace(state, state == "Campeche", "04"),
         state = replace(state, state == "Coahuila", "05"),
         state = replace(state, state == "Colima", "06"),
         state = replace(state, state == "Chiapas", "07"),
         state = replace(state, state == "Chihuahua", "08"),
         state = replace(state, state == "Ciudad de México", "09"),
         state = replace(state, state == "Durango", "10"),
         state = replace(state, state == "Guanajuato", "11"),
         state = replace(state, state == "Guerrero", "12"),
         state = replace(state, state == "Hidalgo", "13"),
         state = replace(state, state == "Jalisco", "14"),
         state = replace(state, state == "México", "15"),
         state = replace(state, state == "Michoacán", "16"),
         state = replace(state, state == "Morelos", "17"),
         state = replace(state, state == "Nayarit", "18"),
         state = replace(state, state == "Nuevo León", "19"),
         state = replace(state, state == "Oaxaca", "20"),
         state = replace(state, state == "Puebla", "21"),
         state = replace(state, state == "Querétaro", "22"),
         state = replace(state, state == "Quintana Roo", "23"),
         state = replace(state, state == "San Luis Potosí", "24"),
         state = replace(state, state == "Sinaloa", "25"),
         state = replace(state, state == "Sonora", "26"),
         state = replace(state, state == "Tabasco", "27"),
         state = replace(state, state == "Tamaulipas", "28"),
         state = replace(state, state == "Tlaxcala", "29"),
         state = replace(state, state == "Veracruz", "30"),
         state = replace(state, state == "Yucatán", "31"),
         state = replace(state, state == "Zacatecas", "32"),
         state = replace(state, state == "República Mexicana", "33"))

df_mort_state_age_sex <- df_mort_state_age_sex %>%
  mutate(state = as.factor(state))

levels(df_mort_state_age_sex$state) <- v_names_states

### Compute general estimates NOT by sex
df_mort_state_age <- df_mort_state_age_sex %>%
  group_by(year, state, CVE_GEO, age) %>%
  summarise(deaths = sum(deaths))

### Compute general estimates NOT by age
df_mort_state <- df_mort_state_age %>%
  group_by(year, state, CVE_GEO) %>%
  summarise(deaths = sum(deaths))

### Save Mortality Projections data.frames
save(df_mort_state_age_sex, file = "data/df_mort_state_age_sex.Rdata")
save(df_mort_state_age,     file = "data/df_mort_state_age.Rdata")
save(df_mort_state,         file = "data/df_mort_state.Rdata")
