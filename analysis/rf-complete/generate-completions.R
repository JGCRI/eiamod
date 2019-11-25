library('dplyr')

load_temperature <- function()
{
    temperature <- readRDS('temp-by-hour-pca.rds') %>% select(-pca)  # pca column in this dataset is bad.
    pca_mapping <- read.csv('control_area_to_eia_id.csv', stringsAsFactors = FALSE) %>%
        rename(pca=Abbreviated.PCA.Name) %>%
        select(c('NAME', 'pca'))
    temperature <- left_join(temperature, pca_mapping, by='NAME')
    select(temperature, year, day, hour, temp, pca) %>% rename(doy=day)
}

complete_missing_years <- function(elec, temperature, fillyears=c(2007,2008), fillpca='WACM')
{
    set.seed(867-5309)

    ## create a column for the calendar year
    elec$calyear <- lubridate::year(elec$datetime)
    elec$hour <- lubridate::hour(elec$datetime)
    allyears <- unique(elec$calyear)
    trainyears <- allyears[!(allyears %in% fillyears)]

    electrn <- filter(elec, calyear %in% trainyears) %>% select(calyear, doy, hour, pca, datetime, load)
    temptrn <- filter(temperature, year %in% trainyears, pca==fillpca) %>% rename(calyear=year)

    trndata <- tidyr::spread(electrn, pca, load) %>%
        left_join(temptrn, by=c('calyear', 'doy', 'hour')) %>%
        select(-calyear, -doy, -hour, -pca)
    ## There are a few hours at the beginning and end of the dataset where not all of the PCAs have data
    ## (due to each starting and ending at midnight in its own time zone, so filter these)
    trndata <- trndata[complete.cases(trndata), ]

    ## Get the column names for the predictors.
    predcols <- names(select(trndata, -datetime))
    predcols <- predcols[predcols != fillpca]

    ## Hold back one year as a test set
    testyr <- sample(trainyears, 1)
    testdata <- filter(trndata, lubridate::year(datetime) == testyr)
    fitdata <- filter(trndata, lubridate::year(datetime) != testyr)

    fitx <- fitdata[, predcols]
    fity <- fitdata[[fillpca]]
    testx <- testdata[, predcols]
    testy <- testdata[[fillpca]]

    fit <- randomForest::randomForest(x=fitx, y=fity, xtest=testx, ytest=testy,
                                      importance=TRUE, keep.forest=TRUE,
                                      ntree = 500
                                      )

    ## Use the model to predict the missing data
    elecfill <- filter(elec, calyear %in% fillyears) %>% select(calyear, doy, hour, pca, datetime, load)
    tempfill <- filter(temperature, year %in% fillyears, pca==fillpca) %>% rename(calyear=year)
    filldata <- tidyr::spread(elecfill, pca, load) %>%
        left_join(tempfill, by=c('calyear', 'doy', 'hour')) %>%
        select(-calyear, -doy, -hour, -pca)
    pdata <- filldata[ , predcols]

    predictions <- predict(fit, pdata)

    ## fill in the values we just predicted
    fillin <- data.frame(datetime = filldata$datetime, fillload = predictions, pca = fillpca)
    if('fillload' %in% names(elec)) {
        elec <- select(elec, -fillload)
    }
    elecfill <- full_join(elec, fillin, by=c('datetime','pca')) %>%
        mutate(load = if_else(is.na(fillload), load, fillload))

    list(filled_data=elecfill, fit=fit)
}

elec <- readRDS('elec-by-hour-2006-2017_new.rds')
temp <- load_temperature()

elec_fill_WACM <- complete_missing_years(elec, temp, c(2007,2008), 'WACM')
elec_fill_WACM_OVEC <- complete_missing_years(elec_fill_WACM$filled_data, temp, 2017, "OVEC")

saveRDS(elec_fill_WACM_OVEC, 'random-forest-fill-results-WACM+OVEC.rds')
fillrslt <- dplyr::filter(rslt$filled_data,
                          (calyear %in% c(2007,2008) & pca=='WACM') | (calyear == '2017' & pca=='OVEC')) %>%
  select(-fillload)
write.csv(fillrslt, 'random-forest-fill-values.csv')
