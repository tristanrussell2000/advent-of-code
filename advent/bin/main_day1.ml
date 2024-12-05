let file = "data.txt"

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let () =
  let lines = read_lines file in
  let tupled = List.fold_left (fun acc line ->
                          match List.filter (fun s -> s <> "") (String.split_on_char ' ' line) with
                          | [a; b] -> (int_of_string a, int_of_string b) :: acc
                          | _ -> acc) [] lines in
  let (left, right) = List.split tupled in
  let left_sorted = List.sort compare left in
  let right_sorted = List.sort compare right in
  let combined = List.combine left_sorted right_sorted in  
  let dists = List.map (fun (x, y) -> abs (x - y)) combined in
  let sum = List.fold_left (+) 0 dists in
  (* End of part 1 *)

  let left_scores = List.map (fun x -> x * (List.fold_left (fun acc y -> if x = y then acc + 1 else acc) 0 right)) left in
  let sum_of_scores = List.fold_left (+) 0 left_scores in
  print_endline ("Sum of distances" ^ " " ^ (string_of_int sum));
  print_endline ("Similarity score" ^ " " ^ (string_of_int sum_of_scores));

  

  
  

  
      
 