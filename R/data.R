#' Hourly load and temperature data by region
#'
#' This data frame contains all of the data available at hourly resolution,
#' namely, load and temperature.  These items are tabulated by time and NERC
#' region.
#'
#' @format Data frame with 7 columns
#' \describe{
#' \item{EconYear}{Year of the economic quarter.  Because economic quarters are
#' deemed to begin and end on week boundaries, this may not correspond exactly
#' to the calendar year for the data.}
#' \item{quarter}{Economic quarter.}
#' \item{week}{Week within the quarter.}
#' \item{region}{NERC region.}
#' \item{time}{Date and hour.}
#' \item{load}{Electrical load reported in the region (MW).}
#' \item{temperature}{Average temperature across the region.}
#' }
#'
#' The data also has a \code{notes} attribute that may provide additional
#' relevant information.
#'
#' @name region_hourly
NULL
