#*****************************************************************************# 
# This script loads the formated data of Population projections from CONAPO   # 
# and computes different rates by age groups, states and sex, such as:        #
#  - Mortality rate                                                           #
#  - Birth rate                                                               #
#  - Aging rate                                                               #
#                                                                             # 
# Author: Fernando Alarid-Escudero                                            # 
# E-mail: fernando.alarid@cide.edu                                            # 
#*****************************************************************************# 

rm(list = ls()) # to clean the workspace

# *****************************************************************************
#### 02.01_Load_packages ####
# *****************************************************************************

# library(foreign)
library(data.table)
library(dplyr)
# library(ggplot2)
# library(stringr)
# library(epitools)
# library(tidyr)

# *****************************************************************************
#### 02.02 Load data ####
# *****************************************************************************

load(file = "data/df_pop_state_age_sex.Rdata")
load(file = "data/df_pop_state_age.Rdata")
load(file = "data/df_pop_state.Rdata")

# *****************************************************************************
#### 02.03 Birth Rates Projections ####
# *****************************************************************************
### Load population and birth projections
load("data/df_pop_state.Rdata")
load("data/df_birth_state.Rdata")

### Join data.frames
df_birthrate_state <- inner_join(df_pop_state, 
                                 df_birth_state)

### Compute birth rates
df_birthrate_state <- df_birthrate_state %>%
  mutate(birth_rate = births/population)

### Save Birth Rate Projections data.frame
save(df_birthrate_state, file = "data/df_birthrate_state.Rdata")

# *****************************************************************************
#### 02.04 Mortality Rates Projections ####
# *****************************************************************************
### Load population and mortality projections
load("data/df_pop_state.Rdata")
load("data/df_pop_state_age.Rdata")
load("data/df_pop_state_age_sex.Rdata")
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


df_mortrate_state %>% filter(year == 2012, state == "National")
df_mortrate_state_age %>% filter(year == 2012, state == "National")

# *****************************************************************************
#### 02.05 Aging Rates Projections ####
# *****************************************************************************

# df_pop_state <- 
df_pop_state_age %>%
  filter(state == "National") %>%
  group_by(state, CVE_GEO, age) %>%
  mutate(pop_lag = dplyr::lag(population, n = 1, default = NA),
         pop_dif = population - pop_lag) %>%
  arrange(state, CVE_GEO, year, age)
df_birthrate_state %>% 
  filter(state == "National") 
df_mortrate_state_age %>% 
  filter(state == "National") 

(1116564 - 161388) +  1308722

1259574 - 161388

df_pop_state_age %>% filter(year %in% c(1950, 1951) & age %in% c(0, 1))

1037404 - 1116564 
1259574 - 161388

(1037404 - (1116564 - 161388))/(1116564 - 161388)

n_pop0 <- subset(df_pop_state, state == "National" & year == 1950)$population
ggplot(subset(df_pop_state, state == "National"),
       aes(x = year, y = population/n_pop0)) +
  geom_line()
