use std::fs;
use std::ops::Range;

fn main() {
    let file_path = "./inputs/input1.txt";
    let Ok(input) = fs::read_to_string(file_path) else {
        println!("Invalid file path!");
        return;
    };

    let ranges = input.trim().split(",");
    let mut sum_invalid = 0;
    for range in ranges {
        let low_high: Vec<_> = range.split("-").collect();    
        let [low, high] = low_high[..] else {
            println!("Invalid format for range {range}");
            return;
        };
        let Ok(low_int) = low.parse::<u64>() else {
            println!("Invalid number given for low value {low}");
            return;
        };
        let Ok(high_int) = high.parse::<u64>() else {
            println!("Invalid number given for high value {high}");
            return;
        };
        for i in (Range{start: low_int, end: high_int + 1}) {
            let num_string = i.to_string();
            if num_string.len() % 2 != 0 {
                continue;
            }
            let (first, second) = num_string.split_at(num_string.len() / 2);
            if (first == second) {
                sum_invalid += i;
            }
            
        }
    }
    println!("Number valid: {sum_invalid}");

}

