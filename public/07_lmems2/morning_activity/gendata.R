library("funfact")
library("tidyverse")
library("lme4")

des <- list(ivs = list(congruency = c("congruent", "incongruent"),
                       native_speaker = c("no", "yes")),
            between_subj = "native_speaker",
            n_item = 32L)

pop <- gen_pop(des,
        fixed_ranges = list(c(600, 600), c(50, 50), c(-100, -100), c(80, 80)),
        var_range = c(1600, 1600),
        err_range = c(6400, 6400))

pop$item_rfx[, ] <- 0

dat <- sim_norm(des, 96, pop) %>%
  with_dev_pred(c("native_speaker", "congruency")) %>%
  rename(NS = native_speakeryes, C = congruencyincongruent)

g <- dat %>%
  group_by(native_speaker, congruency) %>%
  summarise(mean_rt = mean(Y)) %>%
  ggplot(aes(congruency, mean_rt, color = native_speaker)) +
  geom_point(aes(shape = native_speaker)) +
  geom_line(aes(group = native_speaker))

ggsave("plot.pdf", g)

summary(lmer(Y ~ NS * C + (C | subj_id), dat, REML = FALSE))

demog <- dat %>%
  distinct(subj_id, native_speaker)

missg <- demog %>%
  group_by(native_speaker) %>%
  sample_n(2L) %>%
  ungroup()

demog2 <- demog %>%
  select(subj_id) %>%
  left_join(demog %>%
            anti_join(missg, "subj_id"), "subj_id")

write_csv(demog2, "data/demog2.csv")

inkcols <- c("blue", "green", "yellow", "red", "purple", "orange", "brown", "pink")

stroop <- dat %>%
  select(subj_id, congruency, rt = Y) %>%
  as_tibble() %>%
  group_by(subj_id, congruency) %>%
  mutate(ink_colour = sample(rep(inkcols, 2)),
         response = ink_colour) %>%
  ungroup() %>%
  mutate(word = if_else(congruency == "incongruent",
                        map_chr(ink_colour, ~ sample(setdiff(inkcols, .x), 1L)),
                        ink_colour)) %>%
  group_by(subj_id) %>%
  mutate(trial_id = row_number()) %>%
  ungroup()

incorrect <- stroop %>%
  filter(congruency == "incongruent") %>%
  group_by(subj_id) %>%
  sample_n(1L) %>%
  ungroup() %>%
  mutate(response = word)

correct <- stroop %>%
  anti_join(incorrect, c("subj_id", "trial_id"))

stroop <- bind_rows(correct, incorrect) %>%
  arrange(subj_id, trial_id) %>%
  select(-trial_id, -congruency)

vv <- stroop %>%
  mutate(congruency = if_else(word == ink_colour, "congruent", "incongruent")) %>%
  filter(response == ink_colour) %>%
  inner_join(demog, "subj_id")

vv %>%
  group_by(native_speaker, congruency) %>%
  summarise(m = mean(rt))

write_csv(stroop, "data/stroop2.csv")
