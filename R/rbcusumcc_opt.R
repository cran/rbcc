#-----------------------------------------------------------------------------#
#                                                                             #
#            RISK-BASED STATISTICAL CONTROL CHARTS                            #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: March 2023                                                   #
#-----------------------------------------------------------------------------#

#' @export
rbcusumcc_opt <- function(X, UC, C, n, T=5, se.shift=1, K_init= 0, LKL=-5, UKL=5){
  if (!requireNamespace("stats", quietly = TRUE)) {
    stop(
      "Package \"stats\" must be installed to use this function.",
      call. = FALSE
    )
  }

  if(missing(n))
  {n <- 1}
  if(missing(T))
  {T <- 5 }
  if(missing(se.shift))
  {se.shift <- 1 }
  if(missing(K_init))
  {K_init <- 0}
  fcn=function(K_init)rbcusumcc(X, UC, C, n, T=5, se.shift=1, K_init)[[1]]
  Q=pracma::fminbnd(fcn, LKL, UKL)
  Kopt<-Q[[1]]
  H_opt<-rbcusumcc(X, UC, C, n, T=5, se.shift=1, K=Kopt)
  H_opt$par<-Kopt
  class(H_opt)<-"rbcusumcc"
  return(H_opt)
}

X=rnorm(200,0,1)
UC=rnorm(200,0,0.011)
n=5
C= c(1, 5,60,5)
H=rbcusumcc(X, UC, C, n, T=5, se.shift=1, K=0)
H_opt=rbcusumcc_opt(X, UC, C, n, T=5, se.shift=1, K_init= 0, LKL=-5, UKL=5)

