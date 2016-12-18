module User.View exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Loop.View
import User.Types exposing (..)


root : Model -> Html msg
root model =
    li [ class "grid-item" ]
        [ Loop.View.root model.loop ]
