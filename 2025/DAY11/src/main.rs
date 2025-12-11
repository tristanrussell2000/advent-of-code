use std::collections::HashMap;
use std::fs;
use std::time::Instant;

fn str_to_code(s: &str) -> u32 {
    match s.as_bytes() {
        [a, b, c] => {
            ((*a as u32) << 16) | (*b as u32) << 8 | (*c as u32)
        }
        _ => panic!()
    }
}

fn search<'a>(curr: u32, paths_map: &'a HashMap<u32, Vec<u32>>, sol_map: &'a mut HashMap<(u32, bool, bool), u64>, seen_fft: bool, seen_dac: bool) -> u64 {
    if let Some(res) = sol_map.get(&(curr, seen_fft, seen_dac)) {
        return *res;
    }
    if curr == str_to_code("out") { 
        if seen_fft && seen_dac {
            return 1;
        }
        return 0; 
    }
    let mut total = 0;
    let conns = paths_map.get(&curr).unwrap();
    
    for &conn in conns {
        total += search(conn, paths_map, sol_map,seen_fft || curr == str_to_code("fft"), seen_dac || curr == str_to_code("dac") );
    }
    sol_map.insert((curr, seen_fft, seen_dac), total);
    total
}
fn main() {
    let start = Instant::now();
    let file_path = "./inputs/input1.txt";
    let input = fs::read_to_string(file_path).unwrap();

    let mut reactor_map: HashMap<u32, Vec<u32>> = HashMap::new();
    for line in input.trim().split("\n") {
        let mut reactor_conns = line.split(":");
        let reactor = reactor_conns.next().unwrap();
        
        let conns = reactor_conns.next().unwrap();
        let conn_vec: Vec<u32> = conns.trim().split(" ").map(|s| str_to_code(s)).collect();
        
        reactor_map.insert(str_to_code(reactor), conn_vec);
    }
    let mut sol_map: HashMap<(u32, bool, bool), u64> = HashMap::new();
    let total = search(str_to_code("svr"), &reactor_map, &mut sol_map, false, false);

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("The total is {}", total);
}
