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
rbcusumcc_opt <- function(X, UC, C, n=1, T=5, se.shift=1, K_init= 0, LKL=0, UKL=6){
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
  fcn=function(K_init)rbcusumcc(X, UC, C, n, T, se.shift, K_init)[[1]]
  Q=pracma::fminbnd(fcn, LKL, UKL)
  Kopt<-Q[[1]]
  H_opt<-rbcusumcc(X, UC, C, n, T, se.shift, K=Kopt)
  H_opt$par<-Kopt
  class(H_opt)<-"rbcusumcc"
  return(H_opt)
}

