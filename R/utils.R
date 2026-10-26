# Internal utilities ---------------------------------------------------------

`%||%` <- function(x, y) if (is.null(x)) y else x

.rbcc_abort <- function(message) stop(message, call. = FALSE)

.rbcc_assert_flag <- function(x, name) {
  if (!is.logical(x) || length(x) != 1L || is.na(x)) {
    .rbcc_abort(sprintf("`%s` must be TRUE or FALSE.", name))
  }
  invisible(x)
}

.rbcc_assert_scalar <- function(x, name, lower = -Inf, upper = Inf,
                                lower_inclusive = TRUE,
                                upper_inclusive = TRUE,
                                integer = FALSE) {
  if (!is.numeric(x) || length(x) != 1L || !is.finite(x)) {
    .rbcc_abort(sprintf("`%s` must be one finite numeric value.", name))
  }
  if (integer && x != floor(x)) {
    .rbcc_abort(sprintf("`%s` must be an integer.", name))
  }
  lower_ok <- if (lower_inclusive) x >= lower else x > lower
  upper_ok <- if (upper_inclusive) x <= upper else x < upper
  if (!lower_ok || !upper_ok) {
    left <- if (lower_inclusive) "[" else "("
    right <- if (upper_inclusive) "]" else ")"
    .rbcc_abort(sprintf("`%s` must lie in %s%s, %s%s.",
                        name, left, format(lower), format(upper), right))
  }
  invisible(x)
}

.rbcc_validate_costs <- function(C) {
  if (!is.numeric(C) || length(C) != 4L || any(!is.finite(C))) {
    .rbcc_abort(paste0(
      "`C` must be a finite numeric vector of length four: ",
      "c11, c10, c01, c00."
    ))
  }
  C <- as.numeric(C)
  names(C) <- c("c11", "c10", "c01", "c00")
  C
}

.rbcc_as_univariate <- function(x, name) {
  if (is.data.frame(x)) x <- as.matrix(x)
  if (is.matrix(x)) {
    if (ncol(x) != 1L) {
      .rbcc_abort(sprintf(
        "`%s` must be a vector or a one-column matrix for a univariate chart.",
        name
      ))
    }
    x <- x[, 1L]
  }
  if (!is.numeric(x)) .rbcc_abort(sprintf("`%s` must be numeric.", name))
  as.numeric(x)
}

.rbcc_prepare_univariate <- function(X, UC, n, validate = TRUE) {
  .rbcc_assert_flag(validate, "validate")
  .rbcc_assert_scalar(n, "n", lower = 1, integer = TRUE)
  x <- .rbcc_as_univariate(X, "X")
  uc <- .rbcc_as_univariate(UC, "UC")
  if (length(x) != length(uc)) {
    .rbcc_abort("`X` and `UC` must contain the same number of observations.")
  }
  keep <- is.finite(x) & is.finite(uc)
  removed <- sum(!keep)
  x <- x[keep]
  uc <- uc[keep]
  if (!length(x)) {
    .rbcc_abort("No paired finite observations remain after removing missing values.")
  }
  groups <- length(x) %/% n
  if (groups < 1L) {
    .rbcc_abort("The available data are insufficient for one complete subgroup.")
  }
  used <- groups * n
  dropped <- length(x) - used
  x <- x[seq_len(used)]
  uc <- uc[seq_len(used)]
  y <- x + uc
  list(
    X = x, UC = uc, Y = y,
    xmat = matrix(x, nrow = groups, ncol = n, byrow = TRUE),
    ymat = matrix(y, nrow = groups, ncol = n, byrow = TRUE),
    n = as.integer(n), groups = groups,
    removed = removed, dropped = dropped
  )
}

.rbcc_prepare_multivariate <- function(X, UC, n, validate = TRUE) {
  .rbcc_assert_flag(validate, "validate")
  .rbcc_assert_scalar(n, "n", lower = 1, integer = TRUE)
  X <- as.matrix(X)
  UC <- as.matrix(UC)
  if (!is.numeric(X) || !is.numeric(UC)) {
    .rbcc_abort("`X` and `UC` must be numeric matrices.")
  }
  if (!identical(dim(X), dim(UC))) {
    .rbcc_abort("`X` and `UC` must have identical dimensions.")
  }
  if (ncol(X) < 2L) {
    .rbcc_abort("A multivariate chart requires at least two variables.")
  }
  keep <- apply(is.finite(X) & is.finite(UC), 1L, all)
  removed <- sum(!keep)
  X <- X[keep, , drop = FALSE]
  UC <- UC[keep, , drop = FALSE]
  if (!nrow(X)) {
    .rbcc_abort("No paired finite rows remain after removing missing values.")
  }
  groups <- nrow(X) %/% n
  if (groups < 1L) {
    .rbcc_abort("The available data are insufficient for one complete subgroup.")
  }
  used <- groups * n
  dropped <- nrow(X) - used
  X <- X[seq_len(used), , drop = FALSE]
  UC <- UC[seq_len(used), , drop = FALSE]
  Y <- X + UC
  split_variables <- function(z) {
    ans <- lapply(seq_len(ncol(z)), function(j) {
      matrix(z[, j], nrow = groups, ncol = n, byrow = TRUE)
    })
    names(ans) <- colnames(z) %||% paste0("V", seq_along(ans))
    ans
  }
  list(
    X = X, UC = UC, Y = Y,
    Dx = split_variables(X), Dy = split_variables(Y),
    n = as.integer(n), groups = groups, variables = ncol(X),
    removed = removed, dropped = dropped
  )
}

