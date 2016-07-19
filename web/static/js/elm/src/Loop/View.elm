module Loop.View exposing (player, display)


import Html exposing (..)
import Html.Events exposing (..)

import Loop.Types exposing (..)


player : Model -> Html Msg
player model =
  case model.state of
    Playing ->
      stopButton
    NotPlaying ->
      playButton


display : Model -> Html msg
display model =
  case model.state of
    Playing ->
      text "Playing"
    NotPlaying ->
      text "Stopped"


playButton : Html Msg
playButton =
  button [ onClick Play ] [ text "Play" ]


stopButton : Html Msg
stopButton =
  button [ onClick Stop ] [ text "Stop" ]
