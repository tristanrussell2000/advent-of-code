use std::collections::HashMap;
use std::fs;
use std::time::Instant;

fn search<'a>(curr: &'a str, paths_map: &'a HashMap<String, Vec<String>>) -> u64 {
    if curr == "out" { return 1; }
    let mut total = 0;
    let conns = paths_map.get(curr).unwrap();
    
    for conn in conns {
        total += search(conn, paths_map);
    }
    total
}
fn main() {
    let start = Instant::now();
    let file_path = "./inputs/input1.txt";
    let input = fs::read_to_string(file_path).unwrap();

    let mut reactor_map: HashMap<String, Vec<String>> = HashMap::new();
    for line in input.trim().split("\n") {
        let mut reactor_conns = line.split(":");
        let reactor = reactor_conns.next().unwrap();
        
        let conns = reactor_conns.next().unwrap();
        let conn_vec: Vec<String> = conns.trim().split(" ").map(|s| s.to_string()).collect();
        
        reactor_map.insert(reactor.to_string(), conn_vec);
    }
    
    let total = search("you", &reactor_map);

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("The total is {}", total);
}
