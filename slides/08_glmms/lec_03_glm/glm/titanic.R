library("readxl")
library("dplyr")
library("broom")

logit_inv <- function(x) 1 / (1 + exp(-x))

tdat <- read_excel("titanic4.xls")

count(tdat, sex, survived)

mod <- glm(survived ~ sex, binomial(link = "logit"),
           tdat)
summary(mod)

broom::tidy(mod)
