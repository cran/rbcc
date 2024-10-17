#-----------------------------------------------------------------------------#
#                                                                             #
#                     RISK-BASED CONTROL CHARTS                               #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: September 2024                                               #
#-----------------------------------------------------------------------------#
#' @export
rbmacc <- function(X, UC, C, n=1, w=2, K=3)
    {
    if (!requireNamespace("pracma", quietly = TRUE)) {
      stop(
        "Package \"pracma\" must be installed to use this function.",
        call. = FALSE
      )
    }
  if(missing(n))
  {n <- 1}
  if(missing(w))
  {w <- 2}
  if(missing(K))
  {K <- 3}
  n_int <- n*(floor(length(X)/n))
    X <- X[1:n_int]
    UC <- UC[1:n_int]
    x <- matrix(X,ncol=n) #  Data with subgroups
    xrm <- rowMeans(x)
    ma_x <-  pracma::movavg(xrm, w, type="s") # real values of MA statistic
    T1 <- mean(ma_x)-3*(pracma::std(ma_x)/sqrt(n*w))    # LCL of MA chart
    T2 <- mean(ma_x)+3*(pracma::std(ma_x)/sqrt(n*w)) # UCL of MA chart
    Y <- X+UC                      # measurement error data matrix
    y <- matrix(Y,ncol=n)
    yrm <- rowMeans(y)
    may <- pracma::movavg(yrm, w, type="s")         # Observed values of MA with measurement errors
    T3 <- mean(ma_x)-K*(pracma::std(ma_x)/sqrt(n*w))  # LCL of MA chart
    T4 <- mean(ma_x)+K*(pracma::std(ma_x)/sqrt(n*w))  # UCL of MA chart
  # -----------------calculation of costs and define cases (boolean)-----------
 
    P1 <- ((T1 < ma_x & ma_x < T2) & (T3< may & may<T4))*1  # correct acceptance
    P2 <- ((T1 < ma_x & ma_x < T2) & (T4< may | may<T3))*1 # type I error
    P3 <- ((T2 < ma_x|ma_x < T1) & (T3< may & may<T4))*1 # type II error
    P4 <- ((T2 < ma_x|ma_x < T1) & (T4< may| may<T3))*1 # correct rejecting
  C0 <- sum(P1)*C[1]+sum(P2)*C[2]+sum(P3)*C[3]+sum(P4)*C[4] # calculation of total cost during the process
  C1 <- sum(P1)*C[1]    # total cost related to decision 1 (c11)
  C2 <- sum(P2)*C[2]    # total cost related to decision 2 (c10)
  C3 <- sum(P3)*C[3]    # total cost related to decision 3 (c01)
  C4 <- sum(P4)*C[4]    # total cost related to decision 4 (c00)
 output <- list(cost0=C0, cost1= C1, cost2= C2, cost3= C3, cost4= C4, LCLx=T1, UCLx=T2, LCLy=T3, UCLy=T4, real=ma_x, Observed= may)
 class(output) <- "rbcc"
 return(output)
}



