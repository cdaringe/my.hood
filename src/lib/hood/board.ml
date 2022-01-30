open Common

type t = Common.board

let max_parks_by_street_index = [| 3; 4; 5 |]
let ( >>= ) = Result.bind

let investment_levels =
  [|
    [| 1; 3 |];
    [| 2; 3; 4 |];
    [| 3; 4; 5; 6 |];
    [| 4; 5; 6; 7; 8 |];
    [| 5; 6; 7; 8; 10 |];
    [| 6; 7; 8; 10; 12 |];
  |]

let empty () : t =
  {
    streets = Street.get_init ();
    bpr = 0;
    temp_agency_usage_count = 0;
    real_estate_investment_counts =
      Array.init 6 (fun i ->
          let open Array in
          let levels = get investment_levels i in
          get levels 0);
    estate_plan_claims = [];
  }

let with_fence board (fence : fence) =
  {
    board with
    streets =
      Array.mapi
        (fun i s ->
          if fence.street_num = i then Street.with_fence fence s else s)
        board.streets;
  }

let invest board size =
  let levels = board.real_estate_investment_counts in
  let points = levels.(size) in
  let curr_idx, _ =
    CCArray.find_idx (Int.equal points) investment_levels.(size)
    |> CCOption.get_exn_or ""
  in
  {
    board with
    real_estate_investment_counts =
      Arrayext.replace levels size investment_levels.(size).(curr_idx + 1);
  }

let add_park street_id board =
  let max_parks = max_parks_by_street_index.(street_id) in
  let update_street id street =
    if id = street_id then (
      let park_count = street.park_count + 1 in
      if park_count > max_parks then raise (Game_error TooManyParks);
      { street with park_count })
    else street
  in
  { board with streets = Array.mapi update_street board.streets }

let add_pool street_id home_id board =
  let update_home id home =
    if id = home_id then
      if home.has_pool then raise (Game_error PoolAlreadyExists)
      else { home with has_pool = true }
    else home
  in
  let update_street id street =
    if id = street_id then
      { street with homes = Array.mapi update_home street.homes }
    else street
  in
  { board with streets = Array.mapi update_street board.streets }
