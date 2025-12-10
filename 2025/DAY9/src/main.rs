use std::fs;
use std::time::Instant;
use geo::{Coord, Intersects, Line, Rect};

fn valid_area(p1: &Coord, p2: &Coord, points: &Vec<Coord>) -> bool {
    let top_left = Coord {x: p1.x.min(p2.x) , y: p1.y.max(p2.y) };
    let bottom_right = Coord {x: p1.x.max(p2.x) , y: p1.y.min(p2.y) };
    let rect = Rect::new(Coord {x: top_left.x + 0.001, y: top_left.y - 0.001}, Coord { x: bottom_right.x - 0.001, y: bottom_right.y +0.001});
    for p in points.windows(2) {
        match p {
            [p, p2] => {
                let l = Line::new(*p, *p2);
                    if l.intersects(&rect) {
                        return false
                    } 
            },
            _ => continue
        }
    }
    
    let p = &points[points.len() - 1];
    let p2 = &points[0];
    let l = Line::new(*p, *p2);
    if l.intersects(&rect) {
        return false
    }
    true
}

fn calc_area(p1: &Coord, p2: &Coord) -> i64 {
    ((p1.x as i64 - p2.x as i64).abs() + 1) * ((p1.y as i64 - p2.y as i64).abs() + 1)
}

fn main() {
    let start = Instant::now();
    let file_path = "./inputs/input1.txt";
    let input = fs::read_to_string(file_path).unwrap();

    let points: Vec<Coord> = input.trim().split("\n").map(|row| {
        let coords: Vec<usize> = row.split(",").map(|s| s.parse::<usize>().unwrap()).collect();
        match coords[..] {
            [x, y] => Coord{ x: x as f64, y: y as f64 },
            _ => panic!(),
        }
    }).collect();
    
    let mut max_area: i64 = 0;
    let mut max_p1 = Coord {x: 0.0, y: 0.0};
    let mut max_2 = Coord {x: 0.0, y: 0.0};
    for (idx, p1) in points.iter().enumerate() {
        for (_, p2) in points[idx+1..].iter().enumerate() {
            if !valid_area(p1, p2, &points) { continue; };
            
            let area = calc_area(p1, p2);
            if area > max_area { max_area = area; max_p1 = p1.clone(); max_2 = p2.clone(); }
        };
    };
    
    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Max area is {}, {:?}, {:?}", max_area, max_p1, max_2);
}
