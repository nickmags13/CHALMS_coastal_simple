### This R code runs the hierarchical genetic algorithm (HGA)

library(R.matlab)
dir <- "C:/Users/nmagliocca/Documents/Matlab_code/CHALMS_coast/simple-chalms"
setwd(dir)

# Load functions
source("hga_funcs.R")

# Define HGA parameters
nind <- 1 # Number of individuals
nmod <- 3 # Number of modules
ngen <- 2 # Number of generations
nelit <- ceiling(0.05 * nind)  # How many elites to carryforward by gen
s <- 2  # Selective pressure (between 1 and 2)
pcross <- 0.2 # Probability of crossover (per parent pair)
scal <- 1 # Scaling parameter for Gaussian mutation
pmut <- 0.2 # Probability of mutation per parameter
pjump <- 0.05 # Probability of mutation to level (up or down) per module

# Number of levels, initial level by module, and min. level with adjustable params.
nlevels <- c(1, 3, 3)
ilevel <- c(1, 1, 1)
adj_lvl <- c(1, 2, 3)

# Lists to hold min. parameter values, max. values and st. dev. (for mutation)
minp <- list(c(mov_cost = 0.01, alt_am = 0.5, am_decay = 0.6,
               trv_cost = 0, ins_prem = 0.1), 
             c(t_wgt = 0), c(loc_think = 0))
maxp <- list(c(mov_cost = 0.25, alt_am = 1, am_decay = 1,
               trv_cost = 5, ins_prem = 1), 
             c(t_wgt = 1.05), c(loc_think = 1))
sdp <- list(c(mov_cost = 0.1, alt_am = 0.2, am_decay = 0.2,
              trv_cost = 0.65, ins_prem = 0.5), 
            c(t_wgt = 0.5), c(loc_think = 0.5))

# Start all at level 1 and initialize params
pop <- replicate(nind, list(
    levels = ilevel, 
    params = lapply(1:nmod, function(i) init[[i]](ilevel[i])),
    fit = NA_real_
), simplify = FALSE)

# Start Matlab server and connect
Matlab$startServer()
ml <- Matlab()
open(ml)
setVerbose(ml, threshold=-2)
g <- 0
# Calculate fitness
for (i in 1:nind) {
    pop[[i]]$fit <- calc_fit(g, i, pop[[i]])
}

# Main genetic algorithm loop
#  Note: this overwrites the population at each step, but could be easily
#   modified to keep intermediary results
for (g in 1:ngen) {
    # Apply selection operator
    pop <- linr_sel(pop, s, nelit)
    
    # Crossover
    for (i in seq(nelit + 1, nind - 1, 2)) {
        if (runif(1) < pcross) {
            pop[i:(i + 1)] <- arith_cross(pop[i:(i + 1)])
        }
    }
    
    # Mutation
    for (i in (nelit + 1):nind) {
        pop[[i]] <- norm_mutate(pop[[i]], scal, pmut, pjump,
                                nlevels, adj_lvl, minp, maxp, sdp)
    }   
    
    # Calculate fitness when missing
    for (i in 1:nind) {
        if (is.na(pop[[i]]$fit)) 
            pop[[i]]$fit <- calc_fit(g, i, pop[[i]])
    }
}

# Close connection to Matlab server
close(ml)
