\name{rbmacc}
\alias{rbmacc}

\title{
Risk-based Moving Average Control Charts
}
\description{
Calculate Risk-based Moving Average univarate Control Charts
}
\usage{
rbmacc (X, UC, C, n=1, w=2, K=3)
}
\arguments{
  \item{X}{vector of variable (numeric vector). Either can be simulated using data_gen or defined by using available data set.}
  \item{UC}{vector  of measuerement error (numeric vector).Either can be simulated using data_gen or defined by using available previous information.}
  \item{C}{vector of decision costs (default value is vector of 1).}
  \item{n}{the sample size for grouping. For individual obervations use n=1).}
   \item{w}{moving average spam. The defualt value is 2. }
  \item{K}{a correction component(default value is 3).}
}

\value{

\item{cost0}{Total cost of a monitoring  process}
\item{cost1}{Total cost of correct acceptance related to a process monitoring}
\item{cost2}{Total cost of decision error type 1 related to a process monitoring}
\item{cost3}{Total cost of decision error type 2 related to a process monitoring}
\item{cost4}{Total cost of correct reject related to a process monitoring}
\item{LCLx}{Lower control limit of MA chart for a given data}
\item{UCLx}{Upper control limit of MA control chart for a given data}
\item{LCLy}{Lower control limit of MA chart for for a given data with measurement
uncertainity}
\item{UCLy}{Upper control limit of MA control chart for a given data with
measurement uncertainity}
\item{real}{Real values of MA statistic for a given data}
\item{Observed}{Observed values of MA statistic with measurement errors for a given data}
}
\references{
Katona, A. I., Saghir, A., Hegedűs, C., & Kosztyán, Z. T. (2023). Design of Risk-Based Univariate Control Charts with Measurement Uncertainty. IEEE Access.

Kosztyán, Z. T., & Katona, A. I. (2016). Risk-based multivariate control chart. Expert Systems with Applications, 62, 250-262.
}
\author{
Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan*

e-mail: kzst@gtk.uni-pannon.hu
}



\seealso{\code{\link{data_gen}}, \code{\link{rbcc}}, \code{\link{rbcc_opt}}, \code{\link{rbcusumcc}}, \code{\link{rbcusumcc_opt}},\code{\link{rbewmacc}}, \code{\link{rbewmacc_opt}},  \code{\link{rbmacc_opt}}, \code{\link{rbmcc}}, \code{\link{rbmcc_opt}}, \code{\link{plot.rbcc}}, \code{\link{summary.rbcc}}.}

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
H <- rbmacc(X, UC, C, w=2, n=1)           # for subgroups of size 1
summary(H)                                # summarize the reults
plot(H)                                   # plot RBMACC

# with vector of proportional decision costs
C <- c(1, 5, 60, 5)                       # vector of decision costs
H <- rbmacc(X, UC, C, w=2, n=2)           # for subgroups of size 1
summary(H)                                # summarize the reults
plot(H)                                   # plot RBMACC

}
\keyword{MA}
\concept{control chart}
