#' Spatial smoothing with Whittaker-Eilers filter.
#'
#' @description Applies [filtrs::fil_wt_x()] for \code{sf} objects.
#' Since the majority of linear objects (i.e., rivers, roads, etc.)
#' have non-equally spaced coordinates, the vector of sample positions
#' (see [this blog post](https://www.anbowell.com/blog/the-perfect-way-to-smooth-your-noisy-data)
#' for details) is estimated automatically based on the distance between
#' point locations. Depending on planar or angular geometry, the Cartesian or
#' Haversine distance is calculated.
#'
#' @param input \code{sf} object of geometry type LINESTRING. Note that
#' currently, only single lines are supported.
#' @param lamda Double, inherits from [filtrs::fil_wt_x()].
#' @param order Double, inherits from [filtrs::fil_wt_x()].
#' @param keep_start Boolean, should starting/ending points remained unchanged?
#' Default \code{TRUE}
#'
#' @return an \code{sf} object
#' @export
#'
#' @examples
#' if (rlang::is_installed("spData")) {
#' library(sf)
#' library(filtrs)
#' library(spData)
#'
#' rivers <-
#'   seine[3, ]
#'
#' rivers_smoothed <-
#'   fil_wt_sf(rivers, lamda = 10e3, order = 3)
#'
#' plot(
#'   sf::st_geometry(rivers),
#'   col = "grey30",
#'   lwd = 3.5,
#'   axes = TRUE
#' )
#' plot(
#'   sf::st_geometry(rivers_smoothed),
#'   col = 'firebrick3',
#'   lwd = 2,
#'   add = TRUE
#' )
#'
#' # Add the legend
#' legend(
#'   "bottomright",
#'   legend = c("Original", "Smoothed"),
#'   col = c("grey30", "firebrick3"),
#'   lwd = c(3, 3)
#' )
#' }
fil_wt_sf <-
  function(
    input,
    lamda = 10,
    order = 2,
    keep_start = TRUE
  ){

    crs <- sf::st_crs(input)

    coords <- sf::st_coordinates(input)
    coords_x <- coords[, 1]
    coords_y <- coords[, 2]
    n <- length(coords_x)

    # Check if the CRS planar or angular
    if (sf::st_is_longlat(input)) {
      distances <-
        haversine_distance_vector(
          coords_x,
          coords_y
        )
    } else {
      distances <-
        cartesian_distance_vector(
          coords_x,
          coords_y
        )
    }

    # Perform smoothing
    x_filt <- fil_wt_x(
      y = coords_x,
      x = distances,
      lambda = lamda,
      order = order
    )

    y_filt <- fil_wt_x(
      y = coords_y,
      x = distances,
      lambda = lamda,
      order = order
    )

    if (keep_start) {
      # Keep start and end points
      x_filt[1] <- coords_x[1]
      x_filt[n] <- coords_x[n]

      y_filt[1] <- coords_y[1]
      y_filt[n] <- coords_y[n]

      # Create LINESTRING and return sf object
      smoothed_line <-
        to_linestring(x_filt, y_filt) |>
        sf::st_as_sfc(crs = crs) |>
        sf::st_as_sf()
      return(smoothed_line)
    } else {
      smoothed_line <-
        to_linestring(x_filt, y_filt) |>
        sf::st_as_sfc(crs = crs) |>
        sf::st_as_sf()
      return(smoothed_line)
    }
  }
