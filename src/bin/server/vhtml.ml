
open! Core_kernel
open! Js_of_ocaml
open Virtual_dom

let bprint_element
      buffer
      ~sep
      ~before_styles
      ~filter_printed_attributes
      { tag_name
      ; attributes
      ; string_properties
      ; bool_properties
      ; styles
      ; handlers
      ; key
      ; hooks
      ; children = _
      }
  =
  bprintf buffer "<%s" tag_name;
  let has_printed_an_attribute = ref false in
  let bprint_aligned_indent () =
    if !has_printed_an_attribute
    then bprintf buffer "%s" sep
    else (
      has_printed_an_attribute := true;
      bprintf buffer " ")
  in
  let list_iter_filter l ~f =
    List.filter l ~f:(fun (k, _) -> filter_printed_attributes k) |> List.iter ~f
  in
  if filter_printed_attributes "@key"
  then
    Option.iter key ~f:(fun key ->
      bprint_aligned_indent ();
      bprintf buffer "@key=%s" key);
  list_iter_filter attributes ~f:(fun (k, v) ->
    bprint_aligned_indent ();
    bprintf buffer "%s=\"%s\"" k v);
  list_iter_filter string_properties ~f:(fun (k, v) ->
    bprint_aligned_indent ();
    bprintf buffer "#%s=\"%s\"" k v);
  list_iter_filter bool_properties ~f:(fun (k, v) ->
    bprint_aligned_indent ();
    bprintf buffer "#%s=\"%b\"" k v);
  list_iter_filter hooks ~f:(fun (k, v) ->
    bprint_aligned_indent ();
    bprintf
      buffer
      "%s=%s"
      k
      (v |> [%sexp_of: Vdom.Attr.Hooks.For_testing.Extra.t] |> Sexp.to_string_mach));
  list_iter_filter handlers ~f:(fun (k, _) ->
    bprint_aligned_indent ();
    bprintf buffer "%s={handler}" k);
  if filter_printed_attributes "style"
  then
    if not (List.is_empty styles)
    then (
      bprint_aligned_indent ();
      bprintf buffer "style={";
      List.iter styles ~f:(fun (k, v) ->
        bprint_aligned_indent ();
        bprintf buffer "%s%s: %s;" before_styles k v);
      bprint_aligned_indent ();
      bprintf buffer "}");
  bprintf buffer ">"

let bprint_element_single_line buffer element =
  bprint_element buffer ~sep:" " ~before_styles:"" element

let bprint_element_multi_line buffer ~indent element =
  let align_with_first_attribute = String.map element.tag_name ~f:(Fn.const ' ') ^ "  " in
  let sep = "\n" ^ indent ^ align_with_first_attribute in
  bprint_element buffer ~sep ~before_styles:"  " element

let bprint_element_single_line buffer element =
  bprint_element buffer ~sep:" " ~before_styles:"" element

let to_string_html ?(filter_printed_attributes = Fn.const true) t =
  (* Keep around the buffer so that it is not re-allocated for every element *)
  let single_line_buffer = Buffer.create 400 in
  let rec recurse buffer ~depth =
    let indent = String.init (depth * 2) ~f:(Fn.const ' ') in
    function
    | None -> bprintf buffer "%s%s" indent ""
    | Text s -> bprintf buffer "%s%s" indent s
    | Widget _s -> bprintf buffer "%s<widget %s />" indent ""
    (* uhhhh not sure where the sexp comes from. deal w/ widgets later *)
    (* | Widget s -> bprintf buffer "%s<widget %s />" indent (Sexp.to_string s) *)
    | Element element ->
      bprintf buffer "%s" indent;
      Buffer.reset single_line_buffer;
      let _ = bprint_element_single_line ~filter_printed_attributes single_line_buffer element;
      if Buffer.length single_line_buffer < 100 - String.length indent
      then Buffer.add_buffer buffer single_line_buffer
      else bprint_element_multi_line ~filter_printed_attributes buffer ~indent element;
      let children_should_collapse =
        List.for_all element.children ~f:(function
          | Text _ -> true
          | _ -> false)
        && List.fold element.children ~init:0 ~f:(fun acc child ->
          match child with
          | Text s -> acc + String.length s
          | _ -> acc)
           < 80 - String.length indent
      in
      let depth = if children_should_collapse then 0 else depth + 1 in
      List.iter element.children ~f:(fun child ->
        if children_should_collapse then bprintf buffer " " else bprintf buffer "\n";
        recurse buffer ~depth child);
      if children_should_collapse
      then bprintf buffer " "
      else (
        bprintf buffer "\n";
        bprintf buffer "%s" indent);
      bprintf buffer "</%s>" element.tag_name
  in
  let buffer = Buffer.create 100 in
  recurse buffer ~depth:0 t;
  Buffer.contents buffer
