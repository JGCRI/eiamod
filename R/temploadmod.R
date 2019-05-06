#### First order modeling of load from temperature

#' Create models for load as a function of temperature
#'
#' (Note this is creating a model for a variable called "load", not, as the name
#' might suggest, loading a model from some storage location.)
#' The modeling is done separately for each region, and a list of regional
#' models is returned.
#'
#' @param model Modeling function to use.  The function must conform to the
#' \code{\link[stats]{lm}} conventions.
#' @param hourly_data Data frame of hourly data.  If omitted, then
#' \code{\link{region_hourly}} is used.
#' @param ... Additional arguments passed to the modeling function.
#' @return List of model objects, one for each region.
#' @export
load_model <- function(model=stats::lm, hourly_data=NULL, ...)
{
    if(is.null(hourly_data)) {
        hourly_data <- region_hourly
    }

    regional_data <- split(hourly_data, hourly_data$region)

    lapply(regional_data, function(h) {
               model(formula=load~temperature, data=h, ...)
           })
}

