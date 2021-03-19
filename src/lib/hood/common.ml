type house = {
  num : int option;
  has_pool : bool;
  is_bis : bool;
  is_bound_to_deal : bool;
}

type establishment = house array

type street = { park_count : int; homes : house array; fences : int list }

type board = {
  streets : street array;
  real_estate_investment_counts : int array;
  bpr : int;
  temp_agency_usage_count : int;
  (* tuple: (plan index, 0 for first claimant,  n-1 for nth claimant *)
  estate_plan_claims : (int * int) list;
}

type fence = { street_num : int; house_num : int }

type effect =
  | PlaceFence of fence
  | InvestInEstablishmentSize of int (* establishment size *)
  | UseTempAgency of int (* adjustment value *)
  | Bis
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
  | InvalidHouseNumber
  | InvalidFenceIndex
  | FenceAlreadyExists
  | InvalidAction of string

exception Game_error of game_error

type card = { num : int; effect : effect }

type deck = card list

type estate_plan = { claimaint_count : int; establishments : int list }

type game = {
  is_complete : bool;
  boards : board list;
  decks : deck list;
  estate_plans : estate_plan list;
}

let in_range_or min max to_raise v =
  if v >= min || v <= max then v else raise to_raise
