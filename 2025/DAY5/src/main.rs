use std::{fs};
use std::cmp::max;
use std::time::Instant;

fn main() {
    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let input = fs::read_to_string(file_path).unwrap();

    let mut parts = input.trim().split("\n\n");

    let ranges = parts.next().unwrap();

    let mut ranges_conv: Vec<(u64, u64)>= ranges.split("\n").map(|range| {
        let mut ends = range.split("-");
        let start = ends.next().unwrap().parse::<u64>().unwrap();
        let end = ends.next().unwrap().parse::<u64>().unwrap();
        (start, end)
    }).collect();
    ranges_conv.sort_by_key(|&(start, _)| start);

    let n = ranges_conv.len();

    let mut total = 0;
    let mut i = 0;
    while i < n {
        let (start, end) = ranges_conv[i];
        let mut end = end;

        let mut j = i + 1;
        while j < n {
            let (start_ahead, end_ahead) = ranges_conv[j];
            if end >= start_ahead {
                end = max(end_ahead, end);
                j += 1;
            } else {break;}
        }

        i = j;
        total += end - start + 1;
    }

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Fresh: {}", total);
}
