let file = "data9.txt"

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let () =  
  let line = List.hd (read_lines file) in
  let t = Sys.time() in
  let str_list = List.map (fun c -> Char.escaped c) (List.of_seq (String.to_seq line)) in
  let file_map = List.map int_of_string str_list in
  let file_map2 = List.map int_of_string str_list in
  print_endline "";
  (* build a list of id numbers with reduce *)
  (* go number by number, add the file id n times to list if its a file, if it's space, then check / modify back of list *)
  (* so loop through file map and reversed file map?*)
  let rec build_file_ids file_map reversed list i ri = 
    if i > ri then list else
    (* let _ = Printf.printf "i: %d, ri: %d\n" i ri in *)
    match file_map, reversed with
    | f :: rest, r :: rest_rev ->
      (* let _ = Printf.printf "f: %d, r: %d, i: %d, ri: %d\n" f r i ri in *)
      if i mod 2 = 0 
        then build_file_ids rest reversed (List.append (List.init f (fun _ -> i / 2)) list) (i+1) ri
        else
          if ri mod 2 <> 0 then build_file_ids file_map rest_rev list i (ri-1)
          else
            if (ri - i) = 1 then build_file_ids rest rest_rev (List.append (List.init r (fun _ -> ri / 2)) list) (i+1) (ri-1)
            else  
            if r = f then build_file_ids rest rest_rev (List.append (List.init f (fun _ -> ri / 2)) list) (i+1) (ri-1)
            else if r > f then build_file_ids rest ((r-f) :: rest_rev) (List.append (List.init f (fun _ -> ri / 2)) list) (i+1) ri
            else build_file_ids ((f-r) :: rest) rest_rev (List.append (List.init r (fun _ -> ri / 2)) list) i (ri-1)
           
    | _ , _ -> list
  in

  let file_ids = List.rev (build_file_ids file_map (List.rev file_map2) [] 0 ((List.length file_map) - 1)) in
  let weighted = List.mapi (fun i x -> x * i) file_ids in
  let summed = List.fold_left (+) 0 weighted in
  (* End of part 1*)
  
  let space_map = List.mapi (fun i x -> if i mod 2 = 0 then (x, i / 2) else (x, -1)) file_map in
  (* List.iter (fun (x, y) -> Printf.printf "(%d, %d)\n" x y) space_map; *)

  let rec insert_file file_map (x, y) =
    match file_map with
    | (x2, -1) :: rest -> if x2 = x then (x, y) :: rest
                          else if x2 > x then (x, y) :: (x2 - x, -1) :: rest
                          else (x2, -1) :: insert_file rest (x, y)
    | file :: rest -> file :: insert_file rest (x, y)
    | _ -> file_map
  in

  let rec build_filesystem reversed =
    match reversed with
    | (x, y) :: rest_rev ->
      if y = -1 then List.append (build_filesystem rest_rev) [(x, y)]
      else
        let inserted = List.rev (insert_file (List.rev rest_rev) (x, y)) in
        (* let _ = Printf.printf  "(%d, %d)\n" x y in
        let _ = List.iter (fun (x, y) -> Printf.printf "(%d, %d)" x y) rest_rev in let _ = Printf.printf "\n--------\n" in
        let _ = List.iter (fun (x, y) -> Printf.printf "(%d, %d)" x y) inserted in let _ = Printf.printf "\n--------\n" in *)
        (* let _ = Printf.printf "%b\n" (List.equal (fun (x1, y1) (x2, y2) -> x1 = x2 && y1 = y2) inserted rest_rev) in *)
        if (List.equal (fun (x1, y1) (x2, y2) -> x1 = x2 && y1 = y2) inserted rest_rev) then List.append (build_filesystem rest_rev) [(x, y)]
        else  List.append (build_filesystem inserted) [(x, -1)]
    | _ -> reversed
  in

  let rec sum_filesystem filesystem i sum = 
    match filesystem with
    | (0, _) :: rest -> sum_filesystem rest i sum
    | (x, y) :: rest -> sum_filesystem ((x-1,y)::rest) (i+1) (sum + (if y = -1 then 0 else i * y))
    | _ -> sum
  in

  let filesystem = build_filesystem (List.rev space_map) in
  List.iter (fun (x, y) -> Printf.printf "(%d, %d)\n" x y) filesystem;

  let filesystem_sum = sum_filesystem filesystem 0 0 in


  print_endline ("Sum of file ids: " ^ (string_of_int summed));
  print_endline ("Sum of filesystem: " ^ (string_of_int filesystem_sum));
  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);