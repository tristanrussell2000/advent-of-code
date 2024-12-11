let file = "data10.txt"
module PairSet = Set.Make(struct
  type t = int * int
  let compare = compare
end)
let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let rec count_reachable_nines array i j prev = 
  if i < 0 || j < 0 || i >= Array.length array || j >= Array.length array.(0) || array.(i).(j) - prev <> 1 then PairSet.empty else
    if array.(i).(j) = 9 then PairSet.singleton (i, j) else
    PairSet.union (count_reachable_nines array (i + 1) j array.(i).(j)) (count_reachable_nines array i (j + 1) array.(i).(j))
    |> PairSet.union (count_reachable_nines array (i - 1) j array.(i).(j))
    |> PairSet.union (count_reachable_nines array i (j - 1) array.(i).(j))

let rec count_distinct_paths_to_nines array i j prev = 
  if i < 0 || j < 0 || i >= Array.length array || j >= Array.length array.(0) || array.(i).(j) - prev <> 1 then 0 else
    if array.(i).(j) = 9 then 1 else
    (count_distinct_paths_to_nines array (i + 1) j array.(i).(j)) + (count_distinct_paths_to_nines array i (j + 1) array.(i).(j))
    + (count_distinct_paths_to_nines array (i - 1) j array.(i).(j)) + (count_distinct_paths_to_nines array i (j - 1) array.(i).(j))

let () =  
  let lines = read_lines file in
  let t = Sys.time() in
  let char_lines = List.map (fun x -> List.map (fun c -> int_of_string (Char.escaped c)) (List.of_seq (String.to_seq x))) lines in
  let array = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in
  let array_results = Array.make_matrix (Array.length array) (Array.length array.(0)) 0 in
  let array_results_2 = Array.make_matrix (Array.length array) (Array.length array.(0)) 0 in
  let _ = Array.iteri (fun i row -> Array.iteri (fun j c -> 
    if c = 0 then array_results.(i).(j) <- PairSet.cardinal (count_reachable_nines array i j (-1))) row ) array in
  let sum_of_array_results = Array.fold_left (fun acc row -> acc + (Array.fold_left (fun acc2 c -> acc2 + c) 0 row)) 0 array_results in
  (* End of part 1 *)

  let _ = Array.iteri (fun i row -> Array.iteri (fun j c -> 
    if c = 0 then array_results_2.(i).(j) <- count_distinct_paths_to_nines array i j (-1)) row ) array in
  let sum_of_array_results_2 = Array.fold_left (fun acc row -> acc + (Array.fold_left (fun acc2 c -> acc2 + c) 0 row)) 0 array_results_2 in

  print_endline ("Sum of array results: " ^ (string_of_int sum_of_array_results));
  print_endline ("Sum of array results 2: " ^ (string_of_int sum_of_array_results_2));

  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);