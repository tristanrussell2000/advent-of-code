use std::{env, fs};
use std::time::Instant;

fn check_ranges(id: u64, ranges: &Vec<(u64, u64)>) -> u32 {
    for &(start, end) in ranges.iter() {
       if id >= start && id <= end {
           return 1;
       }
    }
    0
}

fn main() {
    //let args: Vec<String> = env::args().collect();

    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let input = fs::read_to_string(file_path).unwrap();

    let mut parts = input.trim().split("\n\n");

    let ranges = parts.next().unwrap();
    let ingredients = parts.next().unwrap();

    let ranges_conv: Vec<(u64, u64)>= ranges.split("\n").map(|range| {
        let mut ends = range.split("-");
        let start = ends.next().unwrap().parse::<u64>().unwrap();
        let end = ends.next().unwrap().parse::<u64>().unwrap();
        (start, end)
    }).collect();

    let ids: Vec<u64> = ingredients.split("\n").map(|id| {
        id.parse::<u64>().unwrap()
    }).collect();
    let num_ids = ids.len();

    // Sanity check on output
    println!("Number of Ids: {num_ids}");

    let num_fresh = ids.iter().fold(0, |acc, &id| {
        acc + check_ranges(id, &ranges_conv)
    });

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Fresh: {}", num_fresh);
}
