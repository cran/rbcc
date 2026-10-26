\name{t2uc}
\alias{t2uc}
\docType{data}
\title{Brake-Cylinder Measurement Data}
\description{
Measurements of two brake-cylinder characteristics obtained with a
high-precision optical system and production measurement devices. Measurement
errors are the differences between production and optical measurements.
}
\usage{data("t2uc")}
\format{
A data frame with 50 observations and six numeric variables:
\describe{
\item{length_optical}{Optical cutting-length measurement in millimeters.}
\item{diameter_optical}{Optical main-diameter measurement in millimeters.}
\item{length_manual}{Manual cutting-length measurement in millimeters.}
\item{diameter_manual}{Manual main-diameter measurement in millimeters.}
\item{length_error}{Manual minus optical cutting-length measurement.}
\item{diameter_error}{Manual minus optical main-diameter measurement.}
}
}
\source{Automotive-industry measurement study.}
\references{
Katona, A. I. (2021). Validation of Risk-Based Quality Control Techniques: A
Case Study from the Automotive Industry. \emph{Journal of Applied Statistics}.
}
\examples{
data("t2uc")
X <- as.matrix(t2uc[, 1:2])
UC <- as.matrix(t2uc[, 5:6])
fit <- rbmcc_opt(X, UC, c(1, 20, 160, 5))
fit$cost0
}
\keyword{datasets}
