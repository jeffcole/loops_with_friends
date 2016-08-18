module Loop.View exposing (root)


import Html exposing (..)
import Html.Attributes exposing (..)
import String

import Loop.Types exposing (..)


root : Model -> Html msg
root model =
  div [ class "loop" ]
    [ span [ class "icon" ] []
    , span [] [ text (humanizedName model.name) ]
    , span [] [ text (toString model.state) ]
    ]


humanizedName : String -> String
humanizedName name =
  String.split "_" name |> String.join " "