.rbcc_extract_limits <- function(limits, n) {
  if (is.null(limits)) {
    .rbcc_abort("The underlying control-chart routine did not return limits.")
  }
  if (is.null(dim(limits))) {
    limits <- as.numeric(limits)
    if (length(limits) != 2L) {
      .rbcc_abort("The underlying routine returned invalid control limits.")
    }
    lower <- rep(limits[1L], n)
    upper <- rep(limits[2L], n)
  } else {
    limits <- as.matrix(limits)
    if (ncol(limits) < 2L) {
      .rbcc_abort("The underlying routine returned invalid control limits.")
    }
    if (nrow(limits) == 1L) {
      lower <- rep(limits[1L, 1L], n)
      upper <- rep(limits[1L, 2L], n)
    } else if (nrow(limits) == n) {
      lower <- limits[, 1L]
      upper <- limits[, 2L]
    } else {
      lower <- rep_len(limits[, 1L], n)
      upper <- rep_len(limits[, 2L], n)
    }
  }
  list(lower = as.numeric(lower), upper = as.numeric(upper))
}

.rbcc_qcc <- function(expr, context) {
  tryCatch(expr, error = function(e) {
    .rbcc_abort(sprintf("Unable to compute %s: %s", context,
                        conditionMessage(e)))
  })
}

.rbcc_standardized_distance <- function(value, center, scale) {
  value <- as.numeric(value)
  center <- rep_len(as.numeric(center), length(value))
  scale <- rep_len(as.numeric(scale), length(value))
  difference <- abs(value - center)
  tolerance <- sqrt(.Machine$double.eps) * pmax(1, abs(center))
  out <- rep(Inf, length(value))
  positive <- is.finite(scale) & scale > 0
  out[positive] <- difference[positive] / scale[positive]
  out[!positive & difference <= tolerance] <- 0
  out
}

.rbcc_decisions <- function(real_in, observed_in, costs) {
  real_in <- as.logical(real_in)
  observed_in <- as.logical(observed_in)
  if (length(real_in) != length(observed_in) || anyNA(real_in) ||
      anyNA(observed_in)) {
    .rbcc_abort("Internal error while classifying decision outcomes.")
  }
  counts <- c(
    q11 = sum(real_in & observed_in),
    q10 = sum(real_in & !observed_in),
    q01 = sum(!real_in & observed_in),
    q00 = sum(!real_in & !observed_in)
  )
  components <- counts * unname(costs)
  names(components) <- names(costs)
  outcome <- rep("correct_control", length(real_in))
  outcome[real_in & observed_in] <- "correct_acceptance"
  outcome[real_in & !observed_in] <- "type_I_error"
  outcome[!real_in & observed_in] <- "type_II_error"
  list(
    counts = counts,
    components = components,
    total = sum(components),
    outcome = factor(
      outcome,
      levels = c("correct_acceptance", "type_I_error",
                 "type_II_error", "correct_control")
    )
  )
}

.rbcc_add_decisions <- function(output, decisions) {
  output$cost0 <- unname(decisions$total)
  output$cost1 <- unname(decisions$components[1L])
  output$cost2 <- unname(decisions$components[2L])
  output$cost3 <- unname(decisions$components[3L])
  output$cost4 <- unname(decisions$components[4L])
  output$q11 <- unname(decisions$counts[1L])
  output$q10 <- unname(decisions$counts[2L])
  output$q01 <- unname(decisions$counts[3L])
  output$q00 <- unname(decisions$counts[4L])
  output$decision_counts <- decisions$counts
  output$cost_components <- decisions$components
  output$decision <- decisions$outcome
  output
}

.rbcc_moving_average <- function(x, width) {
  x <- as.numeric(x)
  index <- seq_along(x)
  denominator <- pmin(index, width)
  cumulative <- c(0, cumsum(x))
  start <- pmax(0, index - width)
  (cumulative[index + 1L] - cumulative[start + 1L]) / denominator
}

.rbcc_cusum <- function(statistics, center, sigma, n, se_shift) {
  standard_error <- sigma / sqrt(n)
  if (!is.finite(standard_error) || standard_error <= 0) {
    .rbcc_abort("CUSUM construction requires positive process variation.")
  }
  centered <- as.numeric(statistics) - center
  reference <- (se_shift / 2) * standard_error
  pos_inc <- centered - reference
  neg_inc <- centered + reference
  positive <- numeric(length(centered))
  negative <- numeric(length(centered))
  positive[1L] <- max(0, pos_inc[1L])
  negative[1L] <- min(0, neg_inc[1L])
  if (length(centered) > 1L) {
    for (i in 2:length(centered)) {
      positive[i] <- max(0, positive[i - 1L] + pos_inc[i])
      negative[i] <- min(0, negative[i - 1L] + neg_inc[i])
    }
  }
  list(positive = positive, negative = negative)
}

.rbcc_data_info <- function(prepared) {
  list(
    groups = prepared$groups,
    sample_size = prepared$n,
    removed_nonfinite = prepared$removed,
    dropped_incomplete_group = prepared$dropped
  )
}
