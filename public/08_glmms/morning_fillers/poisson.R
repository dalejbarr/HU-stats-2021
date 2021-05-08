library("tidyverse")
library("lme4")

## https://github.com/dalejbarr/GannBarr2014/raw/master/urefs.rds
gb14 <- readRDS("urefs.rds") %>%
  as_tibble()

subj_means <- gb14 %>%
  group_by(SessionID, Novelty, Addressee, Feedback) %>%
  summarize(m = mean(WC), .groups = "drop")

cell_means <- gb14 %>%
  group_by(Novelty, Addressee, Feedback) %>%
  summarize(m = mean(WC), .groups = "drop")

ggplot(subj_means, aes(Novelty, m, color = Addressee)) +
  geom_point(alpha = .2) +
  geom_line(aes(group = SessionID), alpha = .2) +
  geom_point(data = cell_means, size = 3) +
  geom_line(data = cell_means, aes(group = Addressee), size = 2) +
  facet_wrap(~Feedback, labeller = "label_both")

gb14 %>%
  count(SessionID, Novelty, Addressee, Feedback)

gb14 %>%
  count(ItemID, Novelty, Addressee, Feedback)

gb14_adj <- gb14 %>%
  mutate(WC2 = WC - 1,
         Nov = if_else(Novelty == "New", .5, -.5),
         Add = if_else(Addressee == "New", .5, -.5),
         Fbk = if_else(Feedback == "No", .5, -.5))

gb14_adj %>%
  count(Novelty, Addressee, Feedback, Nov, Add, Fbk)

mod <- glmer(WC2 ~ Nov * Add * Fbk +
               (Nov * Fbk | SessionID) +
               (Nov * Add | ItemID),
             gb14_adj, family = poisson)

mod2 <- glmer(WC2 ~ Nov * Add * Fbk +
                (Nov * Fbk | SessionID) +
                (Nov * Add || ItemID),
              gb14_adj, family = poisson)
