module Player.View exposing (root)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Loop.Types
import Loop.View
import User.Types
import User.Helpers

import Types exposing (..)


root : User.Types.Model -> Html Msg
root user =
  section []
    [ h2 [] [ text "Your Loop" ]
    , div [ class "grid-items" ]
        [ div [ class "grid-item" ]
            [ div []
                [ Loop.View.root user.loop
                , control (User.Helpers.loopState user)
                ]
            ]
        ]
    ]


control : Loop.Types.State -> Html Msg
control state =
  case state of
    Loop.Types.NotPlaying ->
      playButton
    Loop.Types.Queued ->
      queuedIndicator
    Loop.Types.Playing ->
      stopButton


playButton : Html Msg
playButton =
  span
    [ class "play-button"
    , onClick Play
    ]
    []


queuedIndicator : Html Msg
queuedIndicator =
  span [ class "queued-indicator" ] []


stopButton : Html Msg
stopButton =
  span
    [ class "stop-button"
    , onClick Stop
    ]
    []
