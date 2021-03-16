
type t = Common.street
let update_with_pools pool_house_nums establishment' : Common.establishment =
  let maybe_with_pool i house =
    if Array.exists (Int.equal i) pool_house_nums then House.with_pool house
    else house
  in
  Array.mapi maybe_with_pool establishment'

let create_establishment len pool_house_nums =
  let estab = Array.init len (fun _ -> House.empty ()) in
  update_with_pools pool_house_nums estab

let make street_id : t =
  let len, pool_idxs =
    match street_id with
    | 0 -> (10, [| 2; 6; 7 |])
    | 1 -> (11, [| 0; 3; 7 |])
    | 2 -> (12, [| 1; 6; 10 |])
    | _ -> failwith "invalid street id"
  in
  { park_count = 0; homes = create_establishment len pool_idxs; fences = [] }

let get_init () = Array.map make [| 0; 1; 2 |]
