use std::cmp::{Ordering};
use std::fs;
use std::time::Instant;
use disjoint::*;
fn calc_dist(p1: &Point, p2: &Point) -> f64 {
    let dx = p1.0 as i64 - p2.0 as i64;
    let dy = p1.1 as i64 - p2.1 as i64;
    let dz = p1.2 as i64 - p2.2 as i64;

    // Sum the squares of the differences
    let squared_distance = dx * dx + dy * dy + dz * dz;

    // Take the square root to get the final distance
    (squared_distance as f64).sqrt()
}

#[derive(Eq, Hash, PartialEq)]
#[derive(Debug)]
struct Point (u32, u32, u32);
#[derive(Debug)]
struct PointDist {p1: usize, p2: usize, dist: f64}

impl Eq for PointDist {}

impl PartialEq<Self> for PointDist {
    fn eq(&self, other: &Self) -> bool {
        self.dist == other.dist
    }
}

impl PartialOrd<Self> for PointDist {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        self.dist.partial_cmp(&other.dist)
    }
}

impl Ord for PointDist {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).unwrap()
    }
}

fn main() {
    let file_path = "./inputs/input1.txt";
    let start = Instant::now();
    let input = fs::read_to_string(file_path).unwrap();
    
    let points: Vec<Point> = input.trim().split("\n").map(|row| {
        let coords: Vec<u32> = row.split(",").map(|s| s.parse::<u32>().unwrap()).collect();
        match coords[..] {
            [x, y, z] => Point(x, y, z),
            _ => panic!(),
        }
    }).collect();

    let num_points = points.len();
    let mut point_pairs: Vec<PointDist> = points.iter().enumerate().flat_map(|(idx, p1)| {
        points[idx+1..].iter().enumerate().map(move |(idx2, p2)| {
            PointDist {p1: idx, p2: idx2 + idx + 1, dist: calc_dist(p1, p2)}
        })
    }).collect();
    point_pairs.sort();
    let mut sets = DisjointSet::with_len(num_points);
    
    for i in 0..1000 {
        let PointDist {p1, p2, dist: _} = point_pairs[i];
        sets.join(p1, p2);
    }

    let mut occurrences = vec![0; num_points];
    (0..num_points).for_each(|i| {
        occurrences[sets.root_of(i)] += 1;
    });
    occurrences.sort();
    let last = occurrences[num_points-1];
    let second_last = occurrences[num_points-2];
    let third_last = occurrences[num_points-3];
    
    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Total: {}", last * second_last * third_last);
}
