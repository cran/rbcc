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
rbcusumcc <- function(X, UC, C, n=1,T=5, se.shift=1, K=0)
{
  if (!requireNamespace("qcc", quietly = TRUE)) {
    stop(
      "Package \"qcc\" must be installed to use this function.",
      call. = FALSE
    )
  }

   if(missing(T))
  {T <- 5.0}
  if(missing(K))
  {K <- 0}
  if(missing(se.shift))
  {se.shift <- 1 }
  if(missing(n))
  {n <- 1 }
  n_int <- n*(floor(length(X)/n))
  X <- X[1:n_int]
  UC <- UC[1:n_int]
  x <- matrix(X,ncol=n) #  Data with subgroups
  qx <- qcc::cusum(x,decison.interval=T, se.shift = se.shift, plot = FALSE)
  cusumx <- qx$statistics        # real values of cusum statistic
  T1 <- - qx$decision.interval   # LCL of cusum chart
  T2 <- qx$decision.interval     # UCL of cusum chart
  realu <- qx$pos                  # LCL of cusum chart
  reall <- qx$neg                  # UCL of cusum chart

  Y <- X+UC                      # measurement error data matrix
  y <- matrix(Y,ncol=n)
  qy <- qcc::cusum(y,decison.interval=T, se.shift = se.shift, plot = FALSE)
 cusumy <- qy$statistics     #  observed cusum with measurement errors
 T3 <- T1                    # set lower control limit based on observed cusum
 T4 <- T2                    # set upper control limit based on observed cusum
 obsu <- qy$pos              # Increased shift values of cusum statistics
 obsl <- qy$neg              # Decreased shift values of cusum statistics

  # -----------------calculation of costs and define cases (boolean)-----------
  P1 <- (T1 < reall|realu < T2 & T3+K< obsl | obsu<T4-K)*1  # correct acceptance
  P2 <- (T2 < realu|reall < T1 & T3+K< obsl | obsu<T4-K)*1 # type I error
  P3 <- (T1 < reall|realu < T2 & T4-K< obsu| obsl<T3+K)*1 # type II error
  P4 <- (T2 < realu|reall < T1 & T4-K< obsu| obsl<T3+K)*1 # correct rejecting
  C0 <- sum(P1)*C[1]+sum(P2)*C[2]+sum(P3)*C[3]+sum(P4)*C[4] # calculation of total cost during the process
  C1 <- sum(P1)*C[1]    # total cost related to decision 1 (c11)
  C2 <- sum(P2)*C[2]    # total cost related to decision 2 (c10)
  C3 <- sum(P3)*C[3]    # total cost related to decision 3 (c01)
  C4 <- sum(P4)*C[4]    # total cost related to decision 4 (c00)
  output <- list(cost0=C0, cost1= C1, cost2= C2, cost3= C3, cost4= C4, LCLx=T1, UCLx=T2, LCLy=T3+K, UCLy=T4-K, cusumx=cusumx, cusumy=cusumy, reall=reall,realu=realu,obsl=obsl,obsu=obsu)
  class(output) <- "rbcusumcc"
  return(output)
}

