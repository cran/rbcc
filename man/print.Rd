\name{print}
\alias{print}
\alias{print.rbcc}
\alias{print.summary.rbcc}
\alias{print.rbcusumcc}
\alias{print.summary.rbcusumcc}
\alias{print.rbmcc}
\alias{print.summary.rbmcc}

\title{
Print function for Risk-based Univariate and Multivariate Control Charts
}
\description{
Print summary of Risk-based Univariate and Multivariate control charts
}
\usage{
\method{print}{rbcc}(x, digits = getOption("digits"), ...)
\method{print}{summary.rbcc}(x, digits = getOption("digits"), ...)
\method{print}{rbcusumcc}(x, digits = getOption("digits"), ...)
\method{print}{summary.rbcusumcc}(x, digits = getOption("digits"), ...)
\method{print}{rbmcc}(x, digits = getOption("digits"), ...)
\method{print}{summary.rbmcc}(x, digits = getOption("digits"), ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{an object of class 'rbcc'.}
  \item{digits}{the number of significant digits to use when \code{add.stats = TRUE}.}
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
### EXAMPLES FOR UNIVARIATE RISK-BASED X-BAR CHARTS

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

# Construction of risk-based Xbar chart with default vector of decision costs
C <- c(1,1,1,1)                            # vector of decision costs
H <- rbcc(X, UC, C, n=3, type="xbar")      # for subgroups of size 3
print(H)

# optimal risk-based xbar control chart
H_opt <- rbcc_opt(X, UC, C, n=3, type="xbar")
print(H_opt)

### EXAMPLES FOR UNIVARIATE RISK-BASED CUSUM CHARTS

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
H <- rbcusumcc(X, UC, C, n=1,T=5, se.shift=1,K=5)       # for subgroups of size 1
print(H)

# optimal risk-based cusum control chart
H_opt <- rbcusumcc_opt (X, UC, C, n=1, T=5, se.shift=1, K_init=0, LKL=0, UKL=6)
print(H_opt)

### EXAMPLES FOR RISK-BASED MULTIVARIATE CONTROL CHARTS

# Data Generation and multivariate T2 chart.
# Data generation for a matrix X
mu_X <- c(0,1,2)               # vector of means.
va_X  <- c(1,2, 0.5)           # vector of standard deviation.
sk_X <- c(0,0.5, 0.8)          # vector of skewness.
ku_X <- c(3,3.5, 4)            # vector of kurtosis.
obs <- 200                     # Total number of observations of a process.

# Example for generation of data matrix X of 200 obervations of 3 variables.
X <- data_gen (obs, mu_X, va_X, sk_X, ku_X)

# Data generation for measurement error matrix UC.
mu_UC <- c(0,0,0)      # vector of means of measurement errors.
va_UC <- c(1,2, 0.5)   # vector of standard deviation of measurement errors.
sk_UC <- c(0,0,0)      # Vector of skewness of measurement errors.
ku_UC <- c(3,3,3)      # Vector of kurtosis of measurement errors.

# Example for generation of measurement error matrix of 3 variables.
UC <- data_gen(obs,mu_UC, va_UC, sk_UC, ku_UC)

# with default vector of decision costs
C <- c(1,1,1,1)                # vector of decision costs
H <- rbmcc(X, UC, C)           # for subgroups of size 1
print(H)

# optimal risk-based multivariate control chart
H_opt <- rbmcc_opt(X, UC, C)
print(H_opt)

# Example of considering the real sample

data("t2uc")                # load the dataset

X <- as.matrix(t2uc[,1:2])  # get optical measurements ar "real" values
UC <- as.matrix(t2uc[,5:6]) # get measurement errors
C <- c(1,20,160,5) # define cost structure

# Fit optimized RBT2 control chart
R <- rbmcc_opt(X, UC, C, 1,confidence_level = 0.99)
print (R)

}

\keyword{univariate}
\concept{control charts}
