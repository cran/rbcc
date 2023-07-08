#-----------------------------------------------------------------------------#
#                                                                             #
#  RISK-BASED STATISTICAL CONTROL CHARTS                                     #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: March 2022                                                   #
#-----------------------------------------------------------------------------#
#' @export
rbcc <- function(X, UC, C, n, type= c("xbar", "R", "S"), confidence_level=0.9973, K=0)
    {    if (!requireNamespace("qcc", quietly = TRUE)) {
      stop(
        "Package \"qcc\" must be installed to use this function.",
        call. = FALSE
      )
    }
  
  call <- match.call()
 if(missing(confidence_level))
  {confidence_level <- 0.9973 }
  if(missing(K))
  {K <- 0}
 if ("xbar" %in% type)
 {
  if(n==1)
    {
  n_int <- n*(floor(length(X)/n))
  X <- X[1:n_int]
  UC <- UC[1:n_int]
  x <- matrix(X,ncol=n) #  Data with subgroups
  qx <- qcc::qcc(x, type = "xbar.one", confidence.level = confidence_level, plot = FALSE)
  xbar <- qx$statistics          # real values of Xbar statistic
  T1 <- qx$limits[1]             # LCL of Xbar chart
  T2 <- qx$limits[2]             # UCL of xbar chart
  Y <- X+UC                      # measurement error data matrix
  y <- matrix(Y,ncol=n)
  qy <- qcc::qcc(y, type = "xbar.one", confidence.level = confidence_level, plot = FALSE) # calculation of risk based xbar
  ybar <- qy$statistics     #  observed xbar with measurement errors
   T3 <- T1                 # set lower control limit based on observed xbar
   T4 <- T2                 # set upper control limit based on observed xbar
  }
  if(n>=2)
  {
    n_int <- n*(floor(length(X)/n))
    X <- X[1:n_int]
    UC <- UC[1:n_int]
    x <- matrix(X,ncol=n) #  Data with subgroups
    qx <- qcc::qcc(x, type = "xbar", confidence.level = confidence_level, plot = FALSE)
    xbar <- qx$statistics          # real values of Xbar statistic
    T1 <- qx$limits[1]             # LCL of Xbar chart
    T2 <- qx$limits[2]             # UCL of xbar chart

    Y <- X+UC                      # measurement error data matrix
    y <- matrix(Y,ncol=n)
    qy <- qcc::qcc(y, type = "xbar", confidence.level = confidence_level, plot = FALSE) # calculation of risk based xbar
    ybar <- qy$statistics     #  observed xbar with measurement errors
    T3 <- T1                 # set lower control limit based on observed xbar
    T4 <- T2                 # set upper control limit based on observed xbar
  }
  # -----------------calculation of costs and define cases (boolean)-----------
   
   P1 <- ((T1 < xbar & xbar < T2) & (T3+K< ybar & ybar<T4-K))*1  # correct acceptance
   P2 <- ((T1 < xbar & xbar < T2) & (T4-K< ybar | ybar<T3+K))*1 # type I error
   P3 <- ((T2 < xbar|xbar < T1) & (T3+K< ybar& ybar<T4-K))*1 # type II error
   P4 <- ((T2 < xbar|xbar < T1) & (T4-K< ybar| ybar<T3+K))*1 # correct rejecting
  #P1 <- (T1 < xbar|xbar < T2 & T3+K< ybar| ybar<T4-K)*1  # correct acceptance
  #P2 <- (T1 < xbar|xbar < T2 & T4-K< ybar| ybar<T3+K)*1 # type I error
  #P3 <- (T2 < xbar|xbar < T1 & T3+K< ybar| ybar<T4-K)*1 # type II error
  #P4 <- (T2 < xbar|xbar < T1 & T4-K< ybar| ybar<T3+K)*1 # correct rejecting
  C0 <- sum(P1)*C[1]+sum(P2)*C[2]+sum(P3)*C[3]+sum(P4)*C[4] # calculation of total cost during the process
  C1 <- sum(P1)*C[1]    # total cost related to decision 1 (c11)
  C2 <- sum(P2)*C[2]    # total cost related to decision 2 (c10)
  C3 <- sum(P3)*C[3]    # total cost related to decision 3 (c01)
  C4 <- sum(P4)*C[4]    # total cost related to decision 4 (c00)
 output <- list(cost0=C0, cost1= C1, cost2= C2, cost3= C3, cost4= C4, LCLx=T1, UCLx=T2, LCLy=T3+K, UCLy=T4-K, real=xbar, Observed= ybar)
 class(output)="rbcc"
  return(output)
 }
  if ("R" %in% type)
  {
    n_int <- n*(floor(length(X)/n))
    X <- X[1:n_int]
    UC <- UC[1:n_int]
    x <- matrix(X,ncol=n) #  Data with subgroups
    qx <- qcc::qcc(x, type = "R", confidence.level = confidence_level, plot = FALSE)
    Rx <- qx$statistics          # real values of range statistic
    T1 <- qx$limits[1]             # LCL of R chart
    T2 <- qx$limits[2]             # UCL of R chart

    Y <- X+UC                      # measurement error data matrix
    y <- matrix(Y,ncol=n)
    qy <- qcc::qcc(y, type = "R", confidence.level = confidence_level, plot = FALSE) # calculation of risk based Range
    Ry <- qy$statistics     #  observed range with measurement errors
    T3 <- T1                 # set lower control limit based on observed range
    T4 <- T2                 # set upper control limit based on observed range
  # -----------------calculation of costs and define cases (boolean)-----------
    P1 <- ((T1 < Rx & Rx < T2) & (T3+K< Ry & Ry<T4-K))*1  # correct acceptance
    P2 <- ((T1 < Rx & Rx < T2) & (T4-K< Ry | Ry<T3+K))*1 # type I error
    P3 <- ((T2 < Rx|Rx < T1) & (T3+K< Ry& Ry<T4-K))*1 # type II error
    P4 <- ((T2 < Rx|Rx < T1) & (T4-K< Ry| Ry<T3+K))*1 # correct rejecting
  #P1 <- (T1 < Rx|Rx < T2 & T3+K< Ry| Ry<T4-K)*1  # correct acceptance
  #P2 <- (T1 < Rx|Rx < T2 & T4-K< Ry| Ry<T3+K)*1 # type I error
  #P3 <- (T2 < Rx|Rx < T1 & T3+K< Ry| Ry<T4-K)*1 # type II error
  #P4 <- (T2 < Rx|Rx < T1 & T4-K< Ry| Ry<T3+K)*1 # correct rejecting
  C0 <- sum(P1)*C[1]+sum(P2)*C[2]+sum(P3)*C[3]+sum(P4)*C[4] # calculation of total cost during the process
  C1 <- sum(P1)*C[1]    # total cost related to decision 1 (c11)
  C2 <- sum(P2)*C[2]    # total cost related to decision 2 (c10)
  C3 <- sum(P3)*C[3]    # total cost related to decision 3 (c01)
  C4 <- sum(P4)*C[4]    # total cost related to decision 4 (c00)
  output <- list(cost0=C0, cost1= C1, cost2= C2, cost3= C3, cost4= C4, LCLx=T1, UCLx=T2, LCLy=T3+K, UCLy=T4-K, real=Rx, Observed= Ry)
  class(output)="rbcc"
  return(output)
  }
  if ("S" %in% type)
  {
    n_int <- n*(floor(length(X)/n))
    X <- X[1:n_int]
    UC <- UC[1:n_int]
    x <- matrix(X,ncol=n) #  Data with subgroups
    qx <- qcc::qcc(x, type = "S", confidence.level = confidence_level, plot = FALSE)
    Sx <- qx$statistics          # real values of S statistic
    T1 <- qx$limits[1]             # LCL of S chart
    T2 <- qx$limits[2]             # UCL of S chart

    Y <- X+UC                      # measurement error data matrix
    y <- matrix(Y,ncol=n)
    qy <- qcc::qcc(y, type = "S", confidence.level = confidence_level, plot = FALSE) # calculation of risk based S
    Sy <- qy$statistics     #  observed S with measurement errors
    T3 <- T1                 # set lower control limit based on observed S.d
    T4 <- T2                 # set upper control limit based on observed S.d
    # -----------------calculation of costs and define cases (boolean)-----------
   
    P1 <- ((T1 < Sx & Sx < T2) & (T3+K< Sy & Sy<T4-K))*1  # correct acceptance
    P2 <- ((T1 < Sx & Sx < T2) & (T4-K< Sy | Sy<T3+K))*1 # type I error
    P3 <- ((T2 < Sx|Sx < T1) & (T3+K< Sy& Sy<T4-K))*1 # type II error
    P4 <- ((T2 < Sx|Sx < T1) & (T4-K< Sy| Sy<T3+K))*1 # correct rejecting
    
    #P1 <- (T1 < Sx|Sx < T2 & T3+K< Sy| Sy<T4-K)*1  # correct acceptance
    #P2 <- (T1 < Sx|Sx < T2 & T4-K< Sy| Sy<T3+K)*1 # type I error
    #P3 <- (T2 < Sx|Sx < T1 & T3+K< Sy| Sy<T4-K)*1 # type II error
    #P4 <- (T2 < Sx|Sx < T1 & T4-K< Sy| Sy<T3+K)*1 # correct rejecting
    C0 <- sum(P1)*C[1]+sum(P2)*C[2]+sum(P3)*C[3]+sum(P4)*C[4] # calculation of total cost during the process
    C1 <- sum(P1)*C[1]    # total cost related to decision 1 (c11)
    C2 <- sum(P2)*C[2]    # total cost related to decision 2 (c10)
    C3 <- sum(P3)*C[3]    # total cost related to decision 3 (c01)
    C4 <- sum(P4)*C[4]    # total cost related to decision 4 (c00)
    output <- list(cost0=C0, cost1= C1, cost2= C2, cost3= C3, cost4= C4, LCLx=T1, UCLx=T2, LCLy=T3+K, UCLy=T4-K, real=Sx, Observed= Sy)
    class(output)="rbcc"
    return(output)
  }
}



