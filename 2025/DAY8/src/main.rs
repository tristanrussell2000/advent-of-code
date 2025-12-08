use std::cmp::{Ordering};
use std::fs;
use std::time::Instant;
use disjoint::*;
use std::collections::BinaryHeap;

fn calc_dist(p1: &Point, p2: &Point) -> u64 {
    let dx = p1.0 as i64 - p2.0 as i64;
    let dy = p1.1 as i64 - p2.1 as i64;
    let dz = p1.2 as i64 - p2.2 as i64;

    // Sum the squares of the differences
    u64::MAX - (dx * dx + dy * dy + dz * dz) as u64
}

#[derive(Eq, Hash, PartialEq)]
#[derive(Debug)]
#[derive(Clone)]
struct Point (u32, u32, u32);
#[derive(Debug)]
struct PointDist {p1: usize, p2: usize, dist: u64}

impl PartialEq for PointDist {
    fn eq(&self, other: &Self) -> bool {
        self.dist == other.dist
    }
}

// 2. Implement Eq (marker trait, no methods needed)
impl Eq for PointDist {}

// 3. Implement Ord to define total ordering based ONLY on dist
impl Ord for PointDist {
    fn cmp(&self, other: &Self) -> Ordering {
        // Standard comparison: Smallest dist < Largest dist
        self.dist.cmp(&other.dist)
    }
}

// 4. Implement PartialOrd (required by Ord)
impl PartialOrd for PointDist {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
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
    
    let point_pairs: Vec<PointDist> = points.clone().iter().enumerate().flat_map(|(idx, p1)| {
        points[idx+1..].iter().enumerate().map(move |(idx2, p2)| {
            PointDist {p1: idx, p2: idx2 + idx + 1, dist: calc_dist(p1, p2)}
        })
    }).collect();

    
    let mut point_pairs_heap = BinaryHeap::<PointDist>::new();
    for point_pair in point_pairs {
        point_pairs_heap.push(point_pair);
    }
    
    let mut sets = DisjointSet::with_len(num_points);
    
    loop {
        let PointDist {p1, p2, dist: _} = point_pairs_heap.pop().unwrap();
        sets.join(p1, p2);
        if sets.sets().len() == 1 {
            let point1 = &points[p1];
            let point2 = &points[p2];
            println!("X Multiplied {}", point1.0 * point2.0);
            break;
        }
    }

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    let mut occurrences = vec![0; num_points];
    (0..num_points).for_each(|i| {
        occurrences[sets.root_of(i)] += 1;
    });
    occurrences.sort();
    let last = occurrences[num_points-1];
    let second_last = occurrences[num_points-2];
    let third_last = occurrences[num_points-3];
    
    
    println!("Total: {}", last * second_last * third_last);
}
