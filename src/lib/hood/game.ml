open Common

let get_house game boardi streeti housei =
  let board = List.nth game.boards boardi in
  let street = board.streets.(streeti) in
  street.homes.(housei)

let with_player_board game player_id board : game =
  {
    game with
    boards = Listext.replace game.boards player_id board
  }

let handle_assignment a game player_id =
  let board = List.nth game.boards player_id in
  let house_num = House.check_num a.house_num in
  let street_num = Street.check_num a.street_num in
  let maybe_update_house i (h : house) =
    if i = house_num then
      if Option.is_some h.num then raise (Game_error HouseAlreadyFilled)
      else
        {
          num = Some a.value;
          has_pool = false;
          is_bis = false;
          is_bound_to_deal = false;
        }
    else h
  in
  let maybe_update_street street_num' street' : street =
    if street_num' == street_num then
      { street' with homes = Array.mapi maybe_update_house street'.homes }
    else street'
  in
  with_player_board game player_id
    { board with streets = Array.mapi maybe_update_street board.streets }

let handle_effect (eff : effect) (game : game) player_id =
  let board = List.nth game.boards player_id in
  let board' =
    match eff with
    | PlaceFence fence -> Board.with_fence board fence
    | InvestInEstablishmentSize size -> Board.invest board size
    | UseTempAgency _num_adjust -> board
    | Bis -> board
    | DevelopPark -> board
    | DevelopPool -> board
    | BPR -> board
  in
  { game with boards = Listext.replace game.boards player_id board' }

type t_act = game -> int -> action -> (game, game_error) result

let act : t_act =
 fun game player_id { home_assignment; effect } ->
  try
    (match (home_assignment, effect) with
    | None, None -> raise (Game_error EmptyTurn)
    | Some a, None -> handle_assignment a game player_id
    | None, Some e -> handle_effect e game player_id
    | Some a, Some e ->
        handle_assignment a game player_id |> fun game' ->
        handle_effect e game' player_id)
    |> Result.ok
  with Game_error err -> Error err

let create ?(num_players = 2) () =
  let open CCList in
  {
    is_complete = false;
    boards = init num_players (fun _ -> Board.empty ());
    decks = sublists_of_len 27 @@ Deck.create_random ();
    estate_plans = Plans.create_random ();
  }

let test_bpr_gte_3 b = b.bpr >= 3

let test_is_complete game =
  if game.is_complete then true
  else List.find_opt test_bpr_gte_3 game.boards |> Option.is_some

let tick game =
  {
    game with
    is_complete = test_is_complete game;
    decks = List.map Listext.rotate game.decks;
  }
