module View exposing (root)


import Dict exposing (Dict)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Helpers
import Types exposing (..)

import Loop.Types
import User.Types
import User.View


root : Model -> Html Msg
root model =
  div [ class "container" ]
      [ section [ class "welcome" ]
          [ h1 [] [ text "Loops" ]
          , h2 [] [ text "With Friends" ]
          ]
        , playerView model
        , usersView (Helpers.otherUsers model)
      ]


playerView : Model -> Html Msg
playerView model =
  ul []
    [ li [] [ text (Helpers.playerLoopName model) ]
    , li [] [ text (toString (Helpers.playerLoopState model)) ]
    , li [] [ playerButton (Helpers.playerLoopState model) ]
    ]


playerButton : Loop.Types.State -> Html Msg
playerButton state =
  case state of
    Loop.Types.Playing ->
      stopButton
    Loop.Types.NotPlaying ->
      playButton


usersView : User.Types.Collection -> Html Msg
usersView users =
  ul [] (Dict.values users |> List.map User.View.root)


playButton : Html Msg
playButton =
  button [ onClick Play ] [ text "Play" ]


stopButton : Html Msg
stopButton =
  button [ onClick Stop ] [ text "Stop" ]
