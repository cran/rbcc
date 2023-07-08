\name{summary.rbcc}
\alias{summary.rbcc}
\alias{summary.rbcusumcc}
\alias{summary.rbmcc}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Summary of Risk-based Control Charts
}
\description{
Print summary of Risk-based Univariate (shewhart, exponentially weighted
moving average(EWMA), moving average (MA) and cumulative sum (CUSUM) or
Multivariate Control Chart
}
\usage{
\method{summary}{rbcc}(object, digits = getOption("digits"), ...)
\method{summary}{rbcusumcc}(object, digits = getOption("digits"), ...)
\method{summary}{rbmcc}(object, digits = getOption("digits"), ...)
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{an object of class 'rbcc', 'rbcusumcc', or 'rbmcc'.}
  \item{digits}{the number of significant digits to use when \code{add.stats = TRUE}.}
  \item{...}{additional arguments affecting the summary produced.}
}
\value{No return value, called for side effects}
\references{
Kosztyán, Z. T., and Katona, A. I. (2016). Risk-based multivariate control chart. Expert Systems with Applications, 62, 250-262.
}
\author{
Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan*

e-mail: kzst@gtk.uni-pannon.hu
}

\seealso{\code{\link{data_gen}}, \code{\link{rbcc}}, \code{\link{rbcc_opt}}, \code{\link{rbewmacc}}, \code{\link{rbewmacc_opt}}, \code{\link{rbmacc}},  \code{\link{rbmacc_opt}}, \code{\link{rbmcc}}, \code{\link{rbmcc_opt}}, \code{\link{plot.rbcc}}.}

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

X <- data_gen (obs, mu_X, va_X, sk_X, ku_X)    # Simulation of 200 obervations of 1 variable.
# Simulation of 200 muasurement erros related to 1 variable.
UC <- data_gen(obs,mu_UC, va_UC, sk_UC, ku_UC)
# Construction of risk-based Xbar chart with default vector of decision costs
C <- c(1,1,1,1)                                 # vector of decision costs
H <- rbcc(X, UC, C, n=3, type="xbar")           # for subgroups of size 3
plot(H)                                         # plot RBCC

 # optimal risk-based xbar control chart
H_opt <- rbcc_opt(X, UC, C, n=3, type="xbar")
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
mu_UC <- c(0,0,0)        # vector of means of measurement errors.
va_UC <- c(1,2, 0.5)     # vector of standard deviation of measurement errors.
sk_UC <- c(0,0,0)        # Vector of skewness of measurement errors.
ku_UC <- c(3,3,3)        # Vector of kurtosis of measurement errors.

# Example for generation of measurement error matrix of 3 variables.
UC <- data_gen(obs,mu_UC, va_UC, sk_UC, ku_UC)

# with default vector of decision costs
C <- c(1,1,1,1)                # vector of decision costs
H <- rbmcc(X, UC, C)           # for subgroups of size 1
summary(H)                     # summarize the results
plot(H)                        # plot RBMCC

H_opt <- rbmcc_opt(X, UC, C)# optimal risk-based multivariate control chart

# with vector of proportional decision costs
C <- c(1, 5, 60, 5)        # vector of decision costs
H <- rbmcc(X, UC, C)           # for subgroups of size 1
H_opt <- rbmcc_opt(X, UC, C)   # optimal risk-based multivariate control chart

# with vector of proportional decision costs and sugbroup size 3
C <- c(1, 5, 60, 5)           # vector of decision costs
H <- rbmcc(X, UC, C, 3)        # for subgroups of size 3
H_opt <- rbmcc_opt(X, UC, C, 3)# optimal risk-based multivariate control chart
summary(H_opt)                  # summarize the results

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

\keyword{univariate}
\keyword{multivariate}
\concept{control chart}
