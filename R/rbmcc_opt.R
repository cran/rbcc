#-----------------------------------------------------------------------------#
#                                                                             #
#  RISK-BASED MULTIVARIATE CONTROL CHARTS                                     #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: March 2022                                                   #
#-----------------------------------------------------------------------------#

#' @export
rbmcc_opt <- function (X, UC, C, n=1, confidence_level=0.99, K_init=0,LKL=-5,UKL=5){

  if (!requireNamespace("pracma", quietly = TRUE)) {
    stop(
      "Package \"pracma\" must be installed to use this function.",
      call. = FALSE
    )
  }
  if(missing(n)) {
    n <- 1
  }
  if(missing(confidence_level)) {
    confidence_level <- 0.99
  }
  if(missing(K_init)) {
    K_init <- 0
  }
  fcn=function(K_init) rbmcc (X, UC,C, n, confidence_level, K_init)[[1]]
  Q=pracma::fminbnd(fcn, LKL, UKL)
  Kopt<-Q[[1]]
  H_opt<-rbmcc(X, UC, C, n , confidence_level, Kopt)
  H_opt$Kopt<-Kopt
  class(H_opt)<-"rbmcc"
  return(H_opt)
}
