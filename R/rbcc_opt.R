#-----------------------------------------------------------------------------#
#                                                                             #
#                 RISK-BASED CONTROL CHARTS                                   #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: September 2024                                               #
#-----------------------------------------------------------------------------#
#' @export
rbcc_opt <- function (X, UC, C, n, type=c("xbar", "R", "S"),confidence_level=0.9973, K_init=0,LKL=0,UKL=5)
  {

  if (!requireNamespace("stats", quietly = TRUE)) {
    stop(
      "Package \"stats\" must be installed to use this function.",
      call. = FALSE
    )
  }
  if (!requireNamespace("pracma", quietly = TRUE)) {
    stop(
      "Package \"pracma\" must be installed to use this function.",
      call. = FALSE
    )
  }
  if ("xbar" %in% type)
  {
  fcn=function(K_init) rbcc (X, UC,C, n, type="xbar", confidence_level=0.9973, K_init)[[1]]
  Q=pracma::fminbnd(fcn, LKL, UKL)
  Kopt<-Q[[1]]
  H_opt<-rbcc(X, UC, C, n , type="xbar", confidence_level=0.9973, K=Kopt)
  H_opt$par<-Kopt
  }
  if ("R" %in% type)
  {
    fcn=function(K_init) rbcc (X, UC,C, n, type="R", confidence_level=0.9973, K_init)[[1]]
    Q=pracma::fminbnd(fcn, LKL, UKL)
    Kopt<-Q[[1]]
    H_opt<-rbcc(X, UC, C, n , type="R", confidence_level=0.9973, K=Kopt)
    H_opt$par<-Kopt
  }
  if ("S" %in% type)
  {
    fcn=function(K_init) rbcc (X, UC,C, n, type="S", confidence_level=0.9973, K_init)[[1]]
    Q=pracma::fminbnd(fcn, LKL, UKL)
    Kopt<-Q[[1]]
    H_opt<-rbcc(X, UC, C, n , type="S", confidence_level=0.9973, K=Kopt)
    H_opt$par<-Kopt
  }

  class(H_opt)<-"rbcc"
  return(H_opt)
}


