open Tyxml
open Tyxml.Html

let game_json game : string =
  Yojson.Safe.pretty_to_string @@ Hood.Common.game_to_yojson game

(* let render_page el =
  html (head mytitle []) (body el) |> Format.asprintf "%a" (pp ()) *)

let%html render_page el =
  {|<html>
  <head>
    <title>my.hood - great game™</title>
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Fira+Sans&display=swap" rel="stylesheet">
    <style>
      body {
        font-family: "Fira Sans", sans-serif;
      }
      .street {
        white-space: nowrap;
        overflow-x: scroll;
      }
      .home {
        display: inline-block;
        width: 80px;
        height: 80px;
        border: 1px black solid;
        margin-right: 4px;
      }
    </style>
  </head><body>|}
    el {|</body></html>|}

let%html r_home (_house : Hood.Common.house) =
  {|
    <div class="home">|} {|</div>
  |}

let r_street (street : Hood.Common.street) =
  let open Array in
  let home_els = map r_home street.homes |> to_list in
  [%html {|
  <div class="street">|} home_els {|</div>
|}]

let render (game : Hood.Common.game) =
  let board = List.hd game.boards in
  let street_els = Array.map r_street board.streets |> Array.to_list in
  let serialized_game = game_json game in
  [%html
    {|<h1>my.hood</h1>|} street_els {|<pre>|} [ txt serialized_game ] {|</pre>|}]

let game = Hood.Game.create ~num_players:2 ()

let handle_game _request =
  render game |> render_page |> Format.asprintf "%a" (pp ()) |> Dream.html

let create_game_renderer model' =
  let open Incr_dom_testing in
  let driver =
    Driver.create
      ~initial_model:(Ui.initial_model_exn model')
      ~sexp_of_model:Ui.Model.sexp_of_t ~initial_state:()
      (module Ui)
  in
  Helpers.make driver

(* let render_game _request =
  let open Vdom_helpers in
  let (module R) = create_game_renderer [] in
  Dream.html @@ Node_helpers.to_string_html @@ Incr_dom_testing.Driver. *)

let render_game _request =
  let m = Ui.initial_model_exn [] in
  let view = Ui.view m ~inject:(fun _ -> Ui_event.Ignore) in
  Virtual_dom.Vdom.Node.to_dom view

let handle_404 _request = Dream.redirect "/"

let () =
  let open Dream in
  run ~debug:true @@ logger @@ router [ get "/" handle_game ] @@ handle_404
