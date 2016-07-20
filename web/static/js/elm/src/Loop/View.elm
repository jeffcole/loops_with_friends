module Loop.View exposing (root)


import Html exposing (..)

import Loop.Types exposing (..)


root : Model -> Html msg
root model =
  case model.state of
    Playing ->
      text "Playing"
    NotPlaying ->
      text "Stopped"
