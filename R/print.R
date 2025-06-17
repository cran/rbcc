#-----------------------------------------------------------------------------#
#                                                                             #
#               RISK-BASED CONTROL CHARTS                                     #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: January 2025                                                 #
#-----------------------------------------------------------------------------#

#' @export
print <- function(x, ...) {
  UseMethod("print", x)
}

#' @export
print.rbcc <- function(x,  digits =  getOption("digits"), ...)
{
  real <- x$real
  Observed <- x$Observed
  cost0 <- x$cost0 # calculation of total cost during the process
  cost1 <- x$cost1 # total cost related to decision 1 (c11)
  cost2 <- x$cost2 # total cost related to decision 2 (c10)
  cost3 <- x$cost3 # total cost related to decision 3 (c01)
  cost4 <- x$cost4 # total cost related to decision 4 (c00)
  LCLx <- x$LCLx
  UCLx <- x$UCLx
  LCLy <- x$LCLy
  UCLy <- x$UCLy
  Kopt <- x$par

  cat("\nPrint of the cost structure:\n")
  cat("\nTotal cost: ",cost0)
  cat("\nc11: ",cost1)
  cat("\nc10: ",cost2)
  cat("\nc01: ",cost3)
  cat("\nc00: ",cost4)
  cat("\n\nPrint of control limits:\n")
  cat("\nLCL for traditional univariate chart: ",LCLx)
  cat("\nUCL for traditional univariate chart: ",UCLx)
  cat("\nLCL for risk-based  univariate chart: ",LCLy)
  cat("\nUCL for risk-based univariate chart: ",UCLy)
  if (!is.null(Kopt)){
    cat("\n\nOptimal correction factor",Kopt)
  }
  cat("\n\nPrint of group statistics of real values:\n")
  print(real, digits = digits, ...)
  cat("\n\nPrint of group statistics of observed values:\n")
  print(Observed, digits = digits, ...)
  invisible(x)
}

#' @export
print.summary.rbcc <- function(x,  digits =  getOption("digits"), ...)
{
  real <- x$real
  Observed <- x$Observed
  cost0 <- x$cost0 # calculation of total cost during the process
  cost1 <- x$cost1 # total cost related to decision 1 (c11)
  cost2 <- x$cost2 # total cost related to decision 2 (c10)
  cost3 <- x$cost3 # total cost related to decision 3 (c01)
  cost4 <- x$cost4 # total cost related to decision 4 (c00)
  LCLx <- x$LCLx
  UCLx <- x$UCLx
  LCLy <- x$LCLy
  UCLy <- x$UCLy
  Kopt <- x$par

  cat("\nPrint of the cost structure:\n")
  cat("\nTotal cost: ",cost0)
  cat("\nc11: ",cost1)
  cat("\nc10: ",cost2)
  cat("\nc01: ",cost3)
  cat("\nc00: ",cost4)
  cat("\n\nPrint of control limits:\n")
  cat("\nLCL for traditional univariate chart: ",LCLx)
  cat("\nUCL for traditional univariate chart: ",UCLx)
  cat("\nLCL for risk-based  univariate chart: ",LCLy)
  cat("\nUCL for risk-based univariate chart: ",UCLy)
  if (!is.null(Kopt)){
    cat("\n\nOptimal correction factor",Kopt)
  }
  cat("\n\nPrint of group statistics of real values:\n")
  print(real, digits = digits, ...)
  cat("\n\nPrint of group statistics of observed values:\n")
  print(Observed, digits = digits, ...)
  invisible(x)
}


#' @export
print.rbcusumcc <- function(x, digits =  getOption("digits"), ...)
{
  real <- x$cusumx
  Observed <- x$cusumy
  cost0 <- x$cost0 # calculation of total cost during the process
  cost1 <- x$cost1 # total cost related to decision 1 (c11)
  cost2 <- x$cost2 # total cost related to decision 2 (c10)
  cost3 <- x$cost3 # total cost related to decision 3 (c01)
  cost4 <- x$cost4 # total cost related to decision 4 (c00)
  # LCLx <- x$LCLx
  UCLx <- x$UCLx
  #LCLy <- x$LCLy
  UCLy <- x$UCLy
  Kopt <- x$par
  cat("\nPrint of the cost structure:\n")
  cat("\nTotal cost: ",cost0)
  cat("\nc11: ",cost1)
  cat("\nc10: ",cost2)
  cat("\nc01: ",cost3)
  cat("\nc00: ",cost4)
  cat("\n\nPrint of Decision Bound:\n")
  cat("\nDecision Interval for traditional CUSUM chart: ",UCLx)
  cat("\nDecision Interval for risk-based CUSUM chart: ",UCLy)
  if (!is.null(Kopt)){
    cat("\n\nOptimal correction factor",Kopt)
  }
  cat("\n\nPrint of group statistics of real values:\n")
  print(real, digits = digits, ...)
  cat("\n\nPrint of group statistics of observed values:\n")
  print(Observed, digits = digits, ...)
  invisible(x)
}

