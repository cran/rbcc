#' Construct Optimization Controls
#'
#' @param grid_size Number of points used by the grid optimizer.
#' @param tol Positive numerical tolerance.
#' @return A list suitable for the `control` argument.
#' @export
rbcc_control <- function(grid_size = 201L,
                         tol = .Machine$double.eps^0.25) {
  .rbcc_assert_scalar(grid_size, "grid_size", lower = 3, integer = TRUE)
  .rbcc_assert_scalar(tol, "tol", lower = 0, lower_inclusive = FALSE)
  list(grid_size = as.integer(grid_size), tol = tol)
}

.rbcc_validate_bounds <- function(lower, upper) {
  .rbcc_assert_scalar(lower, "LKL")
  .rbcc_assert_scalar(upper, "UKL")
  if (lower >= upper) .rbcc_abort("`LKL` must be smaller than `UKL`.")
  invisible(c(lower, upper))
}

.rbcc_total_cost_threshold <- function(threshold, real_in, distance, costs) {
  observed_in <- distance <= threshold
  sum(ifelse(
    real_in,
    ifelse(observed_in, costs[1L], costs[2L]),
    ifelse(observed_in, costs[3L], costs[4L])
  ))
}

.rbcc_choose_minimum <- function(candidates, values, initial, tol) {
  best <- min(values)
  tolerance <- tol * max(1, abs(best))
  eligible <- which(values <= best + tolerance)
  ordering <- order(abs(candidates[eligible] - initial), candidates[eligible])
  chosen <- eligible[ordering[1L]]
  list(par = candidates[chosen], value = values[chosen])
}

.rbcc_exact_threshold <- function(real_in, distance, costs,
                                  lower, upper, initial, tol) {
  observed_at_lower <- distance <= lower
  value_at_lower <- sum(ifelse(
    real_in,
    ifelse(observed_at_lower, costs[1L], costs[2L]),
    ifelse(observed_at_lower, costs[3L], costs[4L])
  ))
  event <- is.finite(distance) & distance > lower & distance <= upper
  candidates <- lower
  values <- value_at_lower
  if (any(event)) {
    event_distance <- distance[event]
    event_delta <- ifelse(
      real_in[event],
      costs[1L] - costs[2L],
      costs[3L] - costs[4L]
    )
    ordering <- order(event_distance)
    event_distance <- event_distance[ordering]
    event_delta <- event_delta[ordering]
    runs <- rle(event_distance)
    ends <- cumsum(runs$lengths)
    starts <- c(1L, utils::head(ends, -1L) + 1L)
    grouped_delta <- vapply(seq_along(ends), function(i) {
      sum(event_delta[starts[i]:ends[i]])
    }, numeric(1L))
    candidates <- c(lower, event_distance[ends])
    values <- c(value_at_lower, value_at_lower + cumsum(grouped_delta))
  }
  extras <- c(initial, upper)
  extra_values <- vapply(extras, function(k) {
    .rbcc_total_cost_threshold(k, real_in, distance, costs)
  }, numeric(1L))
  candidates <- c(candidates, extras)
  values <- c(values, extra_values)
  best <- .rbcc_choose_minimum(candidates, values, initial, tol)
  c(best, list(
    method = "exact threshold search",
    evaluations = length(candidates),
    convergence = 0L
  ))
}

.rbcc_parallel_grid <- function(grid, objective, use_parallel, workers) {
  if (!use_parallel || length(grid) < 2L) {
    return(vapply(grid, objective, numeric(1L)))
  }
  available <- suppressWarnings(parallel::detectCores(logical = FALSE))
  if (!is.finite(available) || available < 1L) available <- 2L
  if (is.null(workers)) workers <- max(1L, as.integer(available) - 1L)
  .rbcc_assert_scalar(workers, "workers", lower = 1, integer = TRUE)
  workers <- min(as.integer(workers), length(grid))
  if (.Platform$OS.type == "windows") {
    cluster <- parallel::makePSOCKcluster(workers)
    on.exit(parallel::stopCluster(cluster), add = TRUE)
    values <- parallel::parLapply(cluster, grid, objective)
  } else {
    values <- parallel::mclapply(grid, objective, mc.cores = workers)
  }
  unlist(values, use.names = FALSE)
}

