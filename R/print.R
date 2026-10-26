# Print methods --------------------------------------------------------------

.rbcc_print_costs <- function(x, digits) {
  costs <- data.frame(
    outcome = c("Correct acceptance (c11)", "Type I error (c10)",
                "Type II error (c01)", "Correct control (c00)"),
    count = unname(x$decision_counts),
    aggregate_cost = unname(x$cost_components),
    check.names = FALSE
  )
  print(costs, row.names = FALSE, digits = digits)
  cat("Total decision cost:", format(x$cost0, digits = digits), "\n")
}

.rbcc_print_statistics <- function(real, observed, digits) {
  statistics <- rbind(
    true = c(Min. = min(real), Mean = mean(real), Max. = max(real)),
    observed = c(Min. = min(observed), Mean = mean(observed), Max. = max(observed))
  )
  print(statistics, digits = digits)
}

#' Print Risk-Based Control-Chart Objects
#' @param x A fitted or summarized chart object.
#' @param digits Number of significant digits.
#' @param ... Additional print arguments.
#' @return The input object, invisibly.
#' @name print-rbcc
NULL

#' @rdname print-rbcc
#' @export
print.rbcc <- function(x, digits = getOption("digits"), ...) {
  cat("\nRisk-based", toupper(x$chart), "control chart\n")
  cat(strrep("-", 42), "\n", sep = "")
  .rbcc_print_costs(x, digits)
  cat("\nTraditional limits:", format(range(x$LCLx, x$UCLx), digits = digits), "\n")
  cat("Risk-based limits:", format(range(x$LCLy, x$UCLy), digits = digits), "\n")
  if (!is.null(x$par)) cat("Optimal coefficient:", format(x$par, digits = digits), "\n")
  cat("\nStatistic summary:\n")
  .rbcc_print_statistics(x$real, x$Observed, digits)
  invisible(x)
}

#' @rdname print-rbcc
#' @export
print.rbcusumcc <- function(x, digits = getOption("digits"), ...) {
  cat("\nRisk-based CUSUM control chart\n")
  cat(strrep("-", 42), "\n", sep = "")
  .rbcc_print_costs(x, digits)
  cat("\nTraditional decision interval:", format(x$UCLx, digits = digits), "\n")
  cat("Risk-based decision interval:", format(x$UCLy, digits = digits), "\n")
  if (!is.null(x$par)) cat("Optimal coefficient:", format(x$par, digits = digits), "\n")
  cat("\nCUSUM input-statistic summary:\n")
  .rbcc_print_statistics(x$cusumx, x$cusumy, digits)
  invisible(x)
}

#' @rdname print-rbcc
#' @export
print.rbmcc <- function(x, digits = getOption("digits"), ...) {
  cat("\nRisk-based multivariate T-squared control chart\n")
  cat(strrep("-", 50), "\n", sep = "")
  .rbcc_print_costs(x, digits)
  cat("\nTraditional UCL:", format(x$baselimit, digits = digits), "\n")
  cat("Risk-based UCL:", format(x$limit, digits = digits), "\n")
  if (!is.null(x$Kopt)) cat("Optimal correction:", format(x$Kopt, digits = digits), "\n")
  cat("\nT-squared statistic summary:\n")
  .rbcc_print_statistics(x$real, x$Observed, digits)
  invisible(x)
}

#' @rdname print-rbcc
#' @export
print.summary.rbcc <- function(x, digits = getOption("digits"), ...) print.rbcc(x, digits = digits, ...)

#' @rdname print-rbcc
#' @export
print.summary.rbcusumcc <- function(x, digits = getOption("digits"), ...) print.rbcusumcc(x, digits = digits, ...)

#' @rdname print-rbcc
#' @export
print.summary.rbmcc <- function(x, digits = getOption("digits"), ...) print.rbmcc(x, digits = digits, ...)
