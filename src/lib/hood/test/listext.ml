let check_int_list_eq = Alcotest.(check (list int))

let test_extract_with_single_match () =
  let needle', failed', haystack' = Hood.Listext.extract [ 1 ] [ 2; 1; 3 ] in
  check_int_list_eq "needle extracted" [ 1 ] needle';
  check_int_list_eq "haystack reduced" [ 2; 3 ] haystack';
  check_int_list_eq "no failed" [] failed'

let test_extract_with_many_matches () =
  let needle', failed', haystack' =
    Hood.Listext.extract [ 3; 4 ] [ 2; 4; 1; 3 ]
  in
  check_int_list_eq "needle extracted" [ 3; 4 ] needle';
  check_int_list_eq "haystack reduced" [ 2; 1 ] haystack';
  check_int_list_eq "no failed" [] failed'

let test_extract_with_many_dupe_matches () =
  let needle', failed', haystack' =
    Hood.Listext.extract [ 1; 1; 9 ] [ 2; 3; 1; 4; 1; 5; 1 ]
  in
  check_int_list_eq "needle extracted" [ 1; 1 ] needle';
  check_int_list_eq "haystack reduced" [ 2; 3; 4; 5; 1 ] haystack';
  check_int_list_eq "one failed" [ 9 ] failed'

let test_rotate_base () =
  check_int_list_eq "test_rotate_base" [] (Hood.Listext.rotate [])

let test_rotate_n () =
  check_int_list_eq "test_rotate_n" [ 3; 1; 2 ]
    (Hood.Listext.rotate [ 1; 2; 3 ]);
  check_int_list_eq "test_rotate_n" [ 2; 3; 1 ]
    (Hood.Listext.rotate ~n:2 [ 1; 2; 3 ])

let () =
  let open Alcotest in
  run "Listext"
    [
      ( "extract",
        [
          test_case "test_extract_with_single_match" `Quick
            test_extract_with_single_match;
          test_case "test_extract_with_many_matches" `Quick
            test_extract_with_many_matches;
          test_case "test_extract_with_many_dupe_matches" `Quick
            test_extract_with_many_dupe_matches;
        ] );
      ( "rotate",
        [
          test_case "test_rotate_base" `Quick test_rotate_base;
          test_case "test_rotate_n" `Quick test_rotate_n;
        ] );
    ]
