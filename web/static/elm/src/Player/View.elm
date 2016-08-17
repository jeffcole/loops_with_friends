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
            [ Loop.View.root user.loop
            , playerButton (User.Helpers.loopState user)
            ]
        ]
    ]


playerButton : Loop.Types.State -> Html Msg
playerButton state =
  case state of
    Loop.Types.NotPlaying ->
      playButton
    Loop.Types.Queued ->
      queuedMessage
    Loop.Types.Playing ->
      stopButton


playButton : Html Msg
playButton =
  button
    [ onClick Play
    ]
    [ text "Play" ]


queuedMessage : Html Msg
queuedMessage =
  span
    [
    ]
    [ text "Coming Up!" ]


stopButton : Html Msg
stopButton =
  button
    [ onClick Stop
    ]
    [ text "Stop" ]
