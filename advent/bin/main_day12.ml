let file = "data12.txt"

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all in
  String.split_on_char '\n' contents

let () =  
  let lines = read_lines file in
  let t = Sys.time() in
  let char_lines = List.map (fun x -> List.of_seq (String.to_seq x)) lines in
  let array = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in
  let array_visited = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in
  let array_painted = Array.make_matrix (Array.length array) (Array.length array.(0)) 0 in

  let is_same i j c =
    if i < 0 || j < 0 || i >= Array.length array || j >= Array.length array.(0) || array.(i).(j) <> c then 1 else 0
  in

  let count_borders i j c =
    is_same (i - 1) j c + is_same (i + 1) j c + is_same i (j - 1) c + is_same i (j + 1) c
  in

  let sum_pairs (a, b) (c, d) = (a + c, b + d) in

  let rec explore i j c= 
    if i < 0 || j < 0 || i >= Array.length array || j >= Array.length array.(0) || array_visited.(i).(j) = '#' || array.(i).(j) <> c then (0, 0) else
    let _ = Array.set array_visited.(i) j '#' in
    sum_pairs ((count_borders i j array.(i).(j)), 1) (explore (i - 1) j c)
    |> sum_pairs (explore (i + 1) j c)
    |> sum_pairs (explore i (j - 1) c)
    |> sum_pairs (explore i (j + 1) c)
  in

  let rec paint i j c n = 
    if i < 0 || j < 0 || i >= Array.length array || j >= Array.length array.(0) || array.(i).(j) <> c || array_painted.(i).(j) <> 0 then () else
    let _ = Array.set array_painted.(i) j n in 
    let _ = paint (i - 1) j c n in
    let _ = paint (i + 1) j c n in
    let _ = paint i (j - 1) c n in
    paint i (j + 1) c n;
  in


  Array.iteri (fun i row -> Array.iteri (fun j c -> 
    match array_painted.(i).(j) with
    | 0 -> paint i j c ((Array.length row) * i + j + 1)
    | _ -> ()
  ) row) array;

  let visited_numbers = Hashtbl.create 1000 in

  let is_diff_or_edge i j c =
    if i < 0 || j < 0 || i >= Array.length array || j >= Array.length array.(0) || array_painted.(i).(j) <> c then 1 else 0
  in

  let is_same i j c = 
    if i < 0 || j < 0 || i >= Array.length array || j >= Array.length array.(0) || array_painted.(i).(j) <> c then 0 else 1
  in

  let count_corners_diff i j c = 
    let above = is_same (i - 1) j c = 1 in
    let below = is_same (i + 1) j c =1 in
    let left = is_same i (j - 1) c =1 in
   let right = is_same i (j + 1) c =1 in 
    if above && below && left && right then 4 else
    if (above && below && left) || (above && below && right) || (above && left && right) || (below && left && right) then 2 else
    if (above && right) || (above && left) || (below && right) || (below && left) then 1 else 0
  in

  let count_corners i j c =
     let above = is_diff_or_edge (i - 1) j c = 1 in
     let below = is_diff_or_edge (i + 1) j c =1 in
     let left = is_diff_or_edge i (j - 1) c =1 in
     let right = is_diff_or_edge i (j + 1) c =1 in 
     let bottom_right = is_diff_or_edge (i + 1) (j + 1) c =1 in
     let top_right = is_diff_or_edge (i - 1) (j + 1) c =1 in
     let bottom_left = is_diff_or_edge (i + 1) (j - 1) c =1 in
      let top_left = is_diff_or_edge (i - 1) (j - 1) c =1 in
    if above && below && left && right then 4 else
    if (above && below && left && top_left && bottom_left) || (above && below && right && top_right && bottom_right) || (above && left && right && top_left && top_right) || (below && left && right && bottom_left && bottom_right) then 2 else
    if (above && right && top_right) || (above && left && top_left) || (below && right && bottom_right) || (below && left && bottom_left) then 1 else 0
    
  in

  let rec explore_bulk i j c visited= 
    if i < 0 || j < 0 || i >= Array.length array || j >= Array.length array.(0) || visited.(i).(j) = '#' then (0, 0) else
    if array_painted.(i).(j) <> c then let _ = Array.set visited.(i) j '#' in let corners = count_corners_diff i j c in
    (corners, 0) else
    let _ = Array.set visited.(i) j '#' in
    let corners = count_corners i j c in
    sum_pairs (corners, 1) (explore_bulk (i - 1) j c visited)
    |> sum_pairs (explore_bulk (i + 1) j c visited)
    |> sum_pairs (explore_bulk i (j - 1) c visited)
    |> sum_pairs (explore_bulk i (j + 1) c visited)
  in
  
  let sum_of_costs = fst (Array.fold_left (fun (acc, i) row -> (acc + fst (Array.fold_left (fun (acc2, j) c -> (
    let (perim, area) = explore i j c in acc2 + (perim * area), j+1)) (0,0) row), i+1)) (0,0) array )in
    
  let sum_of_costs_bulk = fst (Array.fold_left (fun (acc, i) row -> (acc + fst (Array.fold_left (fun (acc2, j) c -> 
    match Hashtbl.find_opt visited_numbers c with
    | Some _ -> (acc2, j+1)
    | None -> let _ = Hashtbl.add visited_numbers c true in 
              let array_visited_bulk = Array.of_list (List.map (fun line -> Array.of_list line) char_lines) in
              let (sides, area) = explore_bulk i j c array_visited_bulk in
              (* Printf.printf "Exploring %d %d %d %d\n" i j sides area; *)
    (acc2 + (sides * area), j + 1)) (0,0) row), i+1)) (0,0) array_painted )in


  print_endline ("All costs: " ^ (string_of_int sum_of_costs));
  print_endline ("All costs bulk: " ^ (string_of_int sum_of_costs_bulk));
  
  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);