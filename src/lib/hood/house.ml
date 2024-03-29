open Common

type t = Common.house

let empty () : t =
  let h : t =
    { num = None; has_pool = false; is_bis = false; is_bound_to_deal = false }
  in
  h

let with_pool (h : t) : t = { h with has_pool = true }
let check_num = in_range_or 1 16 (Game_error InvalidHouseNumber)
