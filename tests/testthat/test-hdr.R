test_that("BoxCox and InvBoxCox are inverses", {
  x <- c(0.1, 0.5, 1, 2, 5)
  lambda_vals <- c(0, 0.25, 1)
  for(l in lambda_vals){
    y <- BoxCox(x, l)
    x_rec <- InvBoxCox(y, l)
    expect_equal(x_rec, x, tolerance = 1e-8)
  }
})

test_that("hdrbw returns positive numeric for faithful data (quick check)", {
  # use a smaller Monte Carlo sample to keep test fast
  h <- hdrbw(faithful$eruptions, 0.55)
  expect_equal(h, 0.2155, tolerance = 5e-3)
})

test_that("hdr and hdr.den return expected structure", {
  hd <- hdr(faithful$eruptions, prob = 50)
  expect_type(hd, "list")
  expect_true(all(c("hdr", "mode", "falpha") %in% names(hd)))
  # hdr matrix should have one row for a single prob value
  expect_true(is.matrix(hd$hdr))
  expect_equal(dim(hd$hdr), c(1L,4L))
  expect_equal(hd$hdr[1,], c(1.844, 2.033, 4.052, 4.711), tolerance = 5e-3)
  expect_equal(hd$mode, 4.416, tolerance = 5e-3)
  expect_equal(hd$falpha, c(`50%` = 0.434), tolerance = 5e-3)

  den <- density(faithful$eruptions, bw = hdrbw(faithful$eruptions, 50, nMChdr = 5000))
  hd2 <- hdr.den(faithful$eruptions, prob = 50, den = den)
  expect_type(hd2, "list")
  expect_true(all(c("hdr", "mode", "falpha") %in% names(hd2)))
  expect_equal(dim(hd2$hdr), c(1L,4L))
  expect_equal(hd$hdr, hd2$hdr, tolerance = 5e-3)
  expect_equal(hd$mode, hd2$mode, tolerance = 5e-3)
  expect_equal(hd$falpha, hd2$falpha, tolerance = 5e-3)
})

test_that("hdrconf returns hdrconf structure", {
  den <- density(faithful$eruptions, bw = hdrbw(faithful$eruptions, 50, nMChdr = 5000))
  m <- hdrconf(sort(faithful$eruptions), den, conf = 95)
  expect_s3_class(m, "hdrconf")
  expect_true(all(c("hdr", "hdr.lo", "hdr.hi", "falpha", "falpha.ci") %in% names(m)))
  expect_equal(m$hdr, c(1.536, 2.500, 3.492, 5.062), tolerance = 5e-3)
})
