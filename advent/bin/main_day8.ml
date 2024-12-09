let file = "data8.txt"
let node_map  = Hashtbl.create 100

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let () =  
  let lines = read_lines file in
  let t = Sys.time() in
  let char_lines = List.map (fun x -> List.of_seq (String.to_seq x)) lines in
  let array = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in
  let antinode_array = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in
  let antinode_array2 = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in

  Array.iteri (fun i row -> Array.iteri (fun j c -> 
    if c <> '.'
      then let node_list = Hashtbl.find_opt node_map c in
        match node_list with
        | None -> let _ = Hashtbl.add node_map c [(i, j)] in ()
        | Some list -> let _ = Hashtbl.replace node_map c ((i,j) :: list) in ()
      else ()) row) array;

  Hashtbl.iter (fun k v -> Printf.printf "%c: %s\n" k (String.concat "; " (List.map (fun (i, j) -> Printf.sprintf "(%d, %d)" i j) v))) node_map;

  let set_antinode i j = 
    if i >= 0 && j >= 0 && i < Array.length antinode_array && j < Array.length antinode_array.(0)
    then antinode_array.(i).(j) <- '#'
    else () in

  let rec calc_antinodes list =
    match list with
    | (i, j) :: rest -> 
      let _ = List.iter (fun (i2, j2) -> 
        let (dx, dy) = (i2 - i, j2 - j) in
        let _ = set_antinode (i - dx) (j - dy) in
        set_antinode (i2 + dx) (j2 + dy)) rest in
        calc_antinodes rest;
    | _ -> () 
  in
  
  Hashtbl.iter (fun _ node_list -> calc_antinodes node_list) node_map;

  let antinode_count = Array.fold_left (fun acc row -> acc + (Array.fold_left (fun acc2 c -> if c = '#' then acc2 + 1 else acc2) 0 row)) 0 antinode_array in
  (* End of part 1 *)

  let rec set_antinode2 i j dx dy= 
    if i >= 0 && j >= 0 && i < Array.length antinode_array && j < Array.length antinode_array.(0)
    then let _ = antinode_array2.(i).(j) <- '#' in
      set_antinode2 (i + dx) (j + dy) dx dy
    else () in

  let rec calc_antinodes2 list =
    match list with
    | (i, j) :: rest -> 
      let _ = List.iter (fun (i2, j2) -> 
        let (dx, dy) = (i2 - i, j2 - j) in
        let _ = set_antinode2 i j (-dx) (-dy) in
        set_antinode2 i2 j2 dx dy) rest in
        calc_antinodes2 rest;
    | _ -> () 
  in

  Hashtbl.iter (fun _ node_list -> calc_antinodes2 node_list) node_map;
  let antinode2_count = Array.fold_left (fun acc row -> acc + (Array.fold_left (fun acc2 c -> if c = '#' then acc2 + 1 else acc2) 0 row)) 0 antinode_array2 in
  
  print_endline ("Antinode count: " ^ (string_of_int antinode_count));
  print_endline ("Antinode count 2: " ^ (string_of_int antinode2_count));
  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);