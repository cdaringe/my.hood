type house = {
  num : int option;
  has_pool : bool;
  is_bis : bool;
  is_bound_to_deal : bool;
}

type establishment = house array

type establishments = establishment array

type street = { park_count : int; homes : house array; fences : int list }

type board = {
  streets : street array;
  real_estate_investment_counts : int array;
  bpr : int;
  temp_agency_usage_count : int;
}

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
