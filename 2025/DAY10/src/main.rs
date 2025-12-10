use std::collections::HashMap;
use std::fs;
use std::time::Instant;

fn solve_problem(curr: u16, goal: u16, buttons: Vec<u16>, sol_hash: &mut HashMap<(u16, Vec<u16>), u64>) -> u64 {
    if let Some(min) = sol_hash.get(&(curr, buttons.clone())) {
        return *min;
    }
    let mut min_uses = u64::MAX;
    if goal == curr { 
        return 0 
    };
    for (i, &button) in buttons.iter().enumerate() {
        let new_buttons: Vec<u16> = buttons.iter().enumerate().filter(|(i2, _)| *i2 != i).map(|(_, &val)| val).collect();
        //println!("{:?}", new_buttons);
        let uses = solve_problem(curr ^ button, goal, new_buttons, sol_hash);
        let uses = if uses == u64::MAX {uses} else {uses + 1};
        if uses < min_uses { min_uses = uses; }
    }
    sol_hash.insert((curr, buttons), min_uses);
    min_uses
}
fn main() {
    let start = Instant::now();
    let file_path = "./inputs/input1.txt";
    let input = fs::read_to_string(file_path).unwrap();

    let problems: Vec<(u16, Vec<u16>)> = input.split("\n").map(|line| {
        let mut pattern_rest = line.split("]");
        let pattern_bytes = pattern_rest.next().unwrap().bytes().collect::<Vec<_>>();
        
        let pattern = match &pattern_bytes[..] {
            [b'[', rest @ ..] => {
                let mut bit_map: u16 = 0;
                rest.iter().enumerate().for_each(|(i, &b)| { 
                    if b == b'#' { bit_map |= 1u16 << i }
                });
                bit_map
            },
            _ => panic!()
        };
        let buttons_slices: Vec<u16> = pattern_rest.next().unwrap()
            .split("{").next().unwrap().trim()
            .split(" ").map(|button_str| {
            let mut bit_map: u16 = 0;
            (button_str[1..button_str.len() - 1]).split(",").map(|b| b.parse::<u8>().unwrap()).for_each(|u| {
                bit_map |= 1u16 << u;
            });
            bit_map
        }).collect();

        (pattern, buttons_slices)
    }).collect();
    
    let mut total = 0;
    for (pattern, buttons) in problems {
        let mut sol_hash: HashMap<(u16, Vec<u16>), u64> = HashMap::new();
        total += solve_problem(0, pattern, buttons, &mut sol_hash);
    }

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Total: {:?}", total);
}
