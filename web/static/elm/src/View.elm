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
    [ div [ class "content" ]
       [ header []
           [ h1 [] [ text "Loops With Friends" ] ]
       , main' []
           [ Player.View.root (Helpers.playerUser model)
           , usersView (Helpers.otherUsers model)
           ]
       ]
    ]


usersView : User.Types.Collection -> Html Msg
usersView users =
  section []
    [ h2 [] [ text "Other Players' Loops" ]
    , ul [ class "grid-items" ]
        (Dict.values users |> List.map User.View.root)
    ]
