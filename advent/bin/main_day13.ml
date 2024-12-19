let file = "data13.txt"

let () =  
  let t = Sys.time() in

  let contents = In_channel.with_open_bin file In_channel.input_all in
  let machines_2 = Str.split (Str.regexp "\n\n") contents in
  let machines_real = List.map (fun machine2 -> 
    let reg = Str.regexp {|[0-9]+|} in
    let _ = Str.search_forward reg machine2 0 in
    let a1 = float_of_string (Str.matched_string machine2) in
    let _ = Str.search_forward reg machine2 (Str.match_end ()) in
    let a2 = float_of_string (Str.matched_string machine2) in
    let _ = Str.search_forward reg machine2 (Str.match_end ()) in
    let b1 = float_of_string (Str.matched_string machine2) in
    let _ = Str.search_forward reg machine2 (Str.match_end ()) in
    let b2 = float_of_string (Str.matched_string machine2) in
    let _ = Str.search_forward reg machine2 (Str.match_end ()) in
    let t1 = float_of_string (Str.matched_string machine2) in
    let _ = Str.search_forward reg machine2 (Str.match_end ()) in
    let t2 = float_of_string (Str.matched_string machine2) in
    ((a1, a2), (b1, b2), (t1, t2))
  ) machines_2 in
  
  let is_near_integer x =
    let diff = Float.abs (x -. (Float.round x)) in
    diff <= 0.01
  in

  let list_of_solutions = List.map (fun machine -> 
    match machine with
    ((a1, a2), (b1, b2), (t1, t2)) -> 
      let t1 = t1 +. 10000000000000. in
      let t2 = t2 +. 10000000000000. in
      let matrix = Owl.Dense.Ndarray.D.of_arrays [|[| a1;  b1|]; [| a2;  b2|]|] in
      let vector = Owl.Dense.Ndarray.D.of_arrays [|[| t1|]; [| t2|]|] in
      let solution = Owl.Linalg.D.linsolve matrix vector in
      let solution_array = Owl.Dense.Ndarray.D.to_array solution in
      let (a, b) = match solution_array with
      | [|a; b|] -> (a, b)
      | _ -> Printf.printf "No solution\n"; (0.,0.)
      in
      if is_near_integer a && is_near_integer b then ((3 * (int_of_float (Float.round a))) + (int_of_float (Float.round b))) else 0
   ) machines_real in

   let sum_of_solutions = List.fold_left (+) 0 list_of_solutions in

    Printf.printf "Sum of solutions: %d\n" sum_of_solutions;


  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);