library(eiamod)
library(earth)


stdata <- standardize_byrgn(region_hourly, c('load','temperature'))

rsltearth <- load_model(earth, hourly_data=stdata)

ep <- as.vector(sapply(rsltearth, predict))
stdata <- dplyr::mutate(stdata, residual_load = load - ep)

residual_load <- dplyr::select(stdata, EconYear, quarter, week, region, time, residual_load)
usethis::use_data(residual_load, compress='xz')

