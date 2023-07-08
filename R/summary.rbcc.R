#-----------------------------------------------------------------------------#
#                                                                             #
#  RISK-BASED MULTIVARIATE CONTROL CHARTS                                     #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: March 2022                                                   #
#-----------------------------------------------------------------------------#
#' @export
summary.rbcc <- function(object, digits =  getOption("digits"), ...) {
  if (!requireNamespace("qcc", quietly = TRUE)) {
    stop(
      "Package \"qcc\" must be installed to use this function.",
      call. = FALSE
    )
  }
  if ("rbcc" %in% class(object)){
    real <- object$real
    Observed <- object$Observed
    cost0 <- object$cost0 # calculation of total cost during the process
    cost1 <- object$cost1 # total cost related to decision 1 (c11)
    cost2 <- object$cost2 # total cost related to decision 2 (c10)
    cost3 <- object$cost3 # total cost related to decision 3 (c01)
    cost4 <- object$cost4 # total cost related to decision 4 (c00)
    LCLx <- object$LCLx
    UCLx <- object$UCLx
    LCLy <- object$LCLy
    UCLy <- object$UCLy
    Kopt <- object$Kopt

    cat("\nSummary of the cost structure:\n")
    cat("\nTotal cost: ",cost0)
    cat("\nc11: ",cost1)
    cat("\nc10: ",cost2)
    cat("\nc01: ",cost3)
    cat("\nc00: ",cost4)
    cat("\n\nSummary of control limits:\n")
    cat("\nLCL for traditional Univariate chart: ",LCLx)
    cat("\nUCL for traditional Univariate chart: ",UCLx)
    cat("\nLCL for risk-based univariate chart: ",LCLy)
    cat("\nUCL for risk-nbased univariate chart: ",UCLy)
    if (!is.null(Kopt)){
      cat("\n\nOptimal correction factor",Kopt)
    }
    cat("\n\nSummary of group statistics of real values:\n")
    print(summary(real), digits = digits, ...)
    cat("\n\nSummary of group statistics of observed values:\n")
    print(summary(Observed), digits = digits, ...)
  }else{
    summary(object,...)
  }
}
#' @export
summary.rbcusumcc <- function(object, digits =  getOption("digits"), ...) {
  if (!requireNamespace("qcc", quietly = TRUE)) {
    stop(
      "Package \"qcc\" must be installed to use this function.",
      call. = FALSE
    )
  }
  if ("rbcusumcc" %in% class(object)){
    real <- object$cusumx
    Observed <- object$cusumy
    cost0 <- object$cost0 # calculation of total cost during the process
    cost1 <- object$cost1 # total cost related to decision 1 (c11)
    cost2 <- object$cost2 # total cost related to decision 2 (c10)
    cost3 <- object$cost3 # total cost related to decision 3 (c01)
    cost4 <- object$cost4 # total cost related to decision 4 (c00)
    LCLx <- object$LCLx
    UCLx <- object$UCLx
    LCLy <- object$LCLy
    UCLy <- object$UCLy
    Kopt <- object$Kopt

    cat("\nSummary of the cost structure:\n")
    cat("\nTotal cost: ",cost0)
    cat("\nc11: ",cost1)
    cat("\nc10: ",cost2)
    cat("\nc01: ",cost3)
    cat("\nc00: ",cost4)
    cat("\n\nSummary of Decision Bound:\n")
    cat("\nDecision Interval for traditional CUSUM chart: ",UCLx)
    # cat("\nUCL for traditional CUSUM chart: ",UCLx)
    #cat("\nLCL for risk-based CUSUM chart: ",LCLy)
    cat("\nDecision Interval for risk-based CUSUM chart: ",UCLy)
    if (!is.null(Kopt)){
      cat("\n\nOptimal correction factor",Kopt)
    }
    cat("\n\nSummary of group statistics of real values:\n")
    print(summary(real), digits = digits, ...)
    cat("\n\nSummary of group statistics of observed values:\n")
    print(summary(Observed), digits = digits, ...)
  }else{
    summary(object,...)
  }
}

#' @export
summary.rbmcc <- function(object, digits =  getOption("digits"), ...) {
  if (!requireNamespace("qcc", quietly = TRUE)) {
    stop(
      "Package \"qcc\" must be installed to use this function.",
      call. = FALSE
    )
  }
  if ("rbmcc" %in% class(object)){
    real <- object$real
    Observed <- object$Observed
    cost0 <- object$cost0 # calculation of total cost during the process
    cost1 <- object$cost1 # total cost related to decision 1 (c11)
    cost2 <- object$cost2 # total cost related to decision 2 (c10)
    cost3 <- object$cost3 # total cost related to decision 3 (c01)
    cost4 <- object$cost4 # total cost related to decision 4 (c00)
    UCLT2 <- object$baselimit
    UCLRBT2 <- object$limit
    Kopt <- object$Kopt
    #chartx <- object$cchartx
    #charty <- object$ccharty
    #class(chartx)<-"mqcc"
    #class(charty)<-"mqcc"
    cat("\nSummary of the cost structure:\n")
    cat("\nTotal cost: ",cost0)
    cat("\nc11: ",cost1)
    cat("\nc10: ",cost2)
    cat("\nc01: ",cost3)
    cat("\nc00: ",cost4)
    cat("\n\nSummary of control limits:\n")
    cat("\nUCL for T2: ",UCLT2)
    cat("\nUCL for RBT2: ",UCLRBT2)
    if (!is.null(Kopt)){
      cat("\n\nOptimal correction factor",Kopt)
    }
    cat("\n\nSummary of group statistics of real values:\n")
    print(summary(real), digits = digits, ...)
    cat("\n\nSummary of group statistics of observed values:\n")
    print(summary(Observed), digits = digits, ...)
    #cat("\n\nSummary of original T2 chart:\n")
    #qcc::summary.mqcc(chartx)
    #cat("\n\nSummary of original RB-T2 chart:\n")
    #qcc::summary.mqcc(charty)
  }else{
    summary(object,...)
  }
}
