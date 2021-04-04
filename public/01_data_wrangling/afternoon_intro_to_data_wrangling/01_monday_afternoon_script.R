## first part of Monday afternoon session
## data wrangling with the tidyverse: the "Wickham 6 verbs"

library("tidyverse")
library("babynames")

rnorm(10)
rnorm(10, 100)
rnorm(n = 10, mean = 100, sd = 20)

rnorm(mean = 100, n = 10, sd = 20)
rnorm(10, sd = 20)

x <- sample(1:10, 5, replace = TRUE)
y <- unique(x)
sort(y, TRUE)

sample(1:10, 5, replace = TRUE) %>%
  unique() %>%
  sort(TRUE)

sort(unique(sample(1:10, 5, replace = TRUE)), TRUE)

select(babynames, proportion = prop)
rename(babynames, proportion = prop)

arrange(babynames, year, desc(name))

filter(babynames, year > 1970)

keep <- c("Matthew", "Mark", "Luke", "John")

filter(babynames, name %in% keep)

cutoff <- 1971L
filter(babynames, year < cutoff)

# x <- fn1()
# fn2(x)
# fn1() %>% fn2()
bbn2 <- mutate(babynames, 
               decade = floor(year / 10) * 10,
               century = floor(year / 100) * 100)

bbn3 <- group_by(bbn2, century, decade)

summarise(bbn3, 
          tot = sum(n))

babynames %>%
  mutate(decade = floor(year / 10) * 10,
         century = floor(year / 100) * 100)  %>% 
  group_by(century, decade) %>%
  summarise(tot = sum(n))

babynames %>%
  group_by(name, sex) %>%
  summarise(n = n())

count(babynames, name, sex) %>%
  arrange(desc(n))

count(babynames, name)
count(babynames, year)

sonny <- babynames %>% filter(name == "Sonny")
cher <- babynames %>% filter(name == "Cher")

bind_rows(sonny, cher)

babynames %>%
  mutate(nc = map_int(name, nchar))

slice(babynames, 300:351)

vv <- starwars$name
vv[77]

starwars %>% pull(name) %>% pluck(77)

## second part of afternoon session starts here
## tidy data: reshaping and joining data
library("tidyverse")

# tidying a dataset
big5 <- read_csv("personality.csv")

gather(big5, "item", "score", Op1:Ex9) %>%
  arrange(user_id, item) %>%
  separate(item, into = c("trait", "question"),
           sep = 2, convert = TRUE) %>%
  group_by(user_id, trait) %>%
  summarise(tot = mean(score, na.rm = TRUE)) %>%
  ungroup()

inner_join(band_members, band_instruments, "name")
left_join(band_members, band_instruments, "name")
full_join(band_members, band_instruments, "name")

semi_join(band_members, band_instruments, "name")
anti_join(band_members, band_instruments, "name")

bm <- tibble(name = c("John", "John", "Paul"),
             band = c("Beatles", "Led Zeppelin", 
                      "Beatles"))

inner_join(bm, bi, c("name", "band"))

bi <- bm %>%
  mutate(instrument = c("guitar", "bass", "bass"))

