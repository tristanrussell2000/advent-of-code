use std::fs;

fn main() {
    // --snip--
    let file_path = "./inputs/dial1.txt";

    let contents = fs::read_to_string(file_path)
        .expect("Should have been able to read the file");

    let turns: Vec<&str> = contents.trim().split("\n").collect();
    let mut dial = 50;
    let mut count_zeros = 0;
    
    for turn in turns {
        let num_opt = (&turn[1..]).parse::<i32>();
        let num_int = match num_opt {
            Ok(input_int) => input_int,
            Err(e) => {
                println!("please input a number ({})", e);
                return;
            }
        };
        match &turn[0..1] {
            "R" => { 
                let zeros = (dial + num_int).div_euclid(100);
                count_zeros += zeros;
                dial = (dial + num_int).rem_euclid(100);
            }
            "L" => { 
                let zeros = (dial - num_int).div_euclid(100).abs() - (if dial == 0 {1} else {0});
                count_zeros += zeros;
                dial = (dial - num_int).rem_euclid(100);
                if dial == 0 { count_zeros += 1; }
            }
            &_ => { println!("each line must start with R or L"); return; }
        }
    }

    println!("{count_zeros}");
}
