# rbcc 0.2.0

`rbcc` implements risk-based statistical process control charts in the
presence of measurement uncertainty. The package evaluates all four possible
decision outcomes—correct acceptance, false control, missed control, and
correct control—and can optimize chart limits by minimizing their total cost.

## Available charts

* Shewhart X-bar, R, and S charts: `rbcc()` and `rbcc_opt()`
* Moving-average charts: `rbmacc()` and `rbmacc_opt()`
* EWMA charts: `rbewmacc()` and `rbewmacc_opt()`
* CUSUM charts: `rbcusumcc()` and `rbcusumcc_opt()`
* Multivariate Hotelling T-squared charts: `rbmcc()` and `rbmcc_opt()`

Version 0.2.0 substantially refactors the computational core. Optimization no
longer rebuilds a complete chart for every trial value. The default exact
threshold optimizer exploits the piecewise-constant structure of the decision
cost and is deterministic. Bounded numerical optimization and optional
parallel grid search remain available.

## Example

```r
library(rbcc)

set.seed(42)
X <- rnorm(80, mean = 10, sd = 0.5)
UC <- rnorm(80, mean = 0, sd = 0.05)
C <- c(1, 5, 60, 5)

fit <- rbcc_opt(X, UC, C, n = 1, type = "xbar")
print(fit)

s <- summary(fit)  # no console output
s$cost0

p <- plot(fit)     # no drawing during assignment
p                  # draws the ggplot object
```

## Optional parallel grid optimization

```r
fit_grid <- rbcc_opt(
  X, UC, C,
  optimizer = "grid",
  parallel = TRUE,
  workers = 2,
  control = rbcc_control(grid_size = 401)
)
```

See `citation("rbcc")` for the methodological publications.
