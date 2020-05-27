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
#### 01.01_Load_packages                                                   ####
# *****************************************************************************
library(data.table)
library(dplyr)


# *****************************************************************************
#### 01.02_Load_data                                                       ####
# *****************************************************************************
load("~/GitHub/demog-model-mex/data/df_pop_county.Rdata")
load("~/GitHub/demog-model-mex/data/df_pop_county_ages.Rdata")
load("~/GitHub/demog-model-mex/data/df_mort_county_age.Rdata")


# *****************************************************************************
#### 01.03 Population projections                                          ####
# *****************************************************************************
# ZMVM population grouped 
df_pop_ZMVM_counties <- df_pop_county %>%
  mutate (ZMVM = case_when(county_id == "9002" ~ 1,
    county_id == "9003"~ 1,
    county_id == "9004" ~ 1,
    county_id == "9005"~ 1,
    county_id == "9006" ~ 1,
    county_id == "9007"~ 1,
    county_id == "9008" ~ 1,
    county_id == "9009"~ 1,
    county_id == "9010" ~ 1,
    county_id == "9011"~ 1,
    county_id == "9012" ~ 1,
    county_id == "9013"~ 1,
    county_id == "9014" ~ 1,
    county_id == "9015"~ 1,
    county_id == "9016" ~ 1,
    county_id == "9017"~ 1,
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

# Clean up 
df_pop_ZMVM <- df_pop_ZMVM_counties %>%
  summarise(population = sum(population)) %>%
  mutate(entidad = "ZMVM", 
          county_name_esp = "ZMVM",
          state = "MCMA",
          county_name_eng = "MCMA") %>%
  select(entidad, county_name_esp, state, county_name_eng, population)

#### ZMVM population per ages
df_pop_ZMVM_couties_ages <- df_pop_county_ages %>%
  mutate (ZMVM = case_when(county_id == "9002" ~ 1,
    county_id == "9003"~ 1,
    county_id == "9004" ~ 1,
    county_id == "9005"~ 1,
    county_id == "9006" ~ 1,
    county_id == "9007"~ 1,
    county_id == "9008" ~ 1,
    county_id == "9009"~ 1,
    county_id == "9010" ~ 1,
    county_id == "9011"~ 1,
    county_id == "9012" ~ 1,
    county_id == "9013"~ 1,
    county_id == "9014" ~ 1,
    county_id == "9015"~ 1,
    county_id == "9016" ~ 1,
    county_id == "9017"~ 1,
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

# Cleanup
df_pop_ZMVM_ages <- df_pop_ZMVM_couties_ages %>%
  group_by(age) %>%
  summarise(population_ag = sum(population), 
            pop_grouped_ag = sum(pop_grouped)) %>%
  mutate(age = as.numeric(age), 
         pais = "México",
         entidad = "ZMVM", 
         municipio = "ZMVM", 
         country = "Mexico", 
         state = "MCMA", 
         county = "MCMA") %>%
  arrange(age) %>%  # The label 69+ gets transformed into NAs
  rename(population = population_ag, 
         pop_grouped = pop_grouped_ag) %>%
  mutate(age = as.character(age)) %>% 
  #mutate(age = case_when(age != "69" ~ age,
  #            age == "69" ~ "69+")) %>%   # Get label 69+ back
  select(country, state, county, pais, entidad, municipio, age, population, pop_grouped)



# Test total population
sum(df_pop_ZMVM$population) 
sum(df_pop_ZMVM_ages$population, na.rm = T)

# *****************************************************************************
#### 01.04 Mortality Projections ####
# *****************************************************************************
df_pop_mort_age_ZMVM_counties <- df_pop_ZMVM_couties_ages  %>%
  mutate(state_id = substr(county_id, 1, 2), 
          age = as.numeric(age)) %>%
  mutate(state_id = case_when((state_id == 90 ~ 9),
                              (state_id == 13 ~ 13),
                              (state_id == 15 ~ 15))) %>%
  full_join(df_mort_county_age, by = c("entidad", "state_id", "age")) %>%
  mutate(deaths = as.numeric(deaths))

sum(df_pop_mort_ZMVM_age$population, na.rm = T)  
sum(df_pop_mort_ZMVM_age$deaths)  


# Collapse information
df_pop_mort_age_ZMVM <- df_pop_mort_age_ZMVM_counties %>%
  group_by(age) %>%
  summarise_at(vars("deaths", "population"), list(sum), na.rm = T) %>%
  mutate(pais = "México",
      entidad = "ZMVM", 
      municipio = "ZMVM", 
      country = "Mexico", 
      state = "MCMA", 
      county = "MCMA") %>%
  select(country, state, county, pais, entidad, municipio, age, population, deaths)



sum(df_pop_mort_age_ZMVM$population, na.rm = T)
sum(df_pop_mort_age_ZMVM$deaths, na.rm = T)

# Collapse ages
df_pop_mort_ZMVM <- df_pop_mort_age_ZMVM %>%
  group_by(country, pais, state, entidad, county, municipio) %>%
  summarise_at(vars("deaths", "population"), list(sum), na.rm = T)


# Check consistency of data at different df 
sum(df_pop_ZMVM$population, na.rm = T)
sum(df_pop_ZMVM_ages$population, na.rm = T)
sum(df_pop_mort_age_ZMVM$population, na.rm = T)
sum(df_pop_mort_ZMVM$population, na.rm = T)

sum(df_pop_mort_age_ZMVM$deaths, na.rm = T)
sum(df_pop_mort_ZMVM$deaths, na.rm = T)

# *****************************************************************************
#### 01.04_Save_data####
# *****************************************************************************
save(df_pop_ZMVM, file = "~/GitHub/demog-model-mex/data/df_pop_ZMVM.Rdata")
save(df_pop_ZMVM_ages, file = "~/GitHub/demog-model-mex/data/df_pop_ZMVM_ages.Rdata")
save(df_pop_mort_ZMVM, file = "~/GitHub/demog-model-mex/data/df_pop_mort_ZMVM.Rdata")
save(df_pop_mort_age_ZMVM, file = "~/GitHub/demog-model-mex/data/df_pop_mort_age_ZMVM.Rdata" ) 
