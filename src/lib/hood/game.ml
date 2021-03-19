open Common

let get_house game boardi streeti housei =
  let board = List.nth game.boards boardi in
  let street = board.streets.(streeti) in
  street.homes.(housei)

let with_board game player_id board : game =
  {
    game with
    boards =
      List.mapi
        (fun i board' -> if i = player_id then board else board')
        game.boards;
  }

let handle_assignment ({ street_num; house_num; value } : home_assignment) game
    player_id =
  let board = List.nth game.boards player_id in
  let maybe_update_house i (h : house) =
    if i = house_num then
      if Option.is_some h.num then raise (Game_error HouseAlreadyFilled)
      else
        {
          num = Some value;
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
  with_board game player_id
    { board with streets = Array.mapi maybe_update_street board.streets }

let handle_effect (_e : effect) (game : game) _player_id = game

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
  let b : game =
    {
      boards = init num_players (fun _ -> Board.empty ());
      decks = sublists_of_len 27 @@ Deck.create_random ();
      estate_plans =
        [
          { claimaint_count = 0; establishments = [ 2; 2; 2; 2 ] };
          { claimaint_count = 0; establishments = [ 3; 4; 5 ] };
          { claimaint_count = 0; establishments = [ 4; 4; 1 ] };
        ];
    }
  in
  b
