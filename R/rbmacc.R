.rbcc_prepare_ma <- function(X, UC, C, n, w, validate) {
  costs <- .rbcc_validate_costs(C)
  .rbcc_assert_scalar(w, "w", lower = 1, integer = TRUE)
  prepared <- .rbcc_prepare_univariate(X, UC, n, validate)
  qcc_type <- if (n == 1L) "xbar.one" else "xbar"
  qx <- .rbcc_qcc(
    qcc::qcc(prepared$xmat, type = qcc_type, plot = FALSE),
    "the process center and variation for the MA chart"
  )
  qy <- .rbcc_qcc(
    qcc::qcc(prepared$ymat, type = qcc_type, plot = FALSE),
    "the observed center and variation for the MA chart"
  )
  real <- .rbcc_moving_average(rowMeans(prepared$xmat), w)
  observed <- .rbcc_moving_average(rowMeans(prepared$ymat), w)
  span <- pmin(seq_along(real), w)
  base_center <- rep_len(as.numeric(qx$center)[1L], length(real))
  risk_center <- rep_len(as.numeric(qy$center)[1L], length(real))
  base_scale <- as.numeric(qx$std.dev)[1L] / sqrt(n * span)
  risk_scale <- as.numeric(qy$std.dev)[1L] / sqrt(n * span)
  list(
    costs = costs, real = real, observed = observed,
    base_lower = base_center - 3 * base_scale,
    base_upper = base_center + 3 * base_scale,
    risk_center = risk_center, risk_scale = risk_scale,
    data = prepared, w = as.integer(w)
  )
}

.rbcc_finish_ma <- function(prepared, K, call) {
  .rbcc_assert_scalar(K, "K", lower = 0)
  risk_lower <- prepared$risk_center - K * prepared$risk_scale
  risk_upper <- prepared$risk_center + K * prepared$risk_scale
  real_in <- prepared$real >= prepared$base_lower &
    prepared$real <= prepared$base_upper
  observed_in <- prepared$observed >= risk_lower &
    prepared$observed <= risk_upper
  decisions <- .rbcc_decisions(real_in, observed_in, prepared$costs)
  output <- list(
    call = call, chart = "ma", sample_size = prepared$data$n,
    w = prepared$w, K = K,
    LCLx = prepared$base_lower, UCLx = prepared$base_upper,
    LCLy = risk_lower, UCLy = risk_upper,
    real = prepared$real, Observed = prepared$observed,
    data_info = .rbcc_data_info(prepared$data)
  )
  output <- .rbcc_add_decisions(output, decisions)
  class(output) <- "rbcc"
  output
}

#' Risk-Based Moving-Average Control Chart
#' @inheritParams rbcc
#' @param w Positive moving-average span.
#' @export
rbmacc <- function(X, UC, C, n = 1, w = 2, K = 3,
                   validate = TRUE) {
  if (missing(X)) .rbcc_abort("`X` is required.")
  if (missing(UC)) .rbcc_abort("`UC` is required.")
  if (missing(C)) .rbcc_abort("`C` is required.")
  prepared <- .rbcc_prepare_ma(X, UC, C, n, w, validate)
  .rbcc_finish_ma(prepared, K, match.call())
}

#' Optimize a Risk-Based Moving-Average Control Chart
#' @inheritParams rbcc_opt
#' @inheritParams rbmacc
#' @export
rbmacc_opt <- function(X, UC, C, n = 1, w = 2,
                       K_init = 0, LKL = 0, UKL = 5,
                       optimizer = c("exact", "optimize", "grid"),
                       parallel = FALSE, workers = NULL,
                       control = list(), validate = TRUE) {
  if (missing(X)) .rbcc_abort("`X` is required.")
  if (missing(UC)) .rbcc_abort("`UC` is required.")
  if (missing(C)) .rbcc_abort("`C` is required.")
  prepared <- .rbcc_prepare_ma(X, UC, C, n, w, validate)
  distance <- .rbcc_standardized_distance(
    prepared$observed, prepared$risk_center, prepared$risk_scale
  )
  real_in <- prepared$real >= prepared$base_lower &
    prepared$real <= prepared$base_upper
  optimization <- .rbcc_optimize_threshold(
    real_in, distance, prepared$costs,
    LKL, UKL, K_init, optimizer, parallel, workers, control
  )
  output <- .rbcc_finish_ma(prepared, optimization$par, match.call())
  output$par <- optimization$par
  output$Kopt <- optimization$par
  output$optimization <- optimization
  output
}
