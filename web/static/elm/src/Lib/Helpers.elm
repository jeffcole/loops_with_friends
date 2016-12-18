module Lib.Helpers exposing (..)

import Dict exposing (Dict)


identityDict : (a -> comparable) -> List a -> Dict comparable a
identityDict idFunction list =
    List.map (\item -> ( idFunction item, item )) list
        |> Dict.fromList
