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

#' Hourly residual load by region
#'
#' This data frame contains the hourly load data, with load values predicted
#' from the temperature data subtracted off.
#'
#' Load values were standardized prior to fitting the temperature model, so
#' these values are the difference between the temperature prediction of the
#' standardized load and the observed standardized load.
#'
#' @format Data frame with 6 columns
#' \describe{
#' \item{EconYear}{Economic year.  Since quarters are forced to begin and
#' end on week boundaries, this may not match the calendar year.}
#' \item{quarter}{Economic quarter (1-4).}
#' \item{week}{Week within the quarter.}
#' \item{region}{NERC region.}
#' \item{time}{Date and hour.}
#' \item{residual_load}{Electrical load minus the load predicted by the temperature-load model.}
#' }
#'
#' @name residual_load
NULL

#' Weekly petroleum and gas consumption
#'
#' This data is organized by economic year, quarter and week.  All values have
#' been standardized.
#'
#' Natural gas consumption is given only for the categories
#' 'Industrial Consumption', 'Lease and Plant Fuel Consumption', and 'Pipeline &
#' Distribution Use'.  Specifically, natural gas for electrical generation is
#' excluded because it would be redundant with the electicity data, and
#' residential use is excluded because it is primarily temperature driven.
#'
#' @format Data frame with 6 columns
#' \describe{
#' \item{EconYear}{Year of the economic quarter.  Because economic quarters are
#' deemed to begin and end on week boundaries, this may not correspond exactly
#' to the calendar year for the data.}
#' \item{quarter}{Economic quarter.}
#' \item{week}{Week within the quarter.  The number of weeks in a quarter varies
#' a bit (usually it's 13 or 14).  Only weeks that exist for a quarter are included in the
#' dataset.}
#' \item{petrol}{Petroleum product consumption for the week.  Given as a
#' standardized value.}
#' \item{gas}{Natural gas consumption in certain product categories (see
#' details) for the week.  Given as a standardized value.}
#' \item{dataset}{Dataset the quarter was originally assigned to (training, dev,
#' or test)}
#' }
#' @name energy_weekly
NULL

#' Quarterly GDP
#'
#' The data is organized by economic year and quarter.  GDP values are in
#' billions of US dollars (inflation adjusted or not?)
#'
#' @format Data frame with 4 columns
#' \describe{
#' \item{EconYear}{Year of the economic quarter.  Because economic quarters are
#' deemed to begin and end on week boundaries, this may not correspond exactly
#' to the calendar year for the data.}
#' \item{quarter}{Economic quarter.}
#' \item{gdp}{US Gross Domestic Product, billions of USD}
#' \item{dataset}{Dataset the quarter was originally assigned to (training, dev,
#' or test)}
#' }
#' @name gdp_quarterly
NULL
