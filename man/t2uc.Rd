\name{t2uc}
\alias{t2uc}
\docType{data}
\title{
Sample data for Risk-based Multivariate Control Chart
}

\description{
This data set contains measured product characteristic values for handbrake cylinder products. The measured product characteristics are cutting length and main diameter respectively for 50 pieces. Each parameter of each product was measured twice, first with a high-precision optical measurement machine and secondly with manual height measurement device/caliper. Measurement errors are estimated as the difference between the optical and manual measurement results. This dataset can be used to validate Risk-based Multivariate control charts.

}

\usage{data("t2uc")}
\format{
  A data frame with 50 observations on the following 6 variables.
  \describe{
    \item{\code{length_optical}}{A numeric vector of optical measurement results regarding cutting length [mm].}
    \item{\code{diameter_optical}}{A numeric vector of optical measurement results regarding the main diameter [mm].}
    \item{\code{length_manual}}{A numeric vector of manual measurement (height gauge) results regarding cutting length [mm].}
    \item{\code{diameter_manual}}{A numeric vector of manual measurement (caliper) results regarding the main diameter [mm].}
    \item{\code{length_error}}{A numeric vector of measurement erros estimated as the difference between manual and optical measurement results associated with cutting length of the product.}
    \item{\code{diameter_error}}{A numeric vector of measurement erros estimated as the difference between manual and optical measurement results associated with the main diameter of the product.}
  }
}

\references{
Katona, A. I. (2021). Validation of risk-based quality control techniques: a case study from the automotive industry. Journal of Applied Statistics, 1-20.
}
\examples{
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
\keyword{datasets}
