## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.2,
  dpi = 96
)
library(rbcc)

## ----data---------------------------------------------------------------------
set.seed(20261)
n <- 4L
groups <- 60L
X <- c(
  rnorm(40L * n, mean = 10.0, sd = 0.45),
  rnorm(20L * n, mean = 10.9, sd = 0.45)
)
UC <- rnorm(groups * n, mean = 0, sd = 0.08)
C <- c(c11 = 1, c10 = 8, c01 = 70, c00 = 4)

## ----xbar-fit-----------------------------------------------------------------
xbar_fit <- rbcc_opt(
  X, UC, C,
  n = n,
  type = "xbar",
  LKL = 0,
  UKL = 5,
  optimizer = "exact"
)
xbar_fit$optimization
summary(xbar_fit)

## ----audit--------------------------------------------------------------------
cbind(
  count = xbar_fit$decision_counts,
  unit_cost = C,
  aggregate_cost = xbar_fit$cost_components
)
sum(xbar_fit$cost_components)

## ----xbar-plot, fig.cap="Reference and observed X-bar statistics with conventional and optimized risk-based limits."----
plot(xbar_fit)

## ----family-fits--------------------------------------------------------------
fits <- list(
  Xbar = xbar_fit,
  R = rbcc_opt(X, UC, C, n = n, type = "R"),
  S = rbcc_opt(X, UC, C, n = n, type = "S"),
  MA = rbmacc_opt(X, UC, C, n = n, w = 3),
  EWMA = rbewmacc_opt(X, UC, C, n = n, lambda = 0.20),
  CUSUM = rbcusumcc_opt(X, UC, C, n = n, T = 5, se.shift = 1)
)

family_summary <- data.frame(
  chart = names(fits),
  K = vapply(fits, function(x) unname(x$Kopt), numeric(1L)),
  total_cost = vapply(fits, function(x) unname(x$cost0), numeric(1L)),
  type_I = vapply(fits, function(x) unname(x$q10), numeric(1L)),
  type_II = vapply(fits, function(x) unname(x$q01), numeric(1L)),
  evaluations = vapply(
    fits,
    function(x) as.numeric(x$optimization$evaluations),
    numeric(1L)
  )
)
knitr::kable(family_summary, digits = 3)

## ----optimizer-comparison-----------------------------------------------------
control <- rbcc_control(grid_size = 201L)
optimizer_fits <- list(
  exact = rbcc_opt(
    X, UC, C, n = n, type = "xbar", optimizer = "exact"
  ),
  bounded = rbcc_opt(
    X, UC, C, n = n, type = "xbar", optimizer = "optimize"
  ),
  grid = rbcc_opt(
    X, UC, C, n = n, type = "xbar", optimizer = "grid",
    control = control
  )
)
optimizer_summary <- data.frame(
  method = names(optimizer_fits),
  K = vapply(optimizer_fits, function(x) x$Kopt, numeric(1L)),
  total_cost = vapply(optimizer_fits, function(x) x$cost0, numeric(1L)),
  evaluations = vapply(
    optimizer_fits,
    function(x) as.numeric(x$optimization$evaluations),
    numeric(1L)
  )
)
knitr::kable(optimizer_summary, digits = 4)

## ----parallel-grid, eval=FALSE------------------------------------------------
# parallel_grid_fit <- rbcc_opt(
#   X, UC, C,
#   n = n,
#   type = "xbar",
#   optimizer = "grid",
#   parallel = TRUE,
#   workers = 2,
#   control = rbcc_control(grid_size = 2001L)
# )

## ----multivariate-------------------------------------------------------------
data("t2uc", package = "rbcc")
X_multi <- as.matrix(t2uc[, 1:2])
UC_multi <- as.matrix(t2uc[, 5:6])
C_multi <- c(c11 = 1, c10 = 20, c01 = 160, c00 = 5)

multi_fit <- rbmcc_opt(
  X_multi, UC_multi, C_multi,
  n = 1,
  confidence_level = 0.99,
  LKL = -5,
  UKL = 5,
  optimizer = "exact"
)
summary(multi_fit)

## ----s3-interface-------------------------------------------------------------
s <- summary(xbar_fit)
p <- plot(xbar_fit)

names(s)
class(p)

