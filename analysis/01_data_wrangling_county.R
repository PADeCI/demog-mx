#*****************************************************************************# 
# This script loads and formats data for 2020 of Population projections from  #
# CONAPO by counties:                                                         #
#                                                                             #
#                                                                             #
#                                                                             #
# Author: Hirvin Azael Diaz Zepeda                                            # 
# Author: Regina Isabel Medina Rosales                                        #
#                                                                             #
# E-mail: hirvin.diaz@alumnos.cide.edu                                        #
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
### Load data of counties with Spanish encoding

df_counties_1 <- data.table::fread(input = "data-raw/base_municipios_final_datos_01.csv",
        encoding = "Latin-1")
df_counties_2 <- data.table::fread(input = "data-raw/base_municipios_final_datos_02.csv",
        encoding = "Latin-1")
df_names <- data.table::fread(input = "data-raw/municipios_nombres.csv", 
        encoding = "Latin-1")

# *****************************************************************************
#### 01.03 Population projections                                          ####
# *****************************************************************************
### Bind counties population data.frames, select year 2020 and rename variables 
df_pop_binded_sex <- df_counties_1 %>%
        bind_rows(df_counties_2) %>%
        rename(year = "AÑO", 
                state = "NOM_ENT",
                county_spa = "MUN",
                county_id = "CLAVE",
               CVE_GEO = "CLAVE_ENT") %>%
        rename(population = "POB", 
                age_groups = "EDAD_QUIN") %>% 
        filter(year == 2020) %>% 
        select(-RENGLON)

### Recode Oaxaca state
df_pop_binded_sex$state <- gsub("Oaxaca-Región Mixteca", "Oaxaca", df_pop_binded_sex$state)
df_pop_binded_sex$state <- gsub("Oaxaca-Región Sierra Norte", "Oaxaca", df_pop_binded_sex$state)
df_pop_binded_sex$state <- gsub("Oaxaca-Región Valles Centrales", "Oaxaca", df_pop_binded_sex$state)
df_pop_binded_sex$state <- gsub("Oaxaca-Región Costa", "Oaxaca", df_pop_binded_sex$state)
df_pop_binded_sex$state <- gsub("Oaxaca-Región Cañada", "Oaxaca", df_pop_binded_sex$state)
df_pop_binded_sex$state <- gsub("Oaxaca-Región Sierra Sur", "Oaxaca", df_pop_binded_sex$state)
df_pop_binded_sex$state <- gsub("Oaxaca-Región Istmo", "Oaxaca", df_pop_binded_sex$state)
df_pop_binded_sex$state <- gsub("Oaxaca-Región Papaloapam", "Oaxaca", df_pop_binded_sex$state)

### Rename and recode sex
df_pop_binded_sex <- df_pop_binded_sex %>%
        mutate(SEXO = factor(SEXO)) %>%
        rename(sex = SEXO)

levels(df_pop_binded_sex$sex)[levels(df_pop_binded_sex$sex) == "Hombres"] = "Male"
levels(df_pop_binded_sex$sex)[levels(df_pop_binded_sex$sex) == "Mujeres"] = "Female"

### Join population and names data.frames  
df_pop_county_sex <- df_names %>%
        inner_join(df_pop_binded_sex, by = "county_id") %>%
        rename(county = "county_name_eng") %>%
        select(year, state, county, county_id, sex, age_groups,population) %>% 
        arrange(sex)

### Recode States
df_pop_county_sex <- df_pop_county_sex %>%
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

df_pop_county_sex <- df_pop_county_sex %>%
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
                    "Tlaxcala", "Veracruz", "Yucatan", "Zacatecas")

levels(df_pop_county_sex$state) <- v_names_states

### County population per ages, we divide the data base in over and under
## (including) 64 years
df_pop_county_age_sex_uand64 <- df_pop_county_sex %>%
        filter(age_groups != "pobm_65_mm") %>% 
        rename(pop_grouped = "population") %>%
        mutate(population = pop_grouped/5) %>%
        uncount(5) %>%
        mutate(age = rep(0:64,4914)) %>% 
        select(year,state,county,county_id,sex,age,population)
        
df_pop_county_age_sex_o64_1 <- df_pop_county_sex %>%
        filter(age_groups == "pobm_65_mm") %>% 
        rename(pop_grouped = "population") %>%
        mutate(population = pop_grouped/5) %>%
        uncount(45) %>%
        mutate(age = rep(65:109,4914)) 

### We obtain the ratio of people over 65 years old for each state to compute
### the proportions of group ages

###Load population considering age and sex data
load(file = "data/df_pop_state_age_sex.Rdata")

### Compute proportion
ratio_state <- df_pop_state_age_sex %>% 
        filter(year == 2020,
               state != "National",
               age >= 65) %>% 
        group_by(state, sex) %>% 
        summarise(pop = sum(population))

df_pop_state_age_sex_ratio <- df_pop_state_age_sex %>%
        filter(year == 2020,
               state != "National",
               age >= 65) %>%
        left_join(ratio_state) %>% 
        mutate(ratio = population/pop)%>%
        select(state, age, sex, ratio)

### Join data.frames and compute proportions
df_pop_county_age_sex_o64 <- left_join(df_pop_county_age_sex_o64_1,
                                        df_pop_state_age_sex_ratio) %>% 
        rename(pop_fake = "population") %>% 
        mutate(population = pop_grouped*ratio) %>% 
        select(year,state,county,county_id,sex,age,population)
        

### Bind data.frames()
df_pop_county_age_sex <- bind_rows(df_pop_county_age_sex_uand64,
                               df_pop_county_age_sex_o64) %>% 
        arrange(state,county,age)

