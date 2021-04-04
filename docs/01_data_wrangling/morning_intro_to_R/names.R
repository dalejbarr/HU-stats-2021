# course materials at
# http://80.229.171.197/ps_stats

library("tidyverse")

people <- tribble(~who, ~where,
        "Dale", "Glasgow",
        "Kerry", "Scottish Borders",
        "Kate", "Oxford",
        "Emma", "London",
        "Te-Yi", "Taiwan",
        "Shu", "London",
        "Lara", "Amsterdam",
        "Simine", "Davis",
        "Kristina", "Seattle",
        "Henry", "London",
        "Nathan", "Nottingham",
        "Elaine", "Edinburgh",
        "Anna", "Stirling",
        "Katie", "Manchester",
        "Tom", "Glasgow")

dat <- read_csv("babies-first-names-all-names-all-years.csv")

dat2 <- dat %>%
  group_by(yr, FirstForename) %>%
  summarise(n = sum(number)) %>%
  ungroup()

pnames <- left_join(people, dat2, c("who" = "FirstForename")) %>%
  arrange(who)

g <- ggplot(pnames, aes(yr, n)) +
  geom_line() +
  facet_wrap(~who, scales = "free_y")

ggsave("names.png", g)
