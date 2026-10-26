.rbcc_prepare_ewma <- function(X, UC, C, n, lambada, nsigmas, validate) {
  costs <- .rbcc_validate_costs(C)
  .rbcc_assert_scalar(lambada, "lambada", lower = 0, upper = 1,
                      lower_inclusive = FALSE)
  .rbcc_assert_scalar(nsigmas, "nsigmas", lower = 0,
                      lower_inclusive = FALSE)
  prepared <- .rbcc_prepare_univariate(X, UC, n, validate)
  qx <- .rbcc_qcc(
    qcc::ewma(prepared$xmat, sizes = n, lambda = lambada,
              nsigmas = nsigmas, plot = FALSE),
    "the traditional EWMA chart"
  )
  qy <- .rbcc_qcc(
    qcc::ewma(prepared$ymat, sizes = n, lambda = lambada,
              nsigmas = nsigmas, plot = FALSE),
    "the observed EWMA statistics"
  )
  real <- as.numeric(qx$y)
  observed <- as.numeric(qy$y)
  base <- .rbcc_extract_limits(qx$limits, length(real))
  list(
    costs = costs, real = real, observed = observed,
    base_lower = base$lower, base_upper = base$upper,
    risk_center = rep_len(as.numeric(qy$center)[1L], length(observed)),
    risk_scale = rep_len(as.numeric(qy$sigma), length(observed)),
    data = prepared, lambada = lambada, nsigmas = nsigmas
  )
}

.rbcc_finish_ewma <- function(prepared, K, call) {
  .rbcc_assert_scalar(K, "K", lower = 0)
  risk_lower <- prepared$risk_center - K * prepared$risk_scale
  risk_upper <- prepared$risk_center + K * prepared$risk_scale
  real_in <- prepared$real >= prepared$base_lower &
    prepared$real <= prepared$base_upper
  observed_in <- prepared$observed >= risk_lower &
    prepared$observed <= risk_upper
  decisions <- .rbcc_decisions(real_in, observed_in, prepared$costs)
  output <- list(
    call = call, chart = "ewma", sample_size = prepared$data$n,
    lambada = prepared$lambada, lambda = prepared$lambada,
    nsigmas = prepared$nsigmas, K = K,
    LCLx = prepared$base_lower, UCLx = prepared$base_upper,
    LCLy = risk_lower, UCLy = risk_upper,
    real = prepared$real, Observed = prepared$observed,
    data_info = .rbcc_data_info(prepared$data)
  )
  output <- .rbcc_add_decisions(output, decisions)
  class(output) <- "rbcc"
  output
}

#' Risk-Based EWMA Control Chart
#' @inheritParams rbcc
#' @param lambada EWMA smoothing parameter; retained for compatibility.
#' @param nsigmas Traditional EWMA limit coefficient.
#' @param lambda Correctly spelled alias for `lambada`.
#' @export
rbewmacc <- function(X, UC, C, n = 1, lambada = 0.20,
                     nsigmas = 3, K = 3, lambda = NULL,
                     validate = TRUE) {
  if (missing(X)) .rbcc_abort("`X` is required.")
  if (missing(UC)) .rbcc_abort("`UC` is required.")
  if (missing(C)) .rbcc_abort("`C` is required.")
  if (!is.null(lambda)) {
    if (!missing(lambada) && !isTRUE(all.equal(lambada, lambda))) {
      warning("Both `lambada` and `lambda` were supplied; `lambda` is used.",
              call. = FALSE)
    }
    lambada <- lambda
  }
  prepared <- .rbcc_prepare_ewma(
    X, UC, C, n, lambada, nsigmas, validate
  )
  .rbcc_finish_ewma(prepared, K, match.call())
}

#' Optimize a Risk-Based EWMA Control Chart
#' @inheritParams rbcc_opt
#' @inheritParams rbewmacc
#' @export
rbewmacc_opt <- function(X, UC, C, n = 1, lambada = 0.20,
                         nsigmas = 3, K_init = 0,
                         LKL = 0, UKL = 5, lambda = NULL,
                         optimizer = c("exact", "optimize", "grid"),
                         parallel = FALSE, workers = NULL,
                         control = list(), validate = TRUE) {
  if (missing(X)) .rbcc_abort("`X` is required.")
  if (missing(UC)) .rbcc_abort("`UC` is required.")
  if (missing(C)) .rbcc_abort("`C` is required.")
  if (!is.null(lambda)) {
    if (!missing(lambada) && !isTRUE(all.equal(lambada, lambda))) {
      warning("Both `lambada` and `lambda` were supplied; `lambda` is used.",
              call. = FALSE)
    }
    lambada <- lambda
  }
  prepared <- .rbcc_prepare_ewma(
    X, UC, C, n, lambada, nsigmas, validate
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
  output <- .rbcc_finish_ewma(prepared, optimization$par, match.call())
  output$par <- optimization$par
  output$Kopt <- optimization$par
  output$optimization <- optimization
  output
}
