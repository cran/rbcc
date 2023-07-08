#-----------------------------------------------------------------------------#
#                                                                             #
#  RISK-BASED CONTROL CHARTS                                                  #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: March 2022                                                   #
#-----------------------------------------------------------------------------#
#' @export
rbmacc <- function(X, UC, C, n=1, w=2, K=0)
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
  {K <- 0}
  n_int <- n*(floor(length(X)/n))
    X <- X[1:n_int]
    UC <- UC[1:n_int]
    x <- matrix(X,ncol=n) #  Data with subgroups
    xrm <- rowMeans(x)
    ma_x= pracma::movavg(xrm, w, type="s") # real values of MA statistic
    LCLx=mean(ma_x)-(3*pracma::std(ma_x)/sqrt(n*w))    # LCL of MA chart
    UCLx=mean(ma_x)+(3*pracma::std(ma_x)/sqrt(n*w)) # UCL of MA chart
    Y <- X+UC                      # measurement error data matrix
    y <- matrix(Y,ncol=n)
    yrm <- rowMeans(y)
    may= pracma::movavg(yrm, w, type="s")         # Observed values of MA with measurement errors
    LCLy=LCLx # LCL of MA chart
    UCLy=UCLx # UCL of MA chart
  # -----------------calculation of costs and define cases (boolean)-----------
  P1 <- (LCLx < ma_x|ma_x < UCLx & LCLy+K< may| may<UCLy-K)*1  # correct acceptance
  P2 <- (LCLx < ma_x|ma_x < UCLx & UCLy-K< may| may<LCLy+K)*1 # type I error
  P3 <- (UCLx < ma_x|ma_x < LCLx & LCLy+K< may| may<UCLy-K)*1 # type II error
  P4 <- (UCLx < ma_x|ma_x < LCLx & UCLy-K< may| may<LCLy+K)*1 # correct rejecting
  C0 <- sum(P1)*C[1]+sum(P2)*C[2]+sum(P3)*C[3]+sum(P4)*C[4] # calculation of total cost during the process
  C1 <- sum(P1)*C[1]    # total cost related to decision 1 (c11)
  C2 <- sum(P2)*C[2]    # total cost related to decision 2 (c10)
  C3 <- sum(P3)*C[3]    # total cost related to decision 3 (c01)
  C4 <- sum(P4)*C[4]    # total cost related to decision 4 (c00)
 output <- list(cost0=C0, cost1= C1, cost2= C2, cost3= C3, cost4= C4, LCLx=LCLx, UCLx=UCLx, LCLy=LCLx+K, UCLy=UCLx-K, real=ma_x, Observed= may)
 class(output) <- "rbcc"
 return(output)
}
X=rnorm(200,10,0.5)
UC=rnorm(200,0,0.05)
C= c(1, 5, 200, 5)
H=rbmacc(X,UC,C, w=3, n=1)




