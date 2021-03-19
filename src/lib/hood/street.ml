open Common

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

let with_fence (fence : fence) street =
  let fence_idx =
    match
      ( fence.house_num,
        CCList.find_opt (Int.equal fence.house_num) street.fences )
    with
    | 0, _ -> raise (Game_error InvalidFenceIndex)
    | _, None -> fence.house_num
    | _ -> raise (Game_error FenceAlreadyExists)
  in
  { street with fences = fence_idx :: street.fences }

let check_num = in_range_or 0 2 (Game_error InvalidStreetIndex)
