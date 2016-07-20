module User.View exposing (root)


import Html exposing (..)

import Loop.View
import User.Types exposing (..)


root : Model -> Html msg
root model =
  li []
    [ ul []
      [ li [] [ text model.id ]
      , li [] [ text model.loopName ]
      , li [] [ Loop.View.root model.loop ]
      ]
    ]
