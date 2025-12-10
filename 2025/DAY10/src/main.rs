use std::fs;
use std::ops::Add;
use std::time::Instant;
use good_lp::{constraint, Solution, SolverModel, variable, ProblemVariables, Variable, Expression};
use good_lp::lp_solve;

fn main() {
    let start = Instant::now();
    let file_path = "./inputs/input1.txt";
    let input = fs::read_to_string(file_path).unwrap();

    let problems: Vec<(Vec<Vec<f64>>, Vec<f64>)> = input.split("\n").map(|line| {
        let mut remove_pattern = line.split("]");
        // [.#...
        remove_pattern.next();
        // (0,1, .. 1,2) |split| {10,11...
        let mut voltage_split = remove_pattern.next().unwrap().split("{");

        let button_string = voltage_split.next().unwrap();

        // Get rid of trailing bracket
        let voltages_string = voltage_split.next().unwrap()
            .split("}").next().unwrap();

        let voltages: Vec<f64> = voltages_string.split(",").map(|s| {
            s.parse::<f64>().unwrap()
        }).collect();
        
        let num_voltages = voltages.len();
        
        // (0,1, .. 1,2)
        let buttons: Vec<Vec<f64>> = button_string
            .trim()
            .split(" ").map(|button_str| {
            let mut button_idx = vec![0_f64; num_voltages];
            // Insert 0s where no addition, 1 in index where it adds
            button_str[1..button_str.len() - 1].split(",").map(|b| b.parse::<f64>().unwrap()).for_each(|idx| {button_idx[idx as usize] += 1.0;});
            button_idx
        }).collect();

        (buttons, voltages)
    }).collect();

    let mut total: f64 = 0.0;
    for (buttons, voltages) in problems {
        let num_buttons = buttons.len();
        let mut all_vars = ProblemVariables::new();

        let vars: Vec<Variable> = (0..num_buttons).map(|_| {
            all_vars.add(variable().min(0).integer())
        }).collect();
        let expr = vars.iter().fold(Expression::with_capacity(vars.len()), |acc,expr| acc.add(expr));
        let mut problem = all_vars.minimise(expr).using(lp_solve);
        for (i, &voltage) in voltages.iter().enumerate() {
            let mut expr = Expression::from_other_affine(0.);
            for (j, button) in buttons.iter().enumerate() {
                expr += vars[j] * button[i];
            }
            let constraint = constraint!(expr == voltage);
            problem.add_constraint(constraint);
        }
        let sol = problem.solve().unwrap();
        for var in vars {
            total += sol.value(var);
        }
    }

    let duration = start.elapsed();
    println!("Elapsed time: {:?}", duration);
    println!("Total solutions: {}", total);
}
