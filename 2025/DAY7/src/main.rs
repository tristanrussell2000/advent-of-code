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
    
    let mut splits = 0;
    let mut beam_pos: HashMap<usize, bool> = HashMap::new();
    let s_pos = rows[0].iter().position(|&s| s == b'S' ).unwrap();
    beam_pos.insert(s_pos, true);
    
    rows[1..].iter().for_each(|row| {
        //println!("{row:?}");
        let curr_entries: Vec<(usize, bool)>= beam_pos.iter().map(|(&x, &y)| (x, y)).collect();
        for (pos, filled) in curr_entries {
            if row[pos] == b'^' && filled == true {
                splits += 1;
                beam_pos.insert(pos, false);
                beam_pos.insert(pos - 1, true);
                beam_pos.insert(pos + 1, true);
            }
        }
    });
    
    
    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Splits: {}", splits);
}
