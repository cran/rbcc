# Multivariate risk-based chart ---------------------------------------------

.rbcc_prepare_multivariate_chart <- function(X, UC, C, n,
                                              confidence_level, validate) {
  costs <- .rbcc_validate_costs(C)
  .rbcc_assert_scalar(confidence_level, "confidence_level",
                      lower = 0, upper = 1,
                      lower_inclusive = FALSE,
                      upper_inclusive = FALSE)
  prepared <- .rbcc_prepare_multivariate(X, UC, n, validate)
  qx <- .rbcc_qcc(
    qcc::mqcc(prepared$Dx, type = "T2",
              confidence.level = confidence_level, plot = FALSE),
    paste0(
      "the traditional Hotelling T-squared chart. Ensure that the ",
      "covariance matrix is nonsingular and enough groups are available"
    )
  )
  qy <- .rbcc_qcc(
    qcc::mqcc(prepared$Dy, type = "T2",
              confidence.level = confidence_level, plot = FALSE),
    "the observed Hotelling T-squared statistics"
  )
  limits <- qx$limits
  if (is.null(dim(limits))) {
    base_limit <- max(as.numeric(limits), na.rm = TRUE)
  } else {
    limits <- as.matrix(limits)
    base_limit <- as.numeric(limits[1L, ncol(limits)])
  }
  if (!is.finite(base_limit)) {
    .rbcc_abort("The multivariate chart returned an invalid upper limit.")
  }
  list(
    costs = costs, real = as.numeric(qx$statistics),
    observed = as.numeric(qy$statistics),
    base_limit = base_limit, data = prepared,
    confidence_level = confidence_level
  )
}

.rbcc_finish_multivariate <- function(prepared, K, call) {
  .rbcc_assert_scalar(K, "K")
  risk_limit <- prepared$base_limit - K
  real_in <- prepared$real <= prepared$base_limit
  observed_in <- prepared$observed <= risk_limit
  decisions <- .rbcc_decisions(real_in, observed_in, prepared$costs)
  output <- list(
    call = call, chart = "T2", sample_size = prepared$data$n,
    variables = prepared$data$variables,
    confidence_level = prepared$confidence_level, K = K,
    baselimit = prepared$base_limit, limit = risk_limit,
    real = prepared$real, Observed = prepared$observed,
    data_info = .rbcc_data_info(prepared$data)
  )
  output <- .rbcc_add_decisions(output, decisions)
  class(output) <- "rbmcc"
  output
}

#' Risk-Based Multivariate T-Squared Control Chart
#' @param X Numeric matrix of true process characteristics.
#' @param UC Numeric matrix of additive measurement errors.
#' @param C Four decision costs ordered as `c11`, `c10`, `c01`, `c00`.
#' @param n Subgroup size.
#' @param confidence_level Traditional-chart confidence level.
#' @param K Correction subtracted from the traditional upper control limit.
#' @param validate Logical; validate inputs.
#' @return An object of class `rbmcc`.
#' @export
rbmcc <- function(X, UC, C, n = 1, confidence_level = 0.99,
                  K = 0, validate = TRUE) {
  if (missing(X)) .rbcc_abort("`X` is required.")
  if (missing(UC)) .rbcc_abort("`UC` is required.")
  if (missing(C)) .rbcc_abort("`C` is required.")
  prepared <- .rbcc_prepare_multivariate_chart(
    X, UC, C, n, confidence_level, validate
  )
  .rbcc_finish_multivariate(prepared, K, match.call())
}

#' Optimize a Risk-Based Multivariate T-Squared Control Chart
#' @inheritParams rbmcc
#' @param K_init Initial or tie-breaking correction.
#' @param LKL,UKL Lower and upper correction bounds.
#' @param optimizer One of `"exact"`, `"optimize"`, or `"grid"`.
#' @param parallel Logical; parallelize the grid optimizer.
#' @param workers Optional worker count.
#' @param control A list created by `rbcc_control()`.
#' @return An optimized `rbmcc` object.
#' @export
rbmcc_opt <- function(X, UC, C, n = 1, confidence_level = 0.99,
                      K_init = 0, LKL = -5, UKL = 5,
                      optimizer = c("exact", "optimize", "grid"),
                      parallel = FALSE, workers = NULL,
                      control = list(), validate = TRUE) {
  if (missing(X)) .rbcc_abort("`X` is required.")
  if (missing(UC)) .rbcc_abort("`UC` is required.")
  if (missing(C)) .rbcc_abort("`C` is required.")
  prepared <- .rbcc_prepare_multivariate_chart(
    X, UC, C, n, confidence_level, validate
  )
  .rbcc_validate_bounds(LKL, UKL)
  lower_limit <- prepared$base_limit - UKL
  upper_limit <- prepared$base_limit - LKL
  initial_limit <- prepared$base_limit - K_init
  real_in <- prepared$real <= prepared$base_limit
  limit_opt <- .rbcc_optimize_threshold(
    real_in, prepared$observed, prepared$costs,
    lower_limit, upper_limit, initial_limit,
    optimizer, parallel, workers, control
  )
  Kopt <- prepared$base_limit - limit_opt$par
  optimization <- limit_opt
  optimization$limit <- limit_opt$par
  optimization$par <- Kopt
  output <- .rbcc_finish_multivariate(prepared, Kopt, match.call())
  output$par <- Kopt
  output$Kopt <- Kopt
  output$optimization <- optimization
  output
}
