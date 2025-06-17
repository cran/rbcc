#-----------------------------------------------------------------------------#
#                                                                             #
#              RISK-BASED CONTROL CHARTS                                      #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kzst@gtk.uni-pannon.hu                                         #
#                                                                             #
# Last modified: January 2025                                                 #
#-----------------------------------------------------------------------------#
#' @export
summary <- function(object, ...) {
  UseMethod("summary", object)
}

#' @export
summary.rbcc <- function(object, digits =  getOption("digits"), ...)
{
  real <- object$real
  Observed <- object$Observed
  cost0 <- object$cost0 # calculation of total cost during the process
  cost1 <- object$cost1 # total cost related to decision 1 (c11)
  cost2 <- object$cost2 # total cost related to decision 2 (c10)
  cost3 <- object$cost3 # total cost related to decision 3 (c01)
  cost4 <- object$cost4 # total cost related to decision 4 (c00)
  LCLx <- object$LCLx
  UCLx <- object$UCLx
  LCLy <- object$LCLy
  UCLy <- object$UCLy
  Kopt <- object$par
  if (!is.null(Kopt)){
    results<-list(real = real, Observed = Observed, cost0 = cost0,
                  cost1 = cost1, cost2 = cost2, cost3 = cost3,
                  cost4 = cost4, LCLx = LCLx, UCLx = UCLx,  LCLy = LCLy,
                  UCLy = UCLy, Kopt = Kopt)
  }else{
    results<-list(real = real, Observed = Observed, cost0 = cost0,
                  cost1 = cost1, cost2 = cost2, cost3 = cost3,
                  cost4 = cost4, LCLx = LCLx, UCLx = UCLx,  LCLy = LCLy,
                  UCLy = UCLy)
  }
  object<-results
  class(object)<-"summary.rbcc"
  object
}

#' @export
summary.rbcusumcc <- function(object, digits =  getOption("digits"), ...)
{
  real <- object$cusumx
  Observed <- object$cusumy
  cost0 <- object$cost0 # calculation of total cost during the process
  cost1 <- object$cost1 # total cost related to decision 1 (c11)
  cost2 <- object$cost2 # total cost related to decision 2 (c10)
  cost3 <- object$cost3 # total cost related to decision 3 (c01)
  cost4 <- object$cost4 # total cost related to decision 4 (c00)
  UCLx <- object$UCLx
  UCLy <- object$UCLy
  Kopt <- object$par
  if (!is.null(Kopt)){
    results<-list(real = real, Observed = Observed, cost0 = cost0,
                  cost1 = cost1, cost2 = cost2, cost3 = cost3,
                  cost4 = cost4, UCLx = UCLx,
                  UCLy = UCLy, Kopt = Kopt)
  }else{
    results<-list(real = real, Observed = Observed, cost0 = cost0,
                  cost1 = cost1, cost2 = cost2, cost3 = cost3,
                  cost4 = cost4, UCLx = UCLx, UCLy = UCLy)
  }
  object<-results
  class(object)<-"summary.rbcusumcc"
  object
}


#' @export
summary.rbmcc <- function(object, digits =  getOption("digits"), ...)
{
  real <- object$real
  Observed <- object$Observed
  cost0 <- object$cost0 # calculation of total cost during the process
  cost1 <- object$cost1 # total cost related to decision 1 (c11)
  cost2 <- object$cost2 # total cost related to decision 2 (c10)
  cost3 <- object$cost3 # total cost related to decision 3 (c01)
  cost4 <- object$cost4 # total cost related to decision 4 (c00)
  UCLT2 <- object$baselimit
  UCLRBT2 <- object$limit
  Kopt <- object$Kopt
  if (!is.null(Kopt)){
    results<-list(real = real, Observed = Observed, cost0 = cost0,
                  cost1 = cost1, cost2 = cost2, cost3 = cost3,
                  cost4 = cost4, UCLT2 = UCLT2, UCLRBT2 = UCLRBT2,
                  Kopt = Kopt)
  }else{
    results<-list(real = real, Observed = Observed, cost0 = cost0,
                  cost1 = cost1, cost2 = cost2, cost3 = cost3,
                  cost4 = cost4, UCLT2 = UCLT2, UCLRBT2 = UCLRBT2)
  }
  object<-results
  class(object)<-"summary.rbmcc"
  object
}
