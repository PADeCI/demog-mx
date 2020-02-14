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
