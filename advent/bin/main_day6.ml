let file = "data6.txt"

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let next_direction offset = match offset with
                            | (0, 1) -> (1, 0)
                            | (1, 0) -> (0, -1)
                            | (0, -1) -> (-1, 0)
                            | (-1, 0) -> (0, 1)
                            | _ -> (-1, 0)

let rec walk array i j offset =
  Array.set array.(i) j 'W';
  let (i', j') = (i + fst offset, j + snd offset) in
  if i' < 0 || i' >= Array.length array || j' < 0 || j' >= Array.length array.(0) 
  then ()
  else 
    if array.(i').(j') = '#'
    then walk array i j (next_direction offset)
    else walk array i' j' offset

let pos_dir_match c offset = match offset with
                            | (0, 1) -> c = '>'
                            | (1, 0) -> c = 'v'
                            | (0, -1) -> c = '<'
                            | (-1, 0) -> c = '^'
                            | _ -> false

let char_from_dir offset = match offset with
                          | (0, 1) -> '>'
                          | (1, 0) -> 'v'
                          | (0, -1) -> '<'
                          | (-1, 0) -> '^'
                          | _ -> 'W'                        

let rec walk_does_loop array i j offset newxi newyi is_first =
  if not is_first && pos_dir_match array.(i).(j) offset
  then true
  else
  let (i', j') = (i + fst offset, j + snd offset) in
  if i' < 0 || i' >= Array.length array || j' < 0 || j' >= Array.length array.(0) 
  then false
  else 
    let (x', y') = (next_direction offset) in
    if array.(i').(j') = '#' || (i', j') = (newxi, newyi)
    then walk_does_loop array i j (x', y') newxi newyi false
    else let _ = Array.set array.(i) j (char_from_dir offset) in walk_does_loop array i' j' offset newxi newyi false

let test arr i j =
  (* let _ = Printf.printf "(%d,%d)\n" i j in
  let _ = flush_all() in *)
  if walk_does_loop arr 80 84 (-1, 0) i j true then 'Y' else 'N'

let () =  
  let lines = read_lines file in
  let t = Sys.time() in
  let char_lines = List.map (fun x -> List.of_seq (String.to_seq x)) lines in
  let array = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in
  let array3 = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in
  walk array 80 84 (-1, 0);
  let total_w = Array.fold_left (fun acc x -> acc + Array.fold_left (fun acc y -> acc + (if y = 'W' then 1 else 0)) 0 x) 0 array in
  Array.iteri (fun i row ->
              Array.iteri (fun j c -> 
                let newarray = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in
                (* let _ = print_char c in
                let _ = flush_all() in *)
                Array.set (array3.(i)) j (if c = '.' then (test newarray i j) else 'N')
                ) row
                ) array3;
  
  let sum_of_ys = Array.fold_left (fun acc x -> acc + Array.fold_left (fun acc y -> acc + (if y = 'Y' then 1 else 0)) 0 x) 0 array3 in
  Printf.printf "Total Ws: %d\n" total_w;
  Printf.printf "Sum of Ys: %d\n" sum_of_ys;
  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);