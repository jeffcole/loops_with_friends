module User.View exposing (root)


import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)

import Loop.View
import User.Types exposing (..)


root : Model -> Html msg
root model =
  li []
    [ ul []
      [ li [] [ text model.id ]
      , li [] [ text model.loopName ]
      , li [] [ Loop.View.display model.loop ]
      ]
    ]
