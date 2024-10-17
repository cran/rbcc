\name{rbewmacc_opt}
\alias{rbewmacc_opt}

\title{
Optimized Risk-based EWMA Control Charts
}
\description{
Calculate Optimized Risk-based Univariate exponentially weighted moving average
Control Chart
}
\usage{
rbewmacc_opt(X, UC, C, n=1, lambada=0.20, nsigmas=3, K_init= 0, LKL=0, UKL=5)
}

\arguments{
  \item{X}{vector of variable (numeric vector). Either can be simulated using data_gen or defined by using available data set.}
  \item{UC}{vector  of measuerement error (numeric vector).Either can be simulated using data_gen or defined by using available previous information.}
  \item{C}{vector of decision costs (default value is vector of 1).}
   \item{n}{the sample size for grouping. For individual obervations use n=1).}
   \item{lambada}{a weight or smoothing constant for EWMA control charts. The value is between (0,1). The defualt value is 0.20. }
  \item{nsigmas}{the charting multiplier(default value is 3)}
     \item{K_init}{Set correction component to 0 by default (default value is 0)}
  \item{LKL}{Lower limit of K parameter (default value is 0)}
  \item{UKL}{Upper limit of K parameter (default value is 5)}
}

\value{
\item{cost0}{Total cost of a monitoring process}
\item{cost1}{Total cost of correct acceptance related to a process monitoring}
\item{cost2}{Total cost of decision error type 1 related to a process monitoring}
\item{cost3}{Total cost of decision error type 2 related to a process monitoring}
\item{cost4}{Total cost of correct reject related to a process monitoring}
\item{baselimit}{UCL of a EWMA chart for a given data}
\item{limit}{UCL of optimized risk based EWMA control chart for a given data}
\item{real}{Real values of plotting statistic for a given data}
\item{Observed}{Observed plotting statistic with measurement errors for a given data}
\item{Kopt}{Optimal 'K' paramater of risk-based EWMA control chart for a given data}
}
\references{
Katona, A. I., Saghir, A., Hegedűs, C., & Kosztyán, Z. T. (2023). Design of Risk-Based Univariate Control Charts with Measurement Uncertainty. IEEE Access.

Kosztyán, Z. T., & Katona, A. I. (2016). Risk-based multivariate control chart. Expert Systems with Applications, 62, 250-262.
}
\author{
Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan*

e-mail: kzst@gtk.uni-pannon.hu
}

\seealso{\code{\link{data_gen}}, \code{\link{rbcc}}, \code{\link{rbcc_opt}}, \code{\link{rbcusumcc}}, \code{\link{rbcusumcc_opt}},\code{\link{rbewmacc}}, \code{\link{rbmacc}},  \code{\link{rbmacc_opt}}, \code{\link{rbmcc}}, \code{\link{rbmcc_opt}}, \code{\link{plot.rbcc}}, \code{\link{summary.rbcc}}.}

\examples{
# Data generation for vector X
mu_X <- c(0)               # Define data mean.
va_X  <- c(1)              # Define data standard deviation.
sk_X <- c(0)               # Define data skewness.
ku_X <- c(3)               # Define data kurtosis.
obs <- 200                 # Total number of observations of a process.

X <- data_gen (obs, mu_X, va_X, sk_X, ku_X)

# Data generation for measurement error vector UC

mu_UC <- c(0)               # Define mean of measurement errors.
va_UC <- c(1)               # Define standard deviation of measurement errors.
sk_UC <- c(0)               # Define skewness of measurement errors.
ku_UC <- c(3)               # Define kurtosis of measurement errors.

UC <- data_gen(obs,mu_UC, va_UC, sk_UC, ku_UC)

C <- c(1,1,1,1)                           # Define a vector of decision costs.
H <- rbewmacc(X, UC, C)                   # for subgroups of size 1
# fit optimal risk-based EWMA control chart
H_opt <- rbewmacc_opt(X, UC, C, n=1,lambada=0.20,nsigmas=3,K_init= 0,LKL=0,UKL=5)
plot(H_opt)                              # plot RBEWMACC

# with vector of proportional decision costs
C <- c(1, 5, 60, 5)               # vector of decision costs
H <- rbewmacc(X, UC, C)           # traditional risk-based EWMA control chat

# fit optimal risk-based EWMA control chart
H_opt <- rbewmacc_opt(X, UC, C, n=1,lambada=0.20,nsigmas=3,K_init= 0,LKL=0,UKL=5)
plot(H_opt)                           # plot RBEWMACC


}
\keyword{multivariate}
\concept{control chart}

