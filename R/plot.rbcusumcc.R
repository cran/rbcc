#-----------------------------------------------------------------------------#
#                                                                             #
#               RISK-BASED CONTROL CHARTS                                     #
#                                                                             #
#  Written by: Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan              #
#              Department of Quantitative Methods                             #
#              University of Pannonia, Hungary                                #
#              kosztyan.zsolt@gtk.uni-pannon.hu                               #
#                                                                             #
# Last modified: January 2025                                                 #
#-----------------------------------------------------------------------------#

#' @export
plot.rbcusumcc <- function(x,...)
{
  if (methods::is(x,"rbcusumcc")){
    H_opt<-x
    LCL=H_opt$LCLx
    UCL=H_opt$UCLx
    LCLopt=H_opt$LCLy
    UCLopt=H_opt$UCLy
    Groups<-value<-variable<-NULL
    df <- data.frame(Groups = c(1:length(H_opt$reall)), y1= H_opt$reall, y2= H_opt$realu, y3= H_opt$obsl, y4= H_opt$obsu, y5= LCL, y6= UCL, y7=LCLopt, y8=UCLopt)
    big_data <- reshape2::melt(df, id = "Groups")
    ggplot2::ggplot(big_data, ggplot2::aes(x = Groups,  y = value, color = variable)) +
      ggplot2::geom_line()+ ggplot2::scale_color_manual(labels = c("real-", "real+","observed-","observed+","LCL","UCL", "LCLopt", "UCLopt"), values=c("black","black", "green1","green1", "blue","blue", "red","red"))+
      ggplot2::labs (x= "Groups", y= "Group_Statistic")+ ggplot2::theme_bw()+ ggplot2::theme(legend.title = ggplot2::element_blank()) +
      ggplot2::ggtitle("CUSUM Chart for traditional and risk-based Statistics")
  }
}
