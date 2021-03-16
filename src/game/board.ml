
  let ( >>= ) = Result.bind

  let empty () : Common.board =
    let b : board =
      {
        streets = Street.get_init ();
        bpr = 0;
        temp_agency_usage_count = 0;
        real_estate_investment_counts = [| 0; 0; 0; 0; 0; 0 |];
      }
    in
    b

  let get_street board street_num =
    try Array.get board.streets street_num |> Result.ok
    with _ -> Error InvalidStreetIndex

  let get_house board street_num house_num =
    get_street board street_num >>= fun street ->
    try Array.get street house_num |> Result.ok
    with _ -> Error InvalidHouseIndex
