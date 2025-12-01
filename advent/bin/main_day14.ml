let file = "data14.txt"

let mx = 50
let my = 51
let size_x = 101
let size_y = 103

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let () =  
  let lines = read_lines file in
  let t = Sys.time() in

  let vectors = List.map (fun line -> 
    let reg = Str.regexp {|-?[0-9]+|} in
    let _ = Str.search_forward reg line 0 in
    let x1 = int_of_string (Str.matched_string line) in
    let _ = Str.search_forward reg line (Str.match_end ()) in
    let y1 = int_of_string (Str.matched_string line) in
    let _ = Str.search_forward reg line (Str.match_end ()) in
    let dx = int_of_string (Str.matched_string line) in
    let _ = Str.search_forward reg line (Str.match_end ()) in
    let dy = int_of_string (Str.matched_string line) in
    ((x1, y1), (dx, dy))
  ) lines in

  (* List.iter (fun ((x1, y1), (dx, dy)) -> Printf.printf "x1: %d y1: %d dx: %d dy: %d\n" x1 y1 dx dy) vectors; *)

  let final_positions = List.map (fun ((x1, y1), (dx, dy)) ->
    let xf = (x1 + (100 * dx)) mod size_x in 
    let xff = if xf < 0 then size_x - (abs xf) else xf in
    let yf = (y1 + (100 * dy)) mod size_y in
    let yff = if yf < 0 then size_y - (abs yf) else yf in
    (xff, yff)
  ) vectors in

  (* List.iter (fun (x, y) -> Printf.printf "x: %d y: %d\n" x y) final_positions; *)

  let num_quadrants = List.fold_left (fun (q1, q2, q3, q4) (x, y) -> 
    if x < mx && y < my then (q1 + 1, q2, q3, q4)
    else if x < mx && y > my then (q1, q2 + 1, q3, q4)
    else if x > mx && y < my then (q1, q2, q3 + 1, q4)
    else if x > mx && y > my then (q1, q2, q3, q4 + 1)
    else (q1, q2, q3, q4)
    ) (0, 0, 0, 0) final_positions in

  (* let (one, two, three, four) = num_quadrants in  *)
  (* Printf.printf "Number of quadrants: %d %d %d %d\n" one two three four; *)
  
  let product_of_quadrants = match num_quadrants with
  | (q1, q2, q3, q4) -> q1 * q2 * q3 * q4
  in

  (*end of part 1*)

  let update ((x, y), (dx, dy)) =
    let xf = (x + dx) mod size_x in 
    let xff = if xf < 0 then size_x - (abs xf) else xf in
    let yf = (y + dy) mod size_y in
    let yff = if yf < 0 then size_y - (abs yf) else yf in
    ((xff, yff), (dx, dy))
  in

  let rec find_tree vector n = 
    if n = 10000 then ()
    else
    let new_vector = List.map update vector in
    let array = Array.make_matrix size_x size_y '.' in
    let _ = List.iter (fun ((x, y), _) -> array.(x).(y) <- '#') new_vector in
    let result = ref "" in
    for y = 0 to size_y - 1 do
      for x = 0 to size_x - 1 do
      result := !result ^ (String.make 1 array.(x).(y))
      done;
      result := !result ^ "\n"
    done;
    (* Printf.printf "%s" !result; *)
    let reg = Str.regexp {|#######|} in
    let _ = Printf.printf "Iteration: %d\n" n in
    flush_all();
    try
      let _ = Str.search_forward reg !result 0 in
      Printf.printf "Found at %d\n" n
    with Not_found -> ();

    find_tree new_vector (n+1)
  in

  find_tree vectors 0;

  Printf.printf "Product of quadrants: %d\n" product_of_quadrants;
  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);