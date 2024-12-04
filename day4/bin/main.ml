let file = "data4.txt"

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let int_of_bool b = if b then 1 else 0
let vertical xmas_array i j =
  try
  xmas_array.(i).(j) = 'X' &&
  xmas_array.(i+1).(j) = 'M' &&
  xmas_array.(i+2).(j) = 'A' &&
  xmas_array.(i+3).(j) = 'S'
  with Invalid_argument _ -> false

let inverse_vertical xmas_array i j =
  try
    xmas_array.(i).(j) = 'X' &&
    xmas_array.(i-1).(j) = 'M' &&
    xmas_array.(i-2).(j) = 'A' &&
    xmas_array.(i-3).(j) = 'S'
  with Invalid_argument _-> false

let horizontal xmas_array i j =
  try
    xmas_array.(i).(j) = 'X' &&
    xmas_array.(i).(j+1) = 'M' &&
    xmas_array.(i).(j+2) = 'A' &&
    xmas_array.(i).(j+3) = 'S'
  with Invalid_argument _ -> false

let inverse_horizontal xmas_array i j =
  try
    xmas_array.(i).(j) = 'X' &&
    xmas_array.(i).(j-1) = 'M' &&
    xmas_array.(i).(j-2) = 'A' &&
    xmas_array.(i).(j-3) = 'S'
  with Invalid_argument _ -> false

let up_right_diag xmas_array i j =
  try
    xmas_array.(i).(j) = 'X' &&
    xmas_array.(i-1).(j+1) = 'M' &&
    xmas_array.(i-2).(j+2) = 'A' &&
    xmas_array.(i-3).(j+3) = 'S'
  with Invalid_argument _ -> false

let up_left_diag xmas_array i j =
  try
    xmas_array.(i).(j) = 'X' &&
    xmas_array.(i-1).(j-1) = 'M' &&
    xmas_array.(i-2).(j-2) = 'A' &&
    xmas_array.(i-3).(j-3) = 'S'
  with Invalid_argument _ -> false

let down_right_diag xmas_array i j =
  try
    xmas_array.(i).(j) = 'X' &&
    xmas_array.(i+1).(j+1) = 'M' &&
    xmas_array.(i+2).(j+2) = 'A' &&
    xmas_array.(i+3).(j+3) = 'S'
  with Invalid_argument _ -> false

let down_left_diag xmas_array i j =
  try
    xmas_array.(i).(j) = 'X' &&
    xmas_array.(i+1).(j-1) = 'M' &&
    xmas_array.(i+2).(j-2) = 'A' &&
    xmas_array.(i+3).(j-3) = 'S'
  with Invalid_argument _ -> false

let mas_down_right xmas_array i j =
  try
    xmas_array.(i).(j) = 'A' &&
    xmas_array.(i-1).(j-1) = 'M' &&
    xmas_array.(i+1).(j+1) = 'S'
  with Invalid_argument _ -> false

let mas_down_left xmas_array i j =
  try
    xmas_array.(i).(j) = 'A' &&
    xmas_array.(i-1).(j+1) = 'M' &&
    xmas_array.(i+1).(j-1) = 'S'
  with Invalid_argument _ -> false

let mas_up_right xmas_array i j =
  try
    xmas_array.(i).(j) = 'A' &&
    xmas_array.(i+1).(j-1) = 'M' &&
    xmas_array.(i-1).(j+1) = 'S'
  with Invalid_argument _ -> false

let mas_up_left xmas_array i j =
  try
    xmas_array.(i).(j) = 'A' &&
    xmas_array.(i+1).(j+1) = 'M' &&
    xmas_array.(i-1).(j-1) = 'S'
  with Invalid_argument _ -> false

let all_mas xmas_array i j = 
  ((mas_down_right xmas_array i j) || (mas_up_left xmas_array i j)) && ((mas_up_right xmas_array i j) || (mas_down_left xmas_array i j))


let xmas_test arr i j =
int_of_bool (vertical arr i j) + int_of_bool (inverse_vertical arr i j) + int_of_bool (horizontal arr i j) + int_of_bool (inverse_horizontal arr i j) + int_of_bool (up_right_diag arr i j) + int_of_bool (up_left_diag arr i j) + int_of_bool (down_right_diag arr i j) + int_of_bool (down_left_diag arr i j)
  

let () =  
  let lines = read_lines file in
  let char_lines = List.map (fun x -> List.of_seq (String.to_seq x)) lines in
  let xmas_array = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in 
  let xmas_tested = Array.mapi (fun i row -> Array.mapi (fun j c -> if c = 'X' then (xmas_test xmas_array i j) else 0) row) xmas_array in
  let xmas_summed = Array.fold_left (fun acc row -> Array.fold_left (+) acc row) 0 xmas_tested in
  (* End of part 1 *)

  let mas_tested = Array.mapi (fun i row -> Array.mapi (fun j c -> if c = 'A' then int_of_bool (all_mas xmas_array i j) else 0) row) xmas_array in
  let mas_summed = Array.fold_left (fun acc row -> Array.fold_left (+) acc row) 0 mas_tested in
  print_endline ("Xmas sum: " ^ (string_of_int xmas_summed));
  print_endline ("Mas sum: " ^ (string_of_int mas_summed));