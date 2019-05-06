context('Data standardization functions')

test_that('Low level standardize and unstandardize functions work.', {
    ndata <- 10
    vec <- seq(1,ndata)
    test_data <- data.frame(alpha=vec, bravo=22+vec,
                            charlie=10*vec, region=rep('foo',ndata),
                            stringsAsFactors=FALSE)

    tstd <- standardize(test_data, c('alpha','charlie'))

    ## excluded columns should be unmodified
    expect_equal(tstd$bravo, test_data$bravo)
    expect_equal(tstd$region, test_data$region)

    means <- c(alpha=mean(test_data$alpha), charlie=mean(test_data$charlie))
    scales <- c(alpha=sd(test_data$alpha), charlie=sd(test_data$charlie))

    expect_equal(attr(tstd, 'mean'), means)
    expect_equal(attr(tstd, 'scale'), scales)

    for(var in c('alpha','charlie')) {
        stdvar <- (test_data[[var]] - mean(test_data[[var]])) /
          sd(test_data[[var]])
        expect_equal(tstd[[var]], stdvar,
                     info=paste('var = ', var))
    }

    tunstd <- unstandardize(tstd)

    ## Check that the round trip works.
    expect_equal(tunstd, test_data)
})

