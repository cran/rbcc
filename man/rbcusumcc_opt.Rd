\name{rbcusumcc_opt}
\alias{rbcusumcc_opt}

\title{
Optimized Risk-based CUSUM Control Charts
}
\description{
Calculate Optimized Risk-based Univariate cumulative sum (CUSUM) Control Chart
}
\usage{
rbcusumcc_opt(X, UC, C, n, T=5, se.shift=1, K_init= 0, LKL=0, UKL=6)
}

\arguments{
  \item{X}{vector of variable (numeric vector). Either can be simulated using data_gen or defined by using available data set.}
  \item{UC}{vector  of measuerement error (numeric vector).Either can be simulated using data_gen or defined by using available previous information.}
  \item{C}{vector of decision costs (default value is vector of 1).}
   \item{n}{the sample size for grouping. For individual obervations use n=1).}
    \item{T}{ A numeric value specifying the number of standard errors of the summary statistics at which the cumulative sum is out of control (The defualt value is 5).}
  \item{se.shift}{The amount of shift to detect in the process, measured in standard errors of the CUSUM statistics (default value is 1).}
     \item{K_init}{Set correction component to 0 by default (default value is 0)}
  \item{LKL}{Lower limit of K parameter (default value is 0)}
  \item{UKL}{Upper limit of K parameter (default value is 6)}
}
\value{
\item{cost0}{Total cost of a monitoring process}
\item{cost1}{Total cost of correct acceptance related to a process monitoring}
\item{cost2}{Total cost of decision error type 1 related to a process monitoring}
\item{cost3}{Total cost of decision error type 2 related to a process monitoring}
\item{cost4}{Total cost of correct reject related to a process monitoring}
\item{LCLx}{Lower decision bound of CUSUM chart for a given data}
\item{UCLx}{Upper decision bound of CUSUM control chart for a given data}
\item{LCLy}{Lower decision bound of CUSUM chart for a given data with measurement
uncertainity}
\item{UCLy}{Upper decision bound of CUSUM chart for a given data with measurement
uncertainity}
\item{cusumx}{Real values of CUSUM statistic for a given data}
\item{cusumy}{Observed values of CUSUM statistic for a given data with
measurement errors}
\item{reall}{Below target real values of CUSUM statistic for a given data}
\item{realu}{Above target real values of CUSUM statistic for a given data}
\item{obsl}{Below target observed values of CUSUM statistic for a given data with
measurement errors}
\item{obsu}{Below target observed values of CUSUM statistic of a given data
with measurement errors}
\item{Kopt}{Optimal 'K' paramater of a risk-based CUSUM control chart}
}
\references{
Katona, A. I., Saghir, A., Hegedűs, C., & Kosztyán, Z. T. (2023). Design of Risk-Based Univariate Control Charts with Measurement Uncertainty. IEEE Access.

Kosztyán, Z. T., & Katona, A. I. (2016). Risk-based multivariate control chart. Expert Systems with Applications, 62, 250-262.
}
\author{
Aamir Saghir, Attila I. Katona, Zsolt T. Kosztyan*

e-mail: kzst@gtk.uni-pannon.hu
}
\seealso{\code{\link{data_gen}}, \code{\link{rbcc}}, \code{\link{rbcc_opt}},\code{\link{rbcusumcc}}, \code{\link{rbewmacc}},\code{\link{rbewmacc_opt}}, \code{\link{rbmacc}},  \code{\link{rbmacc_opt}}, \code{\link{rbmcc}}, \code{\link{rbmcc_opt}}, \code{\link{plot.rbcc}}, \code{\link{summary.rbcc}}.}
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

n <- 1 # For individual obervations use n=1

UC <- data_gen(obs,mu_UC, va_UC, sk_UC, ku_UC)

C <- c(1,1,1,1)                             # Define a vector of decision costs.
H <- rbcusumcc(X, UC, C, n, T=5, se.shift=1, K=5)  # for subgroups of size 1
plot(H)                                           # plot RBCC

# optimal risk-based CUSUM control chart
H_opt <- rbcusumcc_opt(X, UC, C, n, T=5, se.shift=1, K_init= 0, LKL=0, UKL=6)


# with vector of proportional decision costs
C <- c(1, 5, 60, 5)        # vector of decision costs
H <- rbcusumcc(X, UC, C, n, T=5, se.shift=1, K=5)
H_opt <- rbcusumcc_opt(X, UC, C, n, T=5, se.shift=1, K_init= 0, LKL=0, UKL=6)
# optimal risk-based CUSUM control chart

summary(H_opt)                # summarize the reults

# Plot of traditional and optimal risk based cusum control charts
plot(H_opt)
}
\keyword{CUSUM}
\concept{control chart}


