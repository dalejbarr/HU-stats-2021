library(dplyr)
library(tibble)

mu <- 70
a <- c(-3, 3)
b <- c(6, -6)
ab <- c(-11, 11, 11, -11)

nobs <- 12L

set.seed(62)

errs <- c(replicate(4, {
  vv <- sample(-3:3, 2L, TRUE)
  c(vv, -sum(vv))
}))


grades <- tibble(A = rep(c("A1", "A2"), each = nobs / 2),
       B = rep(rep(c("B1", "B2"), each = nobs / 4), 2),
       grade = mu + if_else(A == "A1", a[1], a[2]) +
         if_else(B == "B1", b[1], b[2]) +
         case_when(A == "A1" & B == "B1" ~ ab[1],
                   A == "A1" & B == "B2" ~ ab[2],
                   A == "A2" & B == "B1" ~ ab[3],
                   A == "A2" & B == "B2" ~ ab[4],
                   TRUE ~ NA_real_) +
         errs)

grades %>% summarize(x = mean(grade))

mod <- aov(grade ~ A * B, grades)
