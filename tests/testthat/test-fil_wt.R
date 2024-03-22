library(testthat)

test_that("fil_wt returns a vector of the same length as input", {
  input_vector <- c(1, 2, 3, NA, 5)
  result <- fil_wt(input_vector, 10, 2)
  expect_length(result, length(input_vector))
})

test_that("fil_wt handles vector with no missing values correctly", {
  input_vector <- c(1, 2, 3, 4, 5)
  result <- fil_wt(input_vector, 10, 2)
  expect_type(result, "double")
  expect_true(all(!is.na(result)))
})

test_that("fil_wt does NOT handle vector with all missing values", {
  input_vector <- rep(NA_real_, 5)
  expect_error(fil_wt(input_vector, 10, 2))
})

test_that("fil_wt does not return any NaN values", {
  input_vector <- c(1, NA, 3, 4, 5)
  result <- fil_wt(input_vector, 10, 2)
  expect_false(any(is.nan(result)))
})
