library("lme4")
library("tidyverse")

set.seed(11709)

nsubj <- 100 # number of subjects
nitem <- 50  # must be an even number

mu <- 800 # grand mean
eff <- 80 # 80 ms difference
effc <- c(-.5, .5) # deviation codes

iri_sd <- 80 # by-item random intercept sd (omega_00)

## for the by-subjects variance-covariance matrix
sri_sd <- 100 # by-subject random intercept sd
srs_sd <- 40 # by-subject random slope sd
rcor <- .2 # correlation between intercept and slope

err_sd <- 200 # residual (standard deviation)

items <- tibble(item_id = 1:nitem,
		cond = rep(c(-.5, .5), times = nitem / 2),
		iri = rnorm(nitem, 0, sd = iri_sd))

items

## mx is the variance-covariance matrix
mx <- matrix(c(1, -.6,
	       -.6, 1), nrow = 2, byrow = TRUE)

biv_data <- MASS::mvrnorm(1000, mu = c(0, 0), Sigma = mx)

## look at biv_data
ggplot(as.tibble(biv_data), aes(V1, V2)) + geom_point()

mx <- matrix(c(sri_sd^2,               rcor * sri_sd * srs_sd,
	       rcor * sri_sd * srs_sd, srs_sd^2),
	     nrow = 2, byrow = TRUE) # look at it

by_subj_rfx <- MASS::mvrnorm(nsubj, mu = c(sri = 0, srs = 0), Sigma = mx)

subjects <- as.tibble(by_subj_rfx) %>%
  mutate(subj_id = row_number()) %>%
  select(subj_id, everything())

subjects %>% print(n = +Inf)

trials <- crossing(subjects %>% select(subj_id),
		   items %>% select(item_id)) %>%
  mutate(err = rnorm(nrow(subjects) * nrow(items), mean = 0, sd = err_sd))

trials

dat_sim <- subjects %>%
  inner_join(trials, "subj_id") %>%
  inner_join(items, "item_id") %>%
  arrange(subj_id, item_id) %>%
  select(subj_id, item_id, sri, iri, srs, cond, err)

dat_sim

dat_sim2 <- dat_sim %>%
  mutate(Y = mu + sri + iri + (eff + srs) * cond + err) %>%
  select(subj_id, item_id, Y, everything())

dat_sim2

library("lme4")

mod_sim <- lmer(Y ~ cond + (1 + cond | subj_id) + (1 | item_id),
		dat_sim2, REML = FALSE)

summary(mod_sim, corr = FALSE)

srfx <- attr(VarCorr(mod_sim)$subj_id, "stddev")
irfx <- attr(VarCorr(mod_sim)$item_id, "stddev")
rc <- attr(VarCorr(mod_sim)$subj_id, "correlation")[1, 2]

res <- attr(VarCorr(mod_sim), "sc")

ffx <- fixef(mod_sim)

tribble(~parameter, ~variable, ~input, ~estimate,
	"\\(\\hat{\\beta}_0\\)", "=mu=", mu, round(ffx[1], 3),
	"\\(\\hat{\\beta}_1\\)", "=eff=", eff, round(ffx[2], 3))

tribble(~parameter, ~variable, ~input, ~estimate,
	"\\(\\hat{\\tau}_{00}\\)", "=sri_sd=", sri_sd, round(srfx[1], 3),
	"\\(\\hat{\\tau}_{11}\\)", "=srs_sd=", srs_sd, round(srfx[2], 3),
	"\\(\\hat{\\rho}\\)", "=rcor=", rcor, round(rc, 3),
	"\\(\\hat{\\omega}_{00}\\)", "=iri_sd=", iri_sd, round(irfx[1], 3),
	"\\(\\hat{\\sigma}\\)", "=err_sd=", err_sd, round(res, 3))
