module Loop.View exposing (root)


import Html exposing (..)
import String

import Loop.Types exposing (..)


root : Model -> Html msg
root model =
  ul []
    [ li [] [ text (humanizedName model.name) ]
    , li [] [ text (toString model.state) ]
    ]


humanizedName : String -> String
humanizedName name =
  String.split "_" name |> String.join " "
