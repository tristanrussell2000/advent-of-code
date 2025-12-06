use std::fs;
use std::time::Instant;
use itertools::izip;


fn main() {
    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let input = fs::read_to_string(file_path).unwrap();

    let mut parts = input.trim().split("\n");
    let nums1 = parts.next().unwrap().split(" ").filter(|&s| s != "").collect::<Vec<&str>>();
    let nums2 = parts.next().unwrap().split(" ").filter(|&s| s != "").collect::<Vec<&str>>();
    let nums3 = parts.next().unwrap().split(" ").filter(|&s| s != "").collect::<Vec<&str>>();
    let nums4 = parts.next().unwrap().split(" ").filter(|&s| s != "").collect::<Vec<&str>>();
    let ops = parts.next().unwrap().split(" ").filter(|&s| s != "").collect::<Vec<&str>>();
    assert!(nums1.len() == nums2.len() && nums1.len() == nums3.len() && nums1.len() == nums4.len() && nums1.len() == ops.len());

    let sum = izip!(&nums1, &nums2, &nums3, &nums4, &ops).fold(0_u64, |acc, (&num1, &num2, &num3, &num4, &op)| {
        let i1 = num1.parse::<u64>().unwrap();
        let i2 = num2.parse::<u64>().unwrap();
        let i3 = num3.parse::<u64>().unwrap();
        let i4 = num4.parse::<u64>().unwrap();
        println!("{op}");
        match op {
            "*" => acc + (i1 * i2 * i3 * i4),
            "+" => acc + (i1 + i2 + i3 + i4),
            _ => acc
        }
    });

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Sum: {}", sum);
}
