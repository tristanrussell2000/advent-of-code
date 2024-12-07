let file = "data7.txt"

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let rec math_search arr n curr = 
  match arr with
  | i :: rest -> if curr > n then false else
    if curr = 0 then math_search rest n i else
      (math_search rest n (curr + i)) || (math_search rest n (curr * i))
  | [] -> curr = n

let concat i j = 
  let i_str = string_of_int i in
  let j_str = string_of_int j in
  int_of_string (i_str ^ j_str)
let rec math_search_concat arr n curr = 
  match arr with
  | i :: rest -> if curr > n then false else
    if curr = 0 then math_search_concat rest n i else
      (math_search_concat rest n (curr + i)) || (math_search_concat rest n (curr * i)) || (math_search_concat rest n (concat curr i))
  | [] -> curr = n

let () =  
  let lines = read_lines file in
  let t = Sys.time() in
  let split_lines = List.map (String.split_on_char ':') lines in
  let split_lines = List.map (fun line -> List.map String.trim line) split_lines in
  let split_lines = List.map (fun line -> List.flatten (List.map (fun x -> String.split_on_char ' ' x) line)) split_lines in
  let valid_lines = List.filter (fun line -> (math_search (List.map int_of_string (List.tl line)) (int_of_string (List.hd line)) 0)) split_lines in
  let sum_of_valid_line_totals = List.fold_left (fun acc line -> acc + (int_of_string (List.hd line))) 0 valid_lines in
  (* End of part 1 *)

  let valid_lines_concat = List.filter (fun line -> (math_search_concat (List.map int_of_string (List.tl line)) (int_of_string (List.hd line)) 0)) split_lines in
  let sum_of_valid_line_totals_concat = List.fold_left (fun acc line -> acc + (int_of_string (List.hd line))) 0 valid_lines_concat in

  print_endline ("Sum of valid line totals: " ^ (string_of_int sum_of_valid_line_totals));
  print_endline ("Sum of valid line totals with concatenation: " ^ (string_of_int sum_of_valid_line_totals_concat));
  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);