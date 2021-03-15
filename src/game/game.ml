type house = {
  value : int option;
  has_pool : bool;
  is_bis : bool;
  is_bound_to_deal : bool;
}

type establishment = house array

type establishments = establishment array

type street = { park_count : int; establishments : establishment array }

type board = {
  streets : establishment array;
  real_estate_investment_counts : int array;
  bpr : int;
  temp_agency_usage_count : int;
}

type city_plans = establishments

type fence = { street_num : int; house_num : int }

type effect =
  | PlaceFence of fence
  | InvestInEstablishmentSize of int (* establishment size *)
  | UseTempAgency of int (* adjustment value *)
  | DevelopPark
  | DevelopPool
  | BPR

type home_assignment = { street_num : int; house_num : int; value : int }

type action = {
  home_assignment : home_assignment option;
  effect : effect option;
}

type game_error =
  | EmptyTurn
  | InvalidStreetIndex
  | InvalidHouseIndex
  | HouseAlreadyFilled
  | InvalidAction of string

module Board = struct
  let ( >>= ) = Result.bind

  let get_street board street_num =
    try Array.get board.streets street_num |> Result.ok
    with _ -> Error InvalidStreetIndex

  let get_house board street_num house_num =
    get_street board street_num >>= fun street ->
    try Array.get street house_num |> Result.ok
    with _ -> Error InvalidHouseIndex
end

let handle_assignment ({ street_num; house_num; value } : home_assignment)
    (b : board) =
  let maybe_update_house i (h : house) =
    if i == house_num then
      (* if Option.is_some h.value then Error HouseAlreadyFilled *)
      (* else *)
      ({
         value = Some value;
         has_pool = false;
         is_bis = false;
         is_bound_to_deal = false;
       }
        : house)
    else h
  in
  let maybe_update_street street_num' street : establishment =
    if street_num' == street_num then Array.mapi maybe_update_house street
    else street
  in
  Ok { b with streets = Array.mapi maybe_update_street b.streets }

let handle_effect (_e : effect) (b : board) = Ok b

let act board _plans ({ home_assignment; effect } : action) :
    (board, game_error) result =
  let ( >>= ) = Result.bind in
  match (home_assignment, effect) with
  | None, None -> Error EmptyTurn
  | Some a, None -> handle_assignment a board
  | None, Some e -> handle_effect e board
  | Some a, Some e -> handle_assignment a board >>= handle_effect e
