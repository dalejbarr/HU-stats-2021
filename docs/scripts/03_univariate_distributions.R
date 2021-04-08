## what is the probability of getting 
## 5 or more heads from 7 coin flips?

## p(k=5) + p(k = 6) + p(k = 7)

dbinom(5, 7, prob = 1/2)
dbinom(6, 7, prob = 1/2)
dbinom(7, 7, prob = 1/2)

sum(dbinom(5:7, 7, prob = 1/2))

sum(dbinom(60:100, 100, prob = 1/2))

## rbinom: random generation

## n = number of experiments
## size = number of trials per exp
## 
hist(rbinom(n = 1000, 
            size = 100, 
            prob = 1/6))

## normal distribution

## z = (X - mu) / sd

# ?rnorm
## probability of being 1.25 SD above the mean?
## (for a standard normal distribution, mean = 0 / sd = 1)
pnorm(1.25, lower.tail = FALSE)
1 - pnorm(1.25)

## probability of being 1.25 SD below the mean?
pnorm(1.25, lower.tail = FALSE) # lower.tail= TRUE is the default
pnorm(-1.25)

## IQ is 132
## mean IQ = 100. sd is 15

pnorm(132, 100, 15, lower.tail = FALSE)

qnorm(.10, 100, 15, lower.tail = FALSE)
qnorm(.10, 100, 15, lower.tail = TRUE)
