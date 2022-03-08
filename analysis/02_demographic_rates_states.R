#*****************************************************************************# 
# This script loads the formated data of Population projections from CONAPO   # 
# and computes different rates by age groups, states and sex, such as:        #
#  - Mortality rate                                                           #
#  - Birth rate                                                               #
#  - Aging rate                                                               #
#                                                                             # 
# Author: Fernando Alarid-Escudero                                            #
# Author: Hirvin Azael Diaz Zepeda                                            #
# E-mail: fernando.alarid@cide.edu                                            #
# E-mail: hirvin.diaz@alumnos.cide.edu                                        #
#*****************************************************************************# 

rm(list = ls()) # to clean the workspace

# *****************************************************************************
#### 02.01_Load_packages ####
# *****************************************************************************

library(data.table)
library(dplyr)

# *****************************************************************************
#### 02.02_Birth Rates Projections ####
# *****************************************************************************
### Load population and birth projections by age
load(file = "data/df_pop_state_age.Rdata")
load(file = "data/df_birth_state_age.Rdata")

### Join data.frames
df_birthrate_state_age <- inner_join(df_pop_state_age, 
                                 df_birth_state_age)
### Compute birth rates
df_birthrate_state_age <- df_birthrate_state_age %>%
  mutate(birth_rate = births/population) 

### Load population and birth projections
load(file = "data/df_pop_state.Rdata")
load(file = "data/df_birth_state.Rdata")

### Join data.frames
df_birthrate_state <- inner_join(df_pop_state, 
                                     df_birth_state)
### Compute birth rates
df_birthrate_state <- df_birthrate_state %>%
  mutate(birth_rate = births/population)

### Load population and by age and sex
load(file = "data/df_pop_state_age_sex.Rdata")

### Create data.frame with fertility rate and female variable
df_birthrate_state_age_fmale <- df_birth_state_age %>% 
  mutate(sex = "Female") %>% 
  select(c(year,state,CVE_GEO,age,sex,ferty_rate))

df_fertyrate_state_age <- inner_join(df_pop_state_age_sex, 
                                 df_birthrate_state_age_fmale)

### Save Birth and Fertility Rate Projections data.frame
save(df_birthrate_state_age, file = "data/df_birthrate_state_age.Rdata")
save(df_birthrate_state, file = "data/df_birthrate_state.Rdata")
save(df_fertyrate_state_age, file = "data/df_fertyrate_state_age.Rdata")

write.csv(df_birthrate_state_age, "data/df_birthrate_state_age.csv")
write.csv(df_birthrate_state, "data/df_birthrate_state.csv")
write.csv(df_fertyrate_state_age, "data/df_fertyrate_state_age.csv")


# *****************************************************************************
#### 02.04 Mortality Rates Projections ####
# *****************************************************************************
### Load population projections
load("data/df_mort_state.Rdata")
load("data/df_mort_state_age.Rdata")
load("data/df_mort_state_age_sex.Rdata")

### Join data.frames
df_mortrate_state         <- inner_join(df_pop_state, df_mort_state)
df_mortrate_state_age     <- inner_join(df_pop_state_age, df_mort_state_age)
df_mortrate_state_age_sex <- inner_join(df_pop_state_age_sex, df_mort_state_age_sex)

### Compute mortality rates
df_mortrate_state <- df_mortrate_state %>%
  mutate(mort_rate = deaths/population)
df_mortrate_state_age <- df_mortrate_state_age %>%
  mutate(mort_rate = deaths/population)
df_mortrate_state_age_sex <- df_mortrate_state_age_sex %>%
  mutate(mort_rate = deaths/population)

### Save Mortality Rate Projections data.frame
save(df_mortrate_state, file = "data/df_mortrate_state.Rdata")
save(df_mortrate_state_age, file = "data/df_mortrate_state_age.Rdata")
save(df_mortrate_state_age_sex, file = "data/df_mortrate_state_age_sex.Rdata")

write.csv(df_mortrate_state, "data/df_mortrate_state.csv")
write.csv(df_mortrate_state_age, "data/df_mortrate_state_age.csv")
write.csv(df_mortrate_state_age_sex, "data/df_mortrate_state_age_sex.csv")
