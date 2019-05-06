context('Load modeling function')

test_that('Load modeling function works', {
    ## What we're actually testing here is that the modeling function returns
    ## a list of results of applying the modeling function to each region in turn
    ## and that optional arguments get passed correctly.  So, we create a test
    ## function that does nothing more than report its arguments.
    testfun <- function(formula, data, opt1=NA, opt2=NA) {
        list(formula=formula, data=data, opt1=opt1, opt2=opt2)
    }

    ##  Check with a small input data set
    ndata <- 10
    testdata <- data.frame(EconYear=2006, quarter=1, week=1, region='FOO',
                           time=Sys.time() + 3600*seq(1,ndata), load=300+seq(1,ndata),
                           temperature=270+seq(1,ndata))
    rslt <- load_model(testfun, testdata, opt2='foo')
    expect_equal(rslt,
                 list(FOO=list(formula=load~temperature, data=testdata, opt1=NA, opt2='foo')))

    ## Test overriding the formula
    rslt <- load_model(testfun, testdata, formula=load~temperature^2, opt1='foo', opt2='bar')
    expect_equal(rslt,
                 list(FOO=list(formula=load~temperature^2, data=testdata, opt1='foo', opt2='bar')))

    ## Now check with default data
    rslt <- load_model(testfun, opt1='foo')
    rgns <- unique(region_hourly$region)
    expect_true(is.list(rslt))
    expect_length(rslt, length(rgns))
    expect_equal(names(rslt), rgns)
    for(rgn in rgns) {
        d <- region_hourly[region_hourly$region==rgn,]
        expect_equal(rslt[[rgn]],
                     list(formula=load~temperature, data=d, opt1='foo', opt2=NA))
    }
})
