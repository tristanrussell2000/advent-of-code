use std::fs;
use std::time::Instant;
use std::collections::HashMap;


fn main() {
    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let input = fs::read_to_string(file_path).unwrap();

    let rows: Vec<Vec<u8>>= input.trim().split("\n").map(|row| {
        row.as_bytes().to_owned()
    }).collect();
    
    let mut beam_pos: HashMap<usize, u64> = HashMap::new();
    let s_pos = rows[0].iter().position(|&s| s == b'S' ).unwrap();
    beam_pos.insert(s_pos, 1);
    
    rows[1..].iter().for_each(|row| {
        let curr_entries: Vec<(usize, u64)>= beam_pos.iter().map(|(&x, &y)| (x, y)).collect();
        for (pos, paths) in curr_entries {
            if row[pos] == b'^' && paths > 0 {
                beam_pos.insert(pos, 0);
                beam_pos.entry(pos - 1)
                    .and_modify(|x| *x += paths)
                    .or_insert(paths);
                beam_pos.entry(pos + 1)
                    .and_modify(|x| *x += paths)
                    .or_insert(paths);
            }
        }
    });
    
    let paths = beam_pos.iter().map(|(_, &splits)| splits).fold(0, |acc, x| acc + x);
    
    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Splits: {}", paths);
}
