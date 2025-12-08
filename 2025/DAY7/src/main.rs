use std::cell::{RefCell};
use std::fs;
use std::time::Instant;
use std::ops::AddAssign;

fn main() {
    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let input = fs::read_to_string(file_path).unwrap();

    let rows: Vec<Vec<u8>>= input.trim().split("\n").map(|row| {
        row.as_bytes().to_owned()
    }).collect();
    
    let mut beam_pos: Vec<RefCell<u64>> = vec![RefCell::new(0); rows[0].len()];
    let s_pos = rows[0].iter().position(|&s| s == b'S' ).unwrap();
    beam_pos[s_pos] = RefCell::new(1);
    
    rows[1..].iter().for_each(|row| {
        for (pos, paths) in beam_pos.iter().enumerate() {
            let num_paths = *paths.borrow();
            if row[pos] == b'^' && num_paths > 0 {
                *beam_pos[pos].borrow_mut() = 0;
                beam_pos[pos-1].borrow_mut().add_assign(num_paths);
                beam_pos[pos+1].borrow_mut().add_assign(num_paths);
            }
        }
    });
    
    let paths = beam_pos.iter().fold(0, |acc, x| acc + *x.borrow());
    
    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Splits: {}", paths);
}
