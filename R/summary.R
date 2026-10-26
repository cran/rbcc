# Summary methods ------------------------------------------------------------

#' Summarize Risk-Based Control-Chart Objects
#' @param object A fitted risk-based chart object.
#' @param ... Reserved for future use.
#' @return A structured summary object retaining all original components.
#' @name summary-rbcc
NULL

#' @rdname summary-rbcc
#' @export
summary.rbcc <- function(object, ...) {
  output <- object
  output$statistics_summary <- rbind(
    true = summary(object$real),
    observed = summary(object$Observed)
  )
  class(output) <- c("summary.rbcc", "rbcc_summary", "list")
  output
}

#' @rdname summary-rbcc
#' @export
summary.rbcusumcc <- function(object, ...) {
  output <- object
  output$statistics_summary <- rbind(
    true = summary(object$cusumx),
    observed = summary(object$cusumy)
  )
  class(output) <- c("summary.rbcusumcc", "rbcc_summary", "list")
  output
}

#' @rdname summary-rbcc
#' @export
summary.rbmcc <- function(object, ...) {
  output <- object
  output$statistics_summary <- rbind(
    true = summary(object$real),
    observed = summary(object$Observed)
  )
  class(output) <- c("summary.rbmcc", "rbcc_summary", "list")
  output
}
