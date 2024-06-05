#-----------------------------------------------------------------------------#
#                                                                             #
#            RISK-BASED STATISTICAL CONTROL CHARTS                            #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kosztyan.zsolt@gtk.uni-pannon.hu                               #
#                                                                             #
# Last modified: June 2024                                                    #
#-----------------------------------------------------------------------------#

#' @export
plot.rbcc <- function(x,...){
  if (methods::is(x,"rbcc")){
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      stop(
        "Package \"ggplot2\" must be installed to use this function.",
        call. = FALSE
      )
    }
    if (!requireNamespace("reshape2", quietly = TRUE)) {
      stop(
        "Package \"reshape2\" must be installed to use this function.",
        call. = FALSE
      )
    }
    H_opt<-x
    LCL=H_opt$LCLx
    UCL=H_opt$UCLx
    LCLopt=H_opt$LCLy
    UCLopt=H_opt$UCLy
    Groups<-value<-variable<-NULL
    df <- data.frame(Groups = c(1:length(H_opt$real)), y1= H_opt$real, y2=H_opt$Observed, y3= LCL, y4= UCL, y5=LCLopt, y6=UCLopt)
    big_data <- reshape2::melt(df, id = "Groups")
    ggplot2::ggplot(big_data, ggplot2::aes(x = Groups,  y = value, color = variable)) +
      ggplot2::geom_line()+ ggplot2::scale_color_manual(labels = c("real","observed","LCL","UCL", "LCLopt", "UCLopt"), values=c("black", "green1", "blue","blue", "red","red"))+
      ggplot2::labs (x= "Groups", y= "Group_Statistic")+ ggplot2::theme_bw()+ ggplot2::theme(legend.title = ggplot2::element_blank()) +
      ggplot2::ggtitle("Univariate Control Chart for traditional and risk-based Statistics")
  }else{
    plot(x,...)
  }
}
#' @export
plot.rbcusumcc <- function(x,...){
  if (methods::is(x,"rbcusumcc")){
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      stop(
        "Package \"ggplot2\" must be installed to use this function.",
        call. = FALSE
      )
    }
    if (!requireNamespace("reshape2", quietly = TRUE)) {
      stop(
        "Package \"reshape2\" must be installed to use this function.",
        call. = FALSE
      )
    }
    H_opt<-x
    LCL=H_opt$LCLx
    UCL=H_opt$UCLx
    LCLopt=H_opt$LCLy
    UCLopt=H_opt$UCLy
    Groups<-value<-variable<-NULL
    df <- data.frame(Groups = c(1:length(H_opt$cusumx)), y1= H_opt$cusumx, y2= H_opt$cusumy, y3= LCL, y4= UCL, y5=LCLopt, y6=UCLopt)
    big_data <- reshape2::melt(df, id = "Groups")
    ggplot2::ggplot(big_data, ggplot2::aes(x = Groups,  y = value, color = variable)) +
      ggplot2::geom_line()+ ggplot2::scale_color_manual(labels = c("real", "observed","LCL","UCL", "LCLopt", "UCLopt"), values=c("black", "green1", "blue","blue", "red","red"))+
      ggplot2::labs (x= "Groups", y= "Group_Statistic")+ ggplot2::theme_bw()+ ggplot2::theme(legend.title = ggplot2::element_blank()) +
      ggplot2::ggtitle("CUSUM Chart for traditional and risk-based Statistics")
  }else{
    plot(x,...)
  }
}
#' @export
plot.rbmcc <- function(x,...){
  if (methods::is(x,"rbmcc")){
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      stop(
        "Package \"ggplot2\" must be installed to use this function.",
        call. = FALSE
      )
    }
    if (!requireNamespace("reshape2", quietly = TRUE)) {
      stop(
        "Package \"reshape2\" must be installed to use this function.",
        call. = FALSE
      )
    }
    H_opt<-x
    UCL=H_opt$baselimit
    UCLopt=H_opt$limit
    Groups<-value<-variable<-NULL
    df <- data.frame(Groups = c(1:length(H_opt$real)), y1= H_opt$real, y2=H_opt$Observed, y3= UCL, y4=UCLopt)
    big_data <- reshape2::melt(df, id = "Groups")
    ggplot2::ggplot(big_data, ggplot2::aes(x = Groups,  y = value, color = variable)) +
      ggplot2::geom_line()+ ggplot2::scale_color_manual(labels = c("real","observed","UCL", "UCLopt"), values=c("black", "green1", "blue", "red"))+
      ggplot2::labs (x= "Groups", y= "Group_Statistic")+ ggplot2::theme_bw()+ ggplot2::theme(legend.title = ggplot2::element_blank()) +
      ggplot2::ggtitle(" Multivariate Control chart for Hotelling's and risk-based Statistics")
  }else{
    plot(x,...)
  }
}
