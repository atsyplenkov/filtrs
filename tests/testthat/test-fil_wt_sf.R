library(sf)
library(filtrs)

test_that("fil_wt_sf returns an sf object", {
  # Assuming you have a predefined sf LINESTRING object for testing
  test_line <- st_linestring(matrix(c(0, 1, 1, 0, 2, 1), ncol = 2, byrow = TRUE)) %>%
    st_sfc(crs = 4326) %>%
    st_as_sf()

  result <- fil_wt_sf(test_line, lamda = 10, order = 2)
  expect_s3_class(result, "sf")
})

test_that("fil_wt_sf keeps start and end points unchanged with keep_start = TRUE", {
  test_line <- st_linestring(matrix(c(0, 1, 1, 0, 2, 1), ncol = 2, byrow = TRUE)) %>%
    st_sfc(crs = 4326) %>%
    st_as_sf()

  result <- fil_wt_sf(test_line, lamda = 10, order = 2, keep_start = TRUE)
  result_coords <- st_coordinates(result)
  original_coords <- st_coordinates(test_line)

  expect_equal(result_coords[c(1, nrow(result_coords)), ], original_coords[c(1, nrow(original_coords)), ])
})

test_that("fil_wt_sf handles planar coordinates correctly", {
  # Assuming a planar CRS for testing
  test_line <- st_linestring(matrix(c(0, 1, 1, 0, 2, 1), ncol = 2, byrow = TRUE)) %>%
    st_sfc(crs = 3857) %>%
    st_as_sf()

  result <- fil_wt_sf(test_line, lamda = 10, order = 2)
  expect_s3_class(result, "sf")
  # Additional checks can be added here to verify the correctness of the smoothing
})

test_that("fil_wt_sf handles angular coordinates correctly", {
  # Assuming a longlat CRS for testing
  test_line <- st_linestring(matrix(c(-73.935242, 40.730610, -73.935242, 40.731610), ncol = 2, byrow = TRUE)) %>%
    st_sfc(crs = 4326) %>%
    st_as_sf()

  result <- fil_wt_sf(test_line, lamda = 10, order = 2)
  expect_s3_class(result, "sf")
  # Additional checks can be added here to verify the correctness of the smoothing
})

test_that("fil_wt_sf throws an error for unsupported geometry types", {
  # Assuming a POINT geometry for testing, which is unsupported
  test_point <- st_point(c(0, 1)) %>%
    st_sfc(crs = 4326) %>%
    st_as_sf()

  expect_error(fil_wt_sf(test_point, lamda = 10, order = 2))
})
