let test_empty_board () =
  let b = Hood.Board.empty () in
  Alcotest.(check int) "has 3 streets" 3 (Array.length b.streets)

let () =
  let open Alcotest in
  run "Board" [
      "creation", [
          test_case "test_empty_board"     `Quick test_empty_board;
        ];
    ]
