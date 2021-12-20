let game = Hood.Game.create ()

open Js_of_ocaml

let printjs s = print_endline @@ Js.to_string s

let print s = print_endline s

let _ =
  Js.export_all
    (object%js
       method create = Hood.Game.create

       method act = Hood.Game.act

       method tick = Hood.Game.tick

       method print_game g = print @@ Hood.Common.show_game g
    end)
