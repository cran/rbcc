# rbcc 0.2.1

`rbcc` implements risk-based statistical process control charts in the
presence of measurement uncertainty. The package compares the process state
obtained from reference values with the decision obtained from measured values,
accounts for all four decision outcomes, and can select chart limits by
minimizing their total cost.

## Available charts

* Shewhart X-bar, R, and S charts: `rbcc()` and `rbcc_opt()`
* Moving-average charts: `rbmacc()` and `rbmacc_opt()`
* EWMA charts: `rbewmacc()` and `rbewmacc_opt()`
* CUSUM charts: `rbcusumcc()` and `rbcusumcc_opt()`
* Multivariate Hotelling T-squared charts: `rbmcc()` and `rbmcc_opt()`

The default exact threshold optimizer exploits the piecewise-constant structure
of the empirical decision cost and is deterministic. Bounded numerical
optimization and sequential or optional parallel grid search remain available.

## Getting started

After installation, open the complete workflow with:

```r
vignette("rbcc-workflow", package = "rbcc")
```

A minimal example is:

```r
library(rbcc)

set.seed(42)
X <- rnorm(80, mean = 10, sd = 0.5)
UC <- rnorm(80, mean = 0, sd = 0.05)
C <- c(c11 = 1, c10 = 5, c01 = 60, c00 = 5)

fit <- rbcc_opt(X, UC, C, n = 1, type = "xbar")
print(fit)

s <- summary(fit)  # no console output during assignment
s$cost0

p <- plot(fit)     # no drawing during assignment
p                  # draws the ggplot object
```

## Alternative optimizers

```r
fit_grid <- rbcc_opt(
  X, UC, C,
  optimizer = "grid",
  parallel = FALSE,
  control = rbcc_control(grid_size = 401)
)
```

For sufficiently large grid problems, evaluation can be distributed across
workers:

```r
fit_parallel <- rbcc_opt(
  X, UC, C,
  optimizer = "grid",
  parallel = TRUE,
  workers = 2,
  control = rbcc_control(grid_size = 2001)
)
```

Parallel startup and data-transfer overhead can dominate small problems; the
exact optimizer remains the recommended default for scalar empirical limits.

See `citation("rbcc")` for the methodological publications.
