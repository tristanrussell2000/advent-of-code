let file = "data2.txt"

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let rec valid sign list =
  match list with
    | [] -> false
    | _ :: [] -> true
    | first :: second :: rest -> let diff = first - second in
                              if ((abs diff) >= 1 && (abs diff) <= 3) && (sign = 0 || sign = (compare diff 0))
                              then valid (compare first second) (second :: rest)
                              else false
let rec validish sign is_backtrack list =
  match list with
    | [] -> false
    | _ :: [] -> true
    | first :: second :: rest -> let diff = first - second in
                              if (((abs diff) >= 1 && (abs diff) <= 3) && (sign = 0 || sign = (compare first second))) || first = 0
                              then match (validish (if first = 0 then sign else (compare first second)) is_backtrack (second :: rest)) with
                                | true -> true 
                                | false -> 
                                  if not is_backtrack 
                                  then validish sign true (first :: rest) 
                                  else false
                              else (if is_backtrack then false else (validish sign true (first::rest)))
                                                       
let () = 
  let lines = read_lines file in
  let split = List.map (fun x -> List.map int_of_string (List.filter ((<>) "") (String.split_on_char ' ' x))) lines in
  let valid_lines = List.filter (valid 0) split in
  let count_valid_lines = List.length valid_lines in
  (* End part 1 *)                            

  let validish_lines = List.filter (fun x -> validish 0 false (0::x)) split in  

  print_endline (string_of_int count_valid_lines);
  print_endline (string_of_int (List.length validish_lines));
