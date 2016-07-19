module View exposing (root)


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


usersView : List User.Types.Model -> Html Msg
usersView users =
  ul [] (List.map User.View.root users)


otherUsers : Model -> List User.Types.Model
otherUsers model =
  List.filter (\user -> user.id /= model.userId) model.users
