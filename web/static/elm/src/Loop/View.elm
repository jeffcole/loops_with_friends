module Loop.View exposing (root)


import Html exposing (..)
import Html.Attributes exposing (..)
import String

import Loop.Types exposing (..)


root : Model -> Html msg
root model =
  div [ class "loop" ]
    [ span [ class (stateClass model.state) ] []
    , span [ class "name" ] [ text (humanizedName model.name) ]
    ]


stateClass : Loop.Types.State -> String
stateClass state =
  case state of
    Loop.Types.NotPlaying -> "not-playing"
    Loop.Types.Queued -> "queued"
    Loop.Types.Playing -> "playing"


humanizedName : String -> String
humanizedName string =
  string
  |> String.split "_"
  |> String.join " "
