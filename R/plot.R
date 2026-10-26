# Plot methods ---------------------------------------------------------------

.rbcc_long_data <- function(series, labels) {
  n <- max(vapply(series, length, integer(1L)))
  data.frame(
    group = rep(seq_len(n), times = length(series)),
    value = unlist(lapply(series, rep_len, length.out = n), use.names = FALSE),
    series = factor(rep(labels, each = n), levels = labels)
  )
}

#' Plot Risk-Based Control Charts
#' @param x A fitted risk-based chart object.
#' @param title Optional title.
#' @param xlab,ylab Axis labels.
#' @param ... Reserved for future use.
#' @return A visible `ggplot` object.
#' @name plot-rbcc
NULL

#' @rdname plot-rbcc
#' @export
plot.rbcc <- function(x, title = NULL, xlab = "Group", ylab = "Chart statistic", ...) {
  if (!inherits(x, "rbcc")) .rbcc_abort("`x` must inherit from `rbcc`.")
  title <- title %||% switch(x$chart,
    xbar = "Risk-Based X-bar Control Chart",
    R = "Risk-Based R Control Chart",
    S = "Risk-Based S Control Chart",
    ma = "Risk-Based Moving-Average Control Chart",
    ewma = "Risk-Based EWMA Control Chart",
    "Risk-Based Univariate Control Chart")
  data <- .rbcc_long_data(
    list(x$real, x$Observed, x$LCLx, x$UCLx, x$LCLy, x$UCLy),
    c("True statistic", "Observed statistic", "Traditional LCL", "Traditional UCL", "Risk-based LCL", "Risk-based UCL"))
  ggplot2::ggplot(data, ggplot2::aes(x = group, y = value, color = series, linetype = series)) +
    ggplot2::geom_line(linewidth = 0.55, na.rm = TRUE) +
    ggplot2::labs(title = title, x = xlab, y = ylab, color = NULL, linetype = NULL) +
    ggplot2::theme_bw() + ggplot2::theme(legend.position = "bottom")
}

#' @rdname plot-rbcc
#' @export
plot.rbcusumcc <- function(x, title = NULL, xlab = "Group", ylab = "Cumulative sum", ...) {
  if (!inherits(x, "rbcusumcc")) .rbcc_abort("`x` must inherit from `rbcusumcc`.")
  data <- .rbcc_long_data(
    list(x$reall, x$realu, x$obsl, x$obsu, x$LCLx, x$UCLx, x$LCLy, x$UCLy),
    c("True negative CUSUM", "True positive CUSUM", "Observed negative CUSUM", "Observed positive CUSUM", "Traditional LCL", "Traditional UCL", "Risk-based LCL", "Risk-based UCL"))
  ggplot2::ggplot(data, ggplot2::aes(x = group, y = value, color = series, linetype = series)) +
    ggplot2::geom_line(linewidth = 0.55, na.rm = TRUE) +
    ggplot2::labs(title = title %||% "Risk-Based CUSUM Control Chart", x = xlab, y = ylab, color = NULL, linetype = NULL) +
    ggplot2::theme_bw() + ggplot2::theme(legend.position = "bottom")
}

#' @rdname plot-rbcc
#' @export
plot.rbmcc <- function(x, title = NULL, xlab = "Group", ylab = "T-squared statistic", ...) {
  if (!inherits(x, "rbmcc")) .rbcc_abort("`x` must inherit from `rbmcc`.")
  data <- .rbcc_long_data(
    list(x$real, x$Observed, x$baselimit, x$limit),
    c("True statistic", "Observed statistic", "Traditional UCL", "Risk-based UCL"))
  ggplot2::ggplot(data, ggplot2::aes(x = group, y = value, color = series, linetype = series)) +
    ggplot2::geom_line(linewidth = 0.55, na.rm = TRUE) +
    ggplot2::labs(title = title %||% "Risk-Based Multivariate T-Squared Control Chart", x = xlab, y = ylab, color = NULL, linetype = NULL) +
    ggplot2::theme_bw() + ggplot2::theme(legend.position = "bottom")
}
