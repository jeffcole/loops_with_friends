module View exposing (root)


import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)

import Types exposing (..)

import Loop.View
import User.Types


root : Model -> Html Msg
root model =
  div [ class "container" ]
      [ section [ class "welcome" ]
          [ h1 [] [ text "Loops" ]
          , h2 [] [ text "With Friends" ]
          ]
        , Html.App.map LoopMsg (Loop.View.root model.loop)
        , usersView (otherUsers model)
      ]


usersView : List User.Types.Model -> Html Msg
usersView users =
  ul [] (List.map userView users)


userView : User.Types.Model -> Html Msg
userView user =
  li [] [ text user.id ]


otherUsers : Model -> List User.Types.Model
otherUsers model =
  List.filter (\user -> user.id /= model.userId) model.users
