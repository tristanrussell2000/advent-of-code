use std::cmp::{min};
use std::fs;
use std::time::Instant;

fn main() {
    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let input = fs::read_to_string(file_path).unwrap();

    let rows: Vec<&str> = input.trim().split("\n").collect();
    let mut all_num_reachable = 0;
    let l = rows.len();
    let sz = rows[0].len()-1;
    for i in 0..rows.len() {
        let row = rows[i].as_bytes();
        //dbg!(rows[i]);
        let mut num_reachable = 0;
        row.iter().enumerate().for_each(|(j, c)| {
            if c.eq(&b'.') {return;}

            let mut num_around = 0;

            if i > 0 {
                let prev = rows[i-1];
                (&prev[(if j > 0 {j-1} else {0})..=min(j+1, sz)]).bytes().for_each(|c2| {
                    if c2 == b'@' {num_around += 1}
                })
            }

            if j > 0 && row[j-1] == b'@' {
                num_around += 1;
            }
            if j+1 <= sz && row[j+1] == b'@' {
                num_around += 1;
            }

            if i < l - 1 {
                let next = rows[i+1];
                (&next[(if j > 0 {j-1} else {0})..=min(j + 1, sz)]).bytes().for_each(|c2| {
                    if c2 == b'@' { num_around += 1 }
                })
            }
            //print!("{num_around}");
            if num_around < 4 { num_reachable += 1}
        });
        all_num_reachable += num_reachable;
        //println!("\nReachable: {num_reachable}");
    }

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Reachable Rolls: {}", all_num_reachable)
}