#' @export
print.summary.rbcusumcc <- function(x, digits =  getOption("digits"), ...)
{
  real <- x$cusumx
  Observed <- x$cusumy
  cost0 <- x$cost0 # calculation of total cost during the process
  cost1 <- x$cost1 # total cost related to decision 1 (c11)
  cost2 <- x$cost2 # total cost related to decision 2 (c10)
  cost3 <- x$cost3 # total cost related to decision 3 (c01)
  cost4 <- x$cost4 # total cost related to decision 4 (c00)
  # LCLx <- x$LCLx
  UCLx <- x$UCLx
  #LCLy <- x$LCLy
  UCLy <- x$UCLy
  Kopt <- x$par
  cat("\nPrint of the cost structure:\n")
  cat("\nTotal cost: ",cost0)
  cat("\nc11: ",cost1)
  cat("\nc10: ",cost2)
  cat("\nc01: ",cost3)
  cat("\nc00: ",cost4)
  cat("\n\nPrint of Decision Bound:\n")
  cat("\nDecision Interval for traditional CUSUM chart: ",UCLx)
  cat("\nDecision Interval for risk-based CUSUM chart: ",UCLy)
  if (!is.null(Kopt)){
    cat("\n\nOptimal correction factor",Kopt)
  }
  cat("\n\nPrint of group statistics of real values:\n")
  print(real, digits = digits, ...)
  cat("\n\nPrint of group statistics of observed values:\n")
  print(Observed, digits = digits, ...)
  invisible(x)
}

#' @export
print.rbmcc <- function(x, digits =  getOption("digits"), ...)
{
  real <- x$real
  Observed <- x$Observed
  cost0 <- x$cost0 # calculation of total cost during the process
  cost1 <- x$cost1 # total cost related to decision 1 (c11)
  cost2 <- x$cost2 # total cost related to decision 2 (c10)
  cost3 <- x$cost3 # total cost related to decision 3 (c01)
  cost4 <- x$cost4 # total cost related to decision 4 (c00)
  UCLT2 <- x$baselimit
  UCLRBT2 <- x$limit
  Kopt <- x$Kopt
  cat("\nPrint of the cost structure:\n")
  cat("\nTotal cost: ",cost0)
  cat("\nc11: ",cost1)
  cat("\nc10: ",cost2)
  cat("\nc01: ",cost3)
  cat("\nc00: ",cost4)
  cat("\n\nPrint of control limits:\n")
  cat("\nUCL for T2: ",UCLT2)
  cat("\nUCL for RBT2: ",UCLRBT2)
  if (!is.null(Kopt)){
    cat("\n\nOptimal correction factor",Kopt)
  }
  cat("\n\nPrint of group statistics of real values:\n")
  print(real, digits = digits, ...)
  cat("\n\nPrint of group statistics of observed values:\n")
  print(Observed, digits = digits, ...)
  invisible(x)
}

#' @export
print.summary.rbmcc <- function(x, digits =  getOption("digits"), ...)
{
  real <- x$real
  Observed <- x$Observed
  cost0 <- x$cost0 # calculation of total cost during the process
  cost1 <- x$cost1 # total cost related to decision 1 (c11)
  cost2 <- x$cost2 # total cost related to decision 2 (c10)
  cost3 <- x$cost3 # total cost related to decision 3 (c01)
  cost4 <- x$cost4 # total cost related to decision 4 (c00)
  UCLT2 <- x$baselimit
  UCLRBT2 <- x$limit
  Kopt <- x$Kopt
  cat("\nPrint of the cost structure:\n")
  cat("\nTotal cost: ",cost0)
  cat("\nc11: ",cost1)
  cat("\nc10: ",cost2)
  cat("\nc01: ",cost3)
  cat("\nc00: ",cost4)
  cat("\n\nPrint of control limits:\n")
  cat("\nUCL for T2: ",UCLT2)
  cat("\nUCL for RBT2: ",UCLRBT2)
  if (!is.null(Kopt)){
    cat("\n\nOptimal correction factor",Kopt)
  }
  cat("\n\nPrint of group statistics of real values:\n")
  print(real, digits = digits, ...)
  cat("\n\nPrint of group statistics of observed values:\n")
  print(Observed, digits = digits, ...)
  invisible(x)
}