.rbcc_optimize_threshold <- function(real_in, distance, costs,
                                     lower, upper, initial,
                                     optimizer, use_parallel, workers,
                                     control) {
  .rbcc_validate_bounds(lower, upper)
  .rbcc_assert_scalar(initial, "K_init")
  .rbcc_assert_flag(use_parallel, "parallel")
  optimizer <- match.arg(optimizer[1L], c("exact", "optimize", "grid"))
  if (!is.list(control)) .rbcc_abort("`control` must be a list.")
  control <- utils::modifyList(rbcc_control(), control)
  control <- do.call(rbcc_control, control)
  initial <- min(max(initial, lower), upper)
  if (optimizer == "exact") {
    return(.rbcc_exact_threshold(
      real_in, distance, costs, lower, upper, initial, control$tol
    ))
  }
  objective <- function(k) {
    .rbcc_total_cost_threshold(k, real_in, distance, costs)
  }
  if (optimizer == "optimize") {
    result <- stats::optimize(
      objective, interval = c(lower, upper), tol = control$tol
    )
    candidates <- c(lower, result$minimum, upper)
    values <- vapply(candidates, objective, numeric(1L))
    best <- .rbcc_choose_minimum(candidates, values, initial, control$tol)
    return(c(best, list(
      method = "bounded optimize",
      evaluations = NA_integer_,
      convergence = 0L
    )))
  }
  grid <- seq(lower, upper, length.out = control$grid_size)
  values <- .rbcc_parallel_grid(grid, objective, use_parallel, workers)
  best <- .rbcc_choose_minimum(grid, values, initial, control$tol)
  c(best, list(
    method = if (use_parallel) "parallel grid search" else "grid search",
    evaluations = length(grid),
    convergence = 0L
  ))
}

#' rbcc: Risk-Based Control Charts
#'
#' Risk-based statistical process-control charts that explicitly account for
#' measurement uncertainty and asymmetric decision costs.
#'
#' @name rbcc-package
#' @aliases rbcc-package
#' @docType package
#' @keywords internal
NULL

#' Generate Data from the Pearson Distribution System
#'
#' @param obs Positive number of observations per variable.
#' @param mu Numeric vector of means.
#' @param va Numeric vector of variances.
#' @param sk Numeric vector of skewness coefficients.
#' @param ku Numeric vector of kurtosis coefficients.
#' @param seed Optional integer seed. The caller's random-number state is
#'   restored after generation.
#' @param engine Either `"auto"` or `"pearson"`.
#' @param validate Logical; validate inputs.
#' @return A numeric matrix with one column per variable.
#' @export
data_gen <- function(obs, mu, va, sk, ku, seed = NULL,
                     engine = c("auto", "pearson"), validate = TRUE) {
  engine <- match.arg(engine)
  .rbcc_assert_flag(validate, "validate")
  .rbcc_assert_scalar(obs, "obs", lower = 1, integer = TRUE)
  parameters <- list(mu = mu, va = va, sk = sk, ku = ku)
  if (!all(vapply(parameters, is.numeric, logical(1L)))) {
    .rbcc_abort("`mu`, `va`, `sk`, and `ku` must be numeric vectors.")
  }
  target <- max(vapply(parameters, length, integer(1L)))
  if (target < 1L) .rbcc_abort("At least one set of moments is required.")
  valid_lengths <- vapply(parameters, function(x) {
    length(x) %in% c(1L, target)
  }, logical(1L))
  if (!all(valid_lengths)) {
    .rbcc_abort("Moment vectors must have a common length or length one.")
  }
  parameters <- lapply(parameters, rep_len, length.out = target)
  if (any(!is.finite(unlist(parameters, use.names = FALSE)))) {
    .rbcc_abort("All moments must be finite.")
  }
  if (any(parameters$va < 0)) {
    .rbcc_abort("Variances in `va` must be nonnegative.")
  }
  if (!is.null(seed)) {
    .rbcc_assert_scalar(seed, "seed", lower = 0,
                        upper = .Machine$integer.max, integer = TRUE)
    seed_exists <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
    if (seed_exists) old_seed <- get(".Random.seed", envir = .GlobalEnv)
    on.exit({
      if (seed_exists) {
        assign(".Random.seed", old_seed, envir = .GlobalEnv)
      } else if (exists(".Random.seed", envir = .GlobalEnv,
                        inherits = FALSE)) {
        rm(".Random.seed", envir = .GlobalEnv)
      }
    }, add = TRUE)
    set.seed(as.integer(seed))
  }
  output <- vapply(seq_len(target), function(i) {
    normal_case <- isTRUE(all.equal(parameters$sk[i], 0)) &&
      isTRUE(all.equal(parameters$ku[i], 3))
    if (engine == "auto" && normal_case) {
      return(stats::rnorm(obs, mean = parameters$mu[i],
                          sd = sqrt(parameters$va[i])))
    }
    tryCatch(
      PearsonDS::rpearson(
        obs,
        moments = c(parameters$mu[i], parameters$va[i],
                    parameters$sk[i], parameters$ku[i])
      ),
      error = function(e) {
        .rbcc_abort(sprintf(
          "Pearson generation failed for variable %d: %s",
          i, conditionMessage(e)
        ))
      }
    )
  }, numeric(obs))
  if (target == 1L) output <- matrix(output, ncol = 1L)
  colnames(output) <- paste0("V", seq_len(target))
  output
}
