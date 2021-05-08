open Hood.Common
open Hood.Game

let action_assign_first_house_value : action =
  {
    home_assignment = Some { street_num = 0; house_num = 0; value = 2 };
    effect = None;
  }

let test_empty_game () =
  let game = create () in
  Alcotest.(check int) "has 3 estate plans" 3 (List.length game.estate_plans)

let test_action_no_place_or_effect () =
  let game = create () in
  let action : action = { home_assignment = None; effect = None } in
  let r = act game 0 action in
  Alcotest.(check bool)
    "no action errors with correct error" true
    (match Result.get_error r with EmptyTurn -> true | _ -> false)

let test_action_valid_place () =
  let game = create () in
  let res = act game 0 action_assign_first_house_value in
  let gamep = CCResult.get_exn res in
  let house = get_house gamep 0 0 0 in
  Alcotest.(check bool) "no action errors" true (Result.is_ok res);
  Alcotest.(check int) "home value assigned" 2 (CCOpt.get_exn house.num)

let test_action_invalid_place_alread_filled () =
  let game = create () in
  let game' = act game 0 action_assign_first_house_value |> CCResult.get_exn in
  let err = act game' 0 action_assign_first_house_value |> Result.get_error in
  Alcotest.(check bool) "house already filled" true (HouseAlreadyFilled = err)

let () =
  let open Alcotest in
  run "Game"
    [
      ("creation", [ test_case "test_empty_game" `Quick test_empty_game ]);
      ( "actions",
        [
          test_case "test_action_no_place_or_effect" `Quick
            test_action_no_place_or_effect;
          test_case "test_action_valid_place" `Quick test_action_valid_place;
          test_case "test_action_invalid_place_alread_filled" `Quick
            test_action_invalid_place_alread_filled;
        ] );
    ]
