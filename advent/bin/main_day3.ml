let file = "data3.txt"

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let search_nums eqns = 
  let regex = Str.regexp {|[0-9][0-9]?[0-9]?|} in
  let rec search equations nums = 
    match equations with
    | [] -> nums
    | eqn :: rest ->
    try
      let _ = Str.search_forward regex eqn 0 in
      let num1 = int_of_string(Str.matched_string eqn) in
      let start = Str.match_end () in
      let _ = Str.search_forward regex eqn start in
      let num2 = int_of_string(Str.matched_string eqn) in
      search rest ((num1, num2) :: nums)
    with Not_found -> nums in
  search eqns []
let search_mul s = 
  let regex = Str.regexp {|mul([0-9][0-9]?[0-9]?,[0-9][0-9]?[0-9]?)|} in
  let rec search start equations = 
    try
      let _ = Str.search_forward regex s start in
      let eq = Str.matched_string s in
      search (Str.match_end ()) (eq::equations)
    with Not_found -> 
      equations in
  search 0 []

let search_mul_advanced s =
  let regex = Str.regexp {|mul([0-9][0-9]?[0-9]?,[0-9][0-9]?[0-9]?)\|do()\|don't()|} in
  let rec search start equations flag = 
    try
      let _ = Str.search_forward regex s start in
      match Str.matched_string s with
      | "do()" -> search (Str.match_end ()) (equations) true
      | "don't()" -> search (Str.match_end ()) (equations) false
      | eq -> search (Str.match_end ()) (if flag then eq::equations else equations) flag
    with Not_found -> 
      equations in
  search 0 [] true 

let () = 
  let lines = read_lines file in
  let equations = List.map search_mul lines in
  let nums = List.map search_nums equations in
  let totals = List.map (fun eqn_list -> List.map (fun (x, y) -> x * y) eqn_list) nums in
  let total = List.fold_left (+) 0 (List.concat totals) in
  (* End of part 1 *)

  let equations_advanced = search_mul_advanced (String.concat "" lines) in
  let nums_advanced = search_nums equations_advanced in
  let totals_advanced = List.map (fun (x, y) -> x * y) nums_advanced in
  let total_advanced = List.fold_left (+) 0 totals_advanced in

  print_endline ("Total: " ^ string_of_int total);
  print_endline ("Total advanced: " ^ string_of_int total_advanced);
