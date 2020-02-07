context('Time utilities')

test_that('timesince works correctly', {
    timeseq <- ISOdatetime(1863, 11, 19, 15, 0, 0, tz='EST') + 3600*seq(0,10)
    ts <- timesince(timeseq)
    expect_equal(ts, seq(0,10))

    ts <- timesince(timeseq, 'mins')
    expect_equal(ts, seq(0,600,60))
})
