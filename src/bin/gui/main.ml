open! Core_kernel
open! Incr_dom
open! Js_of_ocaml

let () =
  Start_app.start
    (module Ui)
    ~bind_to_element_with_id:"app"
    ~initial_model:(Ui.initial_model_exn [ (0, 9) ])
