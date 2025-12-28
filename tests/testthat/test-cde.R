test_that("cde bandwidths", {
  cobj <- cde(faithful$waiting, faithful$eruptions)
  expect_s3_class(cobj, "cde")
  expect_equal(unname(cobj$a), 1.859, tolerance = 5e-3)
  expect_equal(unname(cobj$b), 0.524, tolerance = 5e-3)
  cdeb <- cde.bandwidths(faithful$waiting, faithful$eruptions, method = 2)
  expect_equal(cobj$a, cdeb$a)
  expect_equal(cobj$b, cdeb$b)
  cdeb <- cde.bandwidths(faithful$waiting, faithful$eruptions, method = 1)
  expect_equal(unname(cdeb$a), 4.344, tolerance = 5e-3)
  expect_equal(unname(cdeb$b), 0.2385, tolerance = 5e-3)
  cdeb <- cde.bandwidths(faithful$waiting, faithful$eruptions, method = 3)
  expect_equal(unname(cdeb$a), 4.292, tolerance = 5e-3)
  expect_equal(unname(cdeb$b), 0.524, tolerance = 5e-3)
  cdeb <- cde.bandwidths(faithful$waiting, faithful$eruptions, method = 4)
  expect_equal(unname(cdeb$a), 2.2312, tolerance = 5e-3)
  expect_equal(unname(cdeb$b), 0.2097, tolerance = 5e-3)

  # hdr.cde
  hdrres <- hdr.cde(cobj, prob = c(50,95), plot = FALSE)
  expect_type(hdrres, "list")
  expect_all_true(unlist(lapply(hdrres, class)) == "hdr")
  expect_equal(length(hdrres), length(cobj$x))
})

test_that("modalreg computes branches without plotting", {
  x <- faithful$waiting
  y <- faithful$eruptions
  bands <- cde.bandwidths(x, y, method = 2)
  mr <- modalreg(x, y, xfix = seq(min(x), max(x), length.out = 20), a = bands$a, b = bands$b,
                 deg = 0, iter = 10, P = 2, plot.type = "n")
  expect_type(mr, "list")
  expect_true(all(c("xfix", "fitted.values", "bandwidths", "density", "threshold") %in% names(mr)))
  expect_equal(length(mr$xfix), 20)
  expect_equal(dim(mr$fitted.values)[1], 2)
})
