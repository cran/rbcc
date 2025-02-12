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
print.rbcusumcc <- function(x, digits =  getOption("digits"), ...)
{
   if (methods::is(x,"rbcusumcc")){
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
  }
}
