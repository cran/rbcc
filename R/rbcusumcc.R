#-----------------------------------------------------------------------------#
#                                                                             #
#                    RISK-BASED CONTROL CHARTS                                #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: September 2024                                               #
#-----------------------------------------------------------------------------#

#' @export
rbcusumcc <- function(X, UC, C, n=1,T= 5, se.shift=1,  K=5)
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
  {K <- 5}
  if(missing(se.shift))
  {se.shift <- 1 }
  if(missing(n))
  {n <- 1 }
  n_int <- n*(floor(length(X)/n))
  X <- X[1:n_int]
  UC <- UC[1:n_int]
  x <- matrix(X,ncol=n) #  Data with subgroups
  qx <- qcc::cusum(x, sizes=1, decision.interval =T, se.shift = se.shift, plot = FALSE)
  cusumx <- qx$statistics        # real values of cusum statistic
  z=(cusumx-qx$center)
  t=(se.shift/2)*qx$std.dev/sqrt(n)
  z.f <- z-t
  cusum.pos <- rep(NA,  n_int)
  cusum.pos[1] <- max(0,  z.f[1])
  for (i in 2:n_int)
    cusum.pos[i] <- max(0, cusum.pos[i-1]+z.f[i])
  z.f1 <- z+t
  cusum.neg <- rep(NA,  n_int)
  cusum.neg[1] <- min(0,  z.f1[1])
  for (i in 2:n_int)
    cusum.neg[i] <- min(0, cusum.neg[i-1]+z.f1[i])
  T1 <- - T*qx$std.dev  # LCL of cusum chart
  T2 <- T*qx$std.dev  # UCL of cusum chart
  realu <- cusum.pos                  # LCL of cusum chart
  reall <- cusum.neg               # UCL of cusum chart
    Y <- X+UC                      # measurement error data matrix
  y <- matrix(Y,ncol=n)
  qy <- qcc::cusum(y, sizes=1, decision.interval=T, se.shift = se.shift, plot = FALSE)
  cusumy <- qy$statistics     #  observed cusum with measurement errors
  z1=(cusumy-qy$center)
  t1=(se.shift/2)*qy$std.dev/sqrt(n)
  z.f11 <- z1-t1
  cusum.pos1 <- rep(NA,  n_int)
  cusum.pos1[1] <- max(0,  z.f11[1])
  for (i in 2:n_int)
    cusum.pos1[i] <- max(0, cusum.pos1[i-1]+z.f11[i])
  z.f12 <- z1+t1
  cusum.neg1 <- rep(NA,  n_int)
  cusum.neg1[1] <- min(0,  z.f12[1])
  for (i in 2:n_int)
    cusum.neg1[i] <- min(0, cusum.neg1[i-1]+z.f12[i])
  T3 <- - K*qx$std.dev  # set lower control limit based on observed cusum
  T4 <- K*qx$std.dev   # set upper control limit based on observed cusum
  obsu <-  cusum.pos1             # Increased shift values of cusum statistics
  obsl <- cusum.neg1              # Decreased shift values of cusum statistics
  
  # -----------------calculation of costs and define cases (boolean)-----------
  
  P1 <-  ((T1 < reall & realu < T2) & (T3< obsl & obsu<T4))*1  # correct acceptance 
  P2 <-  ((T1 < reall & realu < T2) & ( T4<obsu | obsl<T3))*1 # type I error
  P3 <-  ((T2 < realu | reall < T1) & ( T3< obsl & obsu<T4))*1  # type II error 
  P4 <- ((T2 < realu | reall < T1) & (T4< obsu | obsl<T3))*1 
  C0 <- sum(P1)*C[1]+sum(P2)*C[2]+sum(P3)*C[3]+sum(P4)*C[4] # calculation of total cost during the process
  C1 <- sum(P1)*C[1]    # total cost related to decision 1 (c11)
  C2 <- sum(P2)*C[2]    # total cost related to decision 2 (c10)
  C3 <- sum(P3)*C[3]    # total cost related to decision 3 (c01)
  C4 <- sum(P4)*C[4]    # total cost related to decision 4 (c00)
  output <- list(cost0=C0, cost1= C1, cost2= C2, cost3= C3, cost4= C4, LCLx=T1, UCLx=T2, LCLy=T3, UCLy=T4, cusumx=cusumx, cusumy=cusumy, reall=reall,realu=realu,obsl=obsl,obsu=obsu)
  class(output) <- "rbcusumcc"
  return(output)
}
