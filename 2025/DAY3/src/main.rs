use std::fs;
use std::time::Instant;

fn main() {
    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let Ok(input) = fs::read_to_string(file_path) else {
        println!("Invalid file path!");
        return;
    };
    
    let banks = input.trim().split("\n");
    let mut total: u64 = 0;
    for bank in banks {
        let digits: Vec<u64> = bank.chars().map(|c| c.to_digit(10).unwrap() as u64).collect();

        let mut it = 0;
        let mut num_str = String::new();

        for i in (0..12).rev() {
            // Need to leave room for next iterators
            let end = digits.len() - i;
            let argmax = (&digits[it..end])
                .iter().enumerate()
                // Cursed, but max_by_key returns the *last* index of that value, min_by_key
                // returns the first which is what we want
                .min_by_key(|&(_, &value)| 10 - value)
                .map(|(idx, _)| idx)
                .unwrap();
            it += argmax + 1;
            num_str.push_str(&digits[it-1].to_string());
        }

        let comb: u64 = num_str.parse().unwrap();
        total += comb;
    }
    let duration = start.elapsed(); // Calculate the elapsed time
    println!("Elapsed time: {:?}", duration);
    println!("{total}");
}
