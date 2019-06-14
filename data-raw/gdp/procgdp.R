library('readr')
library('dplyr')
library('tidyr')
library('foreach')

readem <- function(dir, label)
{
    ## read the time variable
    time <- read_csv(file.path(dir,'time.csv')) %>%
        mutate(year=as.integer(year), quarter=as.integer(quarter)) %>%
        rename(EconYear=year)

    ## read gas and petroleum, add time
    gas <- bind_cols(time, read_csv(file.path(dir,'gas.csv'), na=c('','nan'))) %>%
        gather(key='week', value='petrol', -EconYear, -quarter, convert=TRUE) %>%
        mutate(week=1+week, petrol=as.numeric(petrol))  # number weeks 1-14 instead of 0-13
    petrol <- bind_cols(time, read_csv(file.path(dir,'petrol.csv'),
                                       na=c('','nan'))) %>%
        gather(key='week', value='gas', -EconYear, -quarter, convert=TRUE) %>%
        mutate(week=1+week, gas=as.numeric(gas))  # same here

    energy <- full_join(gas, petrol, by=c('EconYear','quarter','week')) %>%
        mutate(dataset=label)

    ## read gdp, add time
    gdp <- bind_cols(time, read_csv(file.path(dir, 'gdp.csv'))) %>%
        mutate(dataset=label)

    list(energy=energy, gdp=gdp)
}


readem_all <- function()
{
    datadir <- 'data-raw/gdp'
    alldata <-
        foreach(dataset=c('dev','test','train')) %do% {
            ddir <- file.path(datadir, dataset)
            readem(ddir, dataset)
        }
    ## combine into master datasets
    energy <- foreach(dataset=alldata, .combine=bind_rows) %do% {
        dataset$energy[!is.na(dataset$energy$gas) & !is.na(dataset$energy$petrol),]
    }
    gdp <- foreach(dataset=alldata, .combine=bind_rows) %do% {
        dataset$gdp
    }
    list(energy=energy, gdp=gdp)
}

alldata <- readem_all()
energy_weekly <- alldata$energy
gdp_quarterly <- alldata$gdp

usethis::use_data(energy_weekly, gdp_quarterly, compress='xz')
