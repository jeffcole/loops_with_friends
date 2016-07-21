module Loop.View exposing (root)


import Html exposing (..)

import Loop.Types exposing (..)


root : Model -> Html msg
root model =
  ul []
    [ li [] [ text model.name ]
    , li [] [ text (toString model.state) ]
    ]
