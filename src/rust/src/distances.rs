use extendr_api::prelude::*;

/// Cartesian distance between two points
/// 
/// Given two planar coordinates, estimates the distance between them
/// 
/// @param  x1 double, X coordinate of the first point
/// @param  y1 double, Y coordinate of the first point
/// @param  x2 double, X coordinate of the second point
/// @param  y2 double, Y coordinate of the second point
/// 
/// @returns a numeric value of class double
#[extendr]
fn cartesian_distance(x1: f64, y1: f64, x2: f64, y2: f64) -> f64 {
    // Find max and min points
    let xmax = x1.max(x2);
    let xmin = x1.min(x2);
    let ymax = y1.max(y2);
    let ymin = y1.min(y2);

    // Calculate the distance between two points in 2D space
    let dx = xmax - xmin;
    let dy = ymax - ymin;
    (dx*dx + dy*dy).sqrt()
}

/// Harvesine distance between two points
/// 
/// Given two angular coordinates, estimates the distance between them
/// 
/// @param  lon1 double, longitude (X1) of the first point
/// @param  lat1 double, latitude (Y1) of the first point
/// @param  lon2 double, longitude (X2) of the second point
/// @param  lat2 double, latitude (Y2) of the second point
/// 
/// @returns a numeric value of class double
#[extendr]
fn haversine_distance(lon1: f64, lat1: f64, lon2: f64, lat2: f64) -> f64 {
    // Constant in meters
    let r = 6371000.0;

    // Convert to radians
    let phi1 = lat1.to_radians();
    let phi2 = lat2.to_radians();

    let dphi = (lat2 - lat1).to_radians();
    let dlambda = (lon2 - lon1).to_radians();

    // Haversine formula
    let a = (dphi / 2.0).sin().powf(2.0) + (phi1).cos() * (phi2).cos() * ((dlambda / 2.0).sin().powf(2.0));
    let c = 2.0 * a.sqrt().atan2((1.0 - a).sqrt());

    // Distance in meters
    r * c
}

#[extendr]
fn haversine_distance_vector(lon_vec: Vec<f64>, lat_vec: Vec<f64>) -> Vec<f64> {
    
    // Pre-allocate result vector
    let mut cumulative_distances: Vec<f64> = Vec::with_capacity(lon_vec.len());
    let n = lon_vec.len() - 1;
    let mut cumulative_distance = 0.0;

    // Iterate over lon-lat pairs
    for i in 0..n {

        let distance = haversine_distance(lon_vec[i], lat_vec[i], lon_vec[i+1], lat_vec[i+1]);
        let distance = distance / 1000.0;

        // Accumulate cumulative distance
        cumulative_distance += distance;

        // Push cumulative distance to the result vector
        cumulative_distances.push(cumulative_distance);
    
    }
    
    // Add 0.0 at the beginning of the vector
    cumulative_distances.insert(0, 0.0);

    cumulative_distances
}

#[extendr]
fn cartesian_distance_vector(x_vec: Vec<f64>, y_vec: Vec<f64>) -> Vec<f64> {
        
    // Pre-allocate result vector
    let mut cumulative_distances: Vec<f64> = Vec::with_capacity(x_vec.len());
    let n = x_vec.len() - 1;
    let mut cumulative_distance = 0.0;

    // Iterate over X-Y pairs
    for i in 0..n {

        let distance = cartesian_distance(x_vec[i], y_vec[i], x_vec[i+1], y_vec[i+1]);
        let distance = distance / 1000.0;

        // Accumulate cumulative distance
        cumulative_distance += distance;

        // Push cumulative distance to the result vector
        cumulative_distances.push(cumulative_distance);
    }
    
    // Add 0.0 at the beginning of the vector
    cumulative_distances.insert(0, 0.0);

    cumulative_distances
}


extendr_module! {
    mod distances;
    fn cartesian_distance;
    fn haversine_distance;
    fn haversine_distance_vector;
    fn cartesian_distance_vector;
}