use std::cell::{Ref, RefCell};
use std::fs;
use std::time::Instant;
use std::collections::HashMap;
use std::ops::AddAssign;

fn main() {
    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let input = fs::read_to_string(file_path).unwrap();

    let rows: Vec<Vec<u8>>= input.trim().split("\n").map(|row| {
        row.as_bytes().to_owned()
    }).collect();
    
    let mut beam_pos: HashMap<usize, RefCell<u64>> = HashMap::new();
    for i in 0..rows[0].len() {
        beam_pos.insert(i, RefCell::new(0));
    }
    let s_pos = rows[0].iter().position(|&s| s == b'S' ).unwrap();
    beam_pos.insert(s_pos, RefCell::new(1));
    
    rows[1..].iter().for_each(|row| {
        for (&pos, paths) in beam_pos.iter() {
            let num_paths = *paths.borrow();
            if row[pos] == b'^' && num_paths > 0 {
                *beam_pos.get(&pos).unwrap().borrow_mut() = 0;
                beam_pos.get(&(pos - 1)).unwrap().borrow_mut().add_assign(num_paths);
                beam_pos.get(&(pos + 1)).unwrap().borrow_mut().add_assign(num_paths);
            }
        }
    });
    
    let paths = beam_pos.iter().map(|(_, splits)| splits).fold(0, |acc, x| acc + *x.borrow());
    
    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Splits: {}", paths);
}
