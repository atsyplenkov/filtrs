use extendr_api::prelude::*;

#[extendr]
fn to_linestrings(x: Vec<f64>, y: Vec<f64>) -> Vec<String> {
    // Pre-allocate result vector
    let n = x.len() - 1;
    let mut lines: Vec<String> = Vec::with_capacity(n);

    // Iterate over lon-lat pairs
    for i in 0..n {
        let formatted_string = format!("LINESTRING({} {}, {} {})", x[i], y[i], x[i + 1], y[i + 1]);
        
        // Push the formatted string into the result vector
        lines.push(formatted_string);
    }

    lines
}


#[extendr]
fn to_linestring(x: Vec<f64>, y: Vec<f64>) -> String {
    // Create an empty string to store the result
    let mut result = String::new();

    // Iterate over the coordinates and append them to the result string
    for i in 0..x.len() {
        // Append the coordinate pair to the result string
        result.push_str(&format!("{} {}", x[i], y[i]));

        // Add a comma and space unless it's the last coordinate pair
        if i < x.len() - 1 {
            result.push_str(", ");
        }
    }

    // Wrap the result string with "LINESTRING()" and return it
    format!("LINESTRING({})", result)
}

extendr_module! {
    mod transformators;
    fn to_linestrings;
    fn to_linestring;
}