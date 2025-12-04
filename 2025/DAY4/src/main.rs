use std::cmp::{min};
use std::{env, fs};
use std::time::Instant;

fn print_row(row: &Vec<u8>) {
    row.iter().for_each(|c| {
        let ch = *c as char;
        print!("{ch}");
    });
    println!();
}

fn print_rows(rows: &Vec<Vec<u8>>) {
    rows.iter().for_each(|row| {
        print_row(row);
    });
    println!();
}

fn removal(rows: Vec<Vec<u8>>) -> Option<(Vec<Vec<u8>>, u64)>{
    let mut all_num_reachable = 0;
    let l = rows.len();
    let sz = rows[0].len()-1;
    let mut new_rows = rows.clone();

    for i in 0..l {
        let row = &rows[i];
        //print_row(row);
        let mut num_reachable = 0;
        for j in 0..=sz {
            let c = &row[j];
            let c2 = &mut new_rows[i][j];
            if *c == b'.' {continue;}
            let mut num_around = 0;

            if i > 0 {
                let prev = &rows[i-1];
                (&prev[(if j > 0 {j-1} else {0})..=min(j+1, sz)]).iter().for_each(|&c2| {
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
                let next = &rows[i+1];
                (&next[(if j > 0 {j-1} else {0})..=min(j + 1, sz)]).iter().for_each(|&c2| {
                    if c2 == b'@' { num_around += 1 }
                })
            }

            if num_around < 4 {
                num_reachable += 1;
                *c2 = b'.';
            }
            //print!("{num_around}");
        }
        //println!("");
        all_num_reachable += num_reachable;
    }
    
    if all_num_reachable == 0 {
        None
    } else {
        Some((new_rows, all_num_reachable))
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let part = &args[1];
    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let input = fs::read_to_string(file_path).unwrap();

    let mut rows: Vec<Vec<u8>> = input.trim().split("\n").map(|row| {
        row.as_bytes().to_owned()
    }).collect();
    //print_rows(&rows);
    let mut all_removed = 0;
    loop {
        if let Some((new_rows, num_removed)) = removal(rows) {
            rows = new_rows;
            //print_rows(&rows);
            all_removed += num_removed;
            if part == "part1" { break; }
        } else {
            break;
        }
    }

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Removed Rolls: {}", all_removed);
}
