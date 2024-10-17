#-----------------------------------------------------------------------------#
#                                                                             #
#            RISK-BASED STATISTICAL CONTROL CHARTS                            #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: September 2024                                               #
#-----------------------------------------------------------------------------#

#' @export
rbmcc <- function(X, UC, C, n=1 , confidence_level=0.99, K=0)
{
  if (!requireNamespace("qcc", quietly = TRUE)) {
    stop(
      "Package \"qcc\" must be installed to use this function.",
      call. = FALSE
    )
  }

  if (missing(X))
    stop("data matrix is not specified")
  if (missing(UC))
    stop("Meaurement error matrix is not specified")
  if (missing(C))
    {stop("Cost vector argument is missing")}
  if(!(length(C)==4))
    {stop("Cost should be a vector of length 4!")}
  if(missing(n))
    {n <- 1}
  if(missing(confidence_level))
    {confidence_level <- 0.99 }
  if(missing(K))
  {K <- 0}
  n_int <- n*(floor(nrow(X)/n))

  X <- X[1:n_int,]
  UC <- UC[1:n_int,]


  Dx <- c()                               #  Data matrix with subgroups

  for (i in 1: ncol(X)){

    x <- matrix(X[,i],ncol=n)
    Dx[[i]]<-x

  }

  qx <- qcc::mqcc(Dx, type = "T2", confidence.level = confidence_level, plot = FALSE)
  T2x <- qx$statistics          # real values of T2 statistic
  T2UCL <- qx$limits[2]         # UCL of T2 chart
  Y <- X+UC                     # measurement error data matrix

  Dy <- c()                   # measurement error data matrix with subgroups

  for (i in 1: ncol(Y)){

    y <- matrix(Y[,i],ncol=n)
    Dy[[i]]<-y

  }

  qy <- qcc::mqcc(Dy, type = "T2", confidence.level= confidence_level, plot = FALSE) # calculation of risk based T2
  T2y <- qy$statistics                      #  observed T2 with measurement errors
  T2UCL_UC <- T2UCL

  # -----------------calculation of costs and define cases (boolean)-----------
  P1 <- (T2x<T2UCL & T2y<T2UCL_UC-K)*1 # correct acceptance
  P2 <- (T2x<T2UCL & T2y>T2UCL_UC-K)*1 # type 1 error
  P3 <- (T2x>T2UCL & T2y<T2UCL_UC-K)*1 # type 2 error
  P4 <- (T2x>T2UCL & T2y>T2UCL_UC-K)*1 # correct rejecting
  C0 <- sum(P1)*C[1]+sum(P2)*C[2]+sum(P3)*C[3]+sum(P4)*C[4] # calculation of
                                               # total cost during the process
  C1 <- sum(P1)*C[1]    # total cost related to decision 1 (c11)
  C2 <- sum(P2)*C[2]    # total cost related to decision 2 (c10)
  C3 <- sum(P3)*C[3]    # total cost related to decision 3 (c01)
  C4 <- sum(P4)*C[4]    # total cost related to decision 4 (c00)
 output <- list(cost0=C0, cost1= C1, cost2= C2, cost3= C3, cost4= C4, baselimit=T2UCL, limit= T2UCL_UC-K, real=T2x, Observed= T2y)
 class(output) <- "rbmcc"
 return(output)
}
