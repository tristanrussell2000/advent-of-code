let file = "data11.txt"

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let table  = Hashtbl.create 100000

let () =  
  let line = List.hd (read_lines file) in
  let t = Sys.time() in
  let stone_list = List.map (fun c -> int_of_string c) (String.split_on_char ' ' line) in
  let stone_list2 = List.map (fun c -> int_of_string c) (String.split_on_char ' ' line) in

  let rec stone_iter_better stone i = 
    match Hashtbl.find_opt table (stone, i) with
    | Some x -> x
    | _ ->
    if i = 0 then 1 else
    if stone = 0 then stone_iter_better 1 (i-1) else
      let xs = string_of_int stone in 
      if (String.length xs) mod 2 <> 0 then stone_iter_better (stone * 2024) (i-1) 
      else let half = (String.length xs) / 2 in
      let first_half = int_of_string (String.sub xs 0 half) in
      let second_half = int_of_string (String.sub xs half half) in
      let res = (stone_iter_better first_half (i-1)) + (stone_iter_better second_half (i-1)) in
      let _ = Hashtbl.add table (stone, i) res in
      res
  in

  let final_stones = List.map (fun x -> stone_iter_better x 25) stone_list in
  let final_stones_count = List.fold_left (+) 0 final_stones in
  (* End of part 1*)

  let final_stones_75 = List.map (fun x -> stone_iter_better x 75) stone_list2 in
  let final_stones_count_75 = List.fold_left (+) 0 final_stones_75 in

  print_endline ("Final stones count: " ^ (string_of_int final_stones_count));
  print_endline ("Final stones count 75: " ^ (string_of_int final_stones_count_75));
  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);