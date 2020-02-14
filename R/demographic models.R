### Non-homogeneous Demographic model
demog.mod.ns <- function(t, init, parameters, n.ages){
  derivs <- vector(length = n.ages)
  
  with(as.list(parameters), 
       {
         derivs[1] <- v_b[t] - (m_d[1, t] + m_mu[1, t])*init[1]
         for(i in 2:n.ages) {
           derivs[i] <- (m_d[i - 1, t]) * init[i - 1] - (m_d[i, t] + m_mu[i, t])*init[i]
         }
         
         return(list(derivs))
       }
  )
}

## Non-homogeneous demographic model vectorized version
demog.mod.ns.vec <- function(t, init, parameters, n.ages){
  with(as.list(parameters), 
       {
         Dg <- c(v_b[t], (m_d[, t]*init)[-n.ages])
         dD_dt <- Dg - (m_d[, t] + m_mu[, t])*init
         return(list(dD_dt))
       }
  )
}