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
rbewmacc_opt <- function (X, UC, C, n=1, lambada=0.20, nsigmas=3, K_init= 0, LKL=-5, UKL=5){
  if (!requireNamespace("stats", quietly = TRUE)) {
    stop(
      "Package \"stats\" must be installed to use this function.",
      call. = FALSE
    )
  }

  if(missing(n))
  {n <- 1}
  if(missing(lambada))
  {confidence_level <- 0.20 }
  if(missing(nsigmas))
  {nsigmas <- 3 }
  if(missing(K_init))
  {K_init <- 0}

  fcn=function(K_init) rbewmacc(X, UC, C, n, lambada=0.20, nsigmas=3, K_init)[[1]]
  Q=pracma::fminbnd(fcn, LKL, UKL)
  Kopt<-Q[[1]]
  H_opt<-rbewmacc(X, UC, C, n, lambada=0.20, nsigmas=3,K=Kopt)
  H_opt$par<- Kopt
  class(H_opt)<-"rbcc"
  return(H_opt)
}
