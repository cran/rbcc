library(rbcc)

check_error <- function(expr, pattern) {
  message <- tryCatch(
    {
      force(expr)
      ""
    },
    error = function(e) conditionMessage(e)
  )
  stopifnot(nzchar(message), grepl(pattern, message, fixed = TRUE))
  invisible(message)
}

# Data generation is reproducible and does not alter the caller's RNG state.
set.seed(99)
before <- .Random.seed
x1 <- data_gen(10, 0, 1, 0, 3, seed = 123)
after <- .Random.seed
x2 <- data_gen(10, 0, 1, 0, 3, seed = 123)
stopifnot(
  isTRUE(all.equal(x1, x2, check.attributes = TRUE)),
  identical(before, after),
  identical(dim(x1), c(10L, 1L))
)

# Paired inputs and decision costs are validated.
check_error(
  rbcc(1:5, 1:4, c(1, 1, 1, 1), n = 1),
  "same number of observations"
)
check_error(
  rbcc(1:5, rep(0, 5), c(1, 1, 1), n = 1),
  "length four"
)

# Non-finite observations are removed pairwise.
set.seed(1)
X <- rnorm(20)
UC <- rnorm(20, sd = 0.05)
X[2] <- NA_real_
UC[3] <- NA_real_
fit <- rbcc(X, UC, c(1, 5, 60, 5), n = 1)
stopifnot(
  fit$data_info$removed_nonfinite == 2,
  length(fit$real) == 18L
)

# Consecutive observations form subgroups.
X_grouped <- c(1, 3, 10, 14, 20, 26)
fit_grouped <- rbcc(
  X_grouped, rep(0, 6), c(1, 1, 1, 1), n = 2, type = "xbar"
)
stopifnot(isTRUE(all.equal(unname(fit_grouped$real), c(2, 12, 23))))

# Plot and summary assignments are silent; explicit printing writes output.
set.seed(2)
fit <- rbcc(
  rnorm(30), rnorm(30, sd = 0.05), c(1, 5, 60, 5), n = 1
)
plot_output <- capture.output(p <- plot(fit))
summary_output <- capture.output(s <- summary(fit))
print_output <- capture.output(print(fit))
summary_print_output <- capture.output(print(s))
stopifnot(
  length(plot_output) == 0L,
  inherits(p, "ggplot"),
  length(summary_output) == 0L,
  inherits(s, "summary.rbcc"),
  any(grepl("Total decision cost", print_output, fixed = TRUE)),
  any(grepl("Total decision cost", summary_print_output, fixed = TRUE))
)

# Exact optimization is no worse than either search endpoint.
set.seed(4)
X <- rnorm(80, 10, 0.5)
UC <- rnorm(80, 0, 0.05)
C <- c(1, 5, 60, 5)
fit_opt <- rbcc_opt(X, UC, C, n = 1, LKL = 0, UKL = 5)
lower <- rbcc(X, UC, C, n = 1, K = 0)
upper <- rbcc(X, UC, C, n = 1, K = 5)
stopifnot(
  fit_opt$cost0 <= min(lower$cost0, upper$cost0) +
    sqrt(.Machine$double.eps),
  identical(fit_opt$optimization$method, "exact threshold search")
)

# Memory-based charts return their documented classes.
set.seed(5)
X <- rnorm(50)
UC <- rnorm(50, sd = 0.05)
C <- c(1, 5, 60, 5)
stopifnot(
  inherits(rbmacc_opt(X, UC, C), "rbcc"),
  inherits(rbewmacc_opt(X, UC, C), "rbcc"),
  inherits(rbcusumcc_opt(X, UC, C), "rbcusumcc")
)

# The multivariate chart works with the package data.
data("t2uc")
X <- as.matrix(t2uc[, 1:2])
UC <- as.matrix(t2uc[, 5:6])
C <- c(1, 20, 160, 5)
multi <- rbmcc(X, UC, C, n = 1)
multi_opt <- rbmcc_opt(X, UC, C, n = 1)
stopifnot(
  inherits(multi, "rbmcc"),
  inherits(multi_opt, "rbmcc"),
  is.finite(multi$cost0),
  is.finite(multi_opt$cost0)
)
