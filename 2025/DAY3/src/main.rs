use std::fs;

fn main() {
    let file_path = "./inputs/input1.txt";
    let Ok(input) = fs::read_to_string(file_path) else {
        println!("Invalid file path!");
        return;
    };

    let banks = input.trim().split("\n");
    let mut total: u64 = 0;
    for bank in banks {
        let digits: Vec<u32> = bank.chars().map(|c| c.to_digit(10).unwrap()).collect();
        let argmax_first = (&digits[0..digits.len()-1])
            .iter()
            .enumerate()
            .min_by_key(|&(_, &value)| 10 -value)
            .map(|(idx, _)| idx)
            .unwrap();

        let argmax_second = (&digits[argmax_first+1..])
            .iter().enumerate()
            .min_by_key(|&(_, &value)| 10 -value)
            .map(|(idx, _)| idx)
            .unwrap();

        let comb: u64 = (digits[argmax_first].to_string() + &digits[argmax_second + argmax_first + 1].to_string()).parse().unwrap();
        total += comb;
    }

    println!("{total}");
}
