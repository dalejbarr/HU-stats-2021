options(crayon.enabled = FALSE, tidyverse.quiet = TRUE)
library("webex")
library("tidyverse")

x <- "Solution"
hide(x)

unhide()

items <- tibble(item_id = 1:nitem,
		cond = rep(c(-.5, .5), times = nitem / 2),
		iri = rnorm(nitem, 0, sd = iri_sd))

mx <- matrix(c(sri_sd^2,               rcor * sri_sd * srs_sd,
	       rcor * sri_sd * srs_sd, srs_sd^2),
	     nrow = 2, byrow = TRUE) # look at it

by_subj_rfx <- MASS::mvrnorm(nsubj, mu = c(sri = 0, srs = 0), Sigma = mx)

subjects <- as.tibble(by_subj_rfx) %>%
  mutate(subj_id = row_number()) %>%
  select(subj_id, everything())

trials <- crossing(subjects %>% select(subj_id),
		   items %>% select(item_id)) %>%
  mutate(err = rnorm(nrow(subjects) * nrow(items), mean = 0, sd = err_sd))

dat_sim <- subjects %>%
  inner_join(trials, "subj_id") %>%
  inner_join(items, "item_id") %>%
  arrange(subj_id, item_id) %>%
  select(subj_id, item_id, sri, iri, srs, cond, err)

dat_sim2 <- dat_sim %>%
  mutate(Y = mu + sri + iri + (eff + srs) * cond + err) %>%
  select(subj_id, item_id, Y, everything())
