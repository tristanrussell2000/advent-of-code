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
  
  let rec stone_change stones acc = 
    match stones with 
    | [] -> acc
    | 0 :: rest -> stone_change rest (1 :: acc)
    | x :: rest -> 
      let xs = string_of_int x in 
      if (String.length xs) mod 2 = 0 then
        let half = (String.length xs) / 2 in
        let first_half = int_of_string (String.sub xs 0 half) in
        let second_half = int_of_string (String.sub xs half half) in
        stone_change rest (second_half :: first_half :: acc)
      else 
        stone_change rest ((x * 2024) :: acc)
  in

  let rec stone_iter stones i = 
    if i = 0 then stones 
    else 
      let new_stones = stone_change stones [] in 
      let _ = print_endline ("Length of new stones: " ^ (string_of_int (List.length new_stones))) in
      stone_iter new_stones (i-1)
  in

  print_endline ("Start of part 1");

  let final_stones = stone_iter stone_list 25 in
  let final_stones_count = List.length final_stones in
  (* End of part 1*)

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

  print_endline ("End of part 1");
  print_endline ("Stone list 2: " ^ (String.concat ", " (List.map string_of_int stone_list2)));
  let final_stones_75 = List.map (fun x -> stone_iter_better x 75) stone_list2 in
  let final_stones_count_75 = List.fold_left (+) 0 final_stones_75 in

  print_endline ("Final stones count: " ^ (string_of_int final_stones_count));
  print_endline ("Final stones count 75: " ^ (string_of_int final_stones_count_75));
  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);