let file = "data5_rules.txt"
let file2 = "data5_pages.txt"

let print_int_list l = List.iter (fun x -> print_int x; print_string " ") l; print_endline ""
let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let table  = Hashtbl.create 1000
let list_overlap l1 l2 = if (List.fold_left (+) 0 (List.map (fun x -> List.fold_left (fun acc y -> if y = x then acc+1 else acc) 0 l2) l1)) > 0 then true else false

let rec line_valid line =
  match line with
  | [] -> true
  | x :: rest ->
    if not (list_overlap (Hashtbl.find table x) rest) then line_valid rest else false

let sort_compare i j =
  if list_overlap (Hashtbl.find table i) [j] then -1 else
    if list_overlap (Hashtbl.find table j) [i] then 1 else 0

let () = 
  let rules = read_lines file in
  let rules_split = List.fold_left (fun acc line ->
    match List.filter (fun s -> s <> "") (String.split_on_char '|' line) with
    | [a; b] -> (int_of_string a, int_of_string b) :: acc
    | _ -> acc) [] rules in
  List.iter (fun (x, y) -> print_int_list [x; y]) rules_split;
  let pages = read_lines file2 in
  let pages_split = List.map (fun line -> (List.map int_of_string ((String.split_on_char ',') line))) pages in
  
  List.iter (fun pair -> 
              match pair with 
              | (x, y) -> 
                try
                  let l = Hashtbl.find table x in
                  Hashtbl.add table x (y::l);
                with Not_found -> Hashtbl.add table x [y];
  ) rules_split;

  let valid_lines = List.filter (fun line -> (line_valid (List.rev line))) pages_split in
  print_int_list (List.nth valid_lines 0);
  let middle_values = List.map (fun line -> List.nth line (List.length line / 2)) valid_lines in
  let sum = List.fold_left (+) 0 middle_values in
  (* End of part 1 *)
  
  let invalid_lines = List.filter (fun line -> not (line_valid (List.rev line))) pages_split in
  let fixed_lines = List.map (fun line -> List.sort (fun i j -> sort_compare i j) line) invalid_lines in
  let fixed_middle_values = List.map (fun line -> List.nth line (List.length line / 2)) fixed_lines in
  let fixed_sum = List.fold_left (+) 0 fixed_middle_values in

  print_endline ("Middle value sum: " ^ (string_of_int sum));
  print_endline ("Fixed middle value sum: " ^ (string_of_int fixed_sum));