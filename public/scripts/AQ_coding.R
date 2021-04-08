library("tidyverse")

dat <- read_csv("sm_data.csv", skip = 1)

dat_long <- dat %>%
  pivot_longer(Q1:Q10, names_to = "item", values_to = "response") %>%
  separate(response, c(NA, "agreement"), " ") 

## lookup table solution

lookup1 <- dat_long %>%
  distinct(item) %>%
  mutate(scoring = if_else(item %in% c("Q1", "Q7", "Q8", "Q10"),
                           "forward",
                           "reverse"))

lookup2 <- tibble(scoring = c("forward", "forward", "reverse", "reverse"),
                  agreement = c("Agree", "Disagree", "Agree", "Disagree"),
                  score = c(1, 0, 0, 1))

scoring_table <- inner_join(lookup1, lookup2, "scoring")

inner_join(dat_long, scoring_table, c("item", "agreement")) %>%
  group_by(Id) %>%
  summarize(AQ = sum(score))

## if_else solution

dat_long %>%
  mutate(score = if_else(item %in% c("Q1", "Q7", "Q8", "Q10"),
                         agreement == "Agree",
                         agreement == "Disagree")) %>%
  group_by(Id) %>%
  summarize(AQ = sum(score))

## case_when solution

dat_long %>%
  mutate(score = case_when(item %in% c("Q1", "Q7", "Q8", "Q10") &
                             agreement == "Agree" ~ 1L,
                           !(item %in% c("Q1", "Q7", "Q8", "Q10")) &
                             agreement == "Disagree" ~ 1L,
                           TRUE ~ 0L))