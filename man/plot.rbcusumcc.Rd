\name{plot.rbcucumcc}
\alias{plot.rbcusumcc}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Plot function for Risk-based Control Charts
}
\description{
Plot function for Risk-based Univariate cumulative sum (CUSUM) Charts
}
\usage{
\method{plot}{rbcusumcc}(x, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{an object of class 'rbcusumcc'.}
  \item{...}{other graphical parameters.}
}
\value{No return value, called for side effects}
\references{
Katona, A. I., Saghir, A., Hegedűs, C., & Kosztyán, Z. T. (2023). Design of Risk-Based Univariate Control Charts with Measurement Uncertainty. IEEE Access, 11, 97567-97573.

Kosztyán, Z. T., & Katona, A. I. (2016). Risk-based multivariate control chart. Expert Systems with Applications, 62, 250-262.
}
\author{
Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan*

e-mail: kzst@gtk.uni-pannon.hu
}


\seealso{\code{\link{data_gen}}, \code{\link{rbcc}}, \code{\link{rbcc_opt}}, \code{\link{rbcusumcc}}, \code{\link{rbcusumcc_opt}}, \code{\link{rbewmacc}}, \code{\link{rbewmacc_opt}}, \code{\link{rbmacc}},  \code{\link{rbmacc_opt}}, \code{\link{rbmcc}}, \code{\link{rbmcc_opt}}, \code{\link{summary.rbcc}}.}

\examples{
# Data Generation and Xbar chart.

## Example for generation of data vector X and measuremenet error vector UC.
obs <- 200                 # Total number of observations of a process.
mu_X <- c(0)               # Define data mean.
va_X  <- c(1)              # Define data standard deviation.
sk_X <- c(0)               # Define data skewness.
ku_X <- c(3)               # Define data kurtosis.
mu_UC <- c(0)              # Define mean of measurement errors.
va_UC <- c(1)              # Define standard deviation of measurement errors.
sk_UC <- c(0)              # Define skewness of measurement errors.
ku_UC <- c(3)              # Define kurtosis of measurement errors.

# Simulation of 200 obervations of 1 variable.
X <- data_gen (obs, mu_X, va_X, sk_X, ku_X)

# Simulation of 200 muasurement erros related to 1 variable.
UC <- data_gen(obs,mu_UC, va_UC, sk_UC, ku_UC)

# Construction of risk-based cusum chart with default vector of decision costs
C <- c(1,1,1,1)                                          # vector of decision costs
H <-  rbcusumcc(X, UC, C, n=1,T=5, se.shift=1,K=5)       # for subgroups of size 1
plot(H)                                                  # plot RBCUSUMCC

# optimal risk-based cusum control chart
H_opt <- rbcusumcc_opt (X, UC, C, n=1, T=5, se.shift=1, K_init=0, LKL=0, UKL=6)
plot(H_opt) 
}

\keyword{cumulative sum}
\concept{control chart}
