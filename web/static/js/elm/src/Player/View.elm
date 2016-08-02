module Player.View exposing (root)


import Html exposing (..)
import Html.Events exposing (..)

import Loop.Types
import User.Types
import User.Helpers

import Types exposing (..)


root : User.Types.Model -> Html Msg
root user =
  ul []
    [ li [] [ text (User.Helpers.loopName user) ]
    , li [] [ text (toString (User.Helpers.loopState user)) ]
    , li [] [ playerButton (User.Helpers.loopState user) ]
    ]


playerButton : Loop.Types.State -> Html Msg
playerButton state =
  case state of
    Loop.Types.Playing ->
      stopButton
    Loop.Types.NotPlaying ->
      playButton


playButton : Html Msg
playButton =
  button [ onClick Play ] [ text "Play" ]


stopButton : Html Msg
stopButton =
  button [ onClick Stop ] [ text "Stop" ]
