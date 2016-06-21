module View exposing (root)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Types exposing (..)


root : Model -> Html Msg
root model =
    div [ class "container" ]
        [ section [ class "welcome" ]
            [ h1 [] [ text "Loops" ]
            , h2 [] [ text "With Friends" ]
            ]
          , case model.state of
              Stopped ->
                button [ onClick Play ] [ text "Play" ]
              Playing ->
                button [ onClick Stop ] [ text "Stop" ]
        ]
