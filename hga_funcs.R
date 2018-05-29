# Initialization function list (one function by module)
init <- list(
    function(lvl) {
        c(mov_cost = runif(1, 0.01, 0.25),
          alt_am = runif(1, 0.5, 1),
          am_decay = runif(1, 0.6, 1),
          trv_cost = max(0, rnorm(1, 1.3, 0.65)),
          ins_prem = runif(1, 0.01, 1))
    },
    function(lvl) {
        if (lvl == 1) c(t_wgt = 1)
        else c(t_wgt = runif(1, 0, 1.05))
    },
    function(lvl) {
        if (lvl < 3) c(loc_think = 1)
        else c(loc_think = runif(1, 0, 1))
    }
)


# Fitness function
#  g: generation number, i: individual number, ind: individual from pop
#  Note: Requires open Matlab connection "ml"
calc_fit <- function(g, i, ind) {
    pars <- unlist(ind$params)
    # adjust order of model levels and parameters as needed for .mat file
    pars_order <- c(eumod = ind$levels[3], riskmod = ind$levels[2], pars["t_wgt"],
                    pars["loc_think"], pars["mov_cost"], pars["trv_cost"], 
                    pars["am_decay"], pars["alt_am"], pars["ins_prem"])
    # If needed, change "params" to the variable name you want in Matlab
    writeMat("params.mat", g_id = g, ind_id = i, params = pars_order)
    setOption(ml, "readResult/interval", 300)
    evaluate(ml, "Master_CHALMS_Coast_event_hga") # Enter exact Matlab file to run
    setOption(ml, "readResult/interval", 1)
    #evaluate(ml, "score = %calc_fitness...%") # Enter exact Matlab function call
    as.vector(getVariable(ml, "score")[[1]])
}


# Linear rank selection function
# (based on http://www.geatbx.com/docu/algindex-02.html)
# s = selective pressure (1 = no select., 2 = strongest select.)
# nelit = nb. of top indiv. to keep as is (elitism)
linr_sel <- function(pop, s, nelit) {
    nind <- length(pop)
    newpop <- pop
    
    # Calculate ranks and selection probabilities
    fit_r <- rank(sapply(pop, "[[", "fit"), ties.method = "random")
    prob <- 1/nind * (2 - s + 2 * (s - 1) * (fit_r - 1)/(nind - 1))
    
    # Keep elites, move to start of list
    newpop[seq_len(nelit)] <- pop[fit_r > nind - nelit]
    
    # Redraw nind - nelit individuals to replace non-elites
    sel_ind <- sample.int(nind, nind - nelit, replace = TRUE,
                          prob = prob)
    newpop[(nelit + 1):nind] <- pop[sel_ind]
    newpop
}


# Arithmetic crossover function
#  input and output is a list of two individuals
arith_cross <- function(parents) {
    children <- parents
    for (i in seq_along(parents[[1]]$levels)) {
        if (parents[[1]]$levels[i] == parents[[2]]$levels[i]) {
            # Arithmetic crossover if both parents at same level for that block
            a <- runif(1)
            children[[1]]$params[[i]] <- a * parents[[1]]$params[[i]] + 
                                         (1 - a) * parents[[2]]$params[[i]]
            children[[2]]$params[[i]] <- a * parents[[2]]$params[[i]] + 
                                         (1 - a) * parents[[1]]$params[[i]]
        } else {
            # If levels are different, uniform crossover between blocks
            #  (note: we could reduce prob. below 0.5 
            #   to make between-level crossover less likely)
            if (runif(1) < 0.5) {
                children[[1]]$levels[i] <- parents[[2]]$levels[i]
                children[[1]]$params[[i]] <- parents[[2]]$params[[i]]
                children[[2]]$levels[i] <- parents[[1]]$levels[i]
                children[[2]]$params[[i]] <- parents[[1]]$params[[i]]
            }
        }
    }
    # Post-crossover fitness unknown
    children[[1]]$fit <- NA_real_
    children[[2]]$fit <- NA_real_
    children
}


# Hierarchical mutation function applied to individual 'x' from population
# For each module, may switch level with prob. pjump
#  If there's a switch, re-initialize level
#  If not, try mutating each parameter with prob. pmut
#    Mutation is normally distributed around current value, with scaling scal
# nlevels: nb. of levels by module, 
# adj_lvl: min. level with adjustable parameters by module
# minp, maxp, sdp: lists of min., max. and mutation s.d. for parameters

norm_mutate <- function(x, scal, pmut, pjump, nlevels, adj_lvl, minp, maxp, sdp) {
    for (i in seq_along(x$levels)) {
        if (nlevels[i] > 1 && runif(1) < pjump) {
            if (x$levels[i] == 1) { 
                x$levels[i] <- 2
            } else if (x$levels[i] == nlevels[i]) {
                x$levels[i] <- nlevels[i] - 1
            } else { # equal prob. of going up or down a level
                x$levels[i] <- x$levels[i] + sign(rnorm(1))
            }
            # Draw new set of parameters
            x$params[[i]] <- init[[i]](x$levels[i])
            x$fit <- NA_real_
        } else {
            if (x$levels[i] >= adj_lvl[i]) {  
                # 0 or 1 depending if parameter is mutated
                has_mut <- as.integer(runif(length(x$params[[i]])) < pmut)
                if (any(has_mut == 1)) x$fit <- NA_real_
                new_vals <- x$params[[i]] + rnorm(length(x$params[[i]]), mean = 0, 
                                                  sd = has_mut * scal * sdp[[i]])
                # keep within bounds
                x$params[[i]] <- pmax(pmin(new_vals, maxp[[i]]), minp[[i]])
            }
        }
    }
    x
}

