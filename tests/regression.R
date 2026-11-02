library(rbcc)

# Exact threshold search agrees with exhaustive evaluation of every empirical
# X-bar event threshold. The objective is reconstructed independently from
# the package's prepared statistics.
set.seed(20261031)
n <- 4L
groups <- 48L
X <- c(
  rnorm(32L * n, mean = 10.0, sd = 0.45),
  rnorm(16L * n, mean = 10.8, sd = 0.45)
)
UC <- rnorm(groups * n, mean = 0, sd = 0.08)
C <- c(c11 = 1, c10 = 8, c01 = 70, c00 = 4)

prepare_shewhart <- getFromNamespace(".rbcc_prepare_shewhart", "rbcc")
standardized_distance <- getFromNamespace(
  ".rbcc_standardized_distance", "rbcc"
)
prepared <- prepare_shewhart(
  X, UC, C, n, "xbar", confidence_level = 0.9973, validate = TRUE
)
distance <- standardized_distance(
  prepared$observed, prepared$risk_center, prepared$risk_scale
)
real_in <- prepared$real >= prepared$base_lower &
  prepared$real <= prepared$base_upper
candidates <- sort(unique(c(
  0, 5, distance[is.finite(distance) & distance > 0 & distance <= 5]
)))
brute_cost <- vapply(candidates, function(k) {
  observed_in <- distance <= k
  sum(ifelse(
    real_in,
    ifelse(observed_in, prepared$costs[1L], prepared$costs[2L]),
    ifelse(observed_in, prepared$costs[3L], prepared$costs[4L])
  ))
}, numeric(1L))
exact_fit <- rbcc_opt(
  X, UC, C, n = n, type = "xbar",
  LKL = 0, UKL = 5, optimizer = "exact"
)
tolerance <- sqrt(.Machine$double.eps) * max(1, abs(min(brute_cost)))
stopifnot(
  abs(exact_fit$cost0 - min(brute_cost)) <= tolerance,
  identical(exact_fit$optimization$method, "exact threshold search")
)

# Sequential and parallel grid evaluation must select the same threshold and
# cost. One worker exercises the cross-platform parallel branch without making
# CRAN checks depend on multicore availability.
control <- rbcc_control(grid_size = 101L)
sequential_fit <- rbcc_opt(
  X, UC, C, n = n, type = "xbar",
  LKL = 0, UKL = 5,
  optimizer = "grid", parallel = FALSE,
  control = control
)
parallel_fit <- rbcc_opt(
  X, UC, C, n = n, type = "xbar",
  LKL = 0, UKL = 5,
  optimizer = "grid", parallel = TRUE, workers = 1L,
  control = control
)
stopifnot(
  isTRUE(all.equal(sequential_fit$Kopt, parallel_fit$Kopt,
                   tolerance = sqrt(.Machine$double.eps))),
  identical(sequential_fit$cost0, parallel_fit$cost0),
  identical(sequential_fit$optimization$method, "grid search"),
  identical(parallel_fit$optimization$method, "parallel grid search")
)

# An opt-in two-worker regression path is useful in CI and local release checks
# but is not required on constrained CRAN workers.
if (identical(tolower(Sys.getenv("RBCC_RUN_PARALLEL_TESTS")), "true")) {
  two_worker_fit <- rbcc_opt(
    X, UC, C, n = n, type = "xbar",
    LKL = 0, UKL = 5,
    optimizer = "grid", parallel = TRUE, workers = 2L,
    control = control
  )
  stopifnot(
    isTRUE(all.equal(sequential_fit$Kopt, two_worker_fit$Kopt,
                     tolerance = sqrt(.Machine$double.eps))),
    identical(sequential_fit$cost0, two_worker_fit$cost0)
  )
}
