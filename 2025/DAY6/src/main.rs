use std::fs;
use std::time::Instant;
use itertools::izip;


fn main() {
    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let input = fs::read_to_string(file_path).unwrap();


    let mut parts = input.trim_end_matches(&['\r', '\n'][..]).split("\n");
    let nums1 = parts.next().unwrap().bytes().rev();
    let nums2 = parts.next().unwrap().bytes().rev();
    let nums3 = parts.next().unwrap().bytes().rev();
    let nums4 = parts.next().unwrap().bytes().rev();
    let ops = parts.next().unwrap().bytes().rev();

    let mut sum = 0;
    let mut stack: Vec<u64> = Vec::new();

    for col in izip!(nums1, nums2, nums3, nums4, ops) {
        match col {
            (b' ', b' ', b' ', b' ', b' ') => continue,
            (n1, n2, n3, n4, b' ') => stack.push(String::from_utf8(vec![n1, n2, n3, n4]).unwrap().trim().parse::<u64>().unwrap()),
            (n1, n2, n3, n4, b'*') => {
                stack.push(String::from_utf8(vec![n1, n2, n3, n4]).unwrap().trim().parse::<u64>().unwrap());
                sum += stack.into_iter().reduce(|acc, a| acc * a).unwrap();
                stack = Vec::new();
            }
            (n1, n2, n3, n4, b'+') => {
                stack.push(String::from_utf8(vec![n1, n2, n3, n4]).unwrap().trim().parse::<u64>().unwrap());
                sum += stack.into_iter().reduce(|acc, a| acc + a).unwrap();
                stack = Vec::new();
            }
            _ => panic!("Unexpected col {:?}", col),
        }
    }

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Sum of parts: {}", sum);
}