### Build MCMA
df_MCMA_pop_county_age_sex <- df_pop_county_age_sex %>%
        mutate (MCMA = case_when(county_id == "9002" ~ 1,
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
        filter(MCMA == 1) %>% 
        select(-MCMA) %>% 
        mutate(state = "MCMA" )
df_MCMA_pop_county_age_sex$county <- paste(df_MCMA_pop_county_age_sex$county, 
                                           sep="_", "MCMA")

### Add MCMA counties to df_pop_counties_sex_age
df_pop_county_age_sex <- bind_rows(df_pop_county_age_sex,
                                   df_MCMA_pop_county_age_sex) %>% 
        arrange(state,county,age)

### Compute population with age and sex by state for MCMA
pop_MCMA <- df_pop_county_age_sex %>%
        filter(state == "MCMA") %>% 
        group_by(year,state,age,sex) %>% 
        summarise(population = sum(population)) %>% 
        mutate(CVE_GEO = 33) %>% 
        select(c(1,2,6,3:5))

#### Counties population without sex
df_pop_county_age <- df_pop_county_age_sex %>%
        rename(pop = population) %>% 
        group_by(year, state, county, county_id, age) %>%
        summarise(population = sum(pop))

# *****************************************************************************
#### 01.04 Mortality                                                       ####
# *****************************************************************************
###Load mortality rate considering age and sex data
load(file = "data/df_mortrate_state_age_sex.Rdata")

### Filter year 2020
df_mortrate_state_age_sex <- df_mortrate_state_age_sex %>% 
        filter(year == 2020) %>% 
        filter(state != "National")

df_mortrate_county_age_sex <- inner_join(df_pop_county_age_sex,
                                         df_mortrate_state_age_sex, by = 
                                                c("year","state","sex","age")) %>% 
        mutate(death = population.x*mort_rate) %>% 
        select(year,state,county,county_id,sex,age,mort_rate,death)

### Build MCMA
df_MCMA_mortrate_county_age_sex <- df_mortrate_county_age_sex %>%
        mutate (MCMA = case_when(county_id == "9002" ~ 1,
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
        filter(MCMA == 1) %>% 
        select(-MCMA) %>% 
        mutate(state = "MCMA" )

df_MCMA_mortrate_county_age_sex$county <- paste(df_MCMA_mortrate_county_age_sex$county, 
                                           sep="_", "MCMA")
### Add MCMA counties to df_mortrate_counties_sex_age
df_mortrate_county_age_sex <- bind_rows(df_mortrate_county_age_sex,
                                   df_MCMA_mortrate_county_age_sex) %>% 
        arrange(state,county,age) %>% 
        rename(deaths = "death")

### Compute population with age and sex by state for MCMA
deaths_MCMA <- df_mortrate_county_age_sex %>%
        filter(state == "MCMA") %>% 
        group_by(year,state,age,sex) %>% 
        summarise(deaths = sum(deaths)) %>% 
        mutate(CVE_GEO = 33) %>% 
        select(c(1,2,6,4,3,5))


# *****************************************************************************
#### 01.05 join Mortality and population by counties                       ####
# *****************************************************************************
df_pop_mort_county_age_sex <- left_join(df_pop_county_age_sex,
                                        df_mortrate_county_age_sex) 

### Mortality and population without age
df_pop_mort_county_age <- df_pop_mort_county_age_sex %>% 
        group_by(year,state,county,county_id,age) %>% 
        summarise(population = sum(population), deaths = sum(deaths), d_rate = mean(mort_rate))

### Save data
save(df_pop_mort_county_age_sex, file = "data/population_mortality_age_sex.Rdata")
save(df_pop_mort_county_age, file = "data/population_mortality_age.Rdata")

write.csv(df_pop_mort_county_age_sex, "data/df_pop_mort_county_age_sex.csv")
write.csv(df_pop_mort_county_age, "data/df_pop_mort_county_age.csv")

# *****************************************************************************
#### 01.05 Births                                                          ####
# *****************************************************************************
###Load Birth rate
load(file = "data/df_birthrate_state_age.Rdata")

### Filter year 2020
df_birth_state_age <- df_birth_state_age %>% 
        filter(year == 2020) %>% 
        filter(state != "National")

df_birth_county_age <- inner_join(df_pop_county_age,
                                  df_birthrate_state_age,  by = c("year", "state", 
                                                                  "age")) %>% 
        mutate(birth = population.x*birth_rate)%>% 
        select(year,state,county,county_id,age,population.x,birth,births_grouped,
               birth_rate,ferty_rate) %>% 
        rename(population = "population.x",
               births = "birth")

### Build MCMA
df_MCMA_birth_county_age <- df_birth_county_age %>%
        mutate (MCMA = case_when(county_id == "9002" ~ 1,
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
        filter(MCMA == 1) %>% 
        select(-MCMA) %>% 
        mutate(state = "MCMA" )

df_MCMA_birth_county_age$county <- paste(df_MCMA_birth_county_age$county, 
                                                sep="_", "MCMA")

### Add MCMA counties to df_mortrate_counties_sex_age
df_birth_county_age <- bind_rows(df_birth_county_age,
                                      df_MCMA_birth_county_age) %>% 
        arrange(state,county,age)

### Compute births with age by state for MCMA
MCMA_birth <- df_birth_county_age %>% 
        filter(state == "MCMA") %>% 
        group_by(year,state,age,births_grouped,births,ferty_rate) %>% 
        mutate(CVE_GEO = 33) %>% 
        select(year,state,CVE_GEO,age,births_grouped,births,ferty_rate)

### Save Data
save(df_birth_county_age, file = "data/birth_county_age.Rdata")
write.csv(df_birth_county_age, "data/df_birth_county_age.csv")
