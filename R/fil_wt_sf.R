fil_wt_sf <-
  function(
    input,
    ...
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

    x_filt <- fil_wt_x(
      y = coords_x,
      x = distances,
      ...
    )

    y_filt <- fil_wt_x(
      y = coords_y,
      x = distances,
      ...
    )

    # Keep start and end points
    x_filt[1] <- coords_x[1]
    x_filt[n] <- coords_x[n]

    y_filt[1] <- coords_y[1]
    y_filt[n] <- coords_y[n]

    # Create LINESTRING and return sf object
    to_linestring(x_filt, y_filt) |>
      sf::st_as_sfc(crs = crs) |>
      sf::st_as_sf()

  }
