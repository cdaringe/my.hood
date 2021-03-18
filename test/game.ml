let test_empty_game () =
  let b = Hood.Game.empty () in
  Alcotest.(check int) "has 3 streets" 3 (Array.length b.streets)

let () =
  let open Alcotest in
  run "Game" [
      "creation", [
          test_case "test_empty_game"     `Quick test_empty_game;
        ];
    ]
