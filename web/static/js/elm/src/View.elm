module View exposing (root)


import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)

import Types exposing (..)
import Loop.View


root : Model -> Html Msg
root model =
  div [ class "container" ]
      [ section [ class "welcome" ]
          [ h1 [] [ text "Loops" ]
          , h2 [] [ text "With Friends" ]
          ]
        , Html.App.map Loop (Loop.View.root model.loop)
        , usersView (otherUsers model)
      ]


usersView : List User -> Html Msg
usersView users =
  ul [] (List.map userView users)


userView : User -> Html Msg
userView user =
  li [] [ text user.id ]


otherUsers : Model -> List User
otherUsers model =
  List.filter (\user -> user.id /= model.userId) model.users
