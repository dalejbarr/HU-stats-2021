library("tidyverse")

pets <- read_csv("https://psyteachr.github.io/msc-data-skills/data/pets.csv", 
                 col_types = "cffiid")

ggplot(pets, aes(weight, fill = pet)) +
  geom_histogram(binwidth=1) +
  scale_fill_manual(values = c("red", "black", "yellow"))

ggplot(pets, aes(weight)) +
  geom_histogram() +
  facet_wrap(~country)

ggplot(pets, aes(x = score, y = weight, color = pet)) +
  geom_point(alpha = .5) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~pet, scales = "free_x")

ggplot(pets, aes(pet)) +
  geom_bar()

ggplot(pets, aes(x = pet, y = weight)) +
  geom_boxplot()

ggplot(pets, aes(x = pet, y = weight)) +
  geom_point(alpha = .2)

ggplot(pets, aes(x = pet, y = weight)) +
  geom_jitter(alpha = .2)

ggplot(pets, aes(x = pet, y = weight)) +
  geom_violin() +
  geom_boxplot()

ggplot(economics, aes(date, unemploy)) +
  geom_line()

ggplot(economics, aes(date, pop)) +
  geom_line()


ggplot(economics, aes(date, pop)) +
  geom_line() +
  labs(x = "Date Recorded", y = "Population") +
  ggtitle("U.S. Population by Year")
  