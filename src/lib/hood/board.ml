open Common

type t = Common.board

let ( >>= ) = Result.bind

let empty () : t =
  let b : t =
    {
      streets = Street.get_init ();
      bpr = 0;
      temp_agency_usage_count = 0;
      real_estate_investment_counts = [| 0; 0; 0; 0; 0; 0 |];
      estate_plan_claims = []
    }
  in
  b

