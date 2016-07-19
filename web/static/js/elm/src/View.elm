module View exposing (root)


import Dict exposing (Dict)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)

import Types exposing (..)

import Loop.View
import User.Types
import User.View


root : Model -> Html Msg
root model =
  div [ class "container" ]
      [ section [ class "welcome" ]
          [ h1 [] [ text "Loops" ]
          , h2 [] [ text "With Friends" ]
          ]
        , Html.App.map LoopMsg (Loop.View.player model.loop)
        , usersView (otherUsers model)
      ]


usersView : User.Types.Collection -> Html Msg
usersView users =
  ul [] (Dict.values users |> List.map User.View.root)


otherUsers : Model -> User.Types.Collection
otherUsers model =
  model.users
  |> Dict.filter (\userId user -> userId /= model.userId)
