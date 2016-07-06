module Loop.View exposing (root)


import Html exposing (..)
import Html.Events exposing (..)

import Loop.Types exposing (..)


root : Model -> Html Msg
root model =
  case model.state of
    Playing ->
      stopButton
    Stopped ->
      playButton


playButton : Html Msg
playButton =
  button [ onClick Play ] [ text "Play" ]


stopButton : Html Msg
stopButton =
  button [ onClick Stop ] [ text "Stop" ]
