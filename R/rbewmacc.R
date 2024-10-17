#-----------------------------------------------------------------------------#
#                                                                             #
#  RISK-BASED CONTROL CHARTS                                     #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: March 2023                                                   #
#-----------------------------------------------------------------------------#

#' @export
rbewmacc <- function(X, UC, C, n=1, lambada=0.20, nsigmas=3, K=3)
{
  if (!requireNamespace("qcc", quietly = TRUE)) {
    stop(
      "Package \"qcc\" must be installed to use this function.",
      call. = FALSE
    )
  }

  if(missing(n))
  {n <- 1}
  if(missing(lambada))
  {confidence_level <- 0.20 }
  if(missing(nsigmas))
  {nsigmas <- 3 }
  if(missing(K))
  {K <- 3}
  n_int <- n*(floor(length(X)/n))
  X <- X[1:n_int]
  UC <- UC[1:n_int]
  xx <- matrix(X,ncol=n) #  Data with subgroups
  qx <- qcc::ewma(xx,sizes = n,lambda=lambada, nsigmas=nsigmas, plot = FALSE)
  ewmax <- qx$statistics          # real values of ewma statistic
  LCL=qx$center -nsigmas*(qx$sigma)
  UCL=qx$center +nsigmas*(qx$sigma)
  T1 <- LCL[length(qx$statistics)]    #qx$limits[length(qx$statistics)]             # LCL of ewma chart
  T2 <- UCL [length(qx$statistics)]  #qx$limits[length(qx$statistics),2]             # UCL of ewma chart

  Y <- X+UC                      # measurement error data matrix
  y <- matrix(Y,ncol=n)
  qy <- qcc::ewma(y,sizes = n,lambda=lambada, nsigmas=nsigmas, plot = FALSE)
  ewmay <- qy$statistics     #  observed ewma with measurement errors
  ucl <-  qx$center +K*(qx$sigma)
  lcl <-  qx$center -K*(qx$sigma)
  T3 <- lcl[length(qx$statistics)]
  T4 <- ucl[length(qx$statistics)]                 # set upper control limit based on observed ewma
  # -----------------calculation of costs and define cases (boolean)-----------
  P1 <- ((T1 < ewmax & ewmax < T2) & (T3< ewmay & ewmay<T4))*1  # correct acceptance
  P2 <- ((T1 < ewmax & ewmax < T2) & (T4< ewmay | ewmay<T3))*1 # type I error
  P3 <- ((T2 < ewmax | ewmax < T1) & (T3< ewmay & ewmay<T4))*1 # type II error
  P4 <- ((T2 < ewmax | ewmax < T1) & (T4< ewmay | ewmay<T3))*1 # correct rejecting
  C0 <- sum(P1)*C[1]+sum(P2)*C[2]+sum(P3)*C[3]+sum(P4)*C[4] # calculation of total cost during the process
  C1 <- sum(P1)*C[1]    # total cost related to decision 1 (c11)
  C2 <- sum(P2)*C[2]    # total cost related to decision 2 (c10)
  C3 <- sum(P3)*C[3]    # total cost related to decision 3 (c01)
  C4 <- sum(P4)*C[4]    # total cost related to decision 4 (c00)
  output <- list(cost0=C0, cost1= C1, cost2= C2, cost3= C3, cost4= C4, LCLx=T1, UCLx=T2, LCLy=T3, UCLy=T4, real=ewmax, Observed= ewmay)
  class(output) <- "rbcc"
  return(output)
}

