module View exposing (root)


import Dict exposing (Dict)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)

import Helpers
import Types exposing (..)

import Player.View
import User.Types
import User.View


root : Model -> Html Msg
root model =
  div [ class "container" ]
    [ section []
        [ h1 [] [ text "Loops With Friends" ]
        ]
    , Player.View.root (Helpers.playerUser model)
    , usersView (Helpers.otherUsers model)
    ]


usersView : User.Types.Collection -> Html Msg
usersView users =
  ul [] (Dict.values users |> List.map User.View.root)
