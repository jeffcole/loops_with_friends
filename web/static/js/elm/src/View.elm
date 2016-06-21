module View exposing (root)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Types exposing (..)


root : a -> Html Msg
root model =
    div [ class "container" ]
        [ section [ class "welcome" ]
            [ h1 [] [ text "Loops" ]
            , h2 [] [ text "With Friends" ]
            ]
          , button [ onClick Play ] [ text "Play" ]
        ]
