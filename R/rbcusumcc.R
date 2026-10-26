.rbcc_prepare_cusum <- function(X, UC, C, n, T, se.shift, validate) {
  costs <- .rbcc_validate_costs(C)
  .rbcc_assert_scalar(T, "T", lower = 0, lower_inclusive = FALSE)
  .rbcc_assert_scalar(se.shift, "se.shift", lower = 0,
                      lower_inclusive = FALSE)
  prepared <- .rbcc_prepare_univariate(X, UC, n, validate)
  qcc_type <- if (n == 1L) "xbar.one" else "xbar"
  qx <- .rbcc_qcc(
    qcc::qcc(prepared$xmat, type = qcc_type, plot = FALSE),
    "the process center and variation for the CUSUM chart"
  )
  qy <- .rbcc_qcc(
    qcc::qcc(prepared$ymat, type = qcc_type, plot = FALSE),
    "the observed center and variation for the CUSUM chart"
  )
  statistics_x <- as.numeric(qx$statistics)
  statistics_y <- as.numeric(qy$statistics)
  sigma_x <- as.numeric(qx$std.dev)[1L]
  sigma_y <- as.numeric(qy$std.dev)[1L]
  real_cusum <- .rbcc_cusum(
    statistics_x, as.numeric(qx$center)[1L], sigma_x, n, se.shift
  )
  observed_cusum <- .rbcc_cusum(
    statistics_y, as.numeric(qy$center)[1L], sigma_y, n, se.shift
  )
  list(
    costs = costs, statistics_x = statistics_x,
    statistics_y = statistics_y,
    real_positive = real_cusum$positive,
    real_negative = real_cusum$negative,
    observed_positive = observed_cusum$positive,
    observed_negative = observed_cusum$negative,
    sigma = sigma_x, data = prepared, T = T, se.shift = se.shift
  )
}

.rbcc_finish_cusum <- function(prepared, K, call) {
  .rbcc_assert_scalar(K, "K", lower = 0)
  base_lower <- -prepared$T * prepared$sigma
  base_upper <- prepared$T * prepared$sigma
  risk_lower <- -K * prepared$sigma
  risk_upper <- K * prepared$sigma
  real_in <- prepared$real_negative >= base_lower &
    prepared$real_positive <= base_upper
  observed_in <- prepared$observed_negative >= risk_lower &
    prepared$observed_positive <= risk_upper
  decisions <- .rbcc_decisions(real_in, observed_in, prepared$costs)
  output <- list(
    call = call, chart = "cusum", sample_size = prepared$data$n,
    T = prepared$T, se.shift = prepared$se.shift, K = K,
    LCLx = base_lower, UCLx = base_upper,
    LCLy = risk_lower, UCLy = risk_upper,
    cusumx = prepared$statistics_x, cusumy = prepared$statistics_y,
    reall = prepared$real_negative, realu = prepared$real_positive,
    obsl = prepared$observed_negative, obsu = prepared$observed_positive,
    data_info = .rbcc_data_info(prepared$data)
  )
  output <- .rbcc_add_decisions(output, decisions)
  class(output) <- "rbcusumcc"
  output
}

#' Risk-Based CUSUM Control Chart
#' @inheritParams rbcc
#' @param T Positive traditional decision-interval coefficient.
#' @param se.shift Positive standardized reference shift.
#' @export
rbcusumcc <- function(X, UC, C, n = 1, T = 5,
                      se.shift = 1, K = 5, validate = TRUE) {
  if (missing(X)) .rbcc_abort("`X` is required.")
  if (missing(UC)) .rbcc_abort("`UC` is required.")
  if (missing(C)) .rbcc_abort("`C` is required.")
  prepared <- .rbcc_prepare_cusum(X, UC, C, n, T, se.shift, validate)
  .rbcc_finish_cusum(prepared, K, match.call())
}

#' Optimize a Risk-Based CUSUM Control Chart
#' @inheritParams rbcc_opt
#' @inheritParams rbcusumcc
#' @export
rbcusumcc_opt <- function(X, UC, C, n = 1, T = 5,
                          se.shift = 1, K_init = 0,
                          LKL = 0, UKL = 6,
                          optimizer = c("exact", "optimize", "grid"),
                          parallel = FALSE, workers = NULL,
                          control = list(), validate = TRUE) {
  if (missing(X)) .rbcc_abort("`X` is required.")
  if (missing(UC)) .rbcc_abort("`UC` is required.")
  if (missing(C)) .rbcc_abort("`C` is required.")
  prepared <- .rbcc_prepare_cusum(X, UC, C, n, T, se.shift, validate)
  distance <- pmax(
    prepared$observed_positive,
    -prepared$observed_negative
  ) / prepared$sigma
  real_in <- prepared$real_negative >= -T * prepared$sigma &
    prepared$real_positive <= T * prepared$sigma
  optimization <- .rbcc_optimize_threshold(
    real_in, distance, prepared$costs,
    LKL, UKL, K_init, optimizer, parallel, workers, control
  )
  output <- .rbcc_finish_cusum(prepared, optimization$par, match.call())
  output$par <- optimization$par
  output$Kopt <- optimization$par
  output$optimization <- optimization
  output
}
