library(deSolve)
library(reshape2)
#### Non-stationary, age-structured demographic model ####
v_times <- 1:200
n_times <- length(v_times)
parm_ns <- parm
### Non-homogeneous birth rate
parm_ns$v_b <- rep(parm_ns$b, n_times)*seq(1, 2, length.out = 200)
names(parm_ns$v_b) <- v_times
### Non-homogeneous death rate
parm_ns$m_mu <- matrix(rep(parm_ns$mu, 200)*seq(1, 1/2, length.out = 200), 
                       ncol = n_times,
                       dimnames = list(parm_ns$age, v_times))
### Non-homogeneous aging rate
parm_ns$m_d <- matrix(rep(parm_ns$d, 200), ncol = n_times,
                      dimnames = list(parm_ns$age, v_times))

#### Run models ####
system.time(
  test_ns <- lsoda(y = init, func = demog.mod.ns, 
                   times = 1:200, parms = parm_ns, n.ages = n.ages)
)
system.time(
  test.vec_ns <- lsoda(y = init, func = demog.mod.ns.vec, 
                       times = 1:200, parms = parm_ns, n.ages = n.ages)
)
points(rowSums(test_ns[, -1]), col = "red")
points(rowSums(test.vec_ns[, -1]), pch = 2, col = "red")

#### Non-stationary, age-structured demographic model ####
load(file = "data/df_pop_state_age.Rdata")
load(file = "data/df_birthrate_state.Rdata")
v_times <- 0:100
n_times <- length(v_times)
parm_ns <- list()#parm
n_pop0 <- subset(df_pop_state, state == "National" & year == 1950)$population
### Non-homogeneous birth rate
parm_ns$v_b <- subset(df_birth_state, state == "National")$births/n_pop0
  #subset(df_birthrate_state, state == "National")$birth_rate
names(parm_ns$v_b) <- v_times
### Non-homogeneous death rate
parm_ns$m_mu <- matrix(subset(df_mortrate_state_age, 
                              state == "National" & age <= 100)$mort_rate,
                       ncol = n_times,
                       dimnames = list(0:100, v_times))
### Non-homogeneous aging rate
parm_ns$m_d <- matrix(rep(1, 101*101), ncol = n_times,
                      dimnames = list(parm_ns$age, v_times))
v_init <- subset(df_pop_state_age, 
                 state == "National" & age <= 100 & year == 1950)$population/n_pop0
names(v_init) <- 0:100
n.ages <- 101
#### Run models ####
system.time(
  test_ns <- lsoda(y = v_init, func = demog.mod.ns, 
                   times = 1:101, parms = parm_ns, n.ages = n.ages)
)
system.time(
  test.vec_ns <- as.data.frame(lsoda(y = v_init, func = demog.mod.ns.vec, 
                       times = 1:101, parms = parm_ns, n.ages = n.ages))
)
test.vec_ns$time <- 1950:2050
colnames(test.vec_ns)[1] <- "year"
plot(rowSums(test_ns[, -1]), col = "red")
points(rowSums(test.vec_ns[, -1]), pch = 2, col = "red")

df_test.vec_ns <- melt(test.vec_ns, id.vars = "year", 
                       variable.name = "age", value.name = "population")
df_test.vec_ns$year <- factor(df_test.vec_ns$year)
df_test.vec_ns$age <- as.numeric(df_test.vec_ns$age)-1
ggplot(subset(df_pop_state, state == "National"),
       aes(x = year, y = population/n_pop0)) +
  geom_line() +
  geom_line(aes(x = 1950:2051, y = c(1, rowSums(test_ns[, -1]))), col = "red")

ggplot(subset(df_pop_state_age, state == "National" & year %in% c(1950, 2000, 2020)),
       aes(x = age, y = population/n_pop0, color = as.factor(year))) +
  geom_line() +
  geom_line(data = subset(df_test.vec_ns, year %in% c(1950, 2000, 2020)), 
            aes(x = age, y = population), lty = 2)
