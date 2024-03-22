use extendr_api::prelude::*;
use whittaker_eilers::WhittakerSmoother;

/**
Perform a Whittaker-Eilers smoother.

Insanely fast and reliable smoothing and interpolation with the Whittaker-Eilers method.

@param y numeric vector to smooth (must be of class double!!)
@param lambda an number of class double for smoothing control. The larger the lambda, the smoother the data.
@param order an integer for smoothing control. A higher order means the Whittaker will consider more adjacent elements while smoothing.

@examples
data("airquality")

airquality$Ozone_smooth <- 
  fil_wt(as.double(airquality$Ozone), 10, 2)

plot(airquality$Ozone, type = "l", xlab = "Days", ylab = "Ozone")
lines(airquality$Ozone_smooth, co = "red")
@export
*/
#[extendr]
fn fil_wt(y: Vec<f64>, lambda: f64, order: u64) -> Vec<f64> {
    
    // Change type of the order value
    let order = order as usize;
    
    // Compute weights. Zeros for NA and 1.0 for other values
    let weights = y.iter()
        .map(|&val| if val.is_nan() { 0.0 } else { 1.0 })
        .collect();

    // Replace NaN values with a placeholder (e.g., 0.0) for smoothing.
    let y_imputed: Vec<f64> = y.iter()
        .map(|&val| if val.is_nan() { 0.0 } else { val })
        .collect();

    // Perform smoothing
    let whittaker_smoother = WhittakerSmoother::new(lambda, order, y.len(), None, Some(&weights))
        .unwrap();
    let smoothed_data = whittaker_smoother.smooth(&y_imputed)
        .unwrap();
    
    // Return values
    smoothed_data
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod filtrs;
    fn fil_wt;
}
