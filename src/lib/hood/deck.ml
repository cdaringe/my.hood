open Common

type pool_assigner = card list * int list -> card list * int list

let empty_numbers () =
  [
    1;
    1;
    1;
    2;
    2;
    2;
    3;
    3;
    3;
    3;
    4;
    4;
    4;
    4;
    4;
    5;
    5;
    5;
    5;
    5;
    5;
    6;
    6;
    6;
    6;
    6;
    6;
    6;
    7;
    7;
    7;
    7;
    7;
    7;
    7;
    7;
    8;
    8;
    8;
    8;
    8;
    8;
    8;
    8;
    8;
    9;
    9;
    9;
    9;
    9;
    9;
    9;
    9;
    10;
    10;
    10;
    10;
    10;
    10;
    10;
    11;
    11;
    11;
    11;
    11;
    11;
    12;
    12;
    12;
    12;
    12;
    13;
    13;
    13;
    13;
    14;
    14;
    14;
    15;
    15;
    15;
  ]

let assign_cards_effect l effect =
  let f num = { num; effect } in
  List.map f l

let assign_effect cards effect (assigned, unassigned) =
  let pool_nums, _, unassigned' = Listext.extract cards unassigned in
  (assigned @ assign_cards_effect pool_nums effect, unassigned')

let with_effects numbers_deck =
  let common_effect_cards = [ 3; 4; 6; 7; 8; 9; 10; 12; 13 ] in
  let parks_n_re_cards =
    [ 1; 2; 4; 5; 5; 6; 7; 7; 8; 8; 9; 9; 10; 11; 11; 12; 14; 15 ]
  in
  let fence_cards =
    [ 1; 2; 3; 5; 5; 6; 6; 7; 8; 8; 9; 10; 10; 11; 11; 13; 14; 15 ]
  in
  assign_effect common_effect_cards DevelopPool ([], numbers_deck)
  |> assign_effect common_effect_cards (UseTempAgency 0)
  |> assign_effect common_effect_cards Bis
  |> assign_effect fence_cards (PlaceFence { street_num = 0; house_num = 0 })
  |> assign_effect parks_n_re_cards (DevelopPark 0)
  |> assign_effect parks_n_re_cards (InvestInEstablishmentSize 0)
  |> fun (assigned, unassigned) ->
  let num_unassigned = List.length unassigned in
  if num_unassigned > 0 then failwith "cards are unassigned" else assigned

let create () = empty_numbers () |> with_effects

let create_random () = create () |> Listext.shuffle
