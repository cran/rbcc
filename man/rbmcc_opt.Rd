\name{rbmcc_opt}
\alias{rbmcc_opt}

\title{
Optimized Risk-based Multivariate Control Chart
}
\description{
Calculate Optimized Risk-based Multivariate Control Chart
}
\usage{
rbmcc_opt(X, UC, C, n=1, confidence_level=0.99, K_init=0,LKL=-5,UKL=5)
}

\arguments{
  \item{X}{matrix of variables (numeric matrix). Either can be simulated using data_gen or defined by using available data set.}
  \item{UC}{matrix of measuerement error (numeric matrix).}
  \item{C}{vector of decision costs (default value is vector of 1).}
  \item{n}{ The sample size for grouping. For individual obervations use n=1).}
  \item{confidence_level}{The (1-alpha)percent confidence level (default value is 0.99)}
  \item{K_init}{Set correction component to 0 by default (default value is 0)}
  \item{LKL}{Lower limit of K parameter (default value is -5)}
  \item{UKL}{Upper limit of K parameter (default value is -5)}
}

\value{
\item{cost0}{Total cost of a monitoing process}
\item{cost1}{Total cost of correct acceptance related to a process monitoring}
\item{cost2}{Total cost of decision error type 1 related to a process monitoring}
\item{cost3}{Total cost of decision error type 2 related to a process monitoring}
\item{cost4}{Total cost of correct reject related to a process monitoring}
\item{baselimit}{UCL of T^2 chart for a given data}
\item{limit}{UCL of optimized risk based multivariate control chart for a given data}
\item{real}{Real values of T2 statistic for a given data}
\item{Observed}{Observed T2 with measurement errors for a given data}
\item{Kopt}{Optimal K paramater of risk-based multivariate control chart for a given data}
}
\references{
Kosztyán, Z. T., and Katona, A. I. (2016). Risk-based multivariate control chart. Expert Systems with Applications, 62, 250-262.
}
\author{
Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan*

e-mail: kzst@gtk.uni-pannon.hu
}

\seealso{\code{\link{data_gen}}, \code{\link{rbcc}}, \code{\link{rbcc_opt}}, \code{\link{rbewmacc}}, \code{\link{rbewmacc_opt}}, \code{\link{rbmacc}},  \code{\link{rbmacc_opt}}, \code{\link{rbmcc}},  \code{\link{plot.rbcc}}, \code{\link{summary.rbcc}}.}
\examples{
# Data generation for matrix X
mu_X <- c(0,1,2)               # vector of means.
va_X  <- c(1,2, 0.5)           # vector of standard deviation.
sk_X <- c(0,0.5, 0.8)          # vector of skewness.
ku_X <- c(3,3.5, 4)            # vector of kurtosis.
obs <- 200                     # Total number of observations of a process.

X <- data_gen (obs, mu_X, va_X, sk_X, ku_X) # generate data pints

# Data generation for measurement error matrix UC

mu_UC <- c(0,0,0)              # vector of means of measurement errors.
va_UC <- c(1,2, 0.5)           # vector of standard deviation of measurement errors.
sk_UC <- c(0,0,0)              # Vector of skewness of measurement errors.
ku_UC <- c(3,3,3)              # Vector of kurtosis of measurement errors.

# example for generation of measurement error matrix
UC <- data_gen(obs,mu_UC, va_UC, sk_UC, ku_UC)

# with default vector of decision costs
C <- c(1,1,1,1)                # vector of decision costs
H <- rbmcc(X, UC, C)           # for subgroups of size 1
plot(H)                        # plot RBMCC

H_opt <- rbmcc_opt(X, UC, C)   # optimal risk-based multivariate control chart

# with vector of proportional decision costs
C <- c(1, 5, 60, 5)        # vector of decision costs
H <- rbmcc(X, UC, C)           # for subgroups of size 1
H_opt <- rbmcc_opt(X, UC, C)   # optimal risk-based multivariate control chart

# with vector of proportional decision costs and sugbroup size 3
C <- c(1, 5, 60, 5)           # vector of decision costs
H <- rbmcc(X, UC, C, 3)           # for subgroups of size 3
H_opt <- rbmcc_opt(X, UC, C, 3)   # optimal risk-based multivariate control chart

# Plot of Hotelling's T2 and optimal risk based multivariate control charts

plot(H_opt)

# Example of considering the real sample

data("t2uc")                # load the dataset

X <- as.matrix(t2uc[,1:2])  # get optical measurements ar "real" values
UC <- as.matrix(t2uc[,5:6]) # get measurement errors
C <- c(1,20,160,5) # define cost structure

# Fit optimized RBT2 control chart
R <- rbmcc_opt(X, UC, C, 1,confidence_level = 0.99)
summary(R) # summarize the results
plot(R)    # plot the result

}
\keyword{multivariate}
\concept{control chart}

