## Prepare temperature and electricity load package data


temp <- readr::read_csv('temperature_by_agg_region.csv.gz')
temp <- dplyr::rename(temp, region=ID)

load <- readr::read_csv('load_by_agg_region_2006-2017.csv.gz')
load <- dplyr::rename(load,
                      region=`NERC Region`,
                      time=`Hourly Load Data As Of`,
                      load=`Load (MW)`)

region_hourly <- dplyr::left_join(load, temp, by=c('region','time'))
attr(region_hourly, 'notes') <- c('Load is total over region in MW',
                                  'Temperature is average over region in Kelvin')
usethis::use_data(region_hourly, overwrite=TRUE, compress='xz')
