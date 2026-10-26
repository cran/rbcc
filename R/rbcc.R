# Univariate risk-based charts -----------------------------------------------

.rbcc_prepare_shewhart <- function(X, UC, C, n, type,
                                    confidence_level, validate) {
  costs <- .rbcc_validate_costs(C)
  type <- match.arg(type[1L], c("xbar", "R", "S"))
  .rbcc_assert_scalar(confidence_level, "confidence_level",
                      lower = 0, upper = 1,
                      lower_inclusive = FALSE,
                      upper_inclusive = FALSE)
  if (type %in% c("R", "S") && n < 2L) {
    .rbcc_abort(sprintf("An %s chart requires `n` to be at least two.", type))
  }
  prepared <- .rbcc_prepare_univariate(X, UC, n, validate)
  qcc_type <- if (type == "xbar" && n == 1L) "xbar.one" else type
  qx <- .rbcc_qcc(
    qcc::qcc(prepared$xmat, type = qcc_type,
             confidence.level = confidence_level, plot = FALSE),
    sprintf("the traditional %s chart", type)
  )
  qy <- .rbcc_qcc(
    qcc::qcc(prepared$ymat, type = qcc_type,
             confidence.level = confidence_level, plot = FALSE),
    sprintf("the observed %s statistics", type)
  )
  real <- as.numeric(qx$statistics)
  observed <- as.numeric(qy$statistics)
  limits <- .rbcc_extract_limits(qx$limits, length(real))
  if (type == "xbar") {
    risk_center <- rep_len(as.numeric(qx$center)[1L], length(real))
    risk_scale <- rep_len(as.numeric(qx$std.dev)[1L] / sqrt(n), length(real))
  } else {
    risk_center <- rep_len(mean(real), length(real))
    risk_scale <- rep_len(as.numeric(qx$std.dev)[1L], length(real))
  }
  list(
    costs = costs, type = type, real = real, observed = observed,
    base_lower = limits$lower, base_upper = limits$upper,
    risk_center = risk_center, risk_scale = risk_scale,
    data = prepared, confidence_level = confidence_level
  )
}

.rbcc_finish_shewhart <- function(prepared, K, call) {
  .rbcc_assert_scalar(K, "K", lower = 0)
  risk_lower <- prepared$risk_center - K * prepared$risk_scale
  if (prepared$type %in% c("R", "S")) risk_lower <- pmax(0, risk_lower)
  risk_upper <- prepared$risk_center + K * prepared$risk_scale
  real_in <- prepared$real >= prepared$base_lower &
    prepared$real <= prepared$base_upper
  observed_in <- prepared$observed >= risk_lower &
    prepared$observed <= risk_upper
  decisions <- .rbcc_decisions(real_in, observed_in, prepared$costs)
  output <- list(
    call = call, chart = prepared$type, sample_size = prepared$data$n,
    confidence_level = prepared$confidence_level, K = K,
    LCLx = prepared$base_lower, UCLx = prepared$base_upper,
    LCLy = risk_lower, UCLy = risk_upper,
    real = prepared$real, Observed = prepared$observed,
    data_info = .rbcc_data_info(prepared$data)
  )
  output <- .rbcc_add_decisions(output, decisions)
  class(output) <- "rbcc"
  output
}

#' Risk-Based Shewhart Control Chart
#' @param X Numeric process observations.
#' @param UC Numeric additive measurement errors.
#' @param C Four decision costs ordered as `c11`, `c10`, `c01`, `c00`.
#' @param n Subgroup size. Defaults to one when omitted.
#' @param type Chart type: `"xbar"`, `"R"`, or `"S"`.
#' @param confidence_level Traditional-chart confidence level.
#' @param K Nonnegative risk-based limit coefficient.
#' @param validate Logical; validate inputs.
#' @return An object of class `rbcc`.
#' @export
rbcc <- function(X, UC, C, n, type = c("xbar", "R", "S"),
                 confidence_level = 0.9973, K = 3, validate = TRUE) {
  if (missing(X)) .rbcc_abort("`X` is required.")
  if (missing(UC)) .rbcc_abort("`UC` is required.")
  if (missing(C)) .rbcc_abort("`C` is required.")
  if (missing(n)) n <- 1L
  prepared <- .rbcc_prepare_shewhart(
    X, UC, C, n, type, confidence_level, validate
  )
  .rbcc_finish_shewhart(prepared, K, match.call())
}

#' Optimize a Risk-Based Shewhart Control Chart
#' @inheritParams rbcc
#' @param K_init Initial or tie-breaking coefficient.
#' @param LKL,UKL Lower and upper search bounds.
#' @param optimizer One of `"exact"`, `"optimize"`, or `"grid"`.
#' @param parallel Logical; parallelize the grid optimizer.
#' @param workers Optional worker count.
#' @param control A list created by `rbcc_control()`.
#' @return An optimized `rbcc` object.
#' @export
rbcc_opt <- function(X, UC, C, n, type = c("xbar", "R", "S"),
                     confidence_level = 0.9973,
                     K_init = 0, LKL = 0, UKL = 5,
                     optimizer = c("exact", "optimize", "grid"),
                     parallel = FALSE, workers = NULL,
                     control = list(), validate = TRUE) {
  if (missing(X)) .rbcc_abort("`X` is required.")
  if (missing(UC)) .rbcc_abort("`UC` is required.")
  if (missing(C)) .rbcc_abort("`C` is required.")
  if (missing(n)) n <- 1L
  prepared <- .rbcc_prepare_shewhart(
    X, UC, C, n, type, confidence_level, validate
  )
  distance <- .rbcc_standardized_distance(
    prepared$observed, prepared$risk_center, prepared$risk_scale
  )
  real_in <- prepared$real >= prepared$base_lower &
    prepared$real <= prepared$base_upper
  optimization <- .rbcc_optimize_threshold(
    real_in, distance, prepared$costs,
    LKL, UKL, K_init, optimizer, parallel, workers, control
  )
  output <- .rbcc_finish_shewhart(prepared, optimization$par, match.call())
  output$par <- optimization$par
  output$Kopt <- optimization$par
  output$optimization <- optimization
  output
}
