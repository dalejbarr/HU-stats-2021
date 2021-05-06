  library("tidyverse")

  my_line <- function(x, b0 = 0, b1 = 1) {
    b0 + b1 * x
  }

  ## get a probability from a value
  logit_inv <- function(x) {
    1 / (1 + exp(-my_line(x)))
  }


  gen_dat <- function(b0 = 0, b1 = 1, nobs = 200) {
    data_frame(x = runif(nobs, -4, 4),
               eta = my_line(x, b0, b1),
               p = logit_inv(eta),
               resp = map_int(p, function(x) sample(0:1, 1, prob = c(1 - x, x))))
  }

  make_plot <- function(b0 = 0, b1 = 1, nobs = 200) {

    lindat <- data_frame(x = runif(nobs, -3, 3),
			 e = rnorm(nobs),
			 y = my_line(x, b0, b1))

    logitdat <- lindat %>%
      mutate(y = logit_inv(y))

    full <- bind_rows(lindat %>% mutate(space = "linear: eta = b0 + b1 * x"),
                      logitdat %>% mutate(space = "logit: (1 / (1 + exp(-eta)))"))

    ggplot(full, aes(x, y)) +
      geom_point() +
      facet_wrap(~space, scales = "free_y")
  }
