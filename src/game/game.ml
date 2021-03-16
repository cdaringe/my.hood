open Common
let handle_assignment ({ street_num; house_num; value } : home_assignment)
    (b : board) =
  let maybe_update_house i (h : house) =
    if i == house_num then
      (* if Option.is_some h.value then Error HouseAlreadyFilled *)
      (* else *)
      ({
         num = Some value;
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
