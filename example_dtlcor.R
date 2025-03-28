
rm(list = ls())
options(error = recover)
require(devtools)

# for local package
load_all("dtlcor")
document("dtlcor")

# for online package
# install_github("ashwz/dtlcor")

require(dtlcor)
ls(getNamespace("dtlcor"))

set.seed(1000)

# set design parameters
nsim      = 100

delta     = 0.05  
n         = 80    
N         = 152   
alpha     = 0.025

q_seq     = seq(0.19, 0.32, 0.01) 
gamma_seq = seq(0.14, 0.34, 0.01) 

D           = 162
mPFS        = c(180, 276, 300)
q           = c(0.2, 0.4, 0.5)
gamma       = 0.15
drop_rate   = 0.05 # annual drop-out rate
enroll      = 20 * 12 # annual enrollment rate
interim_t   = c(0.5, 1)
fix_rho     = NULL

# --------------------basic function-----------------
# theoretical FWER
dtl_tier_the(n, t = 1, rho = 0.4, q = 0.3, alpha_s = alpha, delta)

# get alpha_s given alpha
dtl_get_alpha_s(n, t = 1, rho = 0.4, q = 0.3, alpha, delta)

# get upper bound of correlation
dtl_cor_the_PH_upper_bound(tau_k = n/N, pi_ar = 0.5, q = 0.3, gamma = 0.2)

# --------------------real application-----------------
# get alpha_t (minimum of alpha_s)
# values of fix_rho: NULL (use upper bound of rho) or real values from 0 to 1.
dtl_app_get_alpha_t(n, N, q_seq, gamma_seq, alpha, fix_rho = NULL, delta)$rst_alpha_t[1,]
dtl_app_get_alpha_t(n, N, q_seq, gamma_seq, alpha, fix_rho = 1, delta)$rst_alpha_t[1,]
dtl_app_get_alpha_t(n, N, q_seq, gamma_seq, alpha, fix_rho = 0, delta)$rst_alpha_t[1,]

dtl_app_get_alpha_t_sim(nsim = 100000, n, N, q_seq, gamma_seq, alpha, fix_rho = NULL, delta = delta)$rst_alpha_t[1,]
dtl_app_get_alpha_t_sim(nsim = 100000, n, N, q_seq, gamma_seq, alpha, fix_rho = 1, delta = delta)$rst_alpha_t[1,]
dtl_app_get_alpha_t_sim(nsim = 100000, n, N, q_seq, gamma_seq, alpha, fix_rho = 0, delta = delta)$rst_alpha_t[1,]

# simulate a single trial
dtl_single = dtl_app_sim_single(D, N, n, mPFS, q, gamma, drop_rate, enroll, interim_t, delta = delta)

# simulation results
alpha_t     = dtl_app_get_alpha_t(n, N, q_seq, gamma_seq, alpha, fix_rho = NULL, delta)$rst_alpha_t$alpha_t[1]
dtl_summary = dtl_app_sim(nsim, alpha_t, D, N, n, mPFS, q, gamma, drop_rate, enroll, interim_t, delta = delta)

# -------------------open the R shiny-----------------
dtl_shiny()
