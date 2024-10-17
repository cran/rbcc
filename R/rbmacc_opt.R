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
rbmacc_opt <- function (X, UC, C, n=1, w=2, K_init=0, LKL=0, UKL=5){
  if (!requireNamespace("stats", quietly = TRUE)) {
    stop(
      "Package \"stats\" must be installed to use this function.",
      call. = FALSE
    )
  }

  if(missing(n))
  {n <- 1}
  if(missing(w))
  {w <- 2 }
    if(missing(K_init))
  {K_init <- 0}

  fcn=function(K_init) rbmacc(X, UC, C, n, w, K_init)[[1]]
  Q= pracma::fminbnd(fcn, LKL, UKL)
  Kopt<-Q[[1]]
  H_opt<-rbmacc(X, UC, C, n, w, K=Kopt)
  H_opt$par<-Kopt
  class(H_opt)<-"rbcc"
  return(H_opt)
}


