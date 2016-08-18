module Loop.View exposing (root)


import Html exposing (..)
import Html.Attributes exposing (..)
import String

import Loop.Types exposing (..)


root : Model -> Html msg
root model =
  div [ class "loop" ]
    [ span [ class (stateClass model.state) ] []
    , span [] [ text (humanizedName model.name) ]
    , span [] [ text (stateString model.state) ]
    ]


stateClass : Loop.Types.State -> String
stateClass state =
  case state of
    Loop.Types.NotPlaying -> "not-playing"
    Loop.Types.Queued -> "queued"
    Loop.Types.Playing -> "playing"


stateString : Loop.Types.State -> String
stateString state =
  case state of
    Loop.Types.NotPlaying -> "Stopped"
    Loop.Types.Queued -> "Queued"
    Loop.Types.Playing -> "Playing"


humanizedName : String -> String
humanizedName string =
  string
  |> String.split "_"
  |> String.join " "
