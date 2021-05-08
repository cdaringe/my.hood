let test_create_deck () =
  let deck = Hood.Deck.create () in
  Alcotest.(check int) "produces deck" 81 (List.length deck)

let test_deck_card_access () =
  let open Alcotest in
  let deck = Hood.Deck.create () in
  let card = List.nth deck 0 in
  check int "produces card in deck" card.num 13

let () =
  let open Alcotest in
  run "Deck"
    [
      ( "create",
        [
          test_case "test_create_deck" `Quick test_create_deck;
          test_case "test_deck_card_access" `Quick test_deck_card_access;
        ] );
    ]
