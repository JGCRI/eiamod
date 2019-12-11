## Functions for working with dates and times
##
#' Return time since the earliest time in a vector
#'
#' For a vector of times, return a vector of times since the minimum
#' time in the vector.
#'
#' @param t Vector of times.
#' @param unit Units to return the differences in.
#' @export
timesince <- function(t, unit='hours')
{
    assertthat::assert_that(inherits(t, 'POSIXt'))
    mint <- min(t)
    as.numeric(t-mint, units=unit)
}
