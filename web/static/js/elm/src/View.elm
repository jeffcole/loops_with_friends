module View exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)


root : a -> Html b
root model =
    div [ class "container" ]
        [ section [ class "welcome" ]
            [ h1 [] [ text "Loops" ]
            , h2 [] [ text "With Friends" ]
            ]
        ]
