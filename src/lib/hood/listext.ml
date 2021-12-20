(* Given needles and a haystack, extract needles elements from haystack.
   Produce (successfully_extracted, unsuccessfully_extracted, remaining_haystack) *)
let extract needles haystack =
  let open CCList in
  let f (extracted, needles', haystack') curr =
    match find_idx (Int.equal curr) needles' with
    | Some (idx, v) -> (v :: extracted, remove_at_idx idx needles', haystack')
    | _ -> (extracted, needles', curr :: haystack')
  in
  fold_left f ([], needles, []) haystack |> fun (a, b, c) -> (a, b, rev c)

let shuffle d =
  let nd = List.map (fun c -> (Random.bits (), c)) d in
  let sond = List.sort compare nd in
  List.map snd sond

let rotate ?(n = 1) = function
  | [] -> []
  | l -> CCList.(last n l @ take (length l - n) l)

let replace l pos a = List.mapi (fun i x -> if i = pos then a else x) l
