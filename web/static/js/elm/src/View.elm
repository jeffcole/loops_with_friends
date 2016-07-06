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
      ]
