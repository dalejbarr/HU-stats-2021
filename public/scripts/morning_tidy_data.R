library("babynames")
library("tidyverse")

targets <- babynames %>%
  filter(prop > .01) %>%
  distinct(name) %>%
  mutate(lastchar = substr(name, nchar(name), nchar(name)),
         is_vowel = lastchar %in% c("a", "e", "i", "o", "u", "y"))

combined <- inner_join(targets, babynames, "name")

combined %>%
  group_by(sex, is_vowel) %>%
  summarize(total = sum(n), .groups = "drop") %>%
  group_by(sex) %>%
  mutate(total_sex = sum(total),
         p = total / total_sex)

# main <- filter(my_data, critical = TRUE)
# comp <- filter(my_data, critical = FALSE)

# comp_means <- comp %>%
#  group_by(subject_id) %>%
#  summarize(p_correct = mean(response))

# main2 <- main # %>% 

#comp_means %>%
#  filter(p_correct > .75) %>%
#  inner_join(main, "subject_id")

## reshaping data using pivot_* functions

ocean <- read_csv("personality.csv")

## how i want the data to look
tribble(~user_id, ~item, ~score,
        0, "Op1", 3,
        0, "Ne1", 4,
        0, "Ne2", 0)

longdata <- ocean %>%
  select(-date) %>%
  pivot_longer(Op1:Ex9, names_to = "item", values_to = "score")

longdata %>%
  distinct(item) %>%
  arrange(item) %>%
  print(n = +Inf)

## make a new variable that identifies the subscale
ocean2 <- longdata %>%
  separate(item, c("subscale", "it"), 2L) %>%
  group_by(user_id, subscale) %>%
  summarize(mscore = mean(score, na.rm = TRUE), .groups = "drop")

## how we want it to look:
tribble(~user_id, ~Ag, ~Co, ~Ex, ~Ne, ~Op,
        0, 1.83, 2.7, 2.78, 1.86, 2.86)

ocean2 %>%
  pivot_wider(names_from = subscale, values_from = mscore)



