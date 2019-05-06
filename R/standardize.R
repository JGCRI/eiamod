#### TODO: collapse all this documentation into a single doc file.

#' Standardize one or more variables in a data frame
#'
#' Standardize by subtracting off the mean and dividing by the standard
#' deviation.
#'
#' The mean and scale are recorded in named vectors attached to the
#' output data frame as attributes names \code{mean} and \code{scale},
#' respectively.
#'
#' @param df Data frame with the data to be standardized
#' @param vars Vector of names of columns to be standardized.
#' @return Data frame with the requested variables standardized.
#' @keywords internal
standardize <- function(df, vars)
{
    means <- sapply(vars, function(v) {mean(df[[v]])})
    scales <- sapply(vars, function(v) {sd(df[[v]])})

    for(v in vars) {
        df[[v]] <- (df[[v]]-means[v]) / scales[v]
    }

    attr(df, 'mean') <- means
    attr(df, 'scale') <- scales

    df
}

#' Standardize variables by region
#'
#' This function applies the standardize function to each regional grouping and
#' recombines the resutls into a single data frame.
#'
#' The means and scales for the transformations are stored in the mean and scale
#' attributes of the output.  Each is a list indexed by region, with each list
#' element being a named vector indexed by variable.
#'
#' @param df Data frame with the data to be standardized.
#' @param vars Vecotr of names of columns to be standardized.
#' @return Data frame with the requested variables standardized.
#' @export
standardize_byrgn <- function(df, vars)
{
    dfsplt <- split(df, df[['region']])
    dfstd <- lapply(dfsplt, function(d) {standardize(d, vars)})
    scales <- lapply(dfstd, function(d) {attr(d, 'scale')})
    means <- lapply(dfstd, function(d) {attr(d, 'mean')})

    dfout <- unsplit(dfstd, df[['region']])
    attr(dfout, 'scale') <- scales
    attr(dfout, 'mean') <- means
    dfout
}

#' Unstandardize variables in a data frame
#'
#' Unstandardize by multiplying by the scale and adding the mean.
#'
#' The means and scales for any standardized variables must be recorded in the
#' \code{mean} and \code{scale} attributes of the input data frame.  Only
#' variables mentioned in those attributes will be modified.
#'
#' @param df Data frame with data to be unstandardized.
#' @return Data frame of unstandardized variables
#' @keywords internal
unstandardize <- function(df)
{
    means <- attr(df, 'mean')
    scales <- attr(df, 'scale')

    assertthat::assert_that(setequal(names(means), names(scales)))

    for(v in names(means)) {
        df[[v]] <- df[[v]] * scales[v] + means[v]
    }

    attr(df, 'mean') <- NULL
    attr(df, 'scale') <- NULL

    df
}

#' Unstandardize variables by region
#'
#' This function reverses the \code{\link{standardize_byrgn}} function.
#'
#' @param df Data frame with the data to be unstandardized
#' @return Data frame of unstandardized variables
#' @export
unstandardize_byrgn <- function(df)
{
    dfsplt <- split(df, df[['region']])
    dfunstd <- lapply(names(dfsplt),
                      function(rgn) {
                          d <- dfsplt[[rgn]]
                          attr(d, 'mean') <- attr(df, 'mean')[[rgn]]
                          attr(d, 'scale') <- attr(df, 'scale')[[rgn]]
                          unstandardize(d)
                      })
    unsplit(dfunstd, df[['region']])
}
