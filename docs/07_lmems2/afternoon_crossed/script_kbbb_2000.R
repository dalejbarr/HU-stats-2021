dat <- readRDS("keysar_et_al.rds") %>%
  mutate(tfix = 1000 * ((targfix - crit) / 60))

ggplot(dat, aes(tfix)) + geom_histogram()

dat %>%
  group_by(cond) %>%
  summarise(m = mean(tfix, na.rm = TRUE), sd = sd(tfix, na.rm = TRUE),
	    .groups = "drop")

dat2 <- dat %>%
  mutate(cnd = if_else(cond == "E", .5, -.5))

mod <- lmer(tfix ~ cnd + (cnd | SubjID) +
	      (cnd | object), dat2, REML = FALSE)

summary(mod)

cf <- fixef(mod)
serr <- sqrt(diag(vcov(mod)))
tval <- cf / serr

2 * (1 - pnorm(abs(tval)))

mod2 <- update(mod, . ~ . -cnd)

anova(mod, mod2)
